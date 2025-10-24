# Scripts Documentation

This directory contains automation scripts for the UI Library project. All scripts are designed to work on both Linux/macOS (via `.sh` files) and Windows (via `.cmd` wrappers that use Git Bash).

## Directory Structure

```
scripts/
├── git-workflow/      # Git workflow automation (Phase 1.0)
├── recovery/          # Disaster recovery tools (Phase 1.0)
├── session-state/     # Session state management (Phase 1.0)
├── setup/             # Project setup automation (Phase 1.1)
└── README.md          # This file
```

## Git Workflow Scripts (Phase 1.0)

### `start-phase.sh <phase> "<phase-name>"`

Initializes a new development phase.

**Usage:**

```bash
./scripts/git-workflow/start-phase.sh 1.1 "Foundation Components"
```

**What it does:**

- Creates feature branch (`feature/phase-X`)
- Initializes session state JSON
- Creates initial checkpoint tag
- Displays next steps

---

### `complete-task.sh <task-id> "<task-description>"`

Completes a task with automated validation and checkpointing.

**Usage:**

```bash
./scripts/git-workflow/complete-task.sh 1.1.1 "Create configuration templates"
```

**What it does:**

- Runs quality gates (TypeScript, ESLint, Prettier, tests)
- Stages all changes
- Generates descriptive commit message
- Creates checkpoint tag
- Updates session state
- Pushes to remote

---

### `complete-phase.sh <phase>`

Completes a phase by merging to develop.

**Usage:**

```bash
./scripts/git-workflow/complete-phase.sh 1.1
```

**What it does:**

- Validates phase completion
- Runs final quality gates
- Merges feature branch to develop (--no-ff)
- Creates phase completion tag
- Deletes feature branch
- Updates session state

---

### `sync-with-remote.sh`

Synchronizes local repository with remote.

**Usage:**

```bash
./scripts/git-workflow/sync-with-remote.sh
```

**What it does:**

- Checks remote connectivity
- Fetches latest changes
- Compares local/remote branches
- Auto-pushes if local ahead
- Auto-pulls if remote ahead
- Detects and reports divergence

---

### `where-am-i.sh`

Displays comprehensive project status.

**Usage:**

```bash
./scripts/git-workflow/where-am-i.sh
```

**What it shows:**

- Current phase and task
- Git status and sync status
- Last checkpoint information
- Progress tracking
- Next steps and quick reference

---

## Recovery Scripts (Phase 1.0)

### `panic-button.sh`

Emergency state preservation.

**Usage:**

```bash
./scripts/recovery/panic-button.sh
```

**What it does:**

- Backs up all session state files
- Captures complete git status
- Stashes uncommitted changes
- Creates recovery manifest
- Provides recovery instructions

**When to use:** When something goes wrong and you need to preserve current state before attempting recovery.

---

### `emergency-recovery.sh [--auto] [--manifest <file>]`

Comprehensive recovery system.

**Usage:**

```bash
# Automatic recovery from latest backup
./scripts/recovery/emergency-recovery.sh --auto

# Interactive menu
./scripts/recovery/emergency-recovery.sh

# Restore from specific manifest
./scripts/recovery/emergency-recovery.sh --manifest .claude/recovery/manifest.20250123_143000.json
```

**What it does:**

- Restores session state from backup
- Provides recovery options
- Lists available recovery points
- Shows manual recovery guidance

---

### `restore-session-state.sh [--file <backup>] [--list] [--validate]`

Restores session state from backup.

**Usage:**

```bash
# Restore from latest backup
./scripts/recovery/restore-session-state.sh

# List available backups
./scripts/recovery/restore-session-state.sh --list

# Validate a backup
./scripts/recovery/restore-session-state.sh --validate --file <backup>
```

---

### `diagnose-issues.sh`

Comprehensive system diagnostics.

**Usage:**

```bash
./scripts/recovery/diagnose-issues.sh
```

**What it checks:**

- Git repository status
- Session state validity
- Recovery infrastructure
- Workflow scripts
- System dependencies

**When to use:** When troubleshooting issues or verifying system health.

---

## Setup Scripts (Phase 1.1)

### `setup-new-project.sh`

Automated project initialization from templates.

**Usage:**

```bash
./scripts/setup/setup-new-project.sh
```

**What it does:**

- Validates prerequisites (Node.js >= 20.0.0, git)
- Checks for existing files (with confirmation)
- Gathers project information
- Copies all configuration templates
- Creates project structure
- Installs dependencies
- Runs initial validation

**Interactive prompts:**

