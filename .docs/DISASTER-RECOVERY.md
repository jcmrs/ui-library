# Disaster Recovery Procedures

**Project:** AI-Native UI Component Library
**Version:** 1.0.0
**Last Updated:** 2025-01-23
**Status:** Active

---

## Overview

This document provides **step-by-step recovery procedures** for all failure scenarios in the UI library project. Procedures are optimized for Claude Code execution with minimal decision-making required.

**Recovery Philosophy:**
- Fast automated recovery (target: < 5 minutes)
- Clear decision trees
- One-command solutions when possible
- Confirmation prompts for destructive operations
- Human escalation path for complex scenarios

---

## Table of Contents

1. [Quick Reference](#quick-reference)
2. [Recovery Tools](#recovery-tools)
3. [Failure Scenarios](#failure-scenarios)
4. [Recovery Procedures](#recovery-procedures)
5. [Post-Recovery](#post-recovery)
6. [Escalation](#escalation)

---

## Quick Reference

### Emergency Commands

```bash
# 🚨 PANIC BUTTON - Interactive recovery wizard
./scripts/recovery/panic-button.sh

# 🔥 NUCLEAR OPTION - Reset to remote state
./scripts/recovery/emergency-recovery.sh

# 💾 RESTORE CONTEXT - Reload session state
./scripts/recovery/restore-session-state.sh

# 🔍 DIAGNOSE - Identify problems
./scripts/recovery/diagnose-issues.sh

# 📍 WHERE AM I - Show current state
./scripts/git-workflow/where-am-i.sh
```

### Recovery Time Objectives

| Scenario | RTO (Recovery Time) | RPO (Data Loss) |
|----------|---------------------|-----------------|
| Lost session context | < 1 minute | None |
| Corrupted local git | < 2 minutes | Up to last push |
| Quality gate failures | < 5 minutes | None |
| Wrong branch work | < 3 minutes | None |
| Remote out of sync | < 2 minutes | None |
| Merge conflicts | < 5 minutes | None (with abort) |
| Unknown error | < 5 minutes | Varies |

---

## Recovery Tools

### Tool 1: panic-button.sh

**Purpose:** Interactive recovery wizard for uncertain situations

**When to Use:**
- You don't know what's wrong
- Multiple errors occurring
- Unsure which recovery procedure to use

**Usage:**
```bash
./scripts/recovery/panic-button.sh
```

**What It Does:**
1. Runs diagnostic checks
2. Identifies problem type
3. Recommends recovery procedure
4. Executes with user confirmation
5. Validates recovery success

**Example Output:**
```
🚨 PANIC BUTTON ACTIVATED 🚨

Running diagnostics...
✓ Git repository exists
✓ Remote configured
✗ Working directory not clean (5 modified files)
✓ On correct branch (feature/phase-1)
✗ Uncommitted changes present
✓ Remote reachable

DIAGNOSIS: Uncommitted changes blocking workflow

RECOMMENDED RECOVERY:
  Option 1: Commit changes
    → ./scripts/git-workflow/complete-task.sh <task-id>

  Option 2: Stash changes
    → git stash push -m "WIP: temporary stash"

  Option 3: Discard changes (DESTRUCTIVE!)
    → git restore .

Select option (1/2/3): _
```

---

### Tool 2: emergency-recovery.sh

**Purpose:** Nuclear option - reset to last known-good remote state

**When to Use:**
- Git state is corrupted beyond repair
- Cannot determine what went wrong
- Need clean slate quickly
- As last resort before human escalation

**⚠️ WARNING:** This is destructive! All local uncommitted changes will be lost.

**Usage:**
```bash
./scripts/recovery/emergency-recovery.sh
```

**What It Does:**
1. Backs up current state (just in case)
2. Fetches latest from remote
3. Hard resets to origin/develop
4. Cleans untracked files
5. Restores session state
6. Validates recovery

**Example Output:**
```
⚠️  EMERGENCY RECOVERY ⚠️

This will:
  - Discard ALL local uncommitted changes
  - Reset to last remote state (origin/develop)
  - Delete untracked files
  - Restore session state

Current state will be backed up to: .git/emergency-backup/

Continue? (type 'yes' to confirm): yes

Creating backup...
✓ Backup created: .git/emergency-backup/20250123-143015

Fetching from remote...
✓ Fetched latest from origin

Resetting to origin/develop...
✓ Hard reset complete

Cleaning untracked files...
✓ Cleaned 7 untracked files

Restoring session state...
✓ Session state restored

RECOVERY COMPLETE
Current branch: develop
Working directory: clean
Last checkpoint: phase-1-complete

Next steps:
  1. Review what was lost: ls .git/emergency-backup/20250123-143015
  2. Check current state: ./scripts/git-workflow/where-am-i.sh
  3. Resume work: ./scripts/git-workflow/start-phase.sh <N>
```

---

### Tool 3: restore-session-state.sh

**Purpose:** Restore session context after loss or corruption

**When to Use:**
- Session state file is missing
- Session state file is corrupted
- Claude Code lost context between conversations
- After manual git operations

**Usage:**
```bash
./scripts/recovery/restore-session-state.sh
```

**What It Does:**
1. Checks if session state exists
2. If corrupted, backs up old file
3. Analyzes git state to infer context
4. Prompts for any missing information
5. Reconstructs session-state.json
6. Validates reconstruction

**Example Output:**
```
🔄 RESTORING SESSION STATE

Checking existing session state...
✗ Session state file corrupted

Backing up corrupted file...
✓ Backup: .claude/session-state.json.backup

Analyzing git repository...
✓ Current branch: feature/phase-1
✓ Base branch: develop
✓ Last checkpoint: task-1.1.1-complete
✓ Remote: https://github.com/jcmrs/ui-library.git

Could not determine current task from git state.
What task are you working on? (format: X.Y.Z): 1.1.2

Reconstructing session state...
✓ Session state reconstructed

Validating...
✓ All required fields present
✓ Branch exists
✓ Checkpoint tag exists
✓ Remote is valid

SESSION STATE RESTORED

Current state:
  Phase: 1 (Automated Foundation)
  Task: 1.1.2 (Setup Script)
  Branch: feature/phase-1
  Last checkpoint: task-1.1.1-complete

You can continue working.
```

---

### Tool 4: diagnose-issues.sh

**Purpose:** Identify problems without taking action

**When to Use:**
- Before recovery (to understand what's wrong)
- After recovery (to validate success)
- Regular health checks

**Usage:**
```bash
./scripts/recovery/diagnose-issues.sh
```

**What It Does:**
1. Runs comprehensive diagnostics
2. Reports all findings
3. Suggests recovery procedures
4. Does not modify anything

**Example Output:**
```
🔍 SYSTEM DIAGNOSTICS

Git Repository:
  ✓ Repository exists
  ✓ .git directory valid
  ✓ Remote configured (origin)
  ✓ Remote reachable

Branch State:
  ✓ Current branch: feature/phase-1
  ✓ Branch exists locally
  ✓ Branch exists on remote
  ✓ Tracking remote branch

Working Directory:
  ✗ Modified files: 5
  ✗ Untracked files: 2
  ✓ No staged files
  ⚠ Working directory not clean

Session State:
  ✓ Session state file exists
  ✓ Session state valid JSON
  ✓ All required fields present
  ✓ Branch matches session state

Quality Gates:
  ✗ TypeScript errors: 3
  ✗ Lint errors: 7
  ✓ Tests pass
  ✓ Coverage: 92%

Remote Sync:
  ⚠ Local ahead by 2 commits
  ✓ Remote not ahead
  ✓ Can push

SUMMARY:
  Issues found: 3
  Warnings: 1
  All checks passed: No

RECOMMENDED ACTIONS:
  1. Fix TypeScript errors (3 files affected)
  2. Fix lint errors (7 issues)
  3. Push local commits to remote
  4. Commit or stash working directory changes
```

---

## Failure Scenarios

### Scenario Matrix

| ID | Scenario | Likelihood | Impact | Priority |
|----|----------|------------|--------|----------|
| S1 | [Corrupted Local Git](#s1-corrupted-local-git) | Low | High | P1 |
| S2 | [Lost Session Context](#s2-lost-session-context) | High | Medium | P1 |
| S3 | [Quality Gate Failures](#s3-quality-gate-failures) | High | Low | P2 |
| S4 | [Wrong Branch Work](#s4-wrong-branch-work) | Medium | Medium | P2 |
| S5 | [Remote Out of Sync](#s5-remote-out-of-sync) | Medium | High | P1 |
| S6 | [Merge Conflicts](#s6-merge-conflicts) | Low | High | P1 |
| S7 | [Uncommitted Changes](#s7-uncommitted-changes) | High | Low | P3 |
| S8 | [Lost Work (Accidental Delete)](#s8-lost-work-accidental-delete) | Low | High | P1 |
| S9 | [Cannot Push to Remote](#s9-cannot-push-to-remote) | Medium | Medium | P2 |
| S10 | [Detached HEAD State](#s10-detached-head-state) | Low | Medium | P2 |

---

## Recovery Procedures

### S1: Corrupted Local Git

**Symptoms:**
- Git commands fail with errors
- `.git` directory seems corrupted
- Cannot checkout branches
- Strange git error messages

**Diagnosis:**
```bash
./scripts/recovery/diagnose-issues.sh
# Look for: "Git repository validation failed"
```

**Recovery Procedure:**

**Option 1: Emergency Recovery (Recommended)**
```bash
./scripts/recovery/emergency-recovery.sh
# Resets to clean remote state
# Time: ~2 minutes
# Data loss: Uncommitted changes only
```

**Option 2: Manual Git Repair**
```bash
# Verify corruption
git fsck

# If repairs possible
git fsck --full

# If still broken, use emergency recovery
```

**Validation:**
```bash
git status  # Should work without errors
./scripts/git-workflow/where-am-i.sh  # Should show state
```

**Post-Recovery:**
- Review lost work in `.git/emergency-backup/`
- Restore session state
- Continue from last checkpoint

---

### S2: Lost Session Context

**Symptoms:**
- `.claude/session-state.json` missing
- `.claude/session-state.json` corrupted
- Claude Code doesn't know current task
- Cannot determine what to work on next

**Diagnosis:**
```bash
cat .claude/session-state.json
# If error or malformed JSON, state is corrupted
```

**Recovery Procedure:**

```bash
./scripts/recovery/restore-session-state.sh
```

**Manual Steps (if script fails):**

1. **Determine Current Branch:**
```bash
git branch --show-current
# Should show feature/phase-N or develop
```

2. **Find Last Checkpoint:**
```bash
git tag -l "task-*" | tail -5
# Shows recent task completions
```

3. **Check Git Log:**
```bash
git log --oneline -10
# Review recent commit messages for context
```

4. **Manually Create Session State:**
```bash
cat > .claude/session-state.json << 'EOF'
{
  "project": "ui-library",
  "version": "1.0.0",
  "current_phase": "1",
  "current_task": "1.1.2",
  "working_branch": "feature/phase-1",
  "base_branch": "develop",
  "last_checkpoint": {
    "tag": "task-1.1.1-complete",
    "commit": "$(git rev-parse HEAD)",
    "timestamp": "$(date -Iseconds)"
  },
  "remote_url": "https://github.com/jcmrs/ui-library.git"
}
EOF
```

**Validation:**
```bash
./scripts/git-workflow/where-am-i.sh
# Should display current state correctly
```

---

### S3: Quality Gate Failures

**Symptoms:**
- `complete-task.sh` fails with quality gate errors
- TypeScript errors
- Lint errors
- Test failures
- Coverage below threshold

**Diagnosis:**
```bash
./scripts/recovery/diagnose-issues.sh
# Shows specific quality gate failures
```

**Recovery Procedure:**

**For TypeScript Errors:**
```bash
# See errors
bun run type-check

# Common fixes:
# 1. Add missing types
# 2. Fix type mismatches
# 3. Add @ts-expect-error with explanation if needed
```

**For Lint Errors:**
```bash
# Auto-fix what's possible
bun run lint

# Manual fixes for remaining errors
# Check: eslint output for specific issues
```

**For Test Failures:**
```bash
# Run tests to see failures
bun run test

# Fix failing tests
# Update snapshots if needed: bun run test -- -u
```

**For Coverage Issues:**
```bash
# See coverage report
bun run test -- --coverage

# Add tests for uncovered code
# Or adjust coverage thresholds if appropriate
```

**Validation:**
```bash
# Run full quality check
./scripts/quality/validate-all.sh

# Should pass all gates
```

---

### S4: Wrong Branch Work

**Symptoms:**
- Commits on wrong branch
- Work meant for feature branch on develop
- Work meant for one phase in another phase branch

**Diagnosis:**
```bash
git log --oneline -5  # Review recent commits
git branch --show-current  # Check current branch
```

**Recovery Procedure:**

**Scenario A: Uncommitted Work on Wrong Branch**
```bash
# 1. Stash changes
git stash push -m "Work intended for feature/phase-N"

# 2. Switch to correct branch
git checkout feature/phase-N

# 3. Apply stashed changes
git stash pop

# 4. Continue working
```

**Scenario B: Committed Work on Wrong Branch**
```bash
# 1. Note the commit hash
COMMIT=$(git rev-parse HEAD)

# 2. Switch to correct branch
git checkout feature/phase-N

# 3. Cherry-pick the commit
git cherry-pick $COMMIT

# 4. Go back to wrong branch
git checkout <wrong-branch>

# 5. Remove the commit from wrong branch
git reset --hard HEAD~1

# 6. Return to correct branch
git checkout feature/phase-N
```

**Scenario C: Multiple Commits on Wrong Branch**
```bash
# 1. Create patch of all wrong commits
git format-patch develop..HEAD -o /tmp/patches

# 2. Reset wrong branch
git checkout <wrong-branch>
git reset --hard develop

# 3. Switch to correct branch
git checkout feature/phase-N

# 4. Apply patches
git am /tmp/patches/*

# 5. Clean up
rm -rf /tmp/patches
```

**Validation:**
```bash
./scripts/git-workflow/where-am-i.sh
git log --oneline --graph --all
```

---

### S5: Remote Out of Sync

**Symptoms:**
- Cannot push to remote
- Local and remote have diverged
- Push rejected by remote
- Conflict warnings

**Diagnosis:**
```bash
./scripts/git-workflow/sync-with-remote.sh
# Shows sync status and divergence
```

**Recovery Procedure:**

**Scenario A: Local Ahead of Remote (Safe)**
```bash
# Simply push
git push origin $(git branch --show-current)
```

**Scenario B: Remote Ahead of Local (Safe)**
```bash
# Simply pull
git pull origin $(git branch --show-current)
```

**Scenario C: Diverged (Dangerous)**

```bash
# 1. Check divergence
git fetch origin
git log HEAD..origin/$(git branch --show-current) --oneline  # Remote commits
git log origin/$(git branch --show-current)..HEAD --oneline  # Local commits

# 2. Decide strategy

# Strategy A: Keep Local (if you trust local more)
git push --force-with-lease origin $(git branch --show-current)

# Strategy B: Keep Remote (if you trust remote more)
git reset --hard origin/$(git branch --show-current)

# Strategy C: Merge (if both are valuable)
git merge origin/$(git branch --show-current)
# If conflicts occur, see S6: Merge Conflicts

# Strategy D: Uncertain? Use emergency recovery
./scripts/recovery/emergency-recovery.sh
```

**Validation:**
```bash
./scripts/git-workflow/sync-with-remote.sh
# Should show: "Local and remote are in sync"
```

---

### S6: Merge Conflicts

**Symptoms:**
- Merge failed due to conflicts
- Files marked with conflict markers
- Cannot commit or checkout
- Git status shows "both modified"

**Diagnosis:**
```bash
git status
# Look for: "both modified" or "unmerged paths"

git diff --name-only --diff-filter=U
# Lists files with conflicts
```

**Recovery Procedure:**

**⚠️ WARNING:** Claude Code cannot resolve conflicts. Abort and seek human help.

```bash
# STEP 1: Abort the merge
git merge --abort

# STEP 2: Assess situation
./scripts/recovery/diagnose-issues.sh

# STEP 3: Choose recovery path

# Path A: Reset to safe state
git reset --hard origin/develop

# Path B: Keep local work, avoid merge
# (Continue working, push will create divergence, handle later)

# Path C: Escalate to human
echo "MERGE CONFLICT - HUMAN INTERVENTION REQUIRED" > CONFLICT.txt
echo "Branch: $(git branch --show-current)" >> CONFLICT.txt
echo "Attempted merge from: <source-branch>" >> CONFLICT.txt
echo "Conflicting files: $(git diff --name-only --diff-filter=U)" >> CONFLICT.txt
```

**Validation:**
```bash
git status
# Should NOT show "unmerged paths"

git diff
# Should NOT show conflict markers (<<<<<<<, =======, >>>>>>>)
```

**Post-Recovery:**
- Document conflict details
- Human must manually merge
- Resume automation after human resolution

---

### S7: Uncommitted Changes

**Symptoms:**
- Working directory not clean
- Modified or untracked files
- Cannot switch branches
- Scripts abort due to dirty working directory

**Diagnosis:**
```bash
git status
# Shows modified/untracked files

git diff
# Shows exact changes
```

**Recovery Procedure:**

**Option 1: Commit Changes (if work is complete)**
```bash
./scripts/git-workflow/complete-task.sh <task-id>
```

**Option 2: Stash Changes (if work is incomplete)**
```bash
# Stash with descriptive message
git stash push -m "WIP: Task 1.1.2 - partial implementation"

# Later, retrieve with:
git stash list  # Find stash
git stash pop  # Apply and remove from stash
```

**Option 3: Discard Changes (if work is wrong)**
```bash
# ⚠️ DESTRUCTIVE - Cannot undo!

# Discard all changes
git restore .

# Or discard specific file
git restore <file-path>

# Remove untracked files
git clean -fd
```

**Validation:**
```bash
git status
# Should show: "working tree clean"
```

---

### S8: Lost Work (Accidental Delete)

**Symptoms:**
- Accidentally deleted code
- Commits seem to have disappeared
- Branch was deleted
- File was removed

**Diagnosis:**
```bash
# Check if in git history
git log --all --full-history -- <file-path>

# Check reflog (shows all recent HEAD movements)
git reflog

# Check stash (might have been stashed)
git stash list
```

**Recovery Procedure:**

**Scenario A: File Deleted but Not Committed**
```bash
# Restore from last commit
git restore <file-path>
```

**Scenario B: File Deleted and Committed**
```bash
# Find commit that deleted file
git log --all --full-history -- <file-path>

# Restore from commit before deletion
git checkout <commit-hash>~1 -- <file-path>

# Or restore to specific version
git checkout <commit-hash> -- <file-path>
```

**Scenario C: Branch Deleted**
```bash
# Find branch in reflog
git reflog
# Look for branch name

# Recreate branch at that commit
git checkout -b <branch-name> <commit-hash>
```

**Scenario D: Commit Lost (Reset/Rebase)**
```bash
# Find commit in reflog
git reflog
# Look for commit message

# Cherry-pick or reset to that commit
git cherry-pick <commit-hash>
# Or
git reset --hard <commit-hash>
```

**Scenario E: Everything is Lost**
```bash
# Check emergency backup (if exists)
ls .git/emergency-backup/

# Check remote (might be pushed)
git fetch origin
git log origin/<branch-name>
```

**Validation:**
```bash
# Verify file restored
ls <file-path>
cat <file-path>

# Verify in git
git log -- <file-path>
```

---

### S9: Cannot Push to Remote

**Symptoms:**
- `git push` fails
- Authentication errors
- Network errors
- Remote rejection

**Diagnosis:**
```bash
# Test remote connection
git fetch origin

# Check remote URL
git remote -v

# Check push permissions
git remote show origin
```

**Recovery Procedure:**

**Error Type 1: Authentication Failed**
```bash
# Check credentials
git credential fill

# Re-authenticate (if using HTTPS)
git remote set-url origin https://github.com/jcmrs/ui-library.git

# Or use SSH
git remote set-url origin git@github.com:jcmrs/ui-library.git
```

**Error Type 2: Network Error**
```bash
# Test connection
ping github.com

# Try again
git push origin $(git branch --show-current)

# If still fails, save work locally
# Human will push later
```

**Error Type 3: Branch Protection**
```bash
# Cannot push directly to protected branch
# Push to different branch
git push origin HEAD:feature/temp-branch

# Or use pull request workflow
```

**Error Type 4: Remote Ahead**
```bash
# See S5: Remote Out of Sync
./scripts/git-workflow/sync-with-remote.sh
```

**Validation:**
```bash
git push origin $(git branch --show-current)
# Should succeed without errors

git log origin/$(git branch --show-current)
# Should match local HEAD
```

---

### S10: Detached HEAD State

**Symptoms:**
- Warning: "You are in 'detached HEAD' state"
- Not on any branch
- Commits are not saved to branch

**Diagnosis:**
```bash
git branch
# Shows: * (HEAD detached at <commit>)

git status
# Shows: HEAD detached at <commit>
```

**Recovery Procedure:**

**Scenario A: No Work Done in Detached State**
```bash
# Simply checkout a branch
git checkout develop
```

**Scenario B: Work Done but Not Committed**
```bash
# Stash the work
git stash push -m "Work from detached HEAD"

# Checkout branch
git checkout develop

# Apply stash
git stash pop
```

**Scenario C: Commits Made in Detached State**
```bash
# Note current commit
COMMIT=$(git rev-parse HEAD)

# Create branch from detached HEAD
git checkout -b recovery/detached-work

# Or merge into existing branch
git checkout develop
git merge $COMMIT
```

**Validation:**
```bash
git branch
# Should show branch with * prefix (not detached HEAD)

git status
# Should show "On branch <name>"
```

---

## Post-Recovery

### After Any Recovery

1. **Validate Recovery Success:**
```bash
./scripts/recovery/diagnose-issues.sh
# Should pass all checks
```

2. **Verify Session State:**
```bash
./scripts/git-workflow/where-am-i.sh
# Should display correct state
```

3. **Document What Happened:**
```bash
# Create post-incident note
cat >> .claude/incidents.log << EOF
$(date -Iseconds) - Recovery performed
Scenario: <scenario-id>
Procedure: <procedure-used>
Data lost: <yes/no/details>
Lessons: <what-to-prevent-recurrence>
---
EOF
```

4. **Resume Normal Workflow:**
```bash
# Continue with current task
# Or start new task
./scripts/git-workflow/complete-task.sh <task-id>
```

### Post-Incident Analysis

After significant recovery incidents:

**1. Document Root Cause:**
- What caused the failure?
- Was it preventable?
- Was it detected quickly?

**2. Update Procedures:**
- Did recovery procedure work?
- What could be improved?
- Should automation be updated?

**3. Prevent Recurrence:**
- Add validation checks
- Improve error messages
- Update documentation

---

## Escalation

### When to Escalate to Human

Escalate if:
- Recovery procedures don't work
- Data loss is unacceptable
- Merge conflicts cannot be resolved
- Repository state is too complex
- Uncertain about correct recovery path
- Same failure keeps recurring

### How to Escalate

**1. Create Escalation Report:**
```bash
cat > ESCALATION-REPORT.txt << 'EOF'
ESCALATION REQUIRED

Date: $(date)
Scenario: <description>
Attempted Recoveries: <list procedures tried>
Current State: <output of diagnose-issues.sh>
Data at Risk: <description>
Uncertainty: <what is unclear>

See .claude/incidents.log for full history.
EOF
```

**2. Preserve Current State:**
```bash
# Create full state snapshot
mkdir -p .git/escalation-snapshot
git stash -u  # Stash all changes including untracked
cp .claude/*.json .git/escalation-snapshot/
git log --oneline -20 > .git/escalation-snapshot/git-log.txt
git status > .git/escalation-snapshot/git-status.txt
git remote -v > .git/escalation-snapshot/git-remotes.txt
```

**3. Notify Human:**
- Place ESCALATION-REPORT.txt in project root
- Wait for human intervention
- Do not attempt further automated recovery

---

## Testing Recovery Procedures

### Regular Testing Schedule

**Weekly:**
- Test session state restoration
- Test sync-with-remote.sh

**Monthly:**
- Test emergency recovery (in test repo)
- Test panic-button.sh workflows
- Review and update procedures

**After Any Incident:**
- Test the recovery procedure used
- Validate improvements work

### Testing Protocol

```bash
# 1. Create test repository
cd /tmp
git clone https://github.com/jcmrs/ui-library.git test-recovery
cd test-recovery

# 2. Simulate failure scenario
# (e.g., corrupt session state, create divergence)

# 3. Run recovery procedure
./scripts/recovery/<recovery-script>.sh

# 4. Validate recovery
./scripts/recovery/diagnose-issues.sh

# 5. Document results
echo "Test passed/failed: <details>" >> test-recovery.log

# 6. Clean up
cd ..
rm -rf test-recovery
```

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2025-01-23 | Initial disaster recovery procedures |

---

## See Also

- [GIT-WORKFLOW.md](GIT-WORKFLOW.md) - Normal git workflow
- [SESSION-STATE.md](SESSION-STATE.md) - Session state details
- [TASKS.md](TASKS.md) - Task tracking
