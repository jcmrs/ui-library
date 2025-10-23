# Git Workflow for UI Library Project

**Project:** AI-Native UI Component Library
**Version:** 1.0.0
**Last Updated:** 2025-01-23
**Status:** Active

---

## Overview

This document defines the **automated git workflow** specifically designed for Claude Code usage. The workflow eliminates manual git operations and ensures:

- Zero git knowledge required by Claude Code
- Automatic checkpointing after each task
- Remote backup synchronization
- Session state persistence across conversations
- One-command recovery from failures

**Critical Principle:** Claude Code NEVER uses git commands directly. All git operations are performed through semantic wrapper scripts.

---

## Table of Contents

1. [Core Concepts](#core-concepts)
2. [Branch Strategy](#branch-strategy)
3. [Workflow Scripts](#workflow-scripts)
4. [Session State Management](#session-state-management)
5. [Checkpoint System](#checkpoint-system)
6. [Remote Synchronization](#remote-synchronization)
7. [Recovery Procedures](#recovery-procedures)
8. [Manual Override](#manual-override)

---

## Core Concepts

### Automated Git Operations

**Traditional Workflow (NEVER USE):**
```bash
# ❌ Claude Code cannot reliably do this
git checkout -b feature/phase-1
# ... work happens ...
git add .
git commit -m "some changes"
git push origin feature/phase-1
```

**Automated Workflow (USE THIS):**
```bash
# ✅ One command handles everything
./scripts/git-workflow/start-phase.sh 1
# ... work happens ...
./scripts/git-workflow/complete-task.sh 1.1.1
# ... more work ...
./scripts/git-workflow/complete-phase.sh 1
```

### Why Automation is Required

Claude Code has specific limitations:
- **No Mental Model**: Cannot visualize branch topology
- **No Persistent State**: Forgets context between sessions
- **Pattern Matching Only**: Cannot reason about git concepts
- **No Error Recovery**: Gets stuck in failure loops

Automation compensates by:
- Eliminating all git decisions
- Maintaining session state in JSON
- Providing one-command recovery
- Automatic checkpoint creation

---

## Branch Strategy

### Branch Structure

```
main (protected)
  └─ develop (integration branch)
      ├─ feature/phase-1
      ├─ feature/phase-2
      ├─ feature/phase-3
      └─ hotfix/critical-bug
```

### Branch Rules

**Main Branch:**
- Protected (no direct commits)
- Only accepts merges from develop
- Tagged with version numbers (v1.0.0, v2.0.0)
- Represents production-ready code

**Develop Branch:**
- Integration branch
- Accepts merges from feature branches
- Tagged with phase checkpoints (phase-1-complete, phase-2-complete)
- Current working baseline

**Feature Branches:**
- Created automatically by `start-phase.sh`
- Named `feature/phase-N` where N is phase number
- Deleted after merge to develop
- Short-lived (lifetime of one phase)

**Hotfix Branches:**
- Created manually for critical bugs
- Named `hotfix/description`
- Merged to both main and develop
- Rare (only for production emergencies)

### Branch Lifecycle

```
1. Start Phase
   develop → feature/phase-1

2. Work in Feature Branch
   Commits happen on feature/phase-1

3. Complete Phase
   feature/phase-1 → develop (merged)
   feature/phase-1 deleted
   develop tagged with phase-1-complete

4. Start Next Phase
   develop → feature/phase-2
   [cycle repeats]
```

---

## Workflow Scripts

All scripts located in `scripts/git-workflow/`

### 1. start-phase.sh

**Purpose:** Begin a new project phase with automated branch creation

**Usage:**
```bash
./scripts/git-workflow/start-phase.sh <phase-number>
```

**Example:**
```bash
./scripts/git-workflow/start-phase.sh 1
```

**What It Does:**
1. Validates current branch is develop
2. Validates working directory is clean
3. Creates feature branch `feature/phase-<N>`
4. Checks out the new branch
5. Updates session state JSON
6. Displays task list for the phase
7. Creates initial checkpoint tag

**Output:**
```
✓ Current branch: develop
✓ Working directory clean
✓ Creating branch: feature/phase-1
✓ Checked out: feature/phase-1
✓ Session state updated
✓ Initial checkpoint created: phase-1-start

Phase 1: Automated Foundation
Tasks for this phase:
  1.0.1: Git Workflow Scripts
  1.0.2: Session State Management
  1.0.3: Recovery Infrastructure
  1.0.4: Automation Documentation

See TASKS.md for details.
```

**Error Handling:**
- If working directory not clean → prompts to commit or stash
- If branch already exists → offers to checkout existing or abort
- If not on develop → prompts to switch to develop first

---

### 2. complete-task.sh

**Purpose:** Complete a task with quality validation, commit, and checkpoint

**Usage:**
```bash
./scripts/git-workflow/complete-task.sh <phase>.<section>.<task>
```

**Example:**
```bash
./scripts/git-workflow/complete-task.sh 1.1.1
```

**What It Does:**
1. Validates quality gates (tests, lint, typecheck)
2. Stages all changes
3. Generates descriptive commit message
4. Creates commit
5. Creates checkpoint tag
6. Pushes to remote
7. Updates session state
8. Updates progress tracking

**Commit Message Format:**
```
feat(phase-1): Complete Task 1.1.1 - Create Configuration Templates

- Added package.json.template with locked dependencies
- Added tsconfig.json.template with strict mode
- Added eslint.config.js.template
- Added tailwind.config.ts.template
- Added .storybook/main.ts.template

Task: 1.1.1
Phase: 1
Status: Complete
Coverage: 95%
```

**Quality Gates:**
```bash
# All must pass before commit allowed:
✓ TypeScript type-check (bun run type-check)
✓ ESLint validation (bun run lint)
✓ Prettier formatting (bun run prettier)
✓ Tests pass (bun run test)
✓ Coverage ≥ 90%
```

**Output:**
```
Running quality gates...
✓ TypeScript check passed
✓ Lint passed
✓ Prettier passed
✓ Tests passed (coverage: 95%)

Creating commit...
✓ Commit created: feat(phase-1): Complete Task 1.1.1

Creating checkpoint...
✓ Checkpoint tag: task-1.1.1-complete

Pushing to remote...
✓ Pushed to origin/feature/phase-1

Updating session state...
✓ Session state updated

Task 1.1.1 completed successfully!
Next task: 1.1.2
```

**Error Handling:**
- If quality gates fail → shows errors, aborts commit
- If no changes → warns and aborts
- If remote push fails → shows error, commit still created locally

---

### 3. complete-phase.sh

**Purpose:** Complete a phase by merging to develop and creating release checkpoint

**Usage:**
```bash
./scripts/git-workflow/complete-phase.sh <phase-number>
```

**Example:**
```bash
./scripts/git-workflow/complete-phase.sh 1
```

**What It Does:**
1. Validates all phase tasks are complete
2. Runs full quality validation
3. Switches to develop branch
4. Merges feature branch
5. Creates phase completion tag
6. Pushes to remote (branch + tags)
7. Deletes feature branch
8. Updates session state
9. Updates roadmap progress

**Output:**
```
Validating Phase 1 completion...
✓ All tasks marked complete
✓ Quality gates pass

Merging to develop...
✓ Switched to develop
✓ Merged feature/phase-1
✓ Tag created: phase-1-complete

Pushing to remote...
✓ Pushed develop to origin
✓ Pushed tags to origin

Cleaning up...
✓ Deleted feature/phase-1 (local)
✓ Deleted feature/phase-1 (remote)

Phase 1 completed successfully!
Next phase: Phase 2
```

**Pre-Merge Validation:**
- All tasks in phase must be marked complete
- Quality gates must pass
- Remote must be in sync
- Working directory must be clean

**Error Handling:**
- If tasks incomplete → lists missing tasks, aborts
- If quality gates fail → shows errors, aborts
- If merge conflicts → aborts, provides recovery instructions

---

### 4. sync-with-remote.sh

**Purpose:** Synchronize local repository with remote

**Usage:**
```bash
./scripts/git-workflow/sync-with-remote.sh
```

**What It Does:**
1. Fetches from remote
2. Compares local and remote state
3. Pushes or pulls as needed
4. Detects conflicts
5. Provides recovery guidance

**Scenarios:**

**Scenario 1: Local and Remote in Sync**
```
✓ Local and remote are in sync
Nothing to do.
```

**Scenario 2: Local Ahead of Remote**
```
→ Local is ahead by 3 commits
→ Pushing to remote...
✓ Pushed successfully
```

**Scenario 3: Remote Ahead of Local**
```
→ Remote is ahead by 2 commits
→ Pulling from remote...
✓ Pulled successfully
```

**Scenario 4: Diverged (Conflict)**
```
✗ Local and remote have diverged!

Local commits not on remote: 5
Remote commits not on local: 3

This requires manual resolution:
1. Review local changes: git log origin/develop..develop
2. Review remote changes: git log develop..origin/develop
3. Choose resolution:
   a) Keep local: git push --force origin develop (DANGER!)
   b) Keep remote: git reset --hard origin/develop (LOSES LOCAL WORK!)
   c) Manual merge: Contact human for assistance

Recommendation: Use emergency recovery if uncertain
  ./scripts/recovery/emergency-recovery.sh
```

---

### 5. where-am-i.sh

**Purpose:** Display current project state

**Usage:**
```bash
./scripts/git-workflow/where-am-i.sh
```

**Output:**
```
═══════════════════════════════════════
    UI LIBRARY PROJECT STATUS
═══════════════════════════════════════

Current Phase:    1 (Automated Foundation)
Current Task:     1.1.1 (Create Configuration Templates)
Working Branch:   feature/phase-1
Base Branch:      develop

Git Status:
  Modified files:     3
  Untracked files:    2
  Staged files:       0

Last Checkpoint:
  Tag:     task-1.0.4-complete
  Date:    2025-01-23 14:32:15
  Commit:  a3f8d9c

Remote Sync:
  Local commits:      2 ahead
  Remote commits:     0 behind
  Status:            ✓ Ready to push

Next Steps:
  1. Complete current task: ./scripts/git-workflow/complete-task.sh 1.1.1
  2. View task details: See TASKS.md line 125

═══════════════════════════════════════
```

---

## Session State Management

### Session State File

**Location:** `.claude/session-state.json`

**Schema:**
```json
{
  "project": "ui-library",
  "version": "1.0.0",
  "current_phase": "1",
  "current_task": "1.1.1",
  "working_branch": "feature/phase-1",
  "base_branch": "develop",
  "phase_start_date": "2025-01-23T10:00:00Z",
  "last_checkpoint": {
    "tag": "task-1.0.4-complete",
    "commit": "a3f8d9c",
    "timestamp": "2025-01-23T14:32:15Z"
  },
  "tasks_completed": [
    "1.0.1",
    "1.0.2",
    "1.0.3",
    "1.0.4"
  ],
  "remote_url": "https://github.com/jcmrs/ui-library.git",
  "last_sync": "2025-01-23T14:35:00Z"
}
```

### Progress Tracking File

**Location:** `.claude/progress.json`

**Schema:**
```json
{
  "phases": {
    "phase-1": {
      "name": "Automated Foundation",
      "status": "in-progress",
      "start_date": "2025-01-23T10:00:00Z",
      "completion_date": null,
      "tasks": {
        "1.0.1": { "status": "completed", "completed_at": "2025-01-23T11:30:00Z" },
        "1.0.2": { "status": "completed", "completed_at": "2025-01-23T12:45:00Z" },
        "1.0.3": { "status": "completed", "completed_at": "2025-01-23T13:50:00Z" },
        "1.0.4": { "status": "completed", "completed_at": "2025-01-23T14:30:00Z" },
        "1.1.1": { "status": "in-progress", "started_at": "2025-01-23T15:00:00Z" }
      }
    }
  }
}
```

### State Updates

Session state is updated automatically by workflow scripts:

- `start-phase.sh` → Sets current_phase, creates working_branch
- `complete-task.sh` → Updates current_task, adds to tasks_completed
- `complete-phase.sh` → Marks phase complete, resets to develop
- `sync-with-remote.sh` → Updates last_sync timestamp

### State Restoration

If session state is lost or corrupted:

```bash
./scripts/recovery/restore-session-state.sh

# Prompts for:
# - Current phase number
# - Current task number
# - Validates against git state
# - Reconstructs session-state.json
```

---

## Checkpoint System

### Checkpoint Types

**1. Task Checkpoints**
- Created by `complete-task.sh`
- Format: `task-<phase>.<section>.<task>-complete`
- Example: `task-1.1.1-complete`
- Frequency: After every task completion

**2. Phase Checkpoints**
- Created by `complete-phase.sh`
- Format: `phase-<N>-complete`
- Example: `phase-1-complete`
- Frequency: After phase completion

**3. Emergency Checkpoints**
- Created manually or by panic-button.sh
- Format: `emergency-<timestamp>`
- Example: `emergency-20250123-143015`
- Frequency: Before risky operations

**4. Automatic Checkpoints**
- Created by automated monitoring
- Format: `auto-checkpoint-<timestamp>`
- Example: `auto-checkpoint-20250123-150000`
- Frequency: Hourly (if changes exist)

### Checkpoint Operations

**Create Checkpoint:**
```bash
git tag -a "task-1.1.1-complete" -m "Task 1.1.1: Configuration templates"
git push origin --tags
```

**List Checkpoints:**
```bash
git tag -l "task-*"
git tag -l "phase-*"
```

**View Checkpoint Details:**
```bash
git show task-1.1.1-complete
```

**Restore from Checkpoint:**
```bash
# Soft restore (keep working changes)
git reset --soft task-1.1.1-complete

# Hard restore (discard working changes)
git reset --hard task-1.1.1-complete
```

### Checkpoint Retention

- Task checkpoints: Kept indefinitely
- Phase checkpoints: Kept indefinitely
- Emergency checkpoints: Kept for 30 days
- Auto checkpoints: Kept for 7 days

---

## Remote Synchronization

### Remote Repository

**URL:** https://github.com/jcmrs/ui-library
**Primary Branch:** develop
**Protected Branches:** main, develop

### Automatic Synchronization

Workflow scripts automatically push to remote:

- `complete-task.sh` → Pushes after each task
- `complete-phase.sh` → Pushes after phase completion
- `sync-with-remote.sh` → Can be called manually

### Manual Push (Emergency Only)

```bash
# Push current branch
git push origin $(git branch --show-current)

# Push with tags
git push origin $(git branch --show-current) --tags
```

### Conflict Resolution

If push fails due to conflicts:

```bash
./scripts/git-workflow/sync-with-remote.sh

# Follow on-screen instructions
# If stuck, use recovery:
./scripts/recovery/panic-button.sh
```

---

## Recovery Procedures

### Quick Recovery Reference

| Scenario | Command | Time |
|----------|---------|------|
| Lost context | `./scripts/recovery/restore-session-state.sh` | 1 min |
| Corrupted git state | `./scripts/recovery/emergency-recovery.sh` | 2 min |
| Wrong branch | `./scripts/git-workflow/where-am-i.sh` then switch | 30 sec |
| Need to undo task | `git reset --hard <checkpoint-tag>` | 30 sec |
| Remote out of sync | `./scripts/git-workflow/sync-with-remote.sh` | 1-3 min |
| Don't know what's wrong | `./scripts/recovery/panic-button.sh` | 2-5 min |

See [DISASTER-RECOVERY.md](DISASTER-RECOVERY.md) for detailed procedures.

---

## Manual Override

### When Manual Override is Needed

Automation handles 95% of scenarios. Manual override needed for:

- Complex merge conflicts
- Git state corruption beyond automated recovery
- Multi-branch operations (rare)
- Repository restructuring (very rare)

### Human Git Commands

If human needs to intervene:

```bash
# Check git status
git status

# View branch structure
git log --oneline --graph --all --decorate

# View what's changed
git diff

# View remote state
git fetch origin
git log origin/develop

# Interactive operations
git rebase -i origin/develop
git cherry-pick <commit-hash>
```

### Returning to Automated Workflow

After manual intervention:

1. Ensure working directory is clean
2. Restore session state: `./scripts/recovery/restore-session-state.sh`
3. Verify with: `./scripts/git-workflow/where-am-i.sh`
4. Resume normal workflow

---

## Best Practices

### For Claude Code

1. **NEVER use git commands directly**
2. **ALWAYS use workflow scripts**
3. **Complete tasks one at a time**
4. **Let scripts handle commits**
5. **Check status with where-am-i.sh**
6. **Use panic-button.sh if confused**

### For Humans

1. **Trust the automation** - it's designed to work
2. **Don't bypass scripts** unless absolutely necessary
3. **Document manual interventions** in git commit messages
4. **Test recovery procedures** regularly
5. **Keep scripts updated** as project evolves

---

## Script Reference Summary

| Script | Purpose | Usage |
|--------|---------|-------|
| `start-phase.sh` | Begin new phase | `./scripts/git-workflow/start-phase.sh <N>` |
| `complete-task.sh` | Finish task with validation | `./scripts/git-workflow/complete-task.sh <X.Y.Z>` |
| `complete-phase.sh` | Merge phase to develop | `./scripts/git-workflow/complete-phase.sh <N>` |
| `sync-with-remote.sh` | Sync with GitHub | `./scripts/git-workflow/sync-with-remote.sh` |
| `where-am-i.sh` | Show current state | `./scripts/git-workflow/where-am-i.sh` |

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2025-01-23 | Initial git workflow documentation |

---

## See Also

- [DISASTER-RECOVERY.md](DISASTER-RECOVERY.md) - Failure scenarios and recovery
- [SESSION-STATE.md](SESSION-STATE.md) - Session state management details
- [TASKS.md](TASKS.md) - Task breakdown and dependencies
- [TDD-METHODOLOGY.md](TDD-METHODOLOGY.md) - Testing workflow integration
