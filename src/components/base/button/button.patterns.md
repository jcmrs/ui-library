# Button Usage Patterns

**Component Type**: Base Component (Primitive UI Element)
**Category**: base
**Created**: 2025-10-24
**WCAG Compliance**: AA

## Overview

Production-ready button component with React Aria accessibility, 9 color variants, 4 sizes, loading states, icon support, and polymorphic rendering (button/link). Designed for framework-agnostic use in any React environment.

## Basic Usage

### Simple Example

```tsx
import { Button } from '@/components/base/button';

function Example() {
  return <Button>Click me</Button>;
}
```

### With Color Variants

```tsx
<Button color="primary">Primary Action</Button>
<Button color="secondary">Secondary Action</Button>
<Button color="tertiary">Tertiary Action</Button>
<Button color="link-gray">Link Gray</Button>
<Button color="link-color">Link Color</Button>
<Button color="primary-destructive">Delete</Button>
<Button color="secondary-destructive">Remove</Button>
<Button color="tertiary-destructive">Cancel</Button>
<Button color="link-destructive">Delete Link</Button>
```

### With Size Variants

```tsx
<Button size="sm">Small</Button>
<Button size="md">Medium (default)</Button>
<Button size="lg">Large</Button>
<Button size="xl">Extra Large</Button>
```

### Disabled State

```tsx
<Button isDisabled>Disabled Button</Button>
```

### Loading State

```tsx
<Button isLoading>Processing...</Button>
<Button isLoading showTextWhileLoading>Saving...</Button>
```

## Common Patterns

### Pattern 1: Form Actions

```tsx
function FormActions() {
  const [isLoading, setIsLoading] = useState(false);

  return (
    <div className="flex gap-3">
      <Button
        color="primary"
        size="md"
        isLoading={isLoading}
        onPress={async () => {
          setIsLoading(true);
          await saveForm();
          setIsLoading(false);
        }}
      >
        Save Changes
      </Button>
      <Button color="secondary" size="md">
        Cancel
      </Button>
    </div>
  );
}
```

**When to use**: Form submissions, data mutations, modal actions

### Pattern 2: Icon Buttons

```tsx
function IconButtons() {
  return (
    <div className="flex gap-3">
      <Button color="primary" iconLeading={<PlusIcon />}>
        Add Item
      </Button>
      <Button color="secondary" iconTrailing={<ArrowRightIcon />}>
        Continue
      </Button>
      <Button color="tertiary" iconLeading={<TrashIcon />} />
    </div>
  );
}
```

**When to use**: Actions with visual context, icon-only buttons for toolbars

### Pattern 3: Link-Style Buttons

```tsx
function NavigationLinks() {
  return (
    <nav className="flex gap-4">
      <Button href="/dashboard" color="link-color">
        Dashboard
      </Button>
      <Button href="/settings" color="link-gray">
        Settings
      </Button>
    </nav>
  );
}
```

**When to use**: Navigation within app, external links, in-text actions

### Pattern 4: Destructive Actions

```tsx
function DeleteConfirmation() {
  return (
    <div className="flex gap-3">
      <Button color="primary-destructive">Delete Account</Button>
      <Button color="secondary">Cancel</Button>
    </div>
  );
}
```

**When to use**: Delete operations, destructive mutations, irreversible actions

## Composition Examples

### With Icon Library

```tsx
import { Button } from '@/components/base/button';
import { PlusIcon, TrashIcon } from '@/components/icons';

function ToolbarExample() {
  return (
    <div className="flex gap-2">
      <Button color="primary" size="sm" iconLeading={<PlusIcon />}>
        New
      </Button>
      <Button color="tertiary-destructive" size="sm" iconLeading={<TrashIcon />}>
        Delete
      </Button>
    </div>
  );
}
```

### In Forms

```tsx
function LoginForm() {
  return (
    <form className="space-y-4">
      <input type="email" placeholder="Email" />
      <input type="password" placeholder="Password" />
      <Button type="submit" color="primary" size="lg" className="w-full">
        Sign In
      </Button>
      <Button href="/forgot-password" color="link-color" size="sm" className="w-full">
        Forgot password?
      </Button>
    </form>
  );
}
```

### Responsive Design

```tsx
<Button color="primary" size="md" className="w-full sm:w-auto">
  Responsive Button
</Button>
```

## Accessibility Guidelines

### Keyboard Navigation

- **Focus**: Receives focus with Tab key
- **Activation**: Space or Enter key
- **Link Navigation**: Enter key for href buttons

### Screen Reader Support

- **Announced as**: "Button" or "Link" based on element type
- **States**: Announces disabled state via aria-disabled
- **Loading**: Announces loading state via aria-busy
- **Icons**: Icon-only buttons require aria-label

### ARIA Attributes

