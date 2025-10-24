# Component Development Guide

**Project:** UI Library
**Version:** 1.0.0
**Last Updated:** 2025-01-24

---

## Overview

This guide covers the complete process for creating new components in the UI Library, from scaffolding to documentation to testing.

---

## Quick Start

### Create a New Component

```bash
# Syntax: ./scripts/create-component.sh ComponentName category
./scripts/create-component.sh Button base

# Categories: base, application, marketing, pages
```

This automatically generates:

- `component.tsx` - Component implementation
- `component.test.tsx` - Test suite
- `component.stories.tsx` - Storybook stories
- `component.patterns.md` - Usage patterns
- `component.checklist.json` - Quality checklist
- `index.ts` - Barrel exports

---

## Component Structure

### File Organization

```
src/components/base/button/
├── button.tsx              # Main component implementation
├── button.test.tsx         # Unit and integration tests
├── button.stories.tsx      # Storybook stories
├── button.patterns.md      # Usage patterns and examples
├── button.checklist.json   # Quality validation checklist
└── index.ts                # Public exports
```

### Component Template

```typescript
// button.tsx
import { cx } from '@/utils/cx';
import type { ComponentPropsWithoutRef } from 'react';

/**
 * Button component with multiple variants and sizes
 *
 * @example
 * <Button variant="primary" size="md">Click me</Button>
 */
export interface ButtonProps extends ComponentPropsWithoutRef<'button'> {
  /** Visual style variant */
  variant?: 'primary' | 'secondary' | 'tertiary' | 'ghost';
  /** Button size */
  size?: 'sm' | 'md' | 'lg' | 'xl';
  /** Full width button */
  fullWidth?: boolean;
  /** Loading state */
  loading?: boolean;
  /** Icon to display before text */
  iconBefore?: React.ReactNode;
  /** Icon to display after text */
  iconAfter?: React.ReactNode;
}

export function Button({
  variant = 'primary',
  size = 'md',
  fullWidth = false,
  loading = false,
  iconBefore,
  iconAfter,
  children,
  disabled,
  className,
  ...props
}: ButtonProps) {
  return (
    <button
      className={cx(
        // Base styles
        'inline-flex items-center justify-center gap-2',
        'rounded-lg font-medium transition-all',
        'focus:outline-none focus:ring-2 focus:ring-offset-2',
        'disabled:cursor-not-allowed disabled:opacity-50',

        // Variant styles
        variant === 'primary' && [
          'bg-blue-600 text-white',
          'hover:bg-blue-700 active:bg-blue-800',
          'focus:ring-blue-500',
        ],
        variant === 'secondary' && [
          'bg-gray-200 text-gray-900',
          'hover:bg-gray-300 active:bg-gray-400',
          'focus:ring-gray-500',
        ],
        variant === 'tertiary' && [
          'border border-gray-300 bg-white text-gray-700',
          'hover:bg-gray-50 active:bg-gray-100',
          'focus:ring-gray-500',
        ],
        variant === 'ghost' && [
          'text-gray-700',
          'hover:bg-gray-100 active:bg-gray-200',
          'focus:ring-gray-500',
        ],

        // Size styles
        size === 'sm' && 'px-3 py-1.5 text-sm',
        size === 'md' && 'px-4 py-2 text-base',
        size === 'lg' && 'px-5 py-3 text-lg',
        size === 'xl' && 'px-6 py-4 text-xl',

        // Full width
        fullWidth && 'w-full',

        // Custom className
        className
      )}
      disabled={disabled || loading}
      {...props}
    >
      {loading && <LoadingSpinner size={size} />}
      {!loading && iconBefore}
      {children}
      {!loading && iconAfter}
    </button>
  );
}

Button.displayName = 'Button';
```

---

## Development Process

### Step 1: Design Phase

Before writing code:

1. **Review UntitledUI Reference**

   - Check `UPSTREAM/react/` for component patterns
   - Identify all variants and states
   - Document visual specifications

2. **Define Component API**

   - List all props and their types
   - Determine sensible defaults
   - Plan variant combinations

