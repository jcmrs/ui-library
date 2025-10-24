#!/bin/bash

# diagnose-issues.sh - Comprehensive diagnostics for troubleshooting
# Part of Phase 1.0: Automation Infrastructure
# See: .docs/DISASTER-RECOVERY.md for usage details

set +e  # Don't exit on error - this is diagnostics mode

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
RECOVERY_DIR="${PROJECT_ROOT}/.claude/recovery"

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

# Function: Check item with status
check_item() {
    local label=$1
    local status=$2
    local detail=$3

    printf "  %-40s " "$label"

    case $status in
        "pass")
            print_message "$GREEN" "✓ OK"
            ;;
        "warn")
            print_message "$YELLOW" "⚠ WARNING"
            ;;
        "fail")
            print_message "$RED" "✗ FAIL"
            ;;
        *)
            echo "$status"
            ;;
    esac

    if [ -n "$detail" ]; then
        echo "     $detail"
    fi
}

# Function: Diagnose git repository
diagnose_git() {
    print_section "🔍 GIT REPOSITORY DIAGNOSTICS"
    echo ""

    # Check if in git repository
    if git rev-parse --git-dir > /dev/null 2>&1; then
        check_item "Git Repository" "pass"
    else
        check_item "Git Repository" "fail" "Not a git repository"
        return 1
    fi

    # Current branch
    local current_branch=$(git branch --show-current 2>/dev/null)
    if [ -n "$current_branch" ]; then
        check_item "Current Branch" "pass" "$current_branch"
    else
        check_item "Current Branch" "fail" "No branch detected"
    fi

    # Working directory status
    if [ -z "$(git status --porcelain 2>/dev/null)" ]; then
        check_item "Working Directory" "pass" "Clean"
    else
        local modified=$(git status --porcelain 2>/dev/null | wc -l)
        check_item "Working Directory" "warn" "$modified file(s) modified"
    fi

    # Remote configured
    if git remote get-url origin > /dev/null 2>&1; then
        local remote_url=$(git remote get-url origin)
        check_item "Remote Origin" "pass" "$remote_url"
    else
        check_item "Remote Origin" "fail" "No remote configured"
    fi

    # Remote connectivity
    if git ls-remote origin HEAD > /dev/null 2>&1; then
        check_item "Remote Connectivity" "pass"
    else
        check_item "Remote Connectivity" "fail" "Cannot reach remote"
    fi

    # Branch sync status
    if [ -n "$current_branch" ] && git show-ref --verify --quiet "refs/remotes/origin/${current_branch}"; then
        local local_commit=$(git rev-parse HEAD)
        local remote_commit=$(git rev-parse "origin/${current_branch}")

        if [ "$local_commit" = "$remote_commit" ]; then
            check_item "Remote Sync" "pass" "In sync"
        elif git merge-base --is-ancestor "$remote_commit" "$local_commit"; then
            local ahead=$(git rev-list --count "origin/${current_branch}..HEAD")
            check_item "Remote Sync" "warn" "Local ahead by $ahead commit(s)"
        elif git merge-base --is-ancestor "$local_commit" "$remote_commit"; then
            local behind=$(git rev-list --count "HEAD..origin/${current_branch}")
            check_item "Remote Sync" "warn" "Remote ahead by $behind commit(s)"
        else
            check_item "Remote Sync" "fail" "Branches have diverged"
        fi
    else
        check_item "Remote Sync" "warn" "Remote branch does not exist"
    fi

    # Recent commits
    echo ""
    print_message "$CYAN" "Recent Commits:"
    git log --oneline -5 2>/dev/null | sed 's/^/    /'

    echo ""
}

# Function: Diagnose session state
diagnose_session_state() {
    print_section "📄 SESSION STATE DIAGNOSTICS"
    echo ""

    # Session state exists
    if [ -f "$SESSION_STATE_FILE" ]; then
        check_item "Session State File" "pass" "$SESSION_STATE_FILE"
    else
        check_item "Session State File" "fail" "File not found"
        return 1
    fi

    # jq available
    if command -v jq &> /dev/null; then
        check_item "jq (JSON processor)" "pass"
    else
        check_item "jq (JSON processor)" "warn" "Not installed - limited validation"
        return 0
    fi

    # Valid JSON
    if jq . "$SESSION_STATE_FILE" > /dev/null 2>&1; then
        check_item "JSON Format" "pass"
    else
        check_item "JSON Format" "fail" "Invalid JSON"
        return 1
    fi

    # Required fields
    local required_fields=(
        ".schema_version:Schema Version"
        ".project.name:Project Name"
        ".current.phase:Current Phase"
        ".current.task:Current Task"
        ".current.working_branch:Working Branch"
        ".timing.phase_start:Phase Start"
        ".timing.last_activity:Last Activity"
    )

    for field_spec in "${required_fields[@]}"; do
        local field="${field_spec%%:*}"
        local label="${field_spec##*:}"

        if jq -e "$field" "$SESSION_STATE_FILE" > /dev/null 2>&1; then
            local value=$(jq -r "$field" "$SESSION_STATE_FILE")
            check_item "$label" "pass" "$value"
        else
            check_item "$label" "fail" "Missing"
        fi
    done

    # Branch consistency
    echo ""
    print_message "$CYAN" "Consistency Checks:"
    echo ""

    local session_branch=$(jq -r '.current.working_branch' "$SESSION_STATE_FILE" 2>/dev/null)
    local git_branch=$(git branch --show-current 2>/dev/null)

    if [ "$session_branch" = "$git_branch" ]; then
        check_item "Branch Consistency" "pass" "Git and session match"
    else
        check_item "Branch Consistency" "warn" "Git: $git_branch, Session: $session_branch"
    fi

    echo ""
}

