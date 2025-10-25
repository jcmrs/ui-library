# Button Component Analysis

**Source:** UPSTREAM/react/components/base/buttons/
**Date:** 2025-10-25
**Purpose:** Understand Button architecture for Phase 2 implementation

---

## Architecture Overview

### File Structure

```
UPSTREAM/react/components/base/buttons/
├── button.tsx                  ← Main Button component (272 lines)
├── button-utility.tsx          ← Utility button variant
├── close-button.tsx           ← Close button variant
├── social-button.tsx          ← Social media buttons
├── app-store-buttons.tsx      ← App Store/Google Play buttons
├── buttons.demo.tsx           ← Demo implementations
└── buttons.story.tsx          ← Storybook stories
```

**Key Insight:** Button is NOT a single monolithic component. UntitledUI uses:

- **Core component** (`button.tsx`) - Base implementation with color/size variants
- **Specialized variants** (social, app-store, close, utility) - Separate files for functionally distinct buttons
- **Demo file** (`buttons.demo.tsx`) - Shows all combinations and usage patterns
- **Story file** (`buttons.story.tsx`) - Storybook integration

---

## Core Button Architecture

### TypeScript Structure

```typescript
// Three prop interfaces
export interface CommonProps {
  isDisabled?: boolean;
  isLoading?: boolean;
  size?: 'sm' | 'md' | 'lg' | 'xl';
  color?:
    | 'primary'
    | 'secondary'
    | 'tertiary'
    | 'link-gray'
    | 'link-color'
    | 'primary-destructive'
    | 'secondary-destructive'
    | 'tertiary-destructive'
    | 'link-destructive';
  iconLeading?: FC<{ className?: string }> | ReactNode;
  iconTrailing?: FC<{ className?: string }> | ReactNode;
  noTextPadding?: boolean;
  showTextWhileLoading?: boolean;
}

export interface ButtonProps
  extends CommonProps,
    DetailedHTMLProps<
      Omit<ButtonHTMLAttributes<HTMLButtonElement>, 'color' | 'slot'>,
      HTMLButtonElement
    > {
  slot?: AriaButtonProps['slot'];
}

interface LinkProps
  extends CommonProps,
    DetailedHTMLProps<Omit<AnchorHTMLAttributes<HTMLAnchorElement>, 'color'>, HTMLAnchorElement> {}

export type Props = ButtonProps | LinkProps;
```

**Pattern:** Union type allows component to render as `<button>` OR `<a>` based on presence of `href` prop.

### React Aria Integration

```typescript
import { Button as AriaButton, Link as AriaLink } from 'react-aria-components';

const Button = ({ ...props }: Props) => {
    const href = 'href' in otherProps ? otherProps.href : undefined;
    const Component = href ? AriaLink : AriaButton;

    return <Component {...props}>...</Component>;
};
```

**Key Pattern:**

- Uses React Aria components for accessibility foundation
- Conditionally renders AriaButton or AriaLink based on props
- React Aria handles ARIA attributes, keyboard navigation, focus management

### Style System Architecture

```typescript
export const styles = sortCx({
    common: {
        root: [...], // Base styles applied to ALL buttons
        icon: "...", // Icon-specific styles
    },
    sizes: {
        sm: { root: "...", linkRoot: "..." },
        md: { root: "...", linkRoot: "..." },
        lg: { root: "...", linkRoot: "..." },
        xl: { root: "...", linkRoot: "..." },
    },
    colors: {
        primary: { root: "..." },
        secondary: { root: "..." },
        tertiary: { root: "..." },
        'link-gray': { root: "..." },
        'link-color': { root: "..." },
        'primary-destructive': { root: "..." },
        'secondary-destructive': { root: "..." },
        'tertiary-destructive': { root: "..." },
        'link-destructive': { root: "..." },
    },
});
```

**Architecture:**

1. **Exported `styles` object** - Makes styles reusable and inspectable
2. **`sortCx` function** - Utility to optimize Tailwind class order
3. **Nested structure** - `common`, `sizes`, `colors` organized by concern
4. **Link-specific styles** - Separate `linkRoot` for link variants

**Why This Matters:**

- Styles are data, not just strings
- Enables composition in other components
- Facilitates testing and validation
- Clear separation of concerns

### Loading State Implementation