- Project name
- Author name
- Overwrite confirmation (if files exist)

---

### `validate-setup.sh`

Comprehensive validation of project setup.

**Usage:**

```bash
./scripts/setup/validate-setup.sh
```

**What it validates:**

- Configuration files (package.json, tsconfig, etc.)
- Project directory structure
- Dependencies installation
- NPM scripts availability
- TypeScript compilation
- ESLint rules
- Prettier formatting
- Storybook configuration
- Git configuration

**Exit codes:**

- `0` = All checks passed
- `>0` = Number of errors found

---

## Session State Management (Phase 1.0)

TypeScript modules for reading, writing, and validating session state.

**Location:** `scripts/session-state/`

**Files:**

- `types.ts` - TypeScript type definitions
- `reader.ts` - State reading functions
- `writer.ts` - State writing functions
- `validator.ts` - State validation functions
- `index.ts` - Main entry point

**Usage in TypeScript:**

```typescript
import {
  readSessionState,
  updateSessionState,
  validateSessionState,
} from './scripts/session-state';

const state = readSessionState();
updateSessionState({ current: { phase: '1.2' } });
const validation = validateSessionState(state);
```

---

## Common Workflows

### Starting New Development Work

```bash
# 1. Check current status
./scripts/git-workflow/where-am-i.sh

# 2. Start new phase (if needed)
./scripts/git-workflow/start-phase.sh 1.2 "Component Implementation"

# 3. Work on tasks...

# 4. Complete each task
./scripts/git-workflow/complete-task.sh 1.2.1 "Create Button component"

# 5. Complete the phase
./scripts/git-workflow/complete-phase.sh 1.2
```

### Recovery from Issues

```bash
# 1. Diagnose the problem
./scripts/recovery/diagnose-issues.sh

# 2. Preserve current state
./scripts/recovery/panic-button.sh

# 3. Attempt recovery
./scripts/recovery/emergency-recovery.sh --auto

# 4. Verify recovery
./scripts/git-workflow/where-am-i.sh
```

### Setting Up New Project Clone

```bash
# 1. Clone repository
git clone https://github.com/jcmrs/ui-library.git
cd ui-library

# 2. Run setup
./scripts/setup/setup-new-project.sh

# 3. Validate setup
./scripts/setup/validate-setup.sh

# 4. Start Storybook
npm run storybook
```

---

## Windows Usage

All scripts have `.cmd` wrappers for Windows:

```cmd
REM Instead of:
bash scripts/git-workflow/where-am-i.sh

REM Use:
scripts\git-workflow\where-am-i.cmd
```

**Requirements:**

- Git for Windows (includes Git Bash)
- OR Windows Subsystem for Linux (WSL)

---

## Script Conventions

### Exit Codes

- `0` = Success
- `1` = Error
- `>1` = Number of errors (validation scripts)

### Colors

- 🟢 Green = Success/OK
- 🟡 Yellow = Warning
- 🔴 Red = Error/Fail
- 🔵 Blue = Info
- 🔷 Cyan = Section headers

### Error Handling

- All scripts use `set -e` (except diagnostics/validation)
- Comprehensive error messages with actionable guidance
- Safe defaults (e.g., require confirmation before overwriting)

---

## Documentation

For detailed documentation, see:

- `.docs/GIT-WORKFLOW.md` - Complete git workflow guide
- `.docs/DISASTER-RECOVERY.md` - Recovery procedures and scenarios
- `.docs/SESSION-STATE.md` - Session state management details
- `.docs/ROADMAP.md` - Project roadmap and phases
- `.docs/TASKS.md` - Detailed task breakdown

---

## Troubleshooting

### "Permission denied" errors

```bash
# Make scripts executable
chmod +x scripts/**/*.sh
```

### "bash: command not found" on Windows

- Install Git for Windows
- OR use WSL
- OR run via Git Bash directly

### "jq: command not found"

```bash
# Install jq (JSON processor)
# macOS:
brew install jq

# Ubuntu/Debian:
sudo apt-get install jq

# Windows (via npm):
npm install -g node-jq
```

### Script fails with "Working directory not clean"

```bash
# Commit or stash your changes first
git add .
git commit -m "Your commit message"

# Or stash temporarily
git stash

# Then run the script again
```

---

## Contributing

When adding new scripts:

1. Create both `.sh` and `.cmd` versions
2. Follow the existing color/output conventions
3. Include comprehensive error handling
4. Add to this README
5. Test on both Linux/macOS and Windows

---

## License

MIT License - See LICENSE file for details
