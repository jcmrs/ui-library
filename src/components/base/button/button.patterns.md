# Button Usage Patterns

**Component Type**: Base Component (Primitive UI Element)
**Category**: base
**Created**: 2025-10-24
**WCAG Compliance**: AA

## Overview

[Add a brief 2-3 sentence description of what this component does and when to use it]

## Basic Usage

### Simple Example

```tsx
import { Button } from '@/components/base/button';

function Example() {
  return <Button>Basic content</Button>;
}
```

### With Size Variants

```tsx
<Button size="sm">Small</Button>
<Button size="md">Medium (default)</Button>
<Button size="lg">Large</Button>
<Button size="xl">Extra Large</Button>
```

### With Visual Variants

```tsx
<Button variant="primary">Primary Style</Button>
<Button variant="secondary">Secondary Style</Button>
```

### Disabled State

```tsx
<Button disabled>Disabled content</Button>
```

## Common Patterns

### Pattern 1: [Describe Common Use Case]

```tsx
function Pattern1Example() {
  return (
    <div className="space-y-4">
      <Button variant="primary">Primary action</Button>
      <Button variant="secondary">Secondary action</Button>
    </div>
  );
}
```

**When to use**: [Explain when this pattern is appropriate]

### Pattern 2: [Describe Another Common Use Case]

```tsx
function Pattern2Example() {
  const [isDisabled, setIsDisabled] = useState(false);

  return (
    <Button disabled={isDisabled} size="lg">
      Content
    </Button>
  );
}
```

**When to use**: [Explain when this pattern is appropriate]

## Composition Examples

### With Other Components

```tsx
import { Button } from '@/components/base/button';
// Import other components as needed

function CompositionExample() {
  return (
    <div className="flex gap-4">
      <Button variant="primary">First</Button>
      <Button variant="secondary">Second</Button>
    </div>
  );
}
```

### In Forms

```tsx
function FormExample() {
  return (
    <form className="space-y-4">
      <Button size="md">Form content</Button>
    </form>
  );
}
```

### Responsive Design

```tsx
<Button className="w-full sm:w-auto" size="md">
  Responsive content
</Button>
```

## Accessibility Guidelines

### Keyboard Navigation

- **Focus**: Component receives focus with Tab key
- **Activation**: [Describe activation method - click, Enter, Space, etc.]
- **Navigation**: [Describe any special navigation patterns]

### Screen Reader Support

- **Announced as**: [What screen readers announce]
- **States**: Properly announces disabled state via `aria-disabled`
- **Labels**: [Explain labeling strategy if applicable]

### ARIA Attributes

```tsx
<Button aria-label="Descriptive label" aria-disabled={isDisabled}>
  Content
</Button>
```

### Color Contrast

- All variants meet WCAG AA color contrast requirements (4.5:1 for text)
- Focus indicators have 3:1 contrast ratio minimum
- Disabled state maintains sufficient contrast for visibility

### Focus Management

- Visible focus indicator on all interactive states
- Focus trap behavior (if applicable)
- Skip to content support (if applicable)

## AI Usage Guidance

### For AI Code Generation

When generating code using this component:

1. **Always specify size** - Default is `md`, but be explicit for clarity
2. **Choose appropriate variant** - `primary` for main actions, `secondary` for alternative actions
3. **Handle disabled state** - Use `disabled` prop, not custom CSS
4. **Accessibility first** - Always include proper labels and ARIA attributes
5. **Responsive design** - Use Tailwind responsive utilities for mobile-first design

### Type Safety

```tsx
// ✅ Correct - Fully typed
import type { ButtonProps } from '@/components/base/button';

const props: ButtonProps = {
  size: 'md',
  variant: 'primary',
  disabled: false,
};

// ❌ Incorrect - No type safety
const props = {
  size: 'medium', // Wrong value
  variant: 'blue', // Invalid variant
};
```

### Common AI Patterns

```tsx
// Pattern: Generate component with dynamic content
function AIGeneratedExample({ content, actionType }: Props) {
  return (
    <Button variant={actionType === 'primary' ? 'primary' : 'secondary'} size="md">
      {content}
    </Button>
  );
}
```

## Do's and Don'ts

### ✅ Do

- Use semantic HTML where possible
- Follow the established size/variant patterns
- Provide proper accessibility attributes
- Use TypeScript for type safety
- Test with keyboard navigation
- Test with screen readers
- Handle disabled states properly

### ❌ Don't

- Override core component styles (use `className` for extensions only)
- Use component for purposes outside its intended use case
- Ignore accessibility requirements
- Skip keyboard navigation support
- Use inline styles (use Tailwind classes instead)
- Create custom variants outside the design system
- Forget to test edge cases

## Troubleshooting

### Issue: Component doesn't render

**Cause**: Missing required props or incorrect import
**Solution**:

```tsx
// ✅ Correct
import { Button } from '@/components/base/button';

// ❌ Incorrect
import Button from '@/components/base/button';
```

### Issue: Styles not applying

**Cause**: Tailwind CSS classes not loading or conflicting custom CSS
**Solution**: Ensure Tailwind CSS is properly configured and avoid conflicting custom styles

### Issue: TypeScript errors

**Cause**: Incorrect prop types
**Solution**: Import and use the `ButtonProps` type

```tsx
import type { ButtonProps } from '@/components/base/button';
```

### Issue: Accessibility violations

**Cause**: Missing ARIA attributes or improper semantic structure
**Solution**: Follow the accessibility guidelines above and test with axe DevTools

## Related Components

- [List related components from the same category]
- [List components commonly used together]
- [List alternative components for different use cases]

## References

- [UntitledUI Documentation](https://www.untitledui.com/react/components)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [React Aria Documentation](https://react-spectrum.adobe.com/react-aria/)
- [Storybook Stories](./button.stories.tsx)
- [Component Tests](./button.test.tsx)

## Changelog

### 2025-10-24 - Initial Creation

- Created base component structure
- Added all size and variant options
- Implemented accessibility features
- Added comprehensive tests and documentation
