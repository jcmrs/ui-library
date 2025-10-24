#!/bin/bash

# emergency-recovery.sh - Comprehensive recovery from failure scenarios
# Part of Phase 1.0: Automation Infrastructure
# See: .docs/DISASTER-RECOVERY.md for usage details

set +e  # Don't exit on error - this is recovery mode

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SESSION_STATE_FILE="${PROJECT_ROOT}/.claude/session-state.json"
RECOVERY_DIR="${PROJECT_ROOT}/.claude/recovery"

# Parse command line arguments
AUTO_MODE=false
MANIFEST_FILE=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --auto)
            AUTO_MODE=true
            shift
            ;;
        --manifest)
            MANIFEST_FILE="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [--auto] [--manifest <file>]"
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

# Function: Find latest recovery manifest
find_latest_manifest() {
    if [ ! -d "$RECOVERY_DIR" ]; then
        return 1
    fi

    local latest=$(ls -t "${RECOVERY_DIR}"/manifest.*.json 2>/dev/null | head -n 1)
    if [ -n "$latest" ]; then
        echo "$latest"
        return 0
    fi

    return 1
}

# Function: Load manifest
load_manifest() {
    local manifest=$1

    if [ ! -f "$manifest" ]; then
        print_message "$RED" "✗ Manifest file not found: $manifest"
        return 1
    fi

    if ! command -v jq &> /dev/null; then
        print_message "$RED" "✗ jq is required but not installed"
        return 1
    fi

    print_message "$GREEN" "✓ Loaded manifest: $manifest"
    return 0
}

# Function: Display recovery options
display_recovery_menu() {
    clear
    echo ""
    print_message "$MAGENTA" "╔═══════════════════════════════════════════════════════╗"
    print_message "$MAGENTA" "║              EMERGENCY RECOVERY SYSTEM                ║"
    print_message "$MAGENTA" "╚═══════════════════════════════════════════════════════╝"
    echo ""

    print_section "📋 RECOVERY OPTIONS"
    echo ""
    echo "  1. Restore from latest panic button backup"
    echo "  2. Restore from specific manifest file"
    echo "  3. Restore session state only"
    echo "  4. Restore git stash only"
    echo "  5. Diagnose current state"
    echo "  6. List available recovery points"
    echo "  7. Manual recovery guidance"
    echo "  0. Exit"
    echo ""
}

# Function: List recovery points
list_recovery_points() {
    print_section "📦 AVAILABLE RECOVERY POINTS"

    if [ ! -d "$RECOVERY_DIR" ]; then
        print_message "$YELLOW" "No recovery points found"
        return
    fi

    local manifests=$(ls -t "${RECOVERY_DIR}"/manifest.*.json 2>/dev/null)

    if [ -z "$manifests" ]; then
        print_message "$YELLOW" "No recovery manifests found"
        return
    fi

    echo ""
    local count=1
    for manifest in $manifests; do
        local recovery_id=$(basename "$manifest" | sed 's/manifest.\(.*\).json/\1/')
        local timestamp=$(jq -r '.panic_timestamp' "$manifest" 2>/dev/null || echo "unknown")
        local branch=$(jq -r '.git_state.branch' "$manifest" 2>/dev/null || echo "unknown")
        local phase=$(jq -r '.session_state.phase' "$manifest" 2>/dev/null || echo "unknown")

        echo "  $count. Recovery Point: $recovery_id"
        echo "     Timestamp: $timestamp"
        echo "     Branch: $branch"
        echo "     Phase: $phase"
        echo "     Manifest: $manifest"
        echo ""

        ((count++))
    done
}

# Function: Restore from manifest
restore_from_manifest() {
    local manifest=$1

    print_section "🔄 RESTORING FROM MANIFEST"

    if ! load_manifest "$manifest"; then
        return 1
    fi

    local recovery_id=$(jq -r '.recovery_id' "$manifest")
    local session_backup=$(jq -r '.recovery_files.session_state' "$manifest")
    local stash_file=$(jq -r '.recovery_files.stash_message' "$manifest")
    local has_stash=$(jq -r '.git_state.has_stash' "$manifest")

    echo ""
    print_message "$BLUE" "→ Recovery ID: $recovery_id"

    # Restore session state
    if [ -f "${RECOVERY_DIR}/${session_backup}" ]; then
        print_message "$BLUE" "→ Restoring session state..."
        cp "${RECOVERY_DIR}/${session_backup}" "$SESSION_STATE_FILE"
        print_message "$GREEN" "✓ Session state restored"
    else
        print_message "$YELLOW" "⚠ Session state backup not found"
    fi

    # Restore stash
    if [ "$has_stash" = "true" ] && [ -f "${RECOVERY_DIR}/${stash_file}" ]; then
        print_message "$BLUE" "→ Stash information available"
        print_message "$YELLOW" "⚠ Stash restoration requires manual action"
        echo ""
        echo "  To restore stashed changes:"
        echo "    1. View stash list: git stash list"
        echo "    2. Find the stash matching: $(cat ${RECOVERY_DIR}/${stash_file})"
        echo "    3. Apply stash: git stash pop stash@{N}"
        echo ""
    fi

    print_message "$GREEN" "✓ Recovery complete"
    return 0
}

