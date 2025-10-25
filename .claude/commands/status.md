# Git Status Monitor

Check current git status and reset monitoring counter.

## What This Does

1. Displays comprehensive git status
2. Shows commits ahead/behind remote
3. Lists uncommitted changes
4. Resets the tool use counter

## Implementation

```bash
node scripts/monitor-git-status.cjs check
```

## When to Use

- Manually check git status
- After completing a series of tasks
- Before creating a commit
- When unsure about repository state

## Output Example

```
============================================================
📊 GIT STATUS MONITOR
============================================================
## develop...origin/develop [ahead 2]
 M .claude/session-state.json
?? .docs/NEW-FILE.md

⬆️  2 commit(s) ahead of remote - Consider pushing

📝 Uncommitted changes detected:
   - 1 file(s) modified but not staged
   - 1 untracked file(s)

💡 Consider using /commit to create a checkpoint
============================================================
```
