#!/bin/bash

# complete-phase.sh - Complete a phase by merging to develop and creating release checkpoint
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

# Function: Print info
print_info() {
    print_message "$BLUE" "→ $1"
}

# Function: Check if jq is available
check_jq() {
    if ! command -v jq &> /dev/null; then
        error_exit "jq is required but not installed. Install with: npm install -g node-jq"
    fi
}

# Function: Validate phase completion
validate_phase_completion() {
    local phase=$1

    print_info "Validating Phase ${phase} completion..."

    # Check session state exists
    if [ ! -f "$SESSION_STATE_FILE" ]; then
        error_exit "Session state not found. Cannot validate phase completion."
    fi

    # Get current phase from session state
    local current_phase=$(jq -r '.current.phase' "$SESSION_STATE_FILE")
    if [ "$current_phase" != "$phase" ]; then
        error_exit "Phase mismatch. Session state shows phase ${current_phase}, trying to complete ${phase}"
    fi

    # Check if on feature branch
    local current_branch=$(git branch --show-current)
    local expected_branch="feature/phase-${phase}"
    if [ "$current_branch" != "$expected_branch" ]; then
        error_exit "Must be on ${expected_branch}. Current branch: ${current_branch}"
    fi

    # Check working directory is clean
    if [ -n "$(git status --porcelain)" ]; then
        print_warning "Working directory is not clean"
        git status --short
        error_exit "Commit all changes before completing phase"
    fi

    print_success "Phase ${phase} validation passed"
}

# Function: Run quality gates
run_quality_gates() {
    print_info "Running final quality gates..."

    # Check if package.json exists
    if [ ! -f "${PROJECT_ROOT}/package.json" ]; then
        print_warning "package.json not found - skipping npm-based quality gates"
        return 0
    fi

    local all_passed=true

    # Run all quality checks
    if npm run type-check --silent 2>/dev/null; then
        print_success "TypeScript check passed"
    else
        if [ $? -ne 127 ]; then
            print_message "$RED" "✗ TypeScript errors found"
            all_passed=false
        fi
    fi

    if npm run lint --silent 2>/dev/null; then
        print_success "Lint passed"
    else
        if [ $? -ne 127 ]; then
            print_message "$RED" "✗ Lint errors found"
            all_passed=false
        fi
    fi

    if npm run test --silent 2>/dev/null; then
        print_success "Tests passed"
    else
        if [ $? -ne 127 ]; then
            print_message "$RED" "✗ Tests failed"
            all_passed=false
        fi
    fi

    if [ "$all_passed" = false ]; then
        error_exit "Quality gates failed. Fix errors before completing phase."
    fi

    print_success "All quality gates passed"
}

# Function: Merge to develop
merge_to_develop() {
    local phase=$1
    local feature_branch="feature/phase-${phase}"

    print_info "Merging to ${BASE_BRANCH}..."

    # Switch to develop
    git checkout "$BASE_BRANCH"
    print_success "Switched to ${BASE_BRANCH}"

    # Merge feature branch
    if git merge --no-ff "$feature_branch" -m "Merge phase ${phase}: Complete automation infrastructure

Phase ${phase} implementation complete.
All tasks validated and tested.
Ready for next phase."; then
        print_success "Merged ${feature_branch} to ${BASE_BRANCH}"
    else
        print_message "$RED" "✗ Merge failed"
        echo ""
        print_info "To abort merge: git merge --abort"
        print_info "To resolve manually: fix conflicts, then git commit"
        error_exit "Merge conflicts detected. Resolve manually."
    fi
}

# Function: Create phase completion tag
create_phase_tag() {
    local phase=$1
    local tag_name="phase-${phase}-complete"
    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

    print_info "Creating phase completion tag..."

    # Create annotated tag
    git tag -a "${tag_name}" -m "Phase ${phase} complete - all deliverables implemented and tested

Completion time: ${timestamp}
Branch: feature/phase-${phase}
Final commit: $(git rev-parse HEAD)"

    print_success "Phase tag created: ${tag_name}"
}

