# Session State Management

**Project:** AI-Native UI Component Library
**Version:** 1.0.0
**Last Updated:** 2025-01-23
**Status:** Active

---

## Overview

Session state management maintains context across Claude Code conversations, git operations, and automation workflows. Since Claude Code has no persistent memory, external state tracking is critical for project continuity.

**Key Principle:** State is maintained in JSON files, not in Claude Code's memory. Scripts read/write state, Claude Code executes scripts.

---

## Table of Contents

1. [Why Session State Matters](#why-session-state-matters)
2. [State Files](#state-files)
3. [State Schema](#state-schema)
4. [State Lifecycle](#state-lifecycle)
5. [State Operations](#state-operations)
6. [State Validation](#state-validation)
7. [State Recovery](#state-recovery)
8. [Best Practices](#best-practices)

---

## Why Session State Matters

### Claude Code Limitations

**No Persistent Memory:**
- Each conversation is independent
- No memory of previous sessions
- Cannot remember what was being worked on
- Cannot remember where code was left off

**No Mental Model:**
- Cannot visualize project structure
- Cannot understand phase/task relationships
- Cannot infer next steps from context

**Pattern Matching Only:**
- Can read current state from files
- Cannot remember past state
- Cannot deduce trajectory

### Solution: External State Tracking

Session state files provide:
- **Context Persistence** - Know what phase/task is current
- **Progress Tracking** - Which tasks are complete
- **Recovery Points** - Where to resume after interruption
- **Audit Trail** - History of what was done

---

## State Files

### File Structure

```
.claude/
├── session-state.json      # Current session context
├── progress.json            # Task completion tracking
├── checkpoints.json         # Checkpoint history
├── incidents.log            # Recovery incidents
└── session-history/         # Historical state snapshots
    ├── 2025-01-23-100000.json
    ├── 2025-01-23-110000.json
    └── ...
```

### File Purposes

**session-state.json**
- Current phase and task
- Working branch
- Last checkpoint
- Remote synchronization status
- Updated by: All workflow scripts

**progress.json**
- Task completion status
- Phase completion status
- Task start/end times
- Progress metrics
- Updated by: complete-task.sh, complete-phase.sh

**checkpoints.json**
- Checkpoint metadata
- Checkpoint tags and commits
- Recovery point information
- Updated by: complete-task.sh, complete-phase.sh

**incidents.log**
- Recovery operations log
- Failure scenarios encountered
- Recovery procedures used
- Updated by: Recovery scripts, human interventions

**session-history/**
- Snapshots of session-state.json over time
- One file per hour (while active)
- Retention: 30 days
- Updated by: Automated monitoring

---

## State Schema

### session-state.json

**Schema Version: 1.0.0**

```json
{
  "schema_version": "1.0.0",
  "project": {
    "name": "ui-library",
    "version": "1.0.0",
    "remote_url": "https://github.com/jcmrs/ui-library.git"
  },
  "current": {
    "phase": "1",
    "phase_name": "Automated Foundation",
    "task": "1.1.2",
    "task_name": "Create Setup Script",
    "working_branch": "feature/phase-1",
    "base_branch": "develop"
  },
  "timing": {
    "phase_start": "2025-01-23T10:00:00Z",
    "task_start": "2025-01-23T14:00:00Z",
    "last_activity": "2025-01-23T15:30:00Z",
    "last_sync": "2025-01-23T15:25:00Z"
  },
  "checkpoint": {
    "tag": "task-1.1.1-complete",
    "commit": "a3f8d9c2e1b4f0a7d6c5e8b1a4f7c2e9",
    "timestamp": "2025-01-23T13:45:00Z",
    "message": "Task 1.1.1: Configuration templates complete"
  },
  "progress": {
    "tasks_completed": ["1.0.1", "1.0.2", "1.0.3", "1.0.4", "1.1.1"],
    "tasks_total": 10,
    "completion_percentage": 50,
    "estimated_completion": "2025-01-25T18:00:00Z"
  },
  "git_state": {
    "local_commits_ahead": 2,
    "remote_commits_ahead": 0,
    "modified_files": 3,
    "untracked_files": 1,
    "staged_files": 0,
    "working_directory_clean": false
  },
  "metadata": {
    "last_updated_by": "complete-task.sh",
    "last_updated_at": "2025-01-23T15:30:00Z",
    "conversation_id": "conv-20250123-session-001"
  }
}
```

**Field Descriptions:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `schema_version` | string | Yes | Schema version for compatibility |
| `project.name` | string | Yes | Project identifier |
| `project.version` | string | Yes | Project version |
| `project.remote_url` | string | Yes | GitHub repository URL |
| `current.phase` | string | Yes | Current phase number |
| `current.phase_name` | string | Yes | Human-readable phase name |
| `current.task` | string | Yes | Current task ID (X.Y.Z format) |
| `current.task_name` | string | Yes | Human-readable task name |
| `current.working_branch` | string | Yes | Current git branch |
| `current.base_branch` | string | Yes | Base branch (usually develop) |
| `timing.phase_start` | ISO8601 | Yes | When current phase started |
| `timing.task_start` | ISO8601 | Yes | When current task started |
| `timing.last_activity` | ISO8601 | Yes | Last file modification time |
| `timing.last_sync` | ISO8601 | Yes | Last remote sync time |
| `checkpoint.tag` | string | Yes | Last checkpoint git tag |
| `checkpoint.commit` | string | Yes | Last checkpoint commit hash |
| `checkpoint.timestamp` | ISO8601 | Yes | When checkpoint was created |
| `checkpoint.message` | string | Yes | Checkpoint description |
| `progress.tasks_completed` | array | Yes | List of completed task IDs |
| `progress.tasks_total` | integer | Yes | Total tasks in current phase |
| `progress.completion_percentage` | integer | Yes | Phase completion (0-100) |
| `progress.estimated_completion` | ISO8601 | No | Estimated phase completion |
| `git_state.*` | various | Yes | Current git repository state |
| `metadata.*` | various | Yes | State file metadata |

---

### progress.json

**Schema Version: 1.0.0**

```json
{
  "schema_version": "1.0.0",
  "project": "ui-library",
  "phases": {
    "phase-1": {
      "id": "1",
      "name": "Automated Foundation",
      "status": "in-progress",
      "start_date": "2025-01-23T10:00:00Z",
      "completion_date": null,
      "estimated_completion": "2025-01-25T18:00:00Z",
      "tasks": {
        "1.0.1": {
          "id": "1.0.1",
          "name": "Git Workflow Scripts",
          "status": "completed",
          "started_at": "2025-01-23T10:00:00Z",
          "completed_at": "2025-01-23T11:30:00Z",
          "duration_minutes": 90,
          "checkpoint_tag": "task-1.0.1-complete",
          "quality_gates": {
            "typecheck": true,
            "lint": true,
            "tests": true,
            "coverage": 95
          }
        },
        "1.0.2": {
          "id": "1.0.2",
          "name": "Session State Management",
          "status": "completed",
          "started_at": "2025-01-23T11:30:00Z",
          "completed_at": "2025-01-23T12:15:00Z",
          "duration_minutes": 45,
          "checkpoint_tag": "task-1.0.2-complete",
          "quality_gates": {
            "typecheck": true,
            "lint": true,
            "tests": true,
            "coverage": 92
          }
        },
        "1.1.1": {
          "id": "1.1.1",
          "name": "Create Configuration Templates",
          "status": "completed",
          "started_at": "2025-01-23T13:00:00Z",
          "completed_at": "2025-01-23T13:45:00Z",
          "duration_minutes": 45,
          "checkpoint_tag": "task-1.1.1-complete",
          "quality_gates": {
            "typecheck": true,
            "lint": true,
            "tests": true,
            "coverage": 88
          }
        },
        "1.1.2": {
          "id": "1.1.2",
          "name": "Create Setup Script",
          "status": "in-progress",
          "started_at": "2025-01-23T14:00:00Z",
          "completed_at": null,
          "duration_minutes": null,
          "checkpoint_tag": null,
          "quality_gates": null
        }
      },
      "metrics": {
        "tasks_total": 10,
        "tasks_completed": 3,
        "tasks_in_progress": 1,
        "tasks_pending": 6,
        "completion_percentage": 30,
        "average_task_duration_minutes": 60,
        "estimated_remaining_hours": 7
      }
    }
  },
  "overall": {
    "phases_total": 10,
    "phases_completed": 0,
    "phases_in_progress": 1,
    "project_completion_percentage": 3,
    "project_start_date": "2025-01-23T10:00:00Z",
    "estimated_project_completion": "2025-06-15T18:00:00Z"
  },
  "last_updated": "2025-01-23T15:30:00Z"
}
```

---

### checkpoints.json

**Schema Version: 1.0.0**

```json
{
  "schema_version": "1.0.0",
  "project": "ui-library",
  "checkpoints": [
    {
      "tag": "task-1.0.1-complete",
      "commit": "f9e8d7c6b5a4f3e2d1c0b9a8f7e6d5c4",
      "timestamp": "2025-01-23T11:30:00Z",
      "type": "task",
      "phase": "1",
      "task": "1.0.1",
      "message": "Task 1.0.1: Git workflow scripts complete",
      "quality_gates": {
        "typecheck": true,
        "lint": true,
        "tests": true,
        "coverage": 95
      },
      "pushed_to_remote": true
    },
    {
      "tag": "task-1.0.2-complete",
      "commit": "e8d7c6b5a4f3e2d1c0b9a8f7e6d5c4b3",
      "timestamp": "2025-01-23T12:15:00Z",
      "type": "task",
      "phase": "1",
      "task": "1.0.2",
      "message": "Task 1.0.2: Session state management complete",
      "quality_gates": {
        "typecheck": true,
        "lint": true,
        "tests": true,
        "coverage": 92
      },
      "pushed_to_remote": true
    }
  ],
  "last_checkpoint": {
    "tag": "task-1.1.1-complete",
    "commit": "a3f8d9c2e1b4f0a7d6c5e8b1a4f7c2e9",
    "timestamp": "2025-01-23T13:45:00Z"
  },
  "statistics": {
    "total_checkpoints": 12,
    "task_checkpoints": 10,
    "phase_checkpoints": 0,
    "emergency_checkpoints": 2,
    "oldest_checkpoint": "2025-01-23T10:05:00Z",
    "newest_checkpoint": "2025-01-23T13:45:00Z"
  },
  "last_updated": "2025-01-23T15:30:00Z"
}
```

---

## State Lifecycle

### State Creation

**When:** Project initialization or Phase 1.0 setup

**How:**
```bash
# Automatically created by start-phase.sh
./scripts/git-workflow/start-phase.sh 1

# Or manually
mkdir -p .claude
cat > .claude/session-state.json << 'EOF'
{
  "schema_version": "1.0.0",
  "project": {
    "name": "ui-library",
    "version": "1.0.0",
    "remote_url": "https://github.com/jcmrs/ui-library.git"
  },
  "current": {
    "phase": "1",
    "phase_name": "Automated Foundation",
    "task": "1.0.1",
    "task_name": "Git Workflow Scripts",
    "working_branch": "feature/phase-1",
    "base_branch": "develop"
  }
  // ... rest of schema
}
EOF
```

---

### State Updates

**Automatic Updates:**

All workflow scripts update state automatically:

| Script | Updates | Fields Modified |
|--------|---------|----------------|
| `start-phase.sh` | Session state | phase, phase_name, working_branch, phase_start |
| `complete-task.sh` | Session + Progress | task, task_name, checkpoint, tasks_completed |
| `complete-phase.sh` | Session + Progress | base_branch, phase status, completion_date |
| `sync-with-remote.sh` | Session state | last_sync, git_state.* |

**Example Update Flow:**

```bash
# User runs complete-task.sh
./scripts/git-workflow/complete-task.sh 1.1.2

# Script execution:
# 1. Read current session-state.json
STATE=$(cat .claude/session-state.json)

# 2. Modify relevant fields
STATE=$(echo "$STATE" | jq '.current.task = "1.1.3"')
STATE=$(echo "$STATE" | jq '.checkpoint.tag = "task-1.1.2-complete"')
STATE=$(echo "$STATE" | jq '.progress.tasks_completed += ["1.1.2"]')

# 3. Write back to file
echo "$STATE" | jq '.' > .claude/session-state.json

# 4. Update progress.json
# 5. Update checkpoints.json
```

---

### State Snapshots

**Purpose:** Historical record for recovery

**Frequency:** Hourly (when changes exist)

**Mechanism:**
```bash
# Automated by monitoring script
# Runs every hour via cron or background process

# Copy current state to history
cp .claude/session-state.json \
   .claude/session-history/$(date +%Y-%m-%d-%H%M%S).json

# Prune old snapshots (older than 30 days)
find .claude/session-history -name "*.json" -mtime +30 -delete
```

**Retention Policy:**
- Hourly snapshots: 30 days
- Daily snapshots: 1 year
- Phase completion snapshots: Indefinite

---

## State Operations

### Read State

**From Scripts:**
```bash
#!/bin/bash

# Read entire state
STATE=$(cat .claude/session-state.json)

# Read specific field
CURRENT_TASK=$(jq -r '.current.task' .claude/session-state.json)
CURRENT_PHASE=$(jq -r '.current.phase' .claude/session-state.json)
WORKING_BRANCH=$(jq -r '.current.working_branch' .claude/session-state.json)

# Use in script logic
if [ "$CURRENT_PHASE" == "1" ]; then
  echo "Working on Phase 1"
fi
```

**From JavaScript/TypeScript:**
```typescript
import fs from 'fs';
import path from 'path';

interface SessionState {
  schema_version: string;
  project: {
    name: string;
    version: string;
    remote_url: string;
  };
  current: {
    phase: string;
    task: string;
    working_branch: string;
  };
  // ... rest of schema
}

function readSessionState(): SessionState {
  const statePath = path.join(process.cwd(), '.claude/session-state.json');
  const stateData = fs.readFileSync(statePath, 'utf8');
  return JSON.parse(stateData);
}

const state = readSessionState();
console.log(`Current task: ${state.current.task}`);
```

---

### Update State

**Atomic Updates (Recommended):**
```bash
#!/bin/bash

# Read current state
STATE=$(cat .claude/session-state.json)

# Make modifications
STATE=$(echo "$STATE" | jq '.current.task = "1.1.3"')
STATE=$(echo "$STATE" | jq '.timing.last_activity = "'$(date -Iseconds)'"')
STATE=$(echo "$STATE" | jq '.metadata.last_updated_by = "'$(basename $0)'"')

# Write atomically (temp file + move)
echo "$STATE" | jq '.' > .claude/session-state.json.tmp
mv .claude/session-state.json.tmp .claude/session-state.json
```

**Transaction Pattern:**
```bash
#!/bin/bash

# Backup current state
cp .claude/session-state.json .claude/session-state.json.backup

# Attempt update
if update_state; then
  # Success - remove backup
  rm .claude/session-state.json.backup
else
  # Failure - restore backup
  mv .claude/session-state.json.backup .claude/session-state.json
  echo "State update failed - restored previous state"
  exit 1
fi
```

---

### Validate State

**Schema Validation:**
```bash
#!/bin/bash

# Validate JSON syntax
if ! jq '.' .claude/session-state.json > /dev/null 2>&1; then
  echo "ERROR: Invalid JSON in session-state.json"
  exit 1
fi

# Validate required fields
REQUIRED_FIELDS=(
  ".schema_version"
  ".project.name"
  ".current.phase"
  ".current.task"
  ".current.working_branch"
)

for field in "${REQUIRED_FIELDS[@]}"; do
  if ! jq -e "$field" .claude/session-state.json > /dev/null 2>&1; then
    echo "ERROR: Missing required field: $field"
    exit 1
  fi
done

echo "State validation passed"
```

**Content Validation:**
```bash
#!/bin/bash

# Validate branch exists
WORKING_BRANCH=$(jq -r '.current.working_branch' .claude/session-state.json)
if ! git show-ref --verify --quiet "refs/heads/$WORKING_BRANCH"; then
  echo "ERROR: Working branch does not exist: $WORKING_BRANCH"
  exit 1
fi

# Validate checkpoint tag exists
CHECKPOINT_TAG=$(jq -r '.checkpoint.tag' .claude/session-state.json)
if ! git show-ref --verify --quiet "refs/tags/$CHECKPOINT_TAG"; then
  echo "WARNING: Checkpoint tag does not exist: $CHECKPOINT_TAG"
fi

# Validate task ID format
CURRENT_TASK=$(jq -r '.current.task' .claude/session-state.json)
if ! [[ "$CURRENT_TASK" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "ERROR: Invalid task ID format: $CURRENT_TASK"
  exit 1
fi
```

---

## State Recovery

### Corrupt State File

**Symptoms:**
- JSON syntax errors
- Missing required fields
- File not found

**Recovery:**
```bash
./scripts/recovery/restore-session-state.sh
```

See [DISASTER-RECOVERY.md](DISASTER-RECOVERY.md#s2-lost-session-context) for details.

---

### State Drift (Out of Sync with Git)

**Symptoms:**
- State says phase 1, but on develop branch
- State says task 1.1.2, but task 1.1.3 commits exist
- Checkpoint tag doesn't match state

**Detection:**
```bash
# Compare state with git reality
STATE_BRANCH=$(jq -r '.current.working_branch' .claude/session-state.json)
ACTUAL_BRANCH=$(git branch --show-current)

if [ "$STATE_BRANCH" != "$ACTUAL_BRANCH" ]; then
  echo "WARNING: State drift detected"
  echo "  State says: $STATE_BRANCH"
  echo "  Git says: $ACTUAL_BRANCH"
fi
```

**Recovery:**
```bash
# Option 1: Trust git, update state
./scripts/recovery/restore-session-state.sh

# Option 2: Trust state, update git
git checkout $(jq -r '.current.working_branch' .claude/session-state.json)
```

---

## Best Practices

### For Scripts

1. **Always validate before reading:**
```bash
if [ ! -f .claude/session-state.json ]; then
  echo "ERROR: Session state not found"
  exit 1
fi

if ! jq '.' .claude/session-state.json > /dev/null 2>&1; then
  echo "ERROR: Invalid session state JSON"
  exit 1
fi
```

2. **Use atomic writes:**
```bash
# Write to temp file first
echo "$NEW_STATE" | jq '.' > .claude/session-state.json.tmp

# Then move atomically
mv .claude/session-state.json.tmp .claude/session-state.json
```

3. **Update timestamps:**
```bash
STATE=$(jq '.timing.last_activity = "'$(date -Iseconds)'"' \
          .claude/session-state.json)
```

4. **Update metadata:**
```bash
STATE=$(jq '.metadata.last_updated_by = "'$(basename $0)'"' \
          .claude/session-state.json)
```

---

### For Claude Code

1. **Never modify state files directly**
2. **Always use scripts to update state**
3. **Check state with where-am-i.sh when unsure**
4. **Trust state files over memory**
5. **Report state drift to human**

---

### For Humans

1. **Don't manually edit state files unless necessary**
2. **Use recovery scripts if state is corrupted**
3. **Back up state before manual edits**
4. **Document manual state changes**
5. **Validate state after manual edits**

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2025-01-23 | Initial session state documentation |

---

## See Also

- [GIT-WORKFLOW.md](GIT-WORKFLOW.md) - How state integrates with git workflow
- [DISASTER-RECOVERY.md](DISASTER-RECOVERY.md) - State recovery procedures
- [TASKS.md](TASKS.md) - Task definitions referenced in progress tracking
