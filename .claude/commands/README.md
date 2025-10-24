# Slash Commands

Custom slash commands for Claude Code automation workflows.

## Available Commands

### `/commit` - Intelligent Commit

Performs an intelligent commit with automated validation and message generation.

**Usage:**

```
/commit
```

**What it does:**

1. Shows current changes (`git status`, `git diff`)
2. Generates Conventional Commits message
3. Stages files (excludes sensitive files)
4. Validates with quality gates (pre-commit hook)
5. Creates commit
6. Confirms success

**Example:**

```
User: /commit
Claude: [Analyzes changes]
        [Generates message]
        [Stages files]
        [Commits]
        ✅ Committed: abc1234 feat(Button): Add size variants
```

---

### `/checkpoint` - Session Checkpoint

Creates a session checkpoint before ending conversation.

**Usage:**

```
/checkpoint
```

**What it does:**

1. Reviews current workflow state
2. Updates session state JSON
3. Interactive staging of changes
4. Creates checkpoint commit
5. Creates git tag with date
6. Syncs with remote
7. Generates session summary

**Example:**

```
User: /checkpoint
Claude: [Checks state]
        [Updates session-state.json]
        [Stages and commits changes]
        [Creates tag: checkpoint-2025-01-24-automation]
        [Pushes to remote]
        ✅ Checkpoint created and synced
```

---

## How Slash Commands Work

Slash commands are markdown files that contain prompts for Claude Code to follow.

**Location:** `.claude/commands/<command-name>.md`

**Format:**

- Command name = filename without `.md`
- File contains instructions for Claude to follow
- Can include code examples, workflows, success criteria

**Execution:**
When you type `/commit`, Claude Code:

1. Reads `.claude/commands/commit.md`
2. Follows the instructions in that file
3. Executes the workflow described

---

## Creating Custom Commands

Create a new file: `.claude/commands/my-command.md`

```markdown
# My Custom Command

Description of what this command does.

## Your Task

Step-by-step instructions for Claude Code to follow:

### 1. First Step

\`\`\`bash
command-to-run
\`\`\`

### 2. Second Step

More instructions...

## Success Criteria

- ✅ Criterion 1
- ✅ Criterion 2
```

**Usage:** `/my-command`

---

## Best Practices

### Command Design

- Make commands atomic (one clear purpose)
- Provide explicit step-by-step instructions
- Include validation/success criteria
- Show example workflows
- Handle error cases

### Sensitive Files

Always exclude from auto-staging:

- `.env` files
- `credentials.json`
- `secrets.*`
- `*.key`, `*.pem`
- Lock files (unless dependency update)

### Commit Messages

Follow Conventional Commits:

- `feat`: New feature
- `fix`: Bug fix
- `refactor`: Code refactoring
- `docs`: Documentation
- `style`: Formatting
- `test`: Tests
- `chore`: Maintenance

---

## Command Interaction

Commands can be chained:

```
User: /commit
[Claude commits changes]

User: /checkpoint
[Claude creates checkpoint]
```

---

## Troubleshooting

### Command Not Found

```
Error: Command '/mycommand' not found
```

**Fix:** Ensure `.claude/commands/mycommand.md` exists

### Command Fails

- Check command file syntax
- Verify instructions are clear
- Check file permissions
- Look for typos in bash commands

---

## References

- **Slash Commands Documentation:** This file
- **Git Workflow:** `.docs/GIT-WORKFLOW.md`
- **Automation:** `.claude/AUTOMATION.md`
- **Session State:** `.docs/SESSION-STATE.md`