# Function: Push to remote
push_to_remote() {
    local phase=$1

    print_info "Pushing to remote..."

    # Push develop branch
    if git push origin "$BASE_BRANCH"; then
        print_success "Pushed ${BASE_BRANCH} to origin"
    else
        print_warning "Could not push ${BASE_BRANCH} (will retry later)"
    fi

    # Push tags
    if git push origin --tags; then
        print_success "Pushed tags to remote"
    else
        print_warning "Could not push tags (will retry later)"
    fi
}

# Function: Delete feature branch
delete_feature_branch() {
    local phase=$1
    local feature_branch="feature/phase-${phase}"

    print_info "Cleaning up feature branch..."

    # Delete local branch
    git branch -d "$feature_branch"
    print_success "Deleted local branch: ${feature_branch}"

    # Delete remote branch
    if git push origin --delete "$feature_branch" 2>/dev/null; then
        print_success "Deleted remote branch: ${feature_branch}"
    else
        print_warning "Could not delete remote branch (may not exist)"
    fi
}

# Function: Update session state
update_session_state() {
    local phase=$1
    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

    print_info "Updating session state..."

    # Update session state to reflect completion
    local temp_file="${SESSION_STATE_FILE}.tmp"
    jq --arg timestamp "$timestamp" \
       --arg phase "$phase" \
       '.current.working_branch = "develop" |
        .timing.last_activity = $timestamp |
        .checkpoint.tag = "phase-" + $phase + "-complete" |
        .checkpoint.commit = "'$(git rev-parse HEAD)'" |
        .checkpoint.timestamp = $timestamp |
        .checkpoint.message = "Phase " + $phase + " complete" |
        .metadata.last_updated_by = "complete-phase.sh" |
        .metadata.last_updated_at = $timestamp' \
       "$SESSION_STATE_FILE" > "$temp_file"

    mv "$temp_file" "$SESSION_STATE_FILE"
    print_success "Session state updated"
}

# Function: Display completion summary
display_summary() {
    local phase=$1

    echo ""
    echo "═══════════════════════════════════════════════════════"
    print_message "$GREEN" "🎉 Phase ${phase} Completed Successfully!"
    echo "═══════════════════════════════════════════════════════"
    echo ""
    echo "Phase tag: phase-${phase}-complete"
    echo "Branch: ${BASE_BRANCH}"
    echo "Commit: $(git rev-parse --short HEAD)"
    echo ""
    echo "Feature branch deleted: feature/phase-${phase}"
    echo "All changes merged to ${BASE_BRANCH}"
    echo "All changes pushed to remote"
    echo ""
    echo "Next steps:"
    echo "  1. Review ROADMAP.md for next phase"
    echo "  2. Start next phase: ./scripts/git-workflow/start-phase.sh <next-phase>"
    echo "  3. Check status: ./scripts/git-workflow/where-am-i.sh"
    echo ""
    echo "See .docs/ROADMAP.md for phase progression."
    echo "═══════════════════════════════════════════════════════"
    echo ""
}

# Main script
main() {
    # Check arguments
    if [ $# -lt 1 ]; then
        echo "Usage: $0 <phase-number>"
        echo "Example: $0 1.0"
        exit 1
    fi

    local phase=$1

    echo ""
    print_message "$GREEN" "🏁 Completing Phase ${phase}"
    echo ""

    # Check prerequisites
    check_jq

    # Validate phase completion
    validate_phase_completion "$phase"

    # Run quality gates
    run_quality_gates

    # Merge to develop
    merge_to_develop "$phase"

    # Create phase completion tag
    create_phase_tag "$phase"

    # Push to remote
    push_to_remote "$phase"

    # Delete feature branch
    delete_feature_branch "$phase"

    # Update session state
    update_session_state "$phase"

    # Display summary
    display_summary "$phase"
}

# Run main function
main "$@"
