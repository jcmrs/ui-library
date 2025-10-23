#!/bin/bash

# where-am-i.sh - Display comprehensive project status
# Part of Phase 1.0: Automation Infrastructure
# See: .docs/GIT-WORKFLOW.md for usage details

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Configuration
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SESSION_STATE_FILE="${PROJECT_ROOT}/.claude/session-state.json"

# Function: Print colored message
print_message() {
    local color=$1
    shift
    echo -e "${color}$@${NC}"
}

# Function: Print section header
print_section() {
    echo ""
    print_message "$CYAN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    print_message "$CYAN" "$1"
    print_message "$CYAN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

# Function: Print info line
print_info() {
    local label=$1
    local value=$2
    printf "  %-25s %s\n" "$label" "$value"
}

# Function: Print colored info line
print_colored_info() {
    local label=$1
    local value=$2
    local color=$3
    printf "  %-25s " "$label"
    print_message "$color" "$value"
}

# Function: Read session state
read_session_state() {
    if [ ! -f "$SESSION_STATE_FILE" ]; then
        return 1
    fi

    if ! command -v jq &> /dev/null; then
        return 2
    fi

    return 0
}

# Function: Display project information
display_project_info() {
    print_section "📦 PROJECT INFORMATION"

    if read_session_state; then
        local project_name=$(jq -r '.project.name' "$SESSION_STATE_FILE")
        local project_version=$(jq -r '.project.version' "$SESSION_STATE_FILE")
        local remote_url=$(jq -r '.project.remote_url' "$SESSION_STATE_FILE")

        print_info "Project:" "$project_name"
        print_info "Version:" "$project_version"
        print_info "Remote:" "$remote_url"
    else
        print_colored_info "Status:" "Session state not available" "$YELLOW"
    fi

    echo ""
}

# Function: Display current phase and task
display_current_status() {
    print_section "🎯 CURRENT STATUS"

    if ! read_session_state; then
        print_colored_info "Status:" "Session state not initialized" "$RED"
        echo ""
        print_message "$YELLOW" "  Initialize with: ./scripts/git-workflow/start-phase.sh <phase> \"<name>\""
        echo ""
        return
    fi

    local phase=$(jq -r '.current.phase' "$SESSION_STATE_FILE")
    local phase_name=$(jq -r '.current.phase_name' "$SESSION_STATE_FILE")
    local task=$(jq -r '.current.task' "$SESSION_STATE_FILE")
    local task_name=$(jq -r '.current.task_name' "$SESSION_STATE_FILE")
    local working_branch=$(jq -r '.current.working_branch' "$SESSION_STATE_FILE")
    local base_branch=$(jq -r '.current.base_branch' "$SESSION_STATE_FILE")

    print_colored_info "Phase:" "Phase $phase - $phase_name" "$GREEN"
    print_info "Task:" "$task - $task_name"
    print_info "Working Branch:" "$working_branch"
    print_info "Base Branch:" "$base_branch"

    echo ""
}

# Function: Display timing information
display_timing_info() {
    print_section "⏰ TIMING"

    if ! read_session_state; then
        return
    fi

    local phase_start=$(jq -r '.timing.phase_start' "$SESSION_STATE_FILE")
    local task_start=$(jq -r '.timing.task_start' "$SESSION_STATE_FILE")
    local last_activity=$(jq -r '.timing.last_activity' "$SESSION_STATE_FILE")
    local last_sync=$(jq -r '.timing.last_sync' "$SESSION_STATE_FILE")

    print_info "Phase Started:" "$phase_start"
    print_info "Task Started:" "$task_start"
    print_info "Last Activity:" "$last_activity"
    print_info "Last Sync:" "$last_sync"

    # Calculate time since last activity
    if command -v date &> /dev/null; then
        local now=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
        local last_epoch=$(date -d "$last_activity" +%s 2>/dev/null || echo "0")
        local now_epoch=$(date -d "$now" +%s 2>/dev/null || echo "0")

        if [ "$last_epoch" != "0" ] && [ "$now_epoch" != "0" ]; then
            local diff=$((now_epoch - last_epoch))
            local hours=$((diff / 3600))
            local minutes=$(((diff % 3600) / 60))

            if [ $hours -gt 0 ]; then
                print_colored_info "Time Since Activity:" "${hours}h ${minutes}m ago" "$BLUE"
            else
                print_colored_info "Time Since Activity:" "${minutes}m ago" "$BLUE"
            fi
        fi
    fi

    echo ""
}

# Function: Display git status
display_git_status() {
    print_section "🔀 GIT STATUS"

    local current_branch=$(git branch --show-current)
    local current_commit=$(git rev-parse --short HEAD)
    local commit_message=$(git log -1 --pretty=%B | head -n 1)

    print_info "Current Branch:" "$current_branch"
    print_info "Current Commit:" "$current_commit"
    print_info "Commit Message:" "$commit_message"

    # Check if working directory is clean
    if [ -z "$(git status --porcelain)" ]; then
        print_colored_info "Working Directory:" "Clean ✓" "$GREEN"
    else
        print_colored_info "Working Directory:" "Modified" "$YELLOW"
        echo ""
        echo "  Modified files:"
        git status --short | sed 's/^/    /'
    fi

    # Check remote status
    echo ""
    print_info "Remote Comparison:" ""

    if ! git show-ref --verify --quiet "refs/remotes/origin/${current_branch}"; then
        print_colored_info "" "Remote branch does not exist" "$YELLOW"
        echo "    Push with: git push -u origin ${current_branch}"
    else
        local local_commit=$(git rev-parse HEAD)
        local remote_commit=$(git rev-parse "origin/${current_branch}")

        if [ "$local_commit" = "$remote_commit" ]; then
            print_colored_info "" "In sync with remote ✓" "$GREEN"
        elif git merge-base --is-ancestor "$remote_commit" "$local_commit"; then
            local commits_ahead=$(git rev-list --count "origin/${current_branch}..HEAD")
            print_colored_info "" "Local ahead by ${commits_ahead} commit(s)" "$BLUE"
        elif git merge-base --is-ancestor "$local_commit" "$remote_commit"; then
            local commits_behind=$(git rev-list --count "HEAD..origin/${current_branch}")
            print_colored_info "" "Remote ahead by ${commits_behind} commit(s)" "$YELLOW"
        else
            local local_ahead=$(git rev-list --count "origin/${current_branch}..HEAD")
            local remote_ahead=$(git rev-list --count "HEAD..origin/${current_branch}")
            print_colored_info "" "DIVERGED!" "$RED"
            echo "    Local commits: ${local_ahead}"
            echo "    Remote commits: ${remote_ahead}"
        fi
    fi

    echo ""
}

# Function: Display checkpoint information
display_checkpoint_info() {
    print_section "🏷️  LAST CHECKPOINT"

    if ! read_session_state; then
        return
    fi

    local tag=$(jq -r '.checkpoint.tag' "$SESSION_STATE_FILE")
    local commit=$(jq -r '.checkpoint.commit' "$SESSION_STATE_FILE")
    local timestamp=$(jq -r '.checkpoint.timestamp' "$SESSION_STATE_FILE")
    local message=$(jq -r '.checkpoint.message' "$SESSION_STATE_FILE")

    if [ "$tag" = "null" ] || [ -z "$tag" ]; then
        print_colored_info "Status:" "No checkpoint created yet" "$YELLOW"
    else
        print_info "Tag:" "$tag"
        print_info "Commit:" "$(echo $commit | cut -c1-7)"
        print_info "Timestamp:" "$timestamp"
        print_info "Message:" "$message"
    fi

    echo ""
}

# Function: Display progress
display_progress() {
    print_section "📊 PROGRESS"

    if ! read_session_state; then
        return
    fi

    local tasks_completed=$(jq -r '.progress.tasks_completed | length' "$SESSION_STATE_FILE")
    local tasks_total=$(jq -r '.progress.tasks_total' "$SESSION_STATE_FILE")
    local completion_percentage=$(jq -r '.progress.completion_percentage' "$SESSION_STATE_FILE")

    print_info "Tasks Completed:" "$tasks_completed"

    if [ "$tasks_total" != "0" ] && [ "$tasks_total" != "null" ]; then
        print_info "Tasks Total:" "$tasks_total"
        print_colored_info "Completion:" "${completion_percentage}%" "$GREEN"
    fi

    # List completed tasks
    local completed_tasks=$(jq -r '.progress.tasks_completed[]' "$SESSION_STATE_FILE" 2>/dev/null)
    if [ -n "$completed_tasks" ]; then
        echo ""
        print_info "Completed Tasks:" ""
        echo "$completed_tasks" | while read -r task; do
            echo "    ✓ $task"
        done
    fi

    echo ""
}

# Function: Display next steps
display_next_steps() {
    print_section "➡️  NEXT STEPS"

    if ! read_session_state; then
        echo "  1. Initialize phase: ./scripts/git-workflow/start-phase.sh <phase> \"<name>\""
        echo "  2. View roadmap: cat .docs/ROADMAP.md"
        echo "  3. View tasks: cat .docs/TASKS.md"
        echo ""
        return
    fi

    local current_phase=$(jq -r '.current.phase' "$SESSION_STATE_FILE")
    local current_task=$(jq -r '.current.task' "$SESSION_STATE_FILE")
    local working_branch=$(jq -r '.current.working_branch' "$SESSION_STATE_FILE")

    echo "  Common Operations:"
    echo ""
    echo "  📝 Complete current task:"
    echo "     ./scripts/git-workflow/complete-task.sh $current_task \"Task description\""
    echo ""
    echo "  🔄 Sync with remote:"
    echo "     ./scripts/git-workflow/sync-with-remote.sh"
    echo ""
    echo "  🏁 Complete phase:"
    echo "     ./scripts/git-workflow/complete-phase.sh $current_phase"
    echo ""
    echo "  📋 View documentation:"
    echo "     cat .docs/ROADMAP.md"
    echo "     cat .docs/TASKS.md"
    echo "     cat .docs/GIT-WORKFLOW.md"
    echo ""
}

# Function: Display quick reference
display_quick_reference() {
    print_section "🔧 QUICK REFERENCE"

    echo "  Workflow Scripts:"
    echo "    ./scripts/git-workflow/start-phase.sh <phase> \"<name>\""
    echo "    ./scripts/git-workflow/complete-task.sh <task-id> \"<description>\""
    echo "    ./scripts/git-workflow/complete-phase.sh <phase>"
    echo "    ./scripts/git-workflow/sync-with-remote.sh"
    echo "    ./scripts/git-workflow/where-am-i.sh"
    echo ""
    echo "  Recovery Scripts:"
    echo "    ./scripts/recovery/emergency-recovery.sh"
    echo "    ./scripts/recovery/restore-session-state.sh"
    echo "    ./scripts/recovery/diagnose-issues.sh"
    echo ""
    echo "  Documentation:"
    echo "    .docs/GIT-WORKFLOW.md - Git workflow guide"
    echo "    .docs/DISASTER-RECOVERY.md - Recovery procedures"
    echo "    .docs/SESSION-STATE.md - State management"
    echo "    .docs/ROADMAP.md - Project roadmap"
    echo "    .docs/TASKS.md - Task breakdown"
    echo ""
}

# Main script
main() {
    clear

    echo ""
    print_message "$MAGENTA" "╔═══════════════════════════════════════════════════════╗"
    print_message "$MAGENTA" "║              WHERE AM I? - PROJECT STATUS             ║"
    print_message "$MAGENTA" "╚═══════════════════════════════════════════════════════╝"

    display_project_info
    display_current_status
    display_timing_info
    display_git_status
    display_checkpoint_info
    display_progress
    display_next_steps
    display_quick_reference

    print_message "$CYAN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
}

# Run main function
main "$@"
