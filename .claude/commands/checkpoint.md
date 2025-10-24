# Session Checkpoint

You are creating a **session checkpoint** to save all work and state before ending the session.

## Your Task

Follow these steps in order:

### 1. Review Current State

```bash
# Check current workflow state
bash scripts/git-workflow/where-am-i.sh

# Check git status
git status

# Check what changed since last checkpoint
git log --oneline -5
```

Analyze:

- What phase/task are we on?
- What work has been completed?
- Are there uncommitted changes?
- When was the last checkpoint?

### 2. Update Session State

```bash
# Update session state with current status
node scripts/session-state/writer.ts --checkpoint
```

This should update:

- `.claude/session-state.json` with current progress
- Last activity timestamp
- Checkpoint information

### 3. Interactive Staging

Review all changes and stage selectively:

```bash
# Show detailed changes
git status
git diff

# Stage files interactively
git add <files-to-commit>
```

**EXCLUDE from staging:**

- Sensitive files (.env, credentials, secrets)
- Temporary files (_.tmp, _.log)
- Lock files (unless dependency update)
- IDE settings (unless intentional)

### 4. Create Checkpoint Commit

If there are staged changes:

```bash
git commit -m "$(cat <<'EOF'
chore: Session checkpoint - <brief-description>

Session checkpoint before ending conversation.

Progress:
- <what-was-accomplished>
- <current-state>

Next steps:
- <what-to-do-next>

Phase: <current-phase>
Task: <current-task>
EOF
)"
```

If no changes to commit:

```bash
echo "No changes to commit - checkpoint is session state update only"
```

### 5. Create Git Tag

Create a descriptive tag for this checkpoint:

```bash
# Format: checkpoint-YYYY-MM-DD-description
git tag -a "checkpoint-$(date +%Y-%m-%d)-<description>" -m "Session checkpoint: <description>"
```

Example:

```bash
git tag -a "checkpoint-2025-01-24-phase-1.3-complete" -m "Session checkpoint: Phase 1.3 completed, automation added"
```

### 6. Sync with Remote

```bash
# Push commits
git push origin develop

# Push tags
git push origin --tags
```

### 7. Generate Session Summary

Create a summary of the session:

**Markdown Format:**

```markdown
# Session Checkpoint - <date>

## Completed This Session

- <item-1>
- <item-2>

## Current State

- Phase: <phase>
- Task: <task>
- Branch: <branch>
- Last Commit: <hash> - <message>

## Outstanding Work

- [ ] <todo-1>
- [ ] <todo-2>

## Next Session

Start with: <command-to-run>

## Notes

<any-important-context>
```

Save this summary to: `.claude/checkpoints/checkpoint-<date>.md`

### 8. Verify Checkpoint

```bash
# Verify state is saved
git log -1 --oneline
git tag -l | tail -5
cat .claude/session-state.json | head -20

# Confirm remote sync
git fetch origin
git status
```

## Success Criteria

- ✅ Session state updated in `.claude/session-state.json`
- ✅ All important changes committed
- ✅ Checkpoint tag created with descriptive name
- ✅ Changes pushed to remote
- ✅ Session summary created
- ✅ No uncommitted critical work left

## Example Flow

```bash
# 1. Check state
bash scripts/git-workflow/where-am-i.sh

# 2. Update session state
node scripts/session-state/writer.ts --checkpoint

# 3. Stage changes
git add .claude/session-state.json .claude/AUTOMATION.md
git add .husky/pre-commit

# 4. Commit
git commit -m "chore: Session checkpoint - automation infrastructure added"

# 5. Tag
git tag -a "checkpoint-2025-01-24-automation-complete" -m "Added pre-commit hooks and automation docs"

# 6. Push
git push origin develop
git push origin --tags

# 7. Verify
git log -1 --oneline
git tag -l | tail -3
```

Begin the checkpoint workflow now.
