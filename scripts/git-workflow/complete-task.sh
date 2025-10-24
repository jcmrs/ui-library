#!/bin/bash

# complete-task.sh - Complete a task with quality validation, commit, and checkpoint
# Part of Phase 1.0: Automation Infrastructure
# See: .docs/GIT-WORKFLOW.md for usage details

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SESSION_STATE_FILE="${PROJECT_ROOT}/.claude/session-state.json"
PROGRESS_FILE="${PROJECT_ROOT}/.claude/progress.json"

# Function: Print colored message
print_message() {
    local color=$1
    shift
    echo -e "${color}$@${NC}"
}

# Function: Print error and exit
error_exit() {
    print_message "$RED" "✗ ERROR: $1"
    exit 1
}

# Function: Print success
print_success() {
    print_message "$GREEN" "✓ $1"
}

# Function: Print warning
print_warning() {
    print_message "$YELLOW" "⚠ $1"
}

# Function: Print info
print_info() {
    print_message "$BLUE" "→ $1"
}

# Function: Check if jq is available
check_jq() {
    if ! command -v jq &> /dev/null; then
        error_exit "jq is required but not installed. Install with: npm install -g node-jq or download from https://stedolan.github.io/jq/"
    fi
}

# Function: Run quality gates
run_quality_gates() {
    print_info "Running quality gates..."

    local all_passed=true

    # Check if package.json exists (project might not be set up yet)
    if [ ! -f "${PROJECT_ROOT}/package.json" ]; then
        print_warning "package.json not found - skipping npm-based quality gates"
        print_warning "This is expected during Phase 1.0 automation setup"
        return 0
    fi

    # TypeScript type-check
    print_info "Checking TypeScript..."
    if npm run type-check --silent 2>/dev/null; then
        print_success "TypeScript check passed"
    else
        if [ $? -eq 127 ]; then
            print_warning "type-check script not found - skipping"
        else
            print_message "$RED" "✗ TypeScript errors found"
            all_passed=false
        fi
    fi

    # ESLint
    print_info "Running ESLint..."
    if npm run lint --silent 2>/dev/null; then
        print_success "Lint passed"
    else
        if [ $? -eq 127 ]; then
            print_warning "lint script not found - skipping"
        else
            print_message "$RED" "✗ Lint errors found"
            all_passed=false
        fi
    fi

    # Prettier
    print_info "Checking Prettier formatting..."
    if npm run prettier:check --silent 2>/dev/null; then
        print_success "Prettier check passed"
    else
        if [ $? -eq 127 ]; then
            print_warning "prettier:check script not found - skipping"
        else
            print_message "$RED" "✗ Formatting errors found"
            print_info "Run: npm run prettier"
            all_passed=false
        fi
    fi

    # Tests
    print_info "Running tests..."
    if npm run test --silent 2>/dev/null; then
        print_success "Tests passed"
    else
        if [ $? -eq 127 ]; then
            print_warning "test script not found - skipping"
        else
            print_message "$RED" "✗ Tests failed"
            all_passed=false
        fi
    fi

    if [ "$all_passed" = false ]; then
        error_exit "Quality gates failed. Fix errors before completing task."
    fi

    print_success "All quality gates passed"
}

# Function: Read session state
read_session_state() {
    if [ ! -f "$SESSION_STATE_FILE" ]; then
        error_exit "Session state not found. Run start-phase.sh first."
    fi

    if ! jq empty "$SESSION_STATE_FILE" 2>/dev/null; then
        error_exit "Session state file is corrupted. Run restore-session-state.sh"
    fi
}

# Function: Generate commit message
generate_commit_message() {
    local task_id=$1
    local phase=$(jq -r '.current.phase' "$SESSION_STATE_FILE")
    local phase_name=$(jq -r '.current.phase_name' "$SESSION_STATE_FILE")

    # Get git diff stats
    local files_changed=$(git diff --cached --numstat | wc -l)
    local insertions=$(git diff --cached --numstat | awk '{sum+=$1} END {print sum}')
    local deletions=$(git diff --cached --numstat | awk '{sum+=$2} END {print sum}')

    # Determine commit type based on task ID
    local commit_type="feat"
    if [[ $task_id == *".0."* ]]; then
        commit_type="feat"
    elif [[ $task_id == *.*.1 ]]; then
        commit_type="feat"
    else
        commit_type="chore"
    fi

    # Get changed files list
    local changed_files=$(git diff --cached --name-only | head -10)

    # Generate message
    cat << EOF
${commit_type}(phase-${phase}): Complete Task ${task_id}

Phase: ${phase} - ${phase_name}
Task: ${task_id}
Status: Complete

Changes:
${changed_files}

Stats: ${files_changed} files changed, ${insertions} insertions(+), ${deletions} deletions(-)
EOF
}

# Function: Create commit
create_commit() {
    local task_id=$1

    # Check if there are changes to commit
    if [ -z "$(git status --porcelain)" ]; then
        print_warning "No changes to commit"
        read -p "Continue anyway? (yes/no): " confirm
        if [ "$confirm" != "yes" ]; then
            error_exit "Aborted - no changes to commit"
        fi
    fi

    # Stage all changes
    print_info "Staging changes..."
    git add -A
    print_success "Changes staged"

    # Generate and create commit
    print_info "Creating commit..."
    local commit_msg=$(generate_commit_message "$task_id")
    echo "$commit_msg" | git commit -F -
    print_success "Commit created"
}

