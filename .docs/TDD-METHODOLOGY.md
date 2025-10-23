# Test-Driven Development Methodology

**Project:** AI-Native UI Component Library
**Last Updated:** 2025-01-23

This document defines the TDD (Test-Driven Development) methodology for this project, adapted specifically for building AI-consumable UI components with Claude Code.

---

## Overview

### Why TDD for This Project

1. **Component Reliability** - UI components must work correctly across all variants and states
2. **Regression Prevention** - Changes must not break existing functionality
3. **Documentation Through Tests** - Tests serve as executable specifications
4. **AI Validation** - Tests verify Claude Code can use components correctly
5. **Refactoring Confidence** - Comprehensive tests enable safe refactoring

### TDD Philosophy

We follow **Red-Green-Refactor** cycle with AI-specific adaptations:

```
1. RED: Write failing test (define behavior)
   ↓
2. GREEN: Write minimum code to pass (implement behavior)
   ↓
3. REFACTOR: Improve code quality (maintain behavior)
   ↓
4. DOCUMENT: Add AI-friendly documentation (enable AI usage)
   ↓
5. VALIDATE: Test with Claude Code (verify AI can use it)
```

---

## TDD Cycle for UI Components

### Phase 1: RED (Write Failing Tests)

#### Step 1.1: Define Component Behavior

Before writing any component code, write tests that define expected behavior.

**Example: Button Component**

```typescript
// components/base/button/button.test.tsx

import { describe, it, expect } from 'vitest';
import { render, screen } from '@testing-library/react';
import { Button } from './button';

describe('Button', () => {
  it('renders with text content', () => {
    render(<Button>Click me</Button>);
    expect(screen.getByRole('button', { name: 'Click me' })).toBeInTheDocument();
  });

  it('applies primary variant styles by default', () => {
    render(<Button>Click me</Button>);
    const button = screen.getByRole('button');
    expect(button).toHaveClass('bg-brand-solid');
  });

  it('applies secondary variant when specified', () => {
    render(<Button color="secondary">Click me</Button>);
    const button = screen.getByRole('button');
    expect(button).toHaveClass('bg-primary');
    expect(button).toHaveClass('text-secondary');
  });

  // Test fails - component doesn't exist yet
});
```

#### Step 1.2: Run Tests (Expect Failures)

```bash
npm run test

# Expected output:
# FAIL components/base/button/button.test.tsx
#   ● Cannot find module './button'
```

**Success Criteria for RED Phase:**
- Tests are written
- Tests define clear, specific behavior
- Tests fail for expected reasons (no component yet)
- Test names clearly describe what they test

---

### Phase 2: GREEN (Make Tests Pass)

#### Step 2.1: Implement Minimum Code

Write the simplest code that makes tests pass. Don't optimize yet.

**Example: Button Component (Minimum)**

```typescript
// components/base/button/button.tsx

import { ButtonHTMLAttributes } from 'react';

export interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  color?: 'primary' | 'secondary';
}

export function Button({ color = 'primary', children, ...props }: ButtonProps) {
  const classes = color === 'primary'
    ? 'bg-brand-solid'
    : 'bg-primary text-secondary';

  return (
    <button className={classes} {...props}>
      {children}
    </button>
  );
}
```

#### Step 2.2: Run Tests (Expect Passes)

```bash
npm run test

# Expected output:
# PASS components/base/button/button.test.tsx
#   ✓ renders with text content
#   ✓ applies primary variant styles by default
#   ✓ applies secondary variant when specified
```

**Success Criteria for GREEN Phase:**
- All tests pass
- Code is simple and direct
- No premature optimization
- Coverage starts building

---

### Phase 3: REFACTOR (Improve Code Quality)

#### Step 3.1: Improve Implementation

Now that tests pass, improve code quality without changing behavior.

**Example: Button Component (Refactored)**

