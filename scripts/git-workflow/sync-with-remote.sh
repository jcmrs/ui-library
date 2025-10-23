#!/bin/bash

# sync-with-remote.sh - Synchronize local repository with remote
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

# Function: Check remote connectivity
check_remote() {
    print_info "Checking remote connectivity..."

    if ! git remote get-url origin >/dev/null 2>&1; then
        error_exit "No remote 'origin' configured"
    fi

    local remote_url=$(git remote get-url origin)
    print_success "Remote configured: ${remote_url}"

    # Test connectivity
    if ! git ls-remote origin HEAD >/dev/null 2>&1; then
        error_exit "Cannot reach remote. Check network connection."
    fi

    print_success "Remote is reachable"
}

# Function: Fetch from remote
fetch_remote() {
    print_info "Fetching from remote..."

    if git fetch origin; then
        print_success "Fetched latest from origin"
    else
        error_exit "Failed to fetch from remote"
    fi
}

# Function: Compare local and remote
compare_branches() {
    local current_branch=$(git branch --show-current)

    print_info "Comparing local and remote branches..."

    # Check if remote branch exists
    if ! git show-ref --verify --quiet "refs/remotes/origin/${current_branch}"; then
        print_warning "Remote branch 'origin/${current_branch}' does not exist"
        echo "This is a new branch. Push with: git push -u origin ${current_branch}"
        return 2
    fi

    # Get commit hashes
    local local_commit=$(git rev-parse HEAD)
    local remote_commit=$(git rev-parse "origin/${current_branch}")

    # Compare commits
    if [ "$local_commit" = "$remote_commit" ]; then
        print_success "Local and remote are in sync"
        return 0
    fi

    # Check if local is ahead
    if git merge-base --is-ancestor "$remote_commit" "$local_commit"; then
        local commits_ahead=$(git rev-list --count "origin/${current_branch}..HEAD")
        print_info "Local is ahead by ${commits_ahead} commit(s)"
        return 1  # Local ahead
    fi

    # Check if remote is ahead
    if git merge-base --is-ancestor "$local_commit" "$remote_commit"; then
        local commits_behind=$(git rev-list --count "HEAD..origin/${current_branch}")
        print_info "Remote is ahead by ${commits_behind} commit(s)"
        return 3  # Remote ahead
    fi

    # Branches have diverged
    local local_ahead=$(git rev-list --count "origin/${current_branch}..HEAD")
    local remote_ahead=$(git rev-list --count "HEAD..origin/${current_branch}")
    print_warning "Local and remote have diverged!"
    echo "  Local commits not on remote: ${local_ahead}"
    echo "  Remote commits not on local: ${remote_ahead}"
    return 4  # Diverged
}

# Function: Push to remote
push_to_remote() {
    local current_branch=$(git branch --show-current)

    print_info "Pushing to remote..."

    if git push origin "$current_branch"; then
        print_success "Pushed to origin/${current_branch}"
        return 0
    else
        print_message "$RED" "✗ Push failed"
        return 1
    fi
}

# Function: Pull from remote
pull_from_remote() {
    local current_branch=$(git branch --show-current)

    print_info "Pulling from remote..."

    if git pull origin "$current_branch"; then
        print_success "Pulled from origin/${current_branch}"
        return 0
    else
        print_message "$RED" "✗ Pull failed"
        return 1
    fi
}

# Function: Handle divergence
handle_divergence() {
    local current_branch=$(git branch --show-current)

    echo ""
    print_message "$RED" "⚠️  DIVERGENCE DETECTED ⚠️"
    echo ""
    echo "Local and remote branches have diverged."
    echo "This requires manual resolution."
    echo ""
    echo "Review commits:"
    echo "  Local commits:  git log origin/${current_branch}..HEAD --oneline"
    echo "  Remote commits: git log HEAD..origin/${current_branch} --oneline"
    echo ""
    echo "Resolution options:"
    echo "  1. Keep local (DANGEROUS):  git push --force-with-lease origin ${current_branch}"
    echo "  2. Keep remote (LOSES WORK): git reset --hard origin/${current_branch}"
    echo "  3. Merge both:             git merge origin/${current_branch}"
    echo "  4. Emergency recovery:     ./scripts/recovery/emergency-recovery.sh"
    echo ""
    echo "⚠️  Recommendation: Use emergency recovery if uncertain"
    echo ""
}

# Function: Update session state
update_session_state() {
    if [ ! -f "$SESSION_STATE_FILE" ]; then
        return 0  # Session state might not exist yet
    fi

    if ! command -v jq &> /dev/null; then
        return 0  # jq not available, skip update
    fi

    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    local temp_file="${SESSION_STATE_FILE}.tmp"

    jq --arg timestamp "$timestamp" \
       '.timing.last_sync = $timestamp |
        .metadata.last_updated_by = "sync-with-remote.sh" |
        .metadata.last_updated_at = $timestamp' \
       "$SESSION_STATE_FILE" > "$temp_file"

    mv "$temp_file" "$SESSION_STATE_FILE"
}

# Main script
main() {
    echo ""
    print_message "$GREEN" "🔄 Synchronizing with Remote"
    echo ""

    # Check remote connectivity
    check_remote

    # Fetch from remote
    fetch_remote

    # Compare branches
    compare_branches
    local comparison_result=$?

    echo ""

    case $comparison_result in
        0)
            # In sync
            print_success "✅ Repository is in sync with remote"
            echo "No action needed."
            ;;
        1)
            # Local ahead
            print_info "📤 Pushing local commits to remote..."
            if push_to_remote; then
                print_success "✅ Successfully synchronized"
            else
                error_exit "Failed to push to remote"
            fi
            ;;
        2)
            # New branch
            print_info "New branch detected - not syncing automatically"
            echo "Push manually when ready: git push -u origin $(git branch --show-current)"
            ;;
        3)
            # Remote ahead
            print_info "📥 Pulling remote commits..."
            if pull_from_remote; then
                print_success "✅ Successfully synchronized"
            else
                error_exit "Failed to pull from remote"
            fi
            ;;
        4)
            # Diverged
            handle_divergence
            exit 1
            ;;
    esac

    # Update session state
    update_session_state

    echo ""
    print_success "Sync complete"
    echo ""
}

# Run main function
main "$@"