# Function: Auto recovery
auto_recovery() {
    print_section "🤖 AUTOMATIC RECOVERY"

    local manifest=$(find_latest_manifest)

    if [ -z "$manifest" ]; then
        print_message "$RED" "✗ No recovery points found"
        print_message "$YELLOW" "Run panic button first: ./scripts/recovery/panic-button.sh"
        return 1
    fi

    print_message "$BLUE" "→ Found latest recovery point: $manifest"
    echo ""

    restore_from_manifest "$manifest"
}

# Function: Restore session state only
restore_session_state_only() {
    print_section "📄 RESTORE SESSION STATE ONLY"

    local latest_backup=$(ls -t "${RECOVERY_DIR}"/session-state.*.json 2>/dev/null | head -n 1)

    if [ -z "$latest_backup" ]; then
        print_message "$RED" "✗ No session state backups found"
        return 1
    fi

    print_message "$BLUE" "→ Found backup: $latest_backup"
    print_message "$BLUE" "→ Restoring..."

    cp "$latest_backup" "$SESSION_STATE_FILE"
    print_message "$GREEN" "✓ Session state restored"

    return 0
}

# Function: Display manual recovery guidance
show_manual_guidance() {
    print_section "📖 MANUAL RECOVERY GUIDANCE"

    echo ""
    echo "Common Recovery Scenarios:"
    echo ""
    echo "1. Lost Session State:"
    echo "   - Restore from backup: cp .claude/recovery/session-state.*.json .claude/session-state.json"
    echo "   - Or reinitialize: ./scripts/git-workflow/start-phase.sh <phase> \"<name>\""
    echo ""
    echo "2. Uncommitted Changes Lost:"
    echo "   - Check stash: git stash list"
    echo "   - Apply stash: git stash pop"
    echo "   - Check reflog: git reflog"
    echo ""
    echo "3. Wrong Branch:"
    echo "   - View branches: git branch -a"
    echo "   - Switch branch: git checkout <branch>"
    echo "   - Restore from backup: git checkout <commit> -- <file>"
    echo ""
    echo "4. Diverged from Remote:"
    echo "   - View divergence: git log --oneline HEAD..origin/<branch>"
    echo "   - Sync: ./scripts/git-workflow/sync-with-remote.sh"
    echo "   - Or reset: git reset --hard origin/<branch> (DANGEROUS)"
    echo ""
    echo "5. Corrupted State Files:"
    echo "   - List backups: ls -lh .claude/recovery/"
    echo "   - Restore specific: cp .claude/recovery/<file> .claude/"
    echo "   - Validate: cat .claude/session-state.json | jq ."
    echo ""
    echo "For detailed recovery procedures, see:"
    echo "  .docs/DISASTER-RECOVERY.md"
    echo ""
}

# Function: Interactive menu
interactive_menu() {
    while true; do
        display_recovery_menu

        read -p "Select option (0-7): " choice

        case $choice in
            1)
                auto_recovery
                read -p "Press ENTER to continue..."
                ;;
            2)
                echo ""
                read -p "Enter manifest file path: " manifest_path
                restore_from_manifest "$manifest_path"
                read -p "Press ENTER to continue..."
                ;;
            3)
                restore_session_state_only
                read -p "Press ENTER to continue..."
                ;;
            4)
                print_section "🗃️  GIT STASH"
                echo ""
                git stash list
                echo ""
                print_message "$YELLOW" "To apply stash: git stash pop stash@{N}"
                echo ""
                read -p "Press ENTER to continue..."
                ;;
            5)
                bash "${PROJECT_ROOT}/scripts/recovery/diagnose-issues.sh"
                read -p "Press ENTER to continue..."
                ;;
            6)
                list_recovery_points
                read -p "Press ENTER to continue..."
                ;;
            7)
                show_manual_guidance
                read -p "Press ENTER to continue..."
                ;;
            0)
                echo ""
                print_message "$GREEN" "Exiting recovery system"
                echo ""
                exit 0
                ;;
            *)
                print_message "$RED" "Invalid option"
                sleep 1
                ;;
        esac
    done
}

# Main script
main() {
    # Auto mode
    if [ "$AUTO_MODE" = true ]; then
        auto_recovery
        exit $?
    fi

    # Manifest mode
    if [ -n "$MANIFEST_FILE" ]; then
        restore_from_manifest "$MANIFEST_FILE"
        exit $?
    fi

    # Interactive mode
    interactive_menu
}

# Run main function
main "$@"