```typescript
// components/base/button/button.tsx

import { ButtonHTMLAttributes } from 'react';
import { cx } from '@/utils/cx';

/**
 * Button color variant styles
 *
 * @remarks
 * Each variant defines complete styling for that button type.
 * Variants are mutually exclusive - only one can be active.
 */
const variantStyles = {
  primary: 'bg-brand-solid text-white shadow-xs',
  secondary: 'bg-primary text-secondary shadow-xs ring-1 ring-primary',
} as const;

/**
 * Button component props
 *
 * @property color - Visual variant of the button (default: 'primary')
 * @property children - Button text content
 *
 * @example
 * // Primary button (default)
 * <Button>Save</Button>
 *
 * @example
 * // Secondary button
 * <Button color="secondary">Cancel</Button>
 */
export interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  /** Visual variant of the button */
  color?: keyof typeof variantStyles;
}

/**
 * Button component
 *
 * A clickable button element following WAI-ARIA button pattern.
 *
 * @param props - Button props
 * @returns Button element
 */
export function Button({
  color = 'primary',
  children,
  className,
  ...props
}: ButtonProps) {
  return (
    <button
      className={cx(
        // Base styles applied to all buttons
        'inline-flex items-center justify-center',
        'rounded-lg px-4 py-2',
        'font-semibold transition-colors',
        'focus:outline-2 focus:outline-brand',
        // Variant-specific styles
        variantStyles[color],
        // User-provided custom classes
        className
      )}
      {...props}
    >
      {children}
    </button>
  );
}
```

#### Step 3.2: Run Tests Again (Ensure Still Pass)

```bash
npm run test

# Expected output:
# PASS components/base/button/button.test.tsx
#   ✓ renders with text content
#   ✓ applies primary variant styles by default
#   ✓ applies secondary variant when specified
```

**Success Criteria for REFACTOR Phase:**
- All tests still pass
- Code is cleaner and more maintainable
- Documentation is enhanced
- No behavior changes

---

### Phase 4: DOCUMENT (Add AI-Friendly Documentation)

#### Step 4.1: Add Inline Documentation

Enhance component with AI-specific guidance.

```typescript
/**
 * Button component for primary user actions
 *
 * ## AI Usage Guidelines
 *
 * **When to use:**
 * - Form submissions (Save, Submit, Create)
 * - Primary CTAs (Get Started, Sign Up)
 * - Confirmation actions (Confirm, Accept)
 *
 * **Variant selection:**
 * - `primary`: Main action on the page (limit to 1-2 per view)
 * - `secondary`: Alternative actions (Cancel, Go Back)
 *
 * **DO:**
 * - Use descriptive text ("Save Changes", not "Submit")
 * - Use primary for main action
 * - Disable during loading states
 *
 * **DO NOT:**
 * - Use multiple primary buttons in same context
 * - Use for navigation (use Link instead)
 * - Nest buttons inside buttons
 *
 * @example
 * // Form submission
 * <Button type="submit">Save Changes</Button>
 *
 * @example
 * // With loading state
 * <Button disabled={isLoading}>
 *   {isLoading ? 'Saving...' : 'Save'}
 * </Button>
 */
export function Button(props: ButtonProps) {
  // ... implementation
}
```

#### Step 4.2: Create Usage Patterns Document

Create `button.patterns.md` with comprehensive usage guidance.

**Success Criteria for DOCUMENT Phase:**
- Inline documentation is comprehensive
- JSDoc covers all props
- Examples show common use cases
- AI guidelines are explicit
- Patterns document exists

---

### Phase 5: VALIDATE (Test with Claude Code)

#### Step 5.1: Create AI Validation Test

```markdown
# Button Component - Claude Code Validation

## Test: Create Button Variant

**Prompt:**
"Create a new destructive button variant for the Button component. It should:
- Be red colored (error-500)
- Have hover state (error-600)
- Follow the same pattern as primary/secondary
- Include tests for the new variant"

**Expected Result:**
- Claude Code adds `destructive` variant to `variantStyles`
- Claude Code adds tests for destructive variant
- All tests pass
- Styling matches specification
```

#### Step 5.2: Execute Validation

Run the test with fresh Claude Code instance and record results.

**Success Criteria for VALIDATE Phase:**
- Claude Code successfully completes task
- Generated code follows patterns
- Tests pass
- Quality gates pass

---

## TDD Best Practices

### Test Organization