# Function: Diagnose recovery infrastructure
diagnose_recovery() {
    print_section "🚑 RECOVERY INFRASTRUCTURE DIAGNOSTICS"
    echo ""

    # Recovery directory
    if [ -d "$RECOVERY_DIR" ]; then
        check_item "Recovery Directory" "pass" "$RECOVERY_DIR"
    else
        check_item "Recovery Directory" "warn" "Does not exist"
        return 0
    fi

    # Session state backups
    local backup_count=$(ls "${RECOVERY_DIR}"/session-state.*.json 2>/dev/null | wc -l)
    if [ "$backup_count" -gt 0 ]; then
        check_item "Session State Backups" "pass" "$backup_count backup(s)"
    else
        check_item "Session State Backups" "warn" "No backups found"
    fi

    # Recovery manifests
    local manifest_count=$(ls "${RECOVERY_DIR}"/manifest.*.json 2>/dev/null | wc -l)
    if [ "$manifest_count" -gt 0 ]; then
        check_item "Recovery Manifests" "pass" "$manifest_count manifest(s)"

        # Show latest manifest
        local latest_manifest=$(ls -t "${RECOVERY_DIR}"/manifest.*.json 2>/dev/null | head -n 1)
        if [ -n "$latest_manifest" ] && command -v jq &> /dev/null; then
            local recovery_time=$(jq -r '.panic_timestamp' "$latest_manifest" 2>/dev/null)
            echo "     Latest: $recovery_time"
        fi
    else
        check_item "Recovery Manifests" "warn" "No manifests found"
    fi

    # Git stash
    local stash_count=$(git stash list 2>/dev/null | wc -l)
    if [ "$stash_count" -gt 0 ]; then
        check_item "Git Stashes" "pass" "$stash_count stash(es)"
    else
        check_item "Git Stashes" "pass" "No stashes"
    fi

    echo ""
}

# Function: Diagnose workflow scripts
diagnose_scripts() {
    print_section "🔧 WORKFLOW SCRIPTS DIAGNOSTICS"
    echo ""

    local scripts=(
        "scripts/git-workflow/start-phase.sh:Start Phase"
        "scripts/git-workflow/complete-task.sh:Complete Task"
        "scripts/git-workflow/complete-phase.sh:Complete Phase"
        "scripts/git-workflow/sync-with-remote.sh:Sync Remote"
        "scripts/git-workflow/where-am-i.sh:Where Am I"
        "scripts/recovery/panic-button.sh:Panic Button"
        "scripts/recovery/emergency-recovery.sh:Emergency Recovery"
        "scripts/recovery/restore-session-state.sh:Restore State"
        "scripts/recovery/diagnose-issues.sh:Diagnose Issues"
    )

    for script_spec in "${scripts[@]}"; do
        local script="${script_spec%%:*}"
        local label="${script_spec##*:}"
        local full_path="${PROJECT_ROOT}/${script}"

        if [ -f "$full_path" ]; then
            if [ -x "$full_path" ] || [ -r "$full_path" ]; then
                check_item "$label" "pass"
            else
                check_item "$label" "warn" "Not executable"
            fi
        else
            check_item "$label" "fail" "Not found"
        fi
    done

    echo ""
}

# Function: Diagnose system dependencies
diagnose_dependencies() {
    print_section "📦 SYSTEM DEPENDENCIES DIAGNOSTICS"
    echo ""

    local dependencies=(
        "git:Git"
        "jq:jq (JSON processor)"
        "bash:Bash Shell"
    )

    for dep_spec in "${dependencies[@]}"; do
        local cmd="${dep_spec%%:*}"
        local label="${dep_spec##*:}"

        if command -v "$cmd" &> /dev/null; then
            local version=$($cmd --version 2>&1 | head -n 1)
            check_item "$label" "pass" "$version"
        else
            check_item "$label" "warn" "Not found"
        fi
    done

    echo ""
}

# Function: Generate summary
generate_summary() {
    print_section "📊 DIAGNOSTIC SUMMARY"
    echo ""

    local issues=()

    # Check critical issues
    if [ ! -f "$SESSION_STATE_FILE" ]; then
        issues+=("Session state file missing")
    fi

    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        issues+=("Not in git repository")
    fi

    if ! git remote get-url origin > /dev/null 2>&1; then
        issues+=("No remote configured")
    fi

    if [ ${#issues[@]} -eq 0 ]; then
        print_message "$GREEN" "✅ No critical issues detected"
        echo ""
        print_message "$CYAN" "System appears healthy. If you're experiencing problems:"
        echo "  1. Check DISASTER-RECOVERY.md for specific scenarios"
        echo "  2. Run panic button to preserve current state"
        echo "  3. Contact support with this diagnostic output"
    else
        print_message "$RED" "❌ Critical issues detected:"
        echo ""
        for issue in "${issues[@]}"; do
            echo "  • $issue"
        done
        echo ""
        print_message "$YELLOW" "Recommended actions:"
        echo "  1. Review DISASTER-RECOVERY.md"
        echo "  2. Run: ./scripts/recovery/emergency-recovery.sh"
        echo "  3. Or initialize new phase: ./scripts/git-workflow/start-phase.sh"
    fi

    echo ""
}

# Main script
main() {
    clear

    echo ""
    print_message "$MAGENTA" "╔═══════════════════════════════════════════════════════╗"
    print_message "$MAGENTA" "║           COMPREHENSIVE SYSTEM DIAGNOSTICS            ║"
    print_message "$MAGENTA" "╚═══════════════════════════════════════════════════════╝"

    diagnose_git
    diagnose_session_state
    diagnose_recovery
    diagnose_scripts
    diagnose_dependencies
    generate_summary

    print_message "$CYAN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
}

# Run main function
main "$@"