3. **Accessibility Analysis**
   - Identify ARIA requirements
   - Plan keyboard interactions
   - Consider screen reader experience

### Step 2: Implementation

Follow TDD (Test-Driven Development):

1. **Write Tests First**

```typescript
// button.test.tsx
import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { Button } from './button';

describe('Button', () => {
  it('renders with children', () => {
    render(<Button>Click me</Button>);
    expect(screen.getByRole('button', { name: 'Click me' })).toBeInTheDocument();
  });

  it('handles click events', async () => {
    const handleClick = vi.fn();
    render(<Button onClick={handleClick}>Click</Button>);

    await userEvent.click(screen.getByRole('button'));
    expect(handleClick).toHaveBeenCalledTimes(1);
  });

  it('applies variant styles', () => {
    const { rerender } = render(<Button variant="primary">Primary</Button>);
    expect(screen.getByRole('button')).toHaveClass('bg-blue-600');

    rerender(<Button variant="secondary">Secondary</Button>);
    expect(screen.getByRole('button')).toHaveClass('bg-gray-200');
  });

  it('supports disabled state', () => {
    render(<Button disabled>Disabled</Button>);
    expect(screen.getByRole('button')).toBeDisabled();
  });
});
```

2. **Implement Component**

   - Start with basic structure
   - Add variants incrementally
   - Ensure tests pass after each addition

3. **Add Accessibility**
   - Use React Aria when appropriate
   - Ensure semantic HTML
   - Add ARIA attributes
   - Test keyboard navigation

### Step 3: Documentation

1. **Storybook Stories**

```typescript
// button.stories.tsx
import type { Meta, StoryObj } from '@storybook/react';
import { Button } from './button';

const meta = {
  title: 'Base/Button',
  component: Button,
  parameters: {
    layout: 'centered',
  },
  tags: ['autodocs'],
  argTypes: {
    variant: {
      control: 'select',
      options: ['primary', 'secondary', 'tertiary', 'ghost'],
    },
    size: {
      control: 'select',
      options: ['sm', 'md', 'lg', 'xl'],
    },
  },
} satisfies Meta<typeof Button>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Primary: Story = {
  args: {
    variant: 'primary',
    size: 'md',
    children: 'Button',
  },
};

export const AllVariants: Story = {
  render: () => (
    <div className="flex gap-4">
      <Button variant="primary">Primary</Button>
      <Button variant="secondary">Secondary</Button>
      <Button variant="tertiary">Tertiary</Button>
      <Button variant="ghost">Ghost</Button>
    </div>
  ),
};

export const AllSizes: Story = {
  render: () => (
    <div className="flex items-center gap-4">
      <Button size="sm">Small</Button>
      <Button size="md">Medium</Button>
      <Button size="lg">Large</Button>
      <Button size="xl">Extra Large</Button>
    </div>
  ),
};

export const WithIcons: Story = {
  render: () => (
    <div className="flex gap-4">
      <Button iconBefore={<Icon name="plus" />}>Add Item</Button>
      <Button iconAfter={<Icon name="arrow-right" />}>Continue</Button>
    </div>
  ),
};

export const States: Story = {
  render: () => (
    <div className="flex gap-4">
      <Button>Default</Button>
      <Button loading>Loading</Button>
      <Button disabled>Disabled</Button>
    </div>
  ),
};
```

2. **Usage Patterns**

````markdown
<!-- button.patterns.md -->

# Button Usage Patterns

## Basic Usage

