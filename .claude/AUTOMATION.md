# Automation Infrastructure

**Project:** UI Library
**Version:** 1.0.0
**Last Updated:** 2025-01-24
**Status:** Active

---

## Overview

This project uses comprehensive automation to compensate for AI limitations and ensure consistent quality. All automation is designed to work seamlessly with Claude Code.

---

## Automated Workflows

### 1. Pre-Commit Quality Gates (ACTIVE ✅)

**Status:** Implemented and enforced
**Hook:** `.husky/pre-commit`
**ADR:** ADR-011

Every commit is automatically validated:

```bash
# Runs automatically before git commit
1. TypeScript type checking (tsc --noEmit)
2. ESLint with auto-fix (eslint . --fix)
3. Prettier formatting check (prettier --check)
```

**Behavior:**

- ✅ Commit proceeds if all checks pass
- ❌ Commit blocked if any check fails
- Cannot be bypassed (enforced by Husky)

---

### 2. Git Workflow Automation (MANUAL)

**Status:** Scripts exist but require manual invocation
**Location:** `scripts/git-workflow/`
**Documentation:** `.docs/GIT-WORKFLOW.md`

Available scripts:

- `start-phase.sh <phase> "<name>"` - Create feature branch for new phase
- `complete-task.sh <task-id> "<desc>"` - Complete task with validation
- `complete-phase.sh <phase>` - Merge phase to develop
- `sync-with-remote.sh` - Sync with remote repository
- `where-am-i.sh` - Show current workflow state

**Note:** These are NOT automated. Must be explicitly called.

---

### 3. Component Scaffolding (MANUAL)

**Status:** Scripts exist but require manual invocation
**Location:** `scripts/create-component.sh`
**Documentation:** `scripts/README.md`

Usage:

```bash
# Create new component with all required files
./scripts/create-component.sh ComponentName category

# Generates:
# - component.tsx
# - component.test.tsx
# - component.stories.tsx
# - component.patterns.md
# - component.checklist.json
# - index.ts
```

---

### 4. Session State Tracking (FULLY AUTOMATIC ✅)

**Status:** ✅ Fully automated via post-commit hook
**Hook:** `.husky/post-commit`
**Location:** `.claude/session-state.json`
**Documentation:** `.docs/SESSION-STATE.md`
**ADR:** ADR-014

Automatically updated after EVERY commit:

- `timing.last_activity` - ISO 8601 timestamp
- `git_state.local_commits_ahead` - Commits ahead of remote
- `git_state.modified_files` - Count of modified files
- `git_state.untracked_files` - Count of untracked files
- `git_state.staged_files` - Count of staged files
- `git_state.working_directory_clean` - Boolean clean status
- `checkpoint.commit` - Latest commit hash
- `checkpoint.timestamp` - Latest commit timestamp
- `metadata.last_updated_by` - "post-commit hook"
- `metadata.last_updated_at` - ISO 8601 timestamp

**How it works:**

```bash
# After every git commit, the post-commit hook runs automatically
git commit -m "Your message"
# → Pre-commit quality gates run
# → Commit is created
# → Post-commit hook updates session-state.json
# → Session state is always current
```

**Prettier Integration:** After updating JSON, hook runs `npx prettier --write .claude/session-state.json` to prevent pre-commit hook failures on next commit.

**Failure handling:** Non-blocking - commit always succeeds even if state update fails

---

### 5. Automatic Checkpoint Creation (FULLY AUTOMATIC ✅)

**Status:** ✅ Fully automated via pre-push hook
**Hook:** `.husky/pre-push`
**ADR:** ADR-015

Automatically creates checkpoint git tags before EVERY push:

- Tag format: `checkpoint-YYYYMMDD-HHMMSS-<hash>`
- Example: `checkpoint-20250124-143022-a1b2c3d`
- Lightweight tags (no annotation)
- Non-blocking (push continues even if tag creation fails)

**How it works:**

```bash
# Before every git push, the pre-push hook runs automatically
git push origin develop
# → Pre-push hook creates checkpoint tag
# → Push proceeds to remote
# → Checkpoint preserved locally
```

**Benefits:**

- Every push creates a recovery point
- Easy rollback to any pushed state
- Timestamped for chronological tracking
- Zero manual effort

---

### 6. CI/CD Quality Validation (FULLY AUTOMATIC ✅)

**Status:** ✅ Fully automated via GitHub Actions
**Workflows:** `.github/workflows/validate-pr.yml`, `.github/workflows/validate-push.yml`
**ADR:** ADR-013

Automatically validates quality on GitHub:

**On Pull Request:**

- Triggers when PR opened/updated to main/develop
- Runs TypeScript, ESLint, Prettier, Tests
- Blocks merge if quality gates fail
- Shows status in GitHub PR UI

**On Push:**

- Triggers on push to main/develop/feature branches
- Same quality gates as local pre-commit
- Provides immediate feedback
- Validates all contributors' code

**How it works:**

```bash
# Push code to GitHub
git push origin feature/my-feature
# → GitHub Actions workflow triggered
# → Quality gates run in cloud
# → Status appears in GitHub UI
# → PR can/cannot merge based on result
```

**Benefits:**