```
components/base/button/
├── button.tsx              ← Component implementation
├── button.test.tsx         ← Unit tests
├── button.story.tsx        ← Storybook stories (visual tests)
└── button.a11y.test.tsx    ← Accessibility tests (optional separate file)
```

### Test Structure (AAA Pattern)

```typescript
it('renders with primary variant by default', () => {
  // ARRANGE: Set up test conditions
  const buttonText = 'Click me';

  // ACT: Perform the action being tested
  render(<Button>{buttonText}</Button>);

  // ASSERT: Verify expected outcome
  const button = screen.getByRole('button', { name: buttonText });
  expect(button).toHaveClass('bg-brand-solid');
});
```

### Test Coverage Requirements

**Minimum Coverage Thresholds:**
- **Statements:** 90%
- **Branches:** 85%
- **Functions:** 90%
- **Lines:** 90%

**Coverage Configuration:**

```typescript
// vitest.config.ts
export default defineConfig({
  test: {
    coverage: {
      provider: 'v8',
      reporter: ['text', 'json', 'html'],
      thresholds: {
        statements: 90,
        branches: 85,
        functions: 90,
        lines: 90,
      },
      exclude: [
        '**/*.story.tsx',
        '**/*.test.tsx',
        '**/index.ts',
      ],
    },
  },
});
```

### Test Categories

#### 1. Unit Tests (Required)

Test individual component behavior in isolation.

```typescript
describe('Button - Unit Tests', () => {
  it('renders children correctly', () => { /* ... */ });
  it('calls onClick when clicked', () => { /* ... */ });
  it('applies correct variant classes', () => { /* ... */ });
  it('forwards ref correctly', () => { /* ... */ });
});
```

#### 2. Integration Tests (Required for Compositions)

Test component interactions.

```typescript
describe('ButtonGroup - Integration Tests', () => {
  it('renders multiple buttons correctly', () => { /* ... */ });
  it('applies group spacing', () => { /* ... */ });
  it('handles keyboard navigation between buttons', () => { /* ... */ });
});
```

#### 3. Accessibility Tests (Required)

Test WCAG compliance.

```typescript
import { axe, toHaveNoViolations } from 'jest-axe';
expect.extend(toHaveNoViolations);

describe('Button - Accessibility Tests', () => {
  it('has no accessibility violations', async () => {
    const { container } = render(<Button>Click me</Button>);
    const results = await axe(container);
    expect(results).toHaveNoViolations();
  });

  it('is keyboard navigable', () => {
    render(<Button>Click me</Button>);
    const button = screen.getByRole('button');
    button.focus();
    expect(button).toHaveFocus();
  });
});
```

#### 4. Visual Regression Tests (Optional)

Test visual appearance doesn't change unexpectedly.

```typescript
// Handled by Storybook + Chromatic or Percy
// See button.story.tsx for visual test cases
```

---

## Testing Tools & Utilities

### Testing Stack

- **Test Runner:** Vitest (fast, Vite-native)
- **Testing Library:** React Testing Library (user-centric testing)
- **Accessibility Testing:** jest-axe (automated a11y checks)
- **User Interactions:** @testing-library/user-event (realistic interactions)
- **Mocking:** Vitest mocks (built-in)
- **Coverage:** Vitest coverage (v8 or istanbul)

### Custom Test Utilities

```typescript
// test-utils/render.tsx

import { render, RenderOptions } from '@testing-library/react';
import { ReactElement } from 'react';

/**
 * Custom render function with common providers
 *
 * Wraps components with necessary providers for testing.
 * Use this instead of raw `render` from Testing Library.
 */
export function renderWithProviders(
  ui: ReactElement,
  options?: RenderOptions
) {
  return render(ui, {
    wrapper: ({ children }) => (
      // Add providers here as needed (theme, etc.)
      <>{children}</>
    ),
    ...options,
  });
}

// Re-export everything else
export * from '@testing-library/react';
```

---

## TDD Workflow for Different Component Types

### Base Components (Primitives)

**TDD Cycle Focus:**
- Props validation
- Variant rendering
- State handling
- Accessibility

**Example Test Suite:**