\`\`\`tsx
import { Button } from 'ui-library/base';

<Button variant="primary" size="md">
  Click me
</Button>
\`\`\`

## With Icons

\`\`\`tsx
<Button
variant="primary"
iconBefore={<PlusIcon />}

> Add Item
> </Button> > \`\`\`

## Loading State

\`\`\`tsx
const [loading, setLoading] = useState(false);

<Button
variant="primary"
loading={loading}
onClick={async () => {
setLoading(true);
await submitForm();
setLoading(false);
}}

> Submit
> </Button> > \`\`\`

## Form Integration

\`\`\`tsx

<form onSubmit={handleSubmit}>
  <Button type="submit" variant="primary">
    Submit Form
  </Button>
</form>
\`\`\`

## Accessibility

- Uses semantic \`<button>\` element
- Supports keyboard navigation (Space/Enter)
- Includes focus indicators
- Screen reader friendly
- Disabled state properly announced
  \`\`\`

3. **Quality Checklist**

```json
// button.checklist.json
{
  "component": "Button",
  "category": "base",
  "checklist": {
    "implementation": {
      "typescript": {
        "status": "complete",
        "items": [
          "Props interface exported",
          "All props properly typed",
          "JSDoc comments added",
          "Generics used appropriately"
        ]
      },
      "accessibility": {
        "status": "complete",
        "items": [
          "Semantic HTML used",
          "ARIA attributes correct",
          "Keyboard navigation works",
          "Focus management proper",
          "Screen reader tested"
        ]
      },
      "responsive": {
        "status": "complete",
        "items": [
          "Mobile-first approach",
          "All breakpoints tested",
          "Touch targets adequate (44px min)"
        ]
      }
    },
    "documentation": {
      "storybook": {
        "status": "complete",
        "items": [
          "All variants documented",
          "Interactive controls added",
          "Accessibility addon enabled",
          "Examples comprehensive"
        ]
      },
      "patterns": {
        "status": "complete",
        "items": [
          "Usage patterns documented",
          "Code examples provided",
          "Best practices listed",
          "Common pitfalls noted"
        ]
      }
    },
    "testing": {
      "unit": {
        "status": "complete",
        "items": ["Render tests", "Interaction tests", "Variant tests", "Edge case tests"]
      }
    },
    "quality": {
      "status": "complete",
      "items": [
        "No TypeScript errors",
        "No ESLint warnings",
        "Prettier formatted",
        "All tests passing"
      ]
    }
  }
}
```
````

---

## Component Categories

### Base Components

**Location:** `src/components/base/`

Foundational UI primitives:

- Buttons, Inputs, Textareas
- Badges, Tags, Avatars
- Toggles, Checkboxes, Radio buttons
- Tooltips, Progress indicators
- Dropdowns, Select menus

**Characteristics:**

- Single responsibility
- Highly reusable
- Minimal composition
- Focus on accessibility

### Application UI

**Location:** `src/components/application/`

Complex application patterns:

- Modals, Slideouts, Command menus
- Tables, Data grids
- Charts and metrics
- Navigation (headers, sidebars)
- Forms and inputs
- Notifications, Alerts

**Characteristics:**

- Composed from base components
- Application-specific logic
- Complex interactions
- State management

### Marketing Components

**Location:** `src/components/marketing/`

Landing page sections:

- Hero sections, Headers
- Feature sections, Pricing
- Testimonials, Social proof
- CTAs, Newsletter signups
- Footers, Contact sections

**Characteristics:**

- Visually rich
- Content-driven
- SEO considerations
- Conversion-focused

### Page Templates

**Location:** `src/components/pages/`

Complete page compositions:

- Authentication pages (login, signup)
- Error pages (404, 500)
- Email templates
- Marketing pages

**Characteristics:**

- Full page layouts
- Multiple sections
- Responsive structure
- Ready to customize

---

## Best Practices

### TypeScript

1. **Export All Interfaces**

```typescript
export interface ButtonProps extends ComponentPropsWithoutRef<'button'> {
  variant?: 'primary' | 'secondary';
}
```

2. **Use Discriminated Unions**

```typescript
type AlertProps = { variant: 'success'; onClose: () => void } | { variant: 'error'; error: Error };
```

3. **Leverage Generic Components**

```typescript
export function Select<T>({ options, value, onChange }: SelectProps<T>) {
  // ...
}
```

### React Patterns

1. **Composition Over Configuration**

```typescript
// ✅ Good - Composable
<Card>
  <CardHeader title="Title" />
  <CardBody>Content</CardBody>
</Card>

