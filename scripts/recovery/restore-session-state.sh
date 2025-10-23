#!/bin/bash

# restore-session-state.sh - Restore session state from backup
# Part of Phase 1.0: Automation Infrastructure
# See: .docs/DISASTER-RECOVERY.md for usage details

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SESSION_STATE_FILE="${PROJECT_ROOT}/.claude/session-state.json"
RECOVERY_DIR="${PROJECT_ROOT}/.claude/recovery"

# Parse command line arguments
BACKUP_FILE=""
LIST_ONLY=false
VALIDATE_ONLY=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --file)
            BACKUP_FILE="$2"
            shift 2
            ;;
        --list)
            LIST_ONLY=true
            shift
            ;;
        --validate)
            VALIDATE_ONLY=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [--file <backup>] [--list] [--validate]"
            exit 1
            ;;
    esac
done

# Function: Print colored message
print_message() {
    local color=$1
    shift
    echo -e "${color}$@${NC}"
}

# Function: Print section
print_section() {
    echo ""
    print_message "$CYAN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    print_message "$CYAN" "$1"
    print_message "$CYAN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

# Function: List backups
list_backups() {
    print_section "📦 AVAILABLE SESSION STATE BACKUPS"

    if [ ! -d "$RECOVERY_DIR" ]; then
        print_message "$YELLOW" "No recovery directory found"
        return 1
    fi

    local backups=$(ls -t "${RECOVERY_DIR}"/session-state.*.json 2>/dev/null)

    if [ -z "$backups" ]; then
        print_message "$YELLOW" "No session state backups found"
        return 1
    fi

    echo ""
    local count=1
    for backup in $backups; do
        local timestamp=$(basename "$backup" | sed 's/session-state.\(.*\).json/\1/')
        local file_date=$(stat -c %y "$backup" 2>/dev/null || stat -f %Sm "$backup" 2>/dev/null || echo "unknown")

        echo "  $count. Backup: $timestamp"
        echo "     File: $backup"
        echo "     Date: $file_date"

        # Try to extract phase/task info
        if command -v jq &> /dev/null; then
            local phase=$(jq -r '.current.phase' "$backup" 2>/dev/null || echo "unknown")
            local task=$(jq -r '.current.task' "$backup" 2>/dev/null || echo "unknown")
            local branch=$(jq -r '.current.working_branch' "$backup" 2>/dev/null || echo "unknown")

            echo "     Phase: $phase"
            echo "     Task: $task"
            echo "     Branch: $branch"
        fi

        echo ""
        ((count++))
    done

    return 0
}

# Function: Validate session state
validate_state() {
    local file=$1

    if ! command -v jq &> /dev/null; then
        print_message "$YELLOW" "⚠ jq not available, skipping validation"
        return 0
    fi

    print_message "$BLUE" "→ Validating session state structure..."

    # Check if valid JSON
    if ! jq . "$file" > /dev/null 2>&1; then
        print_message "$RED" "✗ Invalid JSON format"
        return 1
    fi

    # Check required fields
    local required_fields=(
        ".schema_version"
        ".project.name"
        ".current.phase"
        ".current.task"
        ".current.working_branch"
        ".timing.phase_start"
        ".timing.last_activity"
        ".progress.tasks_completed"
        ".git_state.working_directory_clean"
        ".metadata.last_updated_at"
    )

    local missing_fields=()

    for field in "${required_fields[@]}"; do
        if ! jq -e "$field" "$file" > /dev/null 2>&1; then
            missing_fields+=("$field")
        fi
    done

    if [ ${#missing_fields[@]} -gt 0 ]; then
        print_message "$RED" "✗ Missing required fields:"
        for field in "${missing_fields[@]}"; do
            echo "    - $field"
        done
        return 1
    fi

    print_message "$GREEN" "✓ Session state structure is valid"
    return 0
}

# Function: Display state info
display_state_info() {
    local file=$1

    if ! command -v jq &> /dev/null; then
        return 0
    fi

    print_section "📋 SESSION STATE INFORMATION"

    echo ""
    echo "  Project:      $(jq -r '.project.name' "$file")"
    echo "  Phase:        $(jq -r '.current.phase' "$file") - $(jq -r '.current.phase_name' "$file")"
    echo "  Task:         $(jq -r '.current.task' "$file") - $(jq -r '.current.task_name' "$file")"
    echo "  Branch:       $(jq -r '.current.working_branch' "$file")"
    echo "  Base Branch:  $(jq -r '.current.base_branch' "$file")"
    echo ""
    echo "  Phase Start:  $(jq -r '.timing.phase_start' "$file")"
    echo "  Last Activity: $(jq -r '.timing.last_activity' "$file")"
    echo ""
    echo "  Checkpoint:   $(jq -r '.checkpoint.tag' "$file")"
    echo "  Commit:       $(jq -r '.checkpoint.commit' "$file" | cut -c1-7)"
    echo ""
    echo "  Tasks Done:   $(jq -r '.progress.tasks_completed | length' "$file")"
    echo ""
}

# Function: Backup current state
backup_current_state() {
    if [ ! -f "$SESSION_STATE_FILE" ]; then
        print_message "$YELLOW" "⚠ No current session state to backup"
        return 0
    fi

    local timestamp=$(date -u +"%Y%m%d_%H%M%S")
    local backup_path="${SESSION_STATE_FILE}.pre-restore.${timestamp}.json"

    cp "$SESSION_STATE_FILE" "$backup_path"
    print_message "$GREEN" "✓ Current state backed up: $backup_path"
}

# Function: Restore state
restore_state() {
    local backup=$1

    print_section "🔄 RESTORING SESSION STATE"

    # Validate backup
    echo ""
    if ! validate_state "$backup"; then
        print_message "$RED" "✗ Backup validation failed"
        return 1
    fi

    # Display backup info
    display_state_info "$backup"

    # Backup current state
    backup_current_state

    # Restore
    print_message "$BLUE" "→ Restoring session state..."
    cp "$backup" "$SESSION_STATE_FILE"
    print_message "$GREEN" "✓ Session state restored"

    # Verify restore
    echo ""
    if validate_state "$SESSION_STATE_FILE"; then
        print_message "$GREEN" "✓ Restore verified successfully"
        return 0
    else
        print_message "$RED" "✗ Restore verification failed"
        return 1
    fi
}

# Function: Find latest backup
find_latest_backup() {
    if [ ! -d "$RECOVERY_DIR" ]; then
        return 1
    fi

    local latest=$(ls -t "${RECOVERY_DIR}"/session-state.*.json 2>/dev/null | head -n 1)
    if [ -n "$latest" ]; then
        echo "$latest"
        return 0
    fi

    return 1
}

# Main script
main() {
    echo ""
    print_message "$CYAN" "╔═══════════════════════════════════════════════════════╗"
    print_message "$CYAN" "║          RESTORE SESSION STATE FROM BACKUP            ║"
    print_message "$CYAN" "╚═══════════════════════════════════════════════════════╝"

    # List mode
    if [ "$LIST_ONLY" = true ]; then
        list_backups
        exit $?
    fi

    # Determine backup file
    if [ -z "$BACKUP_FILE" ]; then
        BACKUP_FILE=$(find_latest_backup)

        if [ -z "$BACKUP_FILE" ]; then
            echo ""
            print_message "$RED" "✗ No backups found"
            echo ""
            echo "Run panic button to create a backup:"
            echo "  ./scripts/recovery/panic-button.sh"
            echo ""
            exit 1
        fi

        echo ""
        print_message "$BLUE" "→ Using latest backup: $BACKUP_FILE"
    fi

    # Check backup exists
    if [ ! -f "$BACKUP_FILE" ]; then
        echo ""
        print_message "$RED" "✗ Backup file not found: $BACKUP_FILE"
        echo ""
        exit 1
    fi

    # Validate mode
    if [ "$VALIDATE_ONLY" = true ]; then
        echo ""
        validate_state "$BACKUP_FILE"
        display_state_info "$BACKUP_FILE"
        exit $?
    fi

    # Restore mode
    restore_state "$BACKUP_FILE"
    local result=$?

    echo ""
    if [ $result -eq 0 ]; then
        print_message "$GREEN" "✅ Session state restored successfully"
        echo ""
        echo "Check current status:"
        echo "  ./scripts/git-workflow/where-am-i.sh"
        echo ""
    else
        print_message "$RED" "❌ Restore failed"
        echo ""
    fi

    exit $result
}

# Run main function
main "$@"
