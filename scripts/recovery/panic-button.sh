#!/bin/bash

# panic-button.sh - Emergency state preservation and safe exit
# Part of Phase 1.0: Automation Infrastructure
# See: .docs/DISASTER-RECOVERY.md for usage details

set +e  # Don't exit on error - this is recovery mode

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Configuration
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SESSION_STATE_FILE="${PROJECT_ROOT}/.claude/session-state.json"
RECOVERY_DIR="${PROJECT_ROOT}/.claude/recovery"
TIMESTAMP=$(date -u +"%Y%m%d_%H%M%S")

# Function: Print colored message
print_message() {
    local color=$1
    shift
    echo -e "${color}$@${NC}"
}

# Function: Print section
print_section() {
    echo ""
    print_message "$MAGENTA" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    print_message "$MAGENTA" "$1"
    print_message "$MAGENTA" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

# Function: Create recovery directory
create_recovery_dir() {
    mkdir -p "$RECOVERY_DIR"
    print_message "$GREEN" "✓ Recovery directory ready"
}

# Function: Backup session state
backup_session_state() {
    print_message "$BLUE" "→ Backing up session state..."

    if [ ! -f "$SESSION_STATE_FILE" ]; then
        print_message "$YELLOW" "⚠ No session state file found"
        return 1
    fi

    local backup_file="${RECOVERY_DIR}/session-state.${TIMESTAMP}.json"
    cp "$SESSION_STATE_FILE" "$backup_file"
    print_message "$GREEN" "✓ Session state backed up: ${backup_file}"

    return 0
}

# Function: Backup progress files
backup_progress_files() {
    print_message "$BLUE" "→ Backing up progress files..."

    local backed_up=0

    if [ -f "${PROJECT_ROOT}/.claude/progress.json" ]; then
        cp "${PROJECT_ROOT}/.claude/progress.json" "${RECOVERY_DIR}/progress.${TIMESTAMP}.json"
        ((backed_up++))
    fi

    if [ -f "${PROJECT_ROOT}/.claude/checkpoints.json" ]; then
        cp "${PROJECT_ROOT}/.claude/checkpoints.json" "${RECOVERY_DIR}/checkpoints.${TIMESTAMP}.json"
        ((backed_up++))
    fi

    if [ $backed_up -gt 0 ]; then
        print_message "$GREEN" "✓ Backed up ${backed_up} progress file(s)"
    else
        print_message "$YELLOW" "⚠ No progress files found"
    fi
}

# Function: Capture git status
capture_git_status() {
    print_message "$BLUE" "→ Capturing git status..."

    local status_file="${RECOVERY_DIR}/git-status.${TIMESTAMP}.txt"

    {
        echo "=== Git Status Capture ==="
        echo "Timestamp: $(date -u +"%Y-%m-%dT%H:%M:%SZ")"
        echo ""
        echo "=== Current Branch ==="
        git branch --show-current
        echo ""
        echo "=== Status ==="
        git status
        echo ""
        echo "=== Recent Commits ==="
        git log --oneline -5
        echo ""
        echo "=== Diff ==="
        git diff HEAD
        echo ""
        echo "=== Stash List ==="
        git stash list
    } > "$status_file" 2>&1

    print_message "$GREEN" "✓ Git status captured: ${status_file}"
}

# Function: Stash uncommitted changes
stash_changes() {
    print_message "$BLUE" "→ Stashing uncommitted changes..."

    # Check if there are changes to stash
    if [ -z "$(git status --porcelain)" ]; then
        print_message "$YELLOW" "⚠ No changes to stash"
        return 0
    fi

    local current_branch=$(git branch --show-current)
    local stash_message="PANIC-BUTTON: Emergency stash from ${current_branch} at ${TIMESTAMP}"

    if git stash push -u -m "$stash_message"; then
        print_message "$GREEN" "✓ Changes stashed: ${stash_message}"
        echo "$stash_message" > "${RECOVERY_DIR}/last-stash.${TIMESTAMP}.txt"
        return 0
    else
        print_message "$RED" "✗ Failed to stash changes"
        return 1
    fi
}

# Function: Create recovery manifest
create_recovery_manifest() {
    print_message "$BLUE" "→ Creating recovery manifest..."

    local manifest_file="${RECOVERY_DIR}/manifest.${TIMESTAMP}.json"

    local current_branch=$(git branch --show-current 2>/dev/null || echo "unknown")
    local current_commit=$(git rev-parse HEAD 2>/dev/null || echo "unknown")
    local current_phase="unknown"
    local current_task="unknown"

    if [ -f "$SESSION_STATE_FILE" ] && command -v jq &> /dev/null; then
        current_phase=$(jq -r '.current.phase' "$SESSION_STATE_FILE" 2>/dev/null || echo "unknown")
        current_task=$(jq -r '.current.task' "$SESSION_STATE_FILE" 2>/dev/null || echo "unknown")
    fi

    cat > "$manifest_file" <<EOF
{
  "panic_timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "recovery_id": "${TIMESTAMP}",
  "git_state": {
    "branch": "${current_branch}",
    "commit": "${current_commit}",
    "has_stash": $([ -f "${RECOVERY_DIR}/last-stash.${TIMESTAMP}.txt" ] && echo "true" || echo "false")
  },
  "session_state": {
    "phase": "${current_phase}",
    "task": "${current_task}",
    "backed_up": $([ -f "${RECOVERY_DIR}/session-state.${TIMESTAMP}.json" ] && echo "true" || echo "false")
  },
  "recovery_files": {
    "session_state": "session-state.${TIMESTAMP}.json",
    "git_status": "git-status.${TIMESTAMP}.txt",
    "stash_message": "last-stash.${TIMESTAMP}.txt",
    "manifest": "manifest.${TIMESTAMP}.json"
  },
  "recovery_command": "./scripts/recovery/emergency-recovery.sh --manifest ${RECOVERY_DIR}/manifest.${TIMESTAMP}.json"
}
EOF

    print_message "$GREEN" "✓ Recovery manifest created: ${manifest_file}"
    echo "$manifest_file"
}

# Function: Display recovery information
display_recovery_info() {
    local manifest_file=$1

    print_section "🚨 PANIC BUTTON ACTIVATED"

    echo ""
    print_message "$GREEN" "All state has been preserved. Your work is safe."
    echo ""
    print_message "$YELLOW" "Recovery Information:"
    echo ""
    echo "  Recovery ID: ${TIMESTAMP}"
    echo "  Recovery Location: ${RECOVERY_DIR}"
    echo "  Manifest: ${manifest_file}"
    echo ""
    print_message "$BLUE" "To restore this state later:"
    echo ""
    echo "  ./scripts/recovery/emergency-recovery.sh --manifest ${manifest_file}"
    echo ""
    echo "Or use automatic recovery:"
    echo ""
    echo "  ./scripts/recovery/emergency-recovery.sh --auto"
    echo ""
    print_message "$YELLOW" "Additional recovery options:"
    echo ""
    echo "  Diagnose issues:      ./scripts/recovery/diagnose-issues.sh"
    echo "  Restore session only: ./scripts/recovery/restore-session-state.sh"
    echo "  Manual recovery:      See .docs/DISASTER-RECOVERY.md"
    echo ""
    print_message "$MAGENTA" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
}

# Main script
main() {
    clear

    echo ""
    print_message "$RED" "╔═══════════════════════════════════════════════════════╗"
    print_message "$RED" "║                  🚨 PANIC BUTTON 🚨                   ║"
    print_message "$RED" "║              Emergency State Preservation             ║"
    print_message "$RED" "╚═══════════════════════════════════════════════════════╝"
    echo ""

    print_message "$YELLOW" "This will preserve all current state and create a recovery point."
    print_message "$YELLOW" "Your work will be safe and can be restored at any time."
    echo ""

    # Confirmation
    read -p "Press ENTER to activate panic button, or Ctrl+C to cancel... "

    echo ""
    print_section "📦 PRESERVING STATE"

    # Create recovery directory
    create_recovery_dir

    # Backup all state files
    backup_session_state
    backup_progress_files

    # Capture git information
    capture_git_status

    # Stash uncommitted changes
    stash_changes

    # Create recovery manifest
    local manifest_file=$(create_recovery_manifest)

    # Display recovery information
    display_recovery_info "$manifest_file"

    print_message "$GREEN" "✅ Panic button complete. State preserved successfully."
    echo ""

    exit 0
}

# Run main function
main "$@"
