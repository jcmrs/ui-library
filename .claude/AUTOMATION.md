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

### 4. Session State Tracking (AUTOMATIC)

**Status:** Tracks state when scripts run
**Location:** `.claude/session-state.json`
**Documentation:** `.docs/SESSION-STATE.md`

Automatically updated by workflow scripts:

- Current phase and task
- Timestamps and progress
- Git state and checkpoints
- Last activity

**Note:** Only updates when workflow scripts are run, not on direct git operations.

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

### Status Monitor

**Documented In:** Global CLAUDE.md
**Status:** NOT IMPLEMENTED

Global settings mention:

> "Status monitor shows git status every ~5 tool uses"

**Reality:** No status monitoring exists. Use `/commit` or `git status` manually.

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

## Future Automation (Planned but Not Implemented)

### From ADR-001:

- ❌ CI/CD workflows (GitHub Actions)
- ❌ Auto-staging hook
- ❌ Status monitoring
- ❌ Slash commands (/commit, /checkpoint)

### From Phase 1.0 Requirements:

- ❌ Automatic checkpointing after each task
- ❌ Remote repository synchronized automatically
- ❌ Claude Code never uses git commands directly (still does)
- ❌ Session state persists across conversations (manual updates only)

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