// ❌ Bad - Configuration
<Card title="Title" body="Content" />
```

2. **Controlled vs Uncontrolled**

```typescript
// Support both patterns
export function Input({ value, defaultValue, onChange }: InputProps) {
  const [internalValue, setInternalValue] = useState(defaultValue);
  const isControlled = value !== undefined;

  const currentValue = isControlled ? value : internalValue;
  // ...
}
```

3. **Forward Refs**

```typescript
export const Button = forwardRef<HTMLButtonElement, ButtonProps>(
  ({ children, ...props }, ref) => {
    return <button ref={ref} {...props}>{children}</button>;
  }
);
```

### Tailwind CSS

1. **Use cx() Utility**

```typescript
import { cx } from '@/utils/cx';

className={cx(
  'base-classes',
  variant === 'primary' && 'variant-classes',
  size === 'lg' && 'size-classes',
  className // Allow overrides
)}
```

2. **Group Related Styles**

```typescript
variant === 'primary' && [
  'bg-blue-600 text-white',
  'hover:bg-blue-700 active:bg-blue-800',
  'focus:ring-blue-500',
];
```

3. **Avoid Arbitrary Values**

```typescript
// ❌ Bad
'p-[13px]';

// ✅ Good - Use standard spacing
'px-3 py-1.5';
```

### Accessibility

1. **Use React Aria When Appropriate**

```typescript
import { useButton } from 'react-aria';

export function Button(props: ButtonProps) {
  const ref = useRef<HTMLButtonElement>(null);
  const { buttonProps } = useButton(props, ref);

  return <button {...buttonProps} ref={ref} />;
}
```

2. **Semantic HTML**

```typescript
// ✅ Good
<button type="button">

// ❌ Bad
<div role="button">
```

3. **Keyboard Navigation**

```typescript
onKeyDown={(e) => {
  if (e.key === 'Enter' || e.key === ' ') {
    e.preventDefault();
    onClick?.();
  }
}}
```

---

## Quality Checklist

Before marking a component complete:

### Implementation

- [ ] TypeScript types exported
- [ ] All props documented with JSDoc
- [ ] Semantic HTML used
- [ ] ARIA attributes correct
- [ ] Keyboard navigation implemented
- [ ] Focus management proper
- [ ] Mobile-first responsive
- [ ] All variants implemented

### Documentation

- [ ] Storybook stories for all variants
- [ ] Interactive controls added
- [ ] Usage patterns documented
- [ ] Code examples provided
- [ ] Best practices listed
- [ ] Accessibility notes included

### Testing

- [ ] Unit tests written
- [ ] Interaction tests added
- [ ] Edge cases covered
- [ ] All tests passing
- [ ] Accessibility tested

### Quality

- [ ] No TypeScript errors
- [ ] No ESLint warnings
- [ ] Prettier formatted
- [ ] No console warnings
- [ ] Performance acceptable

---

## Common Pitfalls

### 1. Forgetting Disabled State

```typescript
// ❌ Bad - Doesn't handle disabled
<button onClick={onClick}>

// ✅ Good - Prevents click when disabled
<button onClick={disabled ? undefined : onClick} disabled={disabled}>
```

### 2. Missing Focus Indicators

```typescript
// ❌ Bad - Removes focus outline without replacement
'outline-none';

// ✅ Good - Replaces with visible focus ring
'focus:outline-none focus:ring-2 focus:ring-blue-500';
```

### 3. Hardcoded Colors

```typescript
// ❌ Bad - Not themeable
'bg-[#3B82F6]';

// ✅ Good - Uses theme colors
'bg-blue-600';
```

### 4. Inadequate Touch Targets

```typescript
// ❌ Bad - Too small for mobile
'p-1'; // 4px padding = tiny target

// ✅ Good - Minimum 44x44px
'px-4 py-3'; // Adequate touch target
```

---

## Resources

- [React Aria Documentation](https://react-spectrum.adobe.com/react-aria/)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [Tailwind CSS Docs](https://tailwindcss.com/docs)
- [Storybook Docs](https://storybook.js.org/docs)
- [UntitledUI Reference](UPSTREAM/react/)

---

## Getting Help

- Check existing components for patterns
- Review `.serena/memories/` for project context
- Consult `.docs/TDD-METHODOLOGY.md` for testing approach
- See `CONTRIBUTING.md` for contribution guidelines
