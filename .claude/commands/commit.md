# Intelligent Commit Workflow

You are performing an **intelligent commit** with automated validation and message generation.

## Your Task

Follow these steps in order:

### 1. Show Current Changes

```bash
git status
git diff --stat
```

Analyze:

- What files were modified?
- What was added/removed?
- Are there any sensitive files (.env, credentials, etc.)?

### 2. Generate Commit Message

Based on the changes, create a commit message following Conventional Commits:

**Format:**

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**

- `feat`: New feature
- `fix`: Bug fix
- `refactor`: Code refactoring
- `docs`: Documentation only
- `style`: Formatting, missing semicolons, etc.
- `test`: Adding tests
- `chore`: Maintenance tasks

**Guidelines:**

- Subject: 50 chars max, imperative mood ("Add" not "Added")
- Body: Explain what and why (not how)
- Reference related issues/tasks if applicable

### 3. Stage Files

**IMPORTANT:** Do NOT stage sensitive files:

- `.env` files
- `credentials.json`
- `secrets.*`
- `*.key`, `*.pem`
- Lock files (unless dependency update)

```bash
git add <appropriate-files>
```

### 4. Run Quality Validation

The pre-commit hook will automatically run:

- TypeScript type checking
- ESLint validation
- Prettier formatting

If any fail:

- Show the errors
- Fix them
- Re-stage files
- Try commit again

### 5. Commit

```bash
git commit -m "$(cat <<'EOF'
<your-generated-message>
EOF
)"
```

### 6. Confirm Success

After successful commit:

- Show commit hash
- Show final git status
- Confirm working directory is clean

## Example

```bash
# 1. Check changes
git status
# On branch develop
# Changes not staged for commit:
#   modified:   src/components/Button.tsx
#   modified:   src/components/Button.test.tsx

# 2. Stage files
git add src/components/Button.tsx src/components/Button.test.tsx

# 3. Commit with generated message
git commit -m "$(cat <<'EOF'
feat(Button): Add size variants

Added sm, md, lg, xl size variants to Button component.
Updated tests to cover all size combinations.

Related to Phase 1.3 - First Components Implementation
EOF
)"

# 4. Verify
git log -1 --oneline
# abc1234 feat(Button): Add size variants
```

## Success Criteria

- ✅ All changes staged appropriately
- ✅ No sensitive files committed
- ✅ Quality gates passed (pre-commit hook)
- ✅ Commit message follows Conventional Commits
- ✅ Working directory clean after commit

Begin the intelligent commit workflow now.