- Consistent quality enforcement
- Validates code from all team members
- No manual quality review needed
- CI/CD status badges available

---

## Slash Commands (ACTIVE ✅)

**Status:** Implemented
**Location:** `.claude/commands/`
**Documentation:** `.claude/commands/README.md`

Available commands:

- `/commit` - Intelligent commit with validation and message generation
- `/checkpoint` - Session checkpoint with tagging and remote sync

**How to use:**

```
User: /commit
Claude: [Executes intelligent commit workflow]
```

See `.claude/commands/README.md` for details.

---

## Auto-Staging Hook (AVAILABLE, DISABLED BY DEFAULT)

**Status:** Implemented but disabled
**Hook:** `.husky/pre-commit-auto-stage`
**ADR:** ADR-001

Automatically stages modified files before commit, excluding:

- `.env` files
- Credentials and secrets
- Lock files
- Temporary files

**To enable:** Uncomment line in `.husky/pre-commit`:

```bash
.husky/pre-commit-auto-stage
```

**Default:** Disabled for safety (explicit staging preferred)

---

## What's NOT Automated (Yet)

### Status Monitor (MANUAL INVOCATION)

**Status:** Implemented via `/status` command
**Script:** `scripts/monitor-git-status.js`

**How It Works:**

- Manual invocation via `/status` slash command
- Displays comprehensive git status with context
- Shows commits ahead/behind remote
- Lists uncommitted changes
- Provides actionable recommendations

**Usage:**

```
User: /status
Claude: [Executes monitor-git-status.js check]
```

**Note:** Automatic monitoring every ~5 tool uses requires MCP server integration (future enhancement). For now, use `/status` command manually when needed.

---

## Quality Gates

### Pre-Commit (Automatic ✅)

Enforced by Husky hook:

1. **TypeScript**: Strict type checking, no errors allowed
2. **ESLint**: Zero errors/warnings, auto-fix applied
3. **Prettier**: Code formatting must be consistent

### Phase Completion (Manual)

Run by `complete-phase.sh` script:

1. Working directory must be clean
2. All quality gates must pass
3. Feature branch merged to develop
4. Tag created at checkpoint
5. Changes pushed to remote

---

## Automation Status Summary

### Fully Implemented ✅

- **Pre-commit Quality Gates** - TypeScript, ESLint, Prettier validation
- **Post-commit Session State Updates** - Automatic after every commit
- **Pre-push Checkpoint Creation** - Automatic tags before every push
- **Checkpoint Tag Tracking** - Tags recorded in session-state.json
- **CI/CD Quality Validation** - GitHub Actions workflows
- **Git Status Monitoring** - Manual `/status` command with comprehensive display
- **Slash Commands** - `/commit`, `/checkpoint`, `/status`

### Requires MCP Server Integration (Future)

- [ ] **Automatic Git Status Display** - Show every ~5 tool uses (requires MCP server hooks)
- [ ] **Per-Task Checkpointing** - Automatic checkpoints after each completed task
- [ ] **Remote repository synchronized automatically** - Auto-push after commits
- [ ] **Session state persists across conversations** - Cross-session context preservation

---

## How to Use Automation

### For New Components:

```bash
# 1. Create component structure
./scripts/create-component.sh MyComponent base

# 2. Implement component (edit generated files)

# 3. Validate component
./scripts/validate-component.sh MyComponent base

# 4. Commit changes (pre-commit hook runs automatically)
git add .
git commit -m "feat: Add MyComponent"
# ✅ Hook validates TypeScript, ESLint, Prettier
```

### For Phase Workflows:

```bash
# 1. Start new phase
./scripts/git-workflow/start-phase.sh 1.4 "Next Phase"

# 2. Do work, make commits (hooks validate each commit)

# 3. Complete phase
./scripts/git-workflow/complete-phase.sh 1.4
# ✅ Validates, merges, tags, pushes
```

---

## Troubleshooting

### Pre-commit Hook Issues

**Problem:** Hook fails on formatting

```
❌ Formatting issues found. Run 'npm run prettier' to fix.
```

**Solution:**

```bash
npm run prettier
git add .
git commit -m "..."
```

**Problem:** Hook fails on TypeScript

```
❌ TypeScript errors found. Fix them before committing.
```

**Solution:** Fix TypeScript errors, hooks enforce strict mode.

**Problem:** Hook fails on ESLint

```
❌ ESLint errors found. Fix them before committing.
```

**Solution:** Fix linting errors. Hook runs with `--fix` but some errors require manual fixes.

### Bypassing Hooks (NOT RECOMMENDED)

```bash
# Emergency only - breaks quality enforcement
git commit --no-verify -m "..."
```

---

## Implementation History

**Phase 1.0-1.3:** Documentation created but automation NOT implemented
**2025-01-24:** Discovered missing automation during Phase 1.3 completion
**2025-01-24:** Implemented pre-commit hooks (Husky)

**Status:** Pre-commit hooks working. All other automation still manual.

---

## References

- **ADR-001:** Automated Foundation First
- **ADR-011:** Pre-commit Quality Gates
- **.docs/GIT-WORKFLOW.md:** Git workflow documentation
- **.docs/ROADMAP.md:** Phase 1.0 automation requirements
- **scripts/README.md:** Script usage documentation