```typescript
{loading && (
    <svg
        fill="none"
        data-icon="loading"
        viewBox="0 0 20 20"
        className={cx(
            styles.common.icon,
            !showTextWhileLoading && "absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2"
        )}
    >
        <circle className="stroke-current opacity-30" cx="10" cy="10" r="8" fill="none" strokeWidth="2" />
        <circle
            className="origin-center animate-spin stroke-current"
            cx="10" cy="10" r="8" fill="none"
            strokeWidth="2"
            strokeDasharray="12.5 50"
            strokeLinecap="round"
        />
    </svg>
)}
```

**Pattern:**

- Inline SVG for loading spinner (no external deps)
- Conditional positioning based on `showTextWhileLoading` prop
- Uses Tailwind animations (`animate-spin`)
- Positioned absolutely when hiding text

### Icon Handling

```typescript
// Leading icon
{isValidElement(IconLeading) && IconLeading}
{isReactComponent(IconLeading) && <IconLeading data-icon="leading" className={styles.common.icon} />}

// Trailing icon
{isValidElement(IconTrailing) && IconTrailing}
{isReactComponent(IconTrailing) && <IconTrailing data-icon="trailing" className={styles.common.icon} />}
```

**Two Icon Patterns:**

1. **React Element** - Icon passed as pre-rendered element
2. **React Component** - Icon passed as component function

Uses utility function `isReactComponent` to distinguish and render appropriately.

### Data Attributes Strategy

```typescript
<Component
    data-loading={loading ? true : undefined}
    data-icon-only={isIcon ? true : undefined}
    className={cx(
        styles.common.root,
        // ... uses data attributes in selectors:
        "data-icon-only:p-2", // Different padding for icon-only buttons
        loading && (showTextWhileLoading
            ? "[&>*:not([data-icon=loading]):not([data-text])]:hidden"
            : "[&>*:not([data-icon=loading])]:invisible"
        ),
    )}
>
```

**Pattern:** Uses `data-*` attributes for:

- State tracking (`data-loading`, `data-disabled`)
- Conditional styling (`data-icon-only`)
- Complex selectors targeting specific children

### Disabled State for Links

```typescript
if (href) {
  props = {
    ...otherProps,
    href: disabled ? undefined : href,

    // Since anchor elements do not support `disabled` attribute,
    // we need to specify `data-rac` and `data-disabled` to enable
    // the `disabled:` selector in Tailwind classes.
    ...(disabled ? { 'data-rac': true, 'data-disabled': true } : {}),
  };
}
```

**Critical Pattern:**

- `<a>` tags don't support `disabled` attribute
- Solution: Remove `href` + add data attributes
- Enables `disabled:` Tailwind selectors to work on links

---

## Color Variants Analysis

### Standard Colors

**primary** - Brand-colored solid button

- Use case: Primary CTAs, main actions
- Styling: Solid background, white text, shadow, hover state
- Example: "Save", "Submit", "Create"

**secondary** - Outlined/bordered button

- Use case: Secondary actions, alternative choices
- Styling: Border ring, transparent/subtle background
- Example: "Cancel", "Go Back"

**tertiary** - Ghost/minimal button

- Use case: Tertiary actions, less emphasis
- Styling: No background, no border, just text color + hover
- Example: "Skip", "Later"

### Link Variants

**link-gray** - Gray underlined link

- Use case: Navigation, secondary links
- Styling: Text-only, underline on hover, gray color

**link-color** - Brand-colored link

- Use case: Primary navigation, branded links
- Styling: Text-only, underline on hover, brand color

### Destructive Colors

**primary-destructive** - Solid red/error button

- Use case: Dangerous primary actions
- Styling: Red solid background, white text
- Example: "Delete Account", "Remove User"

**secondary-destructive** - Outlined red button

- Use case: Dangerous secondary actions
- Styling: Red border, red text
- Example: "Delete Draft"

**tertiary-destructive** - Ghost red button

- Use case: Dangerous tertiary actions
- Styling: Red text, red hover background
- Example: "Discard Changes"

**link-destructive** - Red link

- Use case: Dangerous navigation/links
- Styling: Red text, underline on hover

---

## Size Variants Analysis

### Size System

