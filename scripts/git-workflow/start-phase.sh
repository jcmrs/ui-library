#!/bin/bash

# start-phase.sh - Begin new project phase with automated branch creation
# Part of Phase 1.0: Automation Infrastructure
# See: .docs/GIT-WORKFLOW.md for usage details

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SESSION_STATE_FILE="${PROJECT_ROOT}/.claude/session-state.json"
PROGRESS_FILE="${PROJECT_ROOT}/.claude/progress.json"
BASE_BRANCH="develop"

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

# Function: Validate prerequisites
validate_prerequisites() {
    # Check if git repository
    if [ ! -d "${PROJECT_ROOT}/.git" ]; then
        error_exit "Not a git repository. Run from project root."
    fi

    # Check if on base branch
    CURRENT_BRANCH=$(git branch --show-current)
    if [ "$CURRENT_BRANCH" != "$BASE_BRANCH" ]; then
        error_exit "Must be on '$BASE_BRANCH' branch. Current: $CURRENT_BRANCH"
    fi
    print_success "Current branch: $BASE_BRANCH"

    # Check if working directory is clean
    if [ -n "$(git status --porcelain)" ]; then
        print_warning "Working directory is not clean"
        git status --short
        echo ""
        read -p "Commit or stash changes before continuing? (yes/no): " confirm
        if [ "$confirm" != "yes" ]; then
            error_exit "Working directory must be clean to start new phase"
        fi
        exit 1
    fi
    print_success "Working directory clean"
}

# Function: Create feature branch
create_feature_branch() {
    local phase=$1
    local branch_name="feature/phase-${phase}"

    # Check if branch already exists
    if git show-ref --verify --quiet "refs/heads/${branch_name}"; then
        print_warning "Branch '${branch_name}' already exists"
        read -p "Checkout existing branch? (yes/no): " confirm
        if [ "$confirm" == "yes" ]; then
            git checkout "${branch_name}"
            print_success "Checked out existing branch: ${branch_name}"
            return 0
        else
            error_exit "Cannot proceed - branch exists and user declined checkout"
        fi
    fi

    # Create and checkout new branch
    git checkout -b "${branch_name}"
    print_success "Created and checked out branch: ${branch_name}"
}

# Function: Initialize session state
initialize_session_state() {
    local phase=$1
    local phase_name=$2
    local branch_name="feature/phase-${phase}"

    # Create .claude directory if it doesn't exist
    mkdir -p "${PROJECT_ROOT}/.claude"

    # Read phase info from ROADMAP.md (simplified - just use provided name)
    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

    # Create session state JSON
    cat > "${SESSION_STATE_FILE}" << EOF
{
  "schema_version": "1.0.0",
  "project": {
    "name": "ui-library",
    "version": "1.0.0",
    "remote_url": "https://github.com/jcmrs/ui-library.git"
  },
  "current": {
    "phase": "${phase}",
    "phase_name": "${phase_name}",
    "task": "${phase}.0.1",
    "task_name": "Initial phase task",
    "working_branch": "${branch_name}",
    "base_branch": "${BASE_BRANCH}"
  },
  "timing": {
    "phase_start": "${timestamp}",
    "task_start": "${timestamp}",
    "last_activity": "${timestamp}",
    "last_sync": "${timestamp}"
  },
  "checkpoint": {
    "tag": "phase-${phase}-start",
    "commit": "$(git rev-parse HEAD)",
    "timestamp": "${timestamp}",
    "message": "Phase ${phase} started"
  },
  "progress": {
    "tasks_completed": [],
    "tasks_total": 0,
    "completion_percentage": 0
  },
  "git_state": {
    "local_commits_ahead": 0,
    "remote_commits_ahead": 0,
    "modified_files": 0,
    "untracked_files": 0,
    "staged_files": 0,
    "working_directory_clean": true
  },
  "metadata": {
    "last_updated_by": "start-phase.sh",
    "last_updated_at": "${timestamp}"
  }
}
EOF

    print_success "Session state initialized"
}

# Function: Create initial checkpoint
create_initial_checkpoint() {
    local phase=$1
    local tag_name="phase-${phase}-start"

    # Create annotated tag
    git tag -a "${tag_name}" -m "Phase ${phase} started - automated checkpoint"
    print_success "Created initial checkpoint: ${tag_name}"

    # Push tag to remote (if remote exists)
    if git remote get-url origin >/dev/null 2>&1; then
        git push origin "${tag_name}" 2>/dev/null || print_warning "Could not push tag to remote (will retry later)"
    fi
}

# Function: Display phase information
display_phase_info() {
    local phase=$1
    local phase_name=$2

    echo ""
    echo "═══════════════════════════════════════════════════════"
    echo "  Phase ${phase}: ${phase_name}"
    echo "═══════════════════════════════════════════════════════"
    echo ""
    echo "Branch: feature/phase-${phase}"
    echo "Status: Ready to begin"
    echo ""
    echo "Next steps:"
    echo "  1. View tasks for this phase: cat .docs/TASKS.md | grep -A 50 'Phase ${phase}'"
    echo "  2. Check current state: ./scripts/git-workflow/where-am-i.sh"
    echo "  3. Complete first task: ./scripts/git-workflow/complete-task.sh <task-id>"
    echo ""
    echo "See .docs/GIT-WORKFLOW.md for detailed workflow guidance."
    echo "═══════════════════════════════════════════════════════"
    echo ""
}

# Main script
main() {
    # Check arguments
    if [ $# -lt 2 ]; then
        echo "Usage: $0 <phase-number> <phase-name>"
        echo "Example: $0 1.0 'Automation Infrastructure'"
        exit 1
    fi

    local phase=$1
    local phase_name=$2

    echo ""
    print_message "$GREEN" "🚀 Starting Phase ${phase}: ${phase_name}"
    echo ""

    # Validate prerequisites
    validate_prerequisites

    # Create feature branch
    create_feature_branch "$phase"

    # Initialize session state
    initialize_session_state "$phase" "$phase_name"

    # Create initial checkpoint
    create_initial_checkpoint "$phase"

    # Display phase information
    display_phase_info "$phase" "$phase_name"
}

# Run main function
main "$@"