```tsx
{
  /* Icon-only button requires label */
}
<Button color="primary" iconLeading={<PlusIcon />} aria-label="Add item" />;

{
  /* Loading state */
}
<Button isLoading aria-busy="true">
  Processing
</Button>;

{
  /* Disabled state */
}
<Button isDisabled aria-disabled="true">
  Disabled
</Button>;
```

### Color Contrast

- All variants meet WCAG AA color contrast (4.5:1 minimum)
- Focus ring has 3:1 contrast ratio
- Disabled state maintains visibility (3:1 contrast)

### Focus Management

- Visible focus ring on all variants
- Focus ring respects prefers-reduced-motion
- React Aria handles focus behavior automatically

## AI Usage Guidance

### For AI Code Generation

When generating code using Button:

1. **Always specify color explicitly** - Don't rely on default
2. **Use size for hierarchy** - xl for primary CTAs, sm for secondary actions
3. **Handle loading states** - Use isLoading prop, not custom logic
4. **Polymorphism via href** - Use href prop for links, not onClick navigation
5. **Icon-only needs aria-label** - Always provide accessible label

### Type Safety

```tsx
// ✅ Correct - Fully typed
import type { Props } from '@/components/base/button';

const buttonProps: Props = {
  color: 'primary',
  size: 'md',
  isDisabled: false,
  children: 'Click me',
};

// ❌ Incorrect - Invalid values
const badProps = {
  color: 'blue', // Invalid
  size: 'medium', // Invalid
};
```

### Common AI Patterns

```tsx
// Pattern: Dynamic action buttons
function DynamicButton({ action }: { action: 'save' | 'delete' | 'cancel' }) {
  const config = {
    save: { color: 'primary' as const, text: 'Save' },
    delete: { color: 'primary-destructive' as const, text: 'Delete' },
    cancel: { color: 'secondary' as const, text: 'Cancel' },
  };

  const { color, text } = config[action];
  return <Button color={color}>{text}</Button>;
}
```

## Do's and Don'ts

### ✅ Do

- Use href prop for navigation (creates semantic link)
- Provide aria-label for icon-only buttons
- Use isLoading for async operations
- Use appropriate color for action context
- Leverage polymorphism (button vs link)
- Test keyboard navigation
- Handle disabled states with isDisabled prop

### ❌ Don't

- Use onClick for navigation (use href instead)
- Override core styles with !important
- Create custom loading indicators
- Use button for navigation without href
- Forget aria-label on icon-only buttons
- Use inline styles (use className with Tailwind)
- Create custom color variants outside design system

## Troubleshooting

### Issue: Button doesn't render as link

**Cause**: Missing href prop
**Solution**:

```tsx
// ✅ Renders as <a> tag
<Button href="/dashboard">Dashboard</Button>

// ❌ Renders as <button>
<Button onClick={() => navigate('/dashboard')}>Dashboard</Button>
```

### Issue: Icon-only button fails accessibility

**Cause**: Missing aria-label
**Solution**:

```tsx
// ✅ Correct
<Button iconLeading={<PlusIcon />} aria-label="Add item" />

// ❌ Fails accessibility
<Button iconLeading={<PlusIcon />} />
```

### Issue: Loading state doesn't show

**Cause**: isLoading prop not set correctly
**Solution**:

```tsx
// ✅ Correct
const [loading, setLoading] = useState(false);
<Button isLoading={loading}>Save</Button>

// ❌ Wrong prop name
<Button loading={loading}>Save</Button>
```

### Issue: TypeScript errors on color/size

**Cause**: Invalid prop values
**Solution**: Use exported types

```tsx
import type { Props } from '@/components/base/button';
// Valid colors: primary, secondary, tertiary, link-gray, link-color,
//               primary-destructive, secondary-destructive,
//               tertiary-destructive, link-destructive
// Valid sizes: sm, md, lg, xl
```

## Related Components

- ButtonGroup (for related action sets)
- IconButton (simplified icon-only variant)
- Link (for pure text links without button styling)

## References

- [UntitledUI Button Documentation](https://www.untitledui.com/react/components/buttons)
- [React Aria Button](https://react-spectrum.adobe.com/react-aria/useButton.html)
- [WCAG 2.1 Button Guidelines](https://www.w3.org/WAI/WCAG21/quickref/?tags=buttons)
- [Storybook Stories](./button.stories.tsx)
- [Component Tests](./button.test.tsx)

## Changelog

### 2025-10-24 - Initial Implementation

- Implemented 9 color variants
- Added 4 size variants
- Polymorphic button/link rendering via href prop
- Loading states with optional text visibility
- Icon support (leading, trailing, icon-only)
- React Aria accessibility integration
- 82 test cases with 100% coverage
- Complete Storybook documentation