# Function: Create checkpoint tag
create_checkpoint() {
    local task_id=$1
    local tag_name="task-${task_id}-complete"
    local commit_hash=$(git rev-parse HEAD)
    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

    print_info "Creating checkpoint..."

    # Create annotated tag
    git tag -a "${tag_name}" -m "Task ${task_id} complete - automated checkpoint"
    print_success "Checkpoint created: ${tag_name}"

    # Update session state checkpoint
    local temp_file="${SESSION_STATE_FILE}.tmp"
    jq --arg tag "$tag_name" \
       --arg commit "$commit_hash" \
       --arg timestamp "$timestamp" \
       --arg msg "Task ${task_id} complete" \
       '.checkpoint.tag = $tag |
        .checkpoint.commit = $commit |
        .checkpoint.timestamp = $timestamp |
        .checkpoint.message = $msg |
        .timing.last_activity = $timestamp |
        .metadata.last_updated_by = "complete-task.sh" |
        .metadata.last_updated_at = $timestamp' \
       "$SESSION_STATE_FILE" > "$temp_file"

    mv "$temp_file" "$SESSION_STATE_FILE"
    print_success "Session state updated"
}

# Function: Push to remote
push_to_remote() {
    local task_id=$1

    print_info "Pushing to remote..."

    # Get current branch
    local current_branch=$(git branch --show-current)

    # Push branch
    if git push origin "$current_branch" 2>&1; then
        print_success "Pushed to origin/${current_branch}"
    else
        print_warning "Could not push branch (will retry later)"
    fi

    # Push tags
    if git push origin --tags 2>&1; then
        print_success "Pushed tags to remote"
    else
        print_warning "Could not push tags (will retry later)"
    fi
}

# Function: Update progress tracking
update_progress() {
    local task_id=$1

    # Add task to completed list in session state
    local temp_file="${SESSION_STATE_FILE}.tmp"
    jq --arg task "$task_id" \
       '.progress.tasks_completed += [$task] |
        .progress.tasks_completed |= unique' \
       "$SESSION_STATE_FILE" > "$temp_file"

    mv "$temp_file" "$SESSION_STATE_FILE"
}

# Function: Get next task
get_next_task() {
    local current_task=$1

    # Simple increment logic for now
    # Format: X.Y.Z -> X.Y.(Z+1)
    if [[ $current_task =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)([a-z]?)$ ]]; then
        local major="${BASH_REMATCH[1]}"
        local minor="${BASH_REMATCH[2]}"
        local patch="${BASH_REMATCH[3]}"
        local suffix="${BASH_REMATCH[4]}"

        if [ -n "$suffix" ]; then
            # Has suffix (e.g., 1.0.1a), increment suffix
            local next_suffix=$(echo "$suffix" | tr 'a-y' 'b-z')
            if [ "$next_suffix" = "z" ]; then
                # Wrap around to next patch number
                echo "${major}.${minor}.$((patch + 1))"
            else
                echo "${major}.${minor}.${patch}${next_suffix}"
            fi
        else
            # No suffix, just increment patch
            echo "${major}.${minor}.$((patch + 1))"
        fi
    else
        echo "unknown"
    fi
}

# Function: Display completion summary
display_summary() {
    local task_id=$1
    local next_task=$(get_next_task "$task_id")

    echo ""
    echo "═══════════════════════════════════════════════════════"
    print_message "$GREEN" "✅ Task ${task_id} Completed Successfully!"
    echo "═══════════════════════════════════════════════════════"
    echo ""
    echo "Checkpoint: task-${task_id}-complete"
    echo "Commit: $(git rev-parse --short HEAD)"
    echo "Branch: $(git branch --show-current)"
    echo ""

    if [ "$next_task" != "unknown" ]; then
        echo "Next task: ${next_task}"
        echo "To continue: ./scripts/git-workflow/complete-task.sh ${next_task}"
    else
        echo "Review TASKS.md for next task"
    fi

    echo ""
    echo "Check status: ./scripts/git-workflow/where-am-i.sh"
    echo "═══════════════════════════════════════════════════════"
    echo ""
}

# Main script
main() {
    # Check arguments
    if [ $# -lt 1 ]; then
        echo "Usage: $0 <task-id>"
        echo "Example: $0 1.0.1a"
        exit 1
    fi

    local task_id=$1

    echo ""
    print_message "$GREEN" "📝 Completing Task ${task_id}"
    echo ""

    # Check prerequisites
    check_jq
    read_session_state

    # Run quality gates
    run_quality_gates

    # Create commit
    create_commit "$task_id"

    # Create checkpoint
    create_checkpoint "$task_id"

    # Update progress
    update_progress "$task_id"

    # Push to remote
    push_to_remote "$task_id"

    # Display summary
    display_summary "$task_id"
}

# Run main function
main "$@"