```typescript
describe('Input', () => {
  describe('Rendering', () => {
    it('renders text input by default');
    it('renders email input when type="email"');
    it('renders with label when provided');
  });

  describe('States', () => {
    it('shows error state when error prop provided');
    it('shows disabled state when disabled');
    it('shows required indicator when required');
  });

  describe('Interactions', () => {
    it('calls onChange when value changes');
    it('calls onBlur when focus lost');
    it('shows validation error on blur');
  });

  describe('Accessibility', () => {
    it('has no axe violations');
    it('associates label with input correctly');
    it('announces errors to screen readers');
  });
});
```

### Application Components (Complex)

**TDD Cycle Focus:**
- Composition correctness
- State management
- Data flow
- Integration with base components

**Example Test Suite:**

```typescript
describe('Modal', () => {
  describe('Rendering', () => {
    it('renders nothing when closed');
    it('renders overlay and content when open');
    it('renders header, body, and footer');
  });

  describe('Interactions', () => {
    it('closes when overlay clicked');
    it('closes when close button clicked');
    it('closes when Escape key pressed');
    it('traps focus within modal');
  });

  describe('Accessibility', () => {
    it('has role="dialog"');
    it('has aria-modal="true"');
    it('focuses first focusable element on open');
    it('returns focus on close');
  });
});
```

### Layout Components

**TDD Cycle Focus:**
- Grid/flexbox behavior
- Responsive breakpoints
- Slot rendering
- Overflow handling

**Example Test Suite:**

```typescript
describe('DashboardLayout', () => {
  describe('Structure', () => {
    it('renders header slot');
    it('renders sidebar slot');
    it('renders content slot');
    it('applies grid layout classes');
  });

  describe('Responsive Behavior', () => {
    it('stacks vertically on mobile');
    it('shows sidebar on tablet and above');
    it('applies correct breakpoint classes');
  });

  describe('Overflow', () => {
    it('makes content area scrollable');
    it('makes sidebar scrollable');
    it('keeps header fixed');
  });
});
```

### Page Templates

**TDD Cycle Focus:**
- Complete page rendering
- Component integration
- User workflows
- E2E interactions

**Example Test Suite:**

```typescript
describe('SimpleDashboard Template', () => {
  describe('Rendering', () => {
    it('renders dashboard layout');
    it('renders header with logo and user menu');
    it('renders sidebar with navigation');
    it('renders main content area');
  });

  describe('Navigation', () => {
    it('highlights active nav item');
    it('navigates when nav item clicked');
  });

  describe('User Menu', () => {
    it('opens menu when clicked');
    it('shows user profile link');
    it('shows logout link');
  });
});
```

---

## TDD Anti-Patterns to Avoid

### ❌ Testing Implementation Details

**Bad:**
```typescript
// Testing internal state (implementation detail)
it('sets isOpen state to true', () => {
  const { result } = renderHook(() => useModal());
  act(() => result.current.open());
  expect(result.current.isOpen).toBe(true); // Testing internal state
});
```

**Good:**
```typescript
// Testing user-observable behavior
it('shows modal when opened', () => {
  render(<Modal />);
  const button = screen.getByRole('button', { name: 'Open' });
  fireEvent.click(button);
  expect(screen.getByRole('dialog')).toBeInTheDocument(); // Testing visible outcome
});
```

### ❌ Testing Styles Directly

**Bad:**
```typescript
// Testing exact CSS values
it('has correct padding', () => {
  render(<Button>Click</Button>);
  const button = screen.getByRole('button');
  expect(button).toHaveStyle({ padding: '8px 16px' }); // Fragile
});
```

**Good:**
```typescript
// Testing class application (more stable)
it('applies size classes correctly', () => {
  render(<Button size="md">Click</Button>);
  const button = screen.getByRole('button');
  expect(button).toHaveClass('px-4 py-2'); // Tests Tailwind classes
});
```

### ❌ Snapshot Testing as Primary Test

**Bad:**
```typescript
// Snapshot test as only test
it('renders correctly', () => {
  const { container } = render(<Button>Click</Button>);
  expect(container).toMatchSnapshot(); // Not descriptive, easy to blindly update
});
```