```typescript
sm: {
    root: "gap-1 rounded-lg px-3 py-2 text-sm font-semibold
           before:rounded-[7px] data-icon-only:p-2",
    linkRoot: "gap-1",
}
md: {
    root: "gap-1 rounded-lg px-3.5 py-2.5 text-sm font-semibold
           before:rounded-[7px] data-icon-only:p-2.5",
    linkRoot: "gap-1",
}
lg: {
    root: "gap-1.5 rounded-lg px-4 py-2.5 text-md font-semibold
           before:rounded-[7px] data-icon-only:p-3",
    linkRoot: "gap-1.5",
}
xl: {
    root: "gap-1.5 rounded-lg px-4.5 py-3 text-md font-semibold
           before:rounded-[7px] data-icon-only:p-3.5",
    linkRoot: "gap-1.5",
}
```

**Pattern:**

- Each size defines: padding, gap, border radius, icon-only padding
- Consistent `font-semibold` across all sizes
- Text size changes (sm vs md)
- Icons automatically sized via `size-5` in common styles

---

## Universal Patterns (Apply to ALL base/ components)

### 1. **React Aria Foundation**

- All interactive base components use React Aria primitives
- Ensures consistent accessibility across component library
- Handles keyboard navigation, ARIA attributes, focus management

### 2. **Exported Styles Object**

- Styles exported as data structure, not just applied
- Enables composition, testing, validation
- `sortCx` utility for Tailwind optimization

### 3. **Data Attribute Strategy**

- Use `data-*` for state tracking
- Enables conditional styling in Tailwind
- Workaround for HTML limitations (e.g., disabled links)

### 4. **TypeScript Strict Mode**

- All props explicitly typed
- Union types for polymorphic components
- Exported interfaces for extensibility

### 5. **Composition Over Configuration**

- Icon props accept components OR elements
- Flexible but type-safe
- Utility functions (`isReactComponent`) for runtime checks

### 6. **Common + Variant Pattern**

- Base styles in `common`
- Variants in structured object (`sizes`, `colors`)
- Combined via `cx()` utility

### 7. **"use client" Directive**

- Required for Next.js App Router compatibility
- Marks client-side interactive components

---

## Button-Specific Patterns (DO NOT generalize)

### 1. **Button vs Link Polymorphism**

- Specific to buttons (clickable actions vs navigation)
- Other components may not need this

### 2. **Loading State with Spinner**

- Button-specific UX pattern
- Other components may have different loading patterns

### 3. **Icon Leading/Trailing**

- Common in buttons, inputs
- Not universal (e.g., cards, avatars don't have this)

### 4. **10 Color Variants**

- Button has many color options
- Other components may have fewer variants (e.g., badges might only have 5)

### 5. **showTextWhileLoading**

- Button-specific loading UX choice
- Other components may handle loading differently

---

## Storybook Documentation Pattern

### Story File Structure

```typescript
export default {
    title: "Base components/Buttons",
    decorators: [
        (Story: FC) => (
            <div className="flex min-h-screen w-full bg-primary p-4">
                <Story />
            </div>
        ),
    ],
};

export const Primary = () => <Buttons.Primary />;
export const Secondary = () => <Buttons.Secondary />;
// ... one export per major variant
```

**Pattern:**

- Separate demo component for each color variant
- Decorator provides consistent background/layout
- Each demo shows: sizes, states (disabled, loading), icon positions, icon-only

### Demo Implementation Pattern

```typescript
export const Primary = () => {
    return (
        <div>
            {/* All sizes: sm, md, lg, xl */}
            <div className="mb-4 flex gap-8">
                <Button size="sm">Button CTA</Button>
                <Button size="md">Button CTA</Button>
                <Button size="lg">Button CTA</Button>
                <Button size="xl">Button CTA</Button>
            </div>

            {/* All sizes disabled */}
            <div className="mb-4 flex gap-8">
                <Button isDisabled size="sm">Button CTA</Button>
                {/* ... */}
            </div>

            {/* All sizes loading */}
            <div className="mb-4 flex gap-8">
                <Button isLoading showTextWhileLoading size="sm">Submitting...</Button>
                {/* ... */}
            </div>

            {/* With icons */}
            {/* Icon-only */}
            {/* etc. */}
        </div>
    );
};
```

**Exhaustive Coverage:**

- Every size × every state × every icon position
- Visual regression testing via Storybook
- Copy-paste ready examples

---

## Implementation Implications for Our Library

### What to Keep from UntitledUI

1. ✅ **React Aria foundation** - Proven accessibility approach
2. ✅ **Exported styles object** - Data-driven styling
3. ✅ **Data attribute strategy** - State tracking and conditional styling
4. ✅ **TypeScript strict mode** - Type safety
5. ✅ **Common + variant pattern** - Organized style architecture
6. ✅ **Exhaustive Storybook demos** - Complete documentation
7. ✅ **"use client" directive** - Next.js compatibility

### What to Enhance for AI Consumption

1. **Inline JSDoc comments** - Explain WHY, not just WHAT
2. **AI usage guidance** - When to use each variant
3. **Usage patterns document** - Copy-paste ready examples
4. **Validation checklist** - Machine-readable quality gates
5. **Explicit pattern documentation** - Universal vs component-specific

### What NOT to Assume Applies Elsewhere

1. ❌ Button/Link polymorphism → Only for navigation-capable components
2. ❌ Loading spinner pattern → Other components may differ
3. ❌ Icon leading/trailing → Not all components need icons
4. ❌ 10 color variants → Other components may have fewer
5. ❌ Size system (sm/md/lg/xl) → Some components may not need all sizes

---

## Phase 2 Implementation Strategy

### Step 1: TDD Approach

**Write tests FIRST for:**

- [ ] Button renders with text content
- [ ] All color variants apply correct classes
- [ ] All size variants render correctly
- [ ] Disabled state works (button + link)
- [ ] Loading state shows spinner
- [ ] Icons render (leading/trailing/both/icon-only)
- [ ] Accessibility (ARIA attributes, keyboard nav)
- [ ] Polymorphism (button vs link based on href)

### Step 2: Core Implementation

**Implement to pass tests:**

- [ ] TypeScript interfaces (CommonProps, ButtonProps, LinkProps, Props)
- [ ] Styles object (common, sizes, colors)
- [ ] React Aria integration (AriaButton, AriaLink)
- [ ] Icon handling (isValidElement, isReactComponent checks)
- [ ] Loading state (SVG spinner, conditional positioning)
- [ ] Data attributes (loading, icon-only, disabled)

### Step 3: AI-Friendly Documentation

**Add inline documentation:**

- [ ] JSDoc for every prop explaining WHY
- [ ] AI usage guidance in comments
- [ ] Examples in JSDoc
- [ ] Pattern explanations

### Step 4: Storybook Stories

**Create exhaustive stories:**

- [ ] One story per color variant
- [ ] Each story shows: all sizes, all states, all icon positions
- [ ] Interactive controls for testing
- [ ] Accessibility addon enabled

### Step 5: Usage Patterns

**Create patterns.md:**

- [ ] When to use each color variant
- [ ] Icon usage patterns
- [ ] Loading state patterns
- [ ] Link vs button decision guide
- [ ] Common mistakes to avoid

### Step 6: Validation

**Create checklist.json:**

- [ ] All variants implemented
- [ ] All tests passing
- [ ] Accessibility verified
- [ ] Storybook complete
- [ ] Documentation complete

---

## Critical Lessons for Phase 2

### 1. Button is a REFERENCE, not a TEMPLATE

From ADR-002 (revised):

> "Button patterns apply ONLY to base/ primitives. Application components require studying application architecture. Marketing components have completely different patterns."

### 2. Study BEFORE Implementing

Don't copy-paste Button patterns to other components without analysis:

- Study the target component in UPSTREAM first
- Identify which patterns are universal vs category-specific
- Document differences before coding

### 3. Test-Driven Development

Following TDD-METHODOLOGY.md:

- RED: Write failing tests defining behavior
- GREEN: Implement minimum code to pass
- REFACTOR: Improve code quality
- DOCUMENT: Add AI-friendly docs
- VALIDATE: Test with Claude Code (simulated)

### 4. Documentation is CRITICAL

Button will serve as reference. Documentation quality determines whether future work succeeds:

- Inline comments explain WHY
- JSDoc provides AI usage guidance
- patterns.md shows copy-paste examples
- checklist.json enables validation

---

## Next Steps

1. ✅ Study complete - Button architecture understood
2. ⏳ Document universal vs Button-specific patterns
3. ⏳ Write TDD tests for Button
4. ⏳ Implement Button component
5. ⏳ Create Storybook stories
6. ⏳ Write usage patterns
7. ⏳ Achieve 90%+ test coverage
8. ⏳ Validate Phase 2 completion

---

**Status:** Button study complete. Ready to document patterns and begin TDD implementation.