**Good:**
```typescript
// Specific behavior tests
it('renders button with text content', () => {
  render(<Button>Click me</Button>);
  expect(screen.getByRole('button', { name: 'Click me' })).toBeInTheDocument();
});

it('applies primary variant styles', () => {
  render(<Button color="primary">Click</Button>);
  expect(screen.getByRole('button')).toHaveClass('bg-brand-solid');
});
```

### ❌ Not Testing Edge Cases

**Bad:**
```typescript
// Only testing happy path
it('renders button', () => {
  render(<Button>Click</Button>);
  expect(screen.getByRole('button')).toBeInTheDocument();
});
```

**Good:**
```typescript
// Testing edge cases
describe('Button edge cases', () => {
  it('renders without children', () => {
    render(<Button />);
    expect(screen.getByRole('button')).toBeInTheDocument();
  });

  it('handles null children', () => {
    render(<Button>{null}</Button>);
    expect(screen.getByRole('button')).toBeInTheDocument();
  });

  it('handles very long text', () => {
    const longText = 'A'.repeat(1000);
    render(<Button>{longText}</Button>);
    expect(screen.getByRole('button')).toHaveTextContent(longText);
  });
});
```

---

## Continuous Integration

### Pre-commit Hooks

```bash
# .git/hooks/pre-commit
#!/bin/bash

echo "Running tests on changed files..."

# Get changed files
CHANGED_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.(tsx?|jsx?)$')

if [ -z "$CHANGED_FILES" ]; then
  echo "No TypeScript/JavaScript files changed"
  exit 0
fi

# Run tests for changed files
npm run test -- --changed

if [ $? -ne 0 ]; then
  echo "❌ Tests failed. Commit blocked."
  exit 1
fi

echo "✅ Tests passed"
```

### GitHub Actions CI

```yaml
# .github/workflows/test.yml
name: Test

on:
  pull_request:
  push:
    branches: [main, develop]

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Run tests
        run: npm run test -- --coverage

      - name: Check coverage thresholds
        run: npm run test:coverage-check

      - name: Upload coverage
        uses: codecov/codecov-action@v4
        with:
          files: ./coverage/coverage-final.json
```

---

## Test Documentation

### Test Naming Convention

```typescript
// Pattern: it('[action/state] [expected result]')

// Good examples:
it('renders with text content');
it('calls onClick when clicked');
it('shows error message when validation fails');
it('disables button when isDisabled is true');
it('applies secondary variant classes when color="secondary"');

// Bad examples:
it('works correctly'); // Too vague
it('test button'); // Not descriptive
it('should render'); // Unnecessary "should"
```

### Test Organization

```typescript
// Group related tests using describe blocks
describe('Button', () => {
  describe('Rendering', () => {
    // Tests for rendering behavior
  });

  describe('Interactions', () => {
    // Tests for user interactions
  });

  describe('States', () => {
    // Tests for different states
  });

  describe('Accessibility', () => {
    // Tests for a11y compliance
  });

  describe('Edge Cases', () => {
    // Tests for unusual scenarios
  });
});
```

---

## Summary

### TDD Cycle Checklist

For each component:

- [ ] **RED:** Write failing tests defining behavior
- [ ] **GREEN:** Implement minimum code to pass tests
- [ ] **REFACTOR:** Improve code quality while maintaining tests
- [ ] **DOCUMENT:** Add AI-friendly inline documentation
- [ ] **VALIDATE:** Test with Claude Code to verify AI usability

### Quality Gates

Before committing:

- [ ] All tests pass
- [ ] Coverage >= 90%
- [ ] No accessibility violations
- [ ] ESLint passes
- [ ] TypeScript compiles
- [ ] Prettier formatted

### Success Criteria

Component is complete when:

- [ ] All tests pass
- [ ] Coverage meets thresholds
- [ ] Documentation is comprehensive
- [ ] Claude Code can use component successfully
- [ ] Storybook stories demonstrate all features
- [ ] Patterns document exists
- [ ] Component passes validation checklist

---

**Next:** See TASKS.md for specific implementation tasks following this methodology.
