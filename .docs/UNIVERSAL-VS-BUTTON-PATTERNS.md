# Universal vs Button-Specific Patterns

**Date:** 2025-10-25
**Purpose:** Clarify which patterns from Button apply to ALL base/ components vs Button-only

---

## ✅ UNIVERSAL PATTERNS (Apply to ALL base/ components)

### 1. React Aria Foundation

**Pattern:**

```typescript
import { Button as AriaButton } from 'react-aria-components';

export const Button = (props) => {
    return <AriaButton {...props}>...</AriaButton>;
};
```

**Applies to:**

- ✅ All interactive base/ components (Input, Checkbox, Toggle, Select, etc.)
- ✅ Ensures consistent accessibility across library
- ✅ Handles ARIA attributes, keyboard navigation, focus management automatically

**When building other components:**

- Use appropriate React Aria primitive (e.g., `TextField`, `Checkbox`, `Select`)
- Follow React Aria patterns for that component type
- Don't reinvent accessibility - leverage React Aria

---

### 2. Exported Styles Object

**Pattern:**

```typescript
export const styles = sortCx({
    common: {
        root: [...],
        // shared base styles
    },
    sizes: {
        sm: { ... },
        md: { ... },
    },
    colors: {
        primary: { ... },
        secondary: { ... },
    },
});
```

**Why Universal:**

- Makes styles inspectable and reusable
- Enables composition in other components
- Facilitates testing and validation
- Clear separation of concerns

**Applies to:**

- ✅ All components with variants
- ✅ Components need composability
- ✅ Components with multiple visual states

**Implementation:**

- Export `styles` object from component file
- Use `sortCx` utility for Tailwind class optimization
- Structure: `common` + variant categories

---

### 3. TypeScript Strict Mode

**Pattern:**

```typescript
export interface ComponentProps extends DetailedHTMLProps<...> {
    /** Documented prop */
    size?: 'sm' | 'md' | 'lg';
    /** Another documented prop */
    variant?: 'primary' | 'secondary';
}
```

**Why Universal:**

- Type safety prevents errors
- Exported interfaces enable extensibility
- JSDoc provides inline documentation

**Applies to:**

- ✅ ALL components in library (100% requirement)
- ✅ Every prop must be typed
- ✅ Every prop must have JSDoc comment

**Requirements:**

- Extend appropriate HTML attributes type
- Export all interfaces
- Document every prop with JSDoc
- Use strict TypeScript config

---

### 4. Data Attribute Strategy

**Pattern:**

```typescript
<Component
    data-loading={loading ? true : undefined}
    data-state={state}
    className={cx(
        "base-classes",
        "data-loading:opacity-50",
        "data-state-active:bg-active",
    )}
>
```

**Why Universal:**

- Enables conditional styling in Tailwind
- Tracks component state
- Workaround for HTML limitations
- Facilitates testing

**Applies to:**

- ✅ Components with states (loading, disabled, active, etc.)
- ✅ Components needing conditional styling
- ✅ Components with boolean variations

**Usage:**

- `data-loading` for loading states
- `data-disabled` for disabled states (especially on non-button elements)
- `data-state` for multi-state components
- `data-variant` for variant tracking

---

### 5. Common + Variant Pattern

**Pattern:**

```typescript
className={cx(
    styles.common.root,          // Base styles for ALL variants
    styles.sizes[size].root,     // Size-specific styles
    styles.colors[color].root,   // Color-specific styles
    className,                   // User overrides
)}
```

**Why Universal:**

- Clear separation between shared and variant-specific styles
- Predictable composition order
- User customization support

**Applies to:**

- ✅ All components with variants
- ✅ Ensures consistent styling approach

**Order:**

1. Common base styles
2. Variant styles (size, color, etc.)
3. Conditional/state styles
4. User className (overrides)

---

### 6. "use client" Directive

**Pattern:**

```typescript
'use client';

import React from 'react';
// ... component code
```

**Why Universal:**

- Required for Next.js App Router compatibility
- Marks client-side interactive components
- Prevents server-side rendering issues

**Applies to:**

- ✅ ALL interactive components (buttons, inputs, modals, etc.)
- ✅ Components using hooks, events, browser APIs
- ✅ Components with state

**Don't use for:**

- ❌ Pure presentation components (if truly static)
- ❌ Server-only utilities

---

### 7. cx() Utility for Class Merging

**Pattern:**

```typescript
import { cx } from '@/utils/cx';

className={cx(
    'base-classes',
    condition && 'conditional-classes',
    variant === 'primary' && 'variant-classes',
    className,
)}
```

**Why Universal:**

- Merges Tailwind classes correctly
- Handles conditionals cleanly
- Deduplicates conflicting classes

**Applies to:**

- ✅ ALL components with Tailwind styling
- ✅ Required for conditional class application

---

### 8. Comprehensive JSDoc

**Pattern:**

```typescript
/**
 * Button component for user interactions
 *
 * ## AI Usage Guidelines
 *
 * **When to use:**
 * - Form submissions
 * - Primary CTAs
 *
 * **DO:**
 * - Use descriptive text
 *
 * **DO NOT:**
 * - Nest buttons
 *
 * @example
 * <Button variant="primary">Save</Button>
 */
export interface ButtonProps {
  /** Visual variant - primary for main actions, secondary for alternatives */
  variant?: 'primary' | 'secondary';
}
```

**Why Universal:**

- Enables AI understanding
- Provides usage guidance
- Documents intent, not just API

**Applies to:**

- ✅ ALL components (100% requirement)
- ✅ Every component needs AI usage guidelines
- ✅ Every prop needs JSDoc

**Structure:**

- Component-level JSDoc with usage guidelines
- Prop-level JSDoc with explanation
- Examples showing common patterns

---

## ❌ BUTTON-SPECIFIC PATTERNS (Do NOT generalize)

### 1. Button vs Link Polymorphism

**Pattern:**

```typescript
export type Props = ButtonProps | LinkProps;

const Button = (props: Props) => {
    const href = 'href' in otherProps ? otherProps.href : undefined;
    const Component = href ? AriaLink : AriaButton;

    return <Component {...conditionalProps} />;
};
```

**Why Button-Specific:**

- Buttons can be navigation links OR actions
- This polymorphism is unique to clickable elements
- Other components don't need this dual-nature

**DON'T apply to:**

- ❌ Inputs (always input elements)
- ❌ Checkboxes (always input[type=checkbox])
- ❌ Avatars (always img/div)
- ❌ Cards (always div/article)
- ❌ Badges (always span)

**MIGHT apply to:**

- ✅ Icon buttons (may also be links)
- ✅ Close buttons (may trigger nav or action)
- ⚠️ Use sparingly - most components are single-element

---

### 2. Loading State with Inline Spinner

**Pattern:**

```typescript
{loading && (
    <svg className="animate-spin" {...}>
        <circle ... /> {/* Background */}
        <circle ... /> {/* Spinning indicator */}
    </svg>
)}
```

**Why Button-Specific:**

- Buttons are action triggers → loading during async operations
- Inline SVG spinner is Button UX pattern
- Other components may handle loading differently

**DON'T assume for:**

- ❌ Inputs → May use skeleton or disabled state
- ❌ Modals → May use overlay spinner or page-level loading
- ❌ Cards → May use skeleton content
- ❌ Tables → May use row-level skeletons

**Pattern alternatives:**

- Inputs: `isLoading` prop → disabled state + subtle indicator
- Modals: Overlay spinner or content skeleton
- Cards: Skeleton card layout
- Tables: Loading rows or shimmer effect

---

### 3. Icon Leading/Trailing Props

**Pattern:**

```typescript
interface ButtonProps {
  iconLeading?: FC<{ className?: string }> | ReactNode;
  iconTrailing?: FC<{ className?: string }> | ReactNode;
}
```

**Why Button-Specific:**

- Common pattern for buttons and inputs
- NOT universal across all components

**DOES apply to:**

- ✅ Buttons (navigation, actions)
- ✅ Inputs (prefix/suffix icons)
- ✅ Text fields
- ✅ Select menus
- ✅ Search boxes

**DOESN'T apply to:**

- ❌ Avatars (image-based)
- ❌ Badges (text-only or single icon)
- ❌ Cards (complex composition, not linear)
- ❌ Modals (header/footer composition, not leading/trailing)
- ❌ Progress indicators (different visual model)

**When to use:**

- Component has linear left-to-right flow
- Icon decorates or clarifies text content
- User expects icon positioning choice

---

### 4. Ten (10) Color Variants

**Pattern:**

```typescript
color?: 'primary' | 'secondary' | 'tertiary' |
        'link-gray' | 'link-color' |
        'primary-destructive' | 'secondary-destructive' |
        'tertiary-destructive' | 'link-destructive';
```

**Why Button-Specific:**

- Buttons have complex hierarchy: primary/secondary/tertiary + link variants + destructive
- Most components have simpler variant systems

**Typical variant counts:**

- Buttons: 9-10 variants (complex hierarchy)
- Badges: 5-7 variants (status indicators)
- Alerts: 4-5 variants (severity levels)
- Avatars: 2-3 variants (size, presence)

**Don't assume:**

- ❌ Every component needs 10 color options
- ❌ Other components need destructive variants
- ❌ Other components need link variants

**Study component's purpose:**

- What visual hierarchy does it need?
- What states/statuses does it represent?
- What's the minimum set of meaningful variants?

---

### 5. showTextWhileLoading Prop

**Pattern:**

```typescript
interface ButtonProps {
  showTextWhileLoading?: boolean;
}

// Usage:
loading &&
  (showTextWhileLoading
    ? '[&>*:not([data-icon=loading]):not([data-text])]:hidden'
    : '[&>*:not([data-icon=loading])]:invisible');
```

**Why Button-Specific:**

- Button-specific loading UX decision
- Controls whether text remains visible during loading
- Other components may handle loading differently

**Alternative approaches:**

- Inputs: Always hide input during loading, show spinner
- Modals: Block entire modal with overlay
- Cards: Show skeleton over entire card
- Forms: Disable all fields, show banner

**Don't generalize:**

- Each component type has own loading UX pattern
- Study component's loading behavior before implementing
- Consider user expectations for that component type

---

### 6. Four (4) Size Variants

**Pattern:**

```typescript
size?: 'sm' | 'md' | 'lg' | 'xl';
```

**Why Button-Specific:**

- Buttons need 4 sizes for various contexts
- Other components may need more, fewer, or different sizes

**Actual size needs:**

- Buttons: 4 sizes (sm, md, lg, xl)
- Inputs: 3-4 sizes (sm, md, lg, possibly xl)
- Avatars: 5-8 sizes (xs, sm, md, lg, xl, 2xl, etc.)
- Badges: 2-3 sizes (sm, md, lg)
- Modals: 3-4 sizes (sm, md, lg, xl, full)

**Guideline:**

- Study component's usage contexts
- Define sizes based on actual UI patterns
- Don't copy Button's 4 sizes blindly

---

### 7. Icon-Only Variant

**Pattern:**

```typescript
const isIcon = (IconLeading || IconTrailing) && !children;

<Component
    data-icon-only={isIcon ? true : undefined}
    className={cx(
        // ...
        "data-icon-only:p-2",  // Different padding for icon-only
    )}
>
```

**Why Button-Specific:**

- Buttons commonly used as icon-only (close, menu, etc.)
- Requires special padding/sizing logic
- Not all components have icon-only variant

**DOES apply to:**

- ✅ Buttons (close, menu, icon actions)
- ✅ Icon buttons (entire component is icon-only)
- ✅ Utility buttons

**DOESN'T apply to:**

- ❌ Inputs (need visible input field)
- ❌ Checkboxes (need clickable box)
- ❌ Cards (complex composition)
- ❌ Modals (need content)

**When to support:**

- Component commonly used without text
- Icon-only version has clear semantic meaning
- Accessibility can be maintained (via aria-label)

---

### 8. Link Variants (link-gray, link-color, link-destructive)

**Pattern:**

```typescript
'link-gray': {
    root: [
        "justify-normal rounded p-0! text-tertiary",
        "*:data-text:underline",
        "*:data-text:decoration-transparent",
        "hover:*:data-text:decoration-current",
    ].join(" "),
}
```

**Why Button-Specific:**

- Buttons can render as links (navigation vs action)
- Link styling is specific to Button's polymorphic nature
- Most components don't have "link" variants

**DOESN'T apply to:**

- ❌ Inputs (never render as links)
- ❌ Checkboxes (never render as links)
- ❌ Modals (not link-like)
- ❌ Avatars (not link-like, though may be wrapped in link)

**Exception:**

- Components that genuinely serve dual purpose (rare)
- Study component's nature before adding link variant

---

## 🔍 HOW TO DETERMINE: Universal vs Specific

### Decision Framework

**For each pattern in Button, ask:**

1. **Is this required for accessibility?**

   - YES → Universal (React Aria integration, ARIA attributes, keyboard nav)
   - NO → May be specific

2. **Is this a TypeScript/code quality requirement?**

   - YES → Universal (strict types, exported interfaces, JSDoc)
   - NO → May be specific

3. **Is this needed for Tailwind/styling?**

   - YES → Universal (cx utility, data attributes, sortCx)
   - NO → May be specific

4. **Is this specific to Button's purpose (clickable action)?**

   - YES → Button-specific (loading spinner, link polymorphism)
   - NO → May be universal

5. **Do ALL base/ components need this?**
   - YES → Universal
   - NO → Study each component individually

### Examples

**Pattern: React Aria integration**

1. Required for accessibility? ✅ YES
2. Quality requirement? ✅ YES
3. Needed for styling? ❌ NO
4. Button-specific? ❌ NO
5. All components need? ✅ YES
   → **UNIVERSAL**

**Pattern: Loading spinner**

1. Required for accessibility? ❌ NO
2. Quality requirement? ❌ NO
3. Needed for styling? ❌ NO
4. Button-specific? ✅ YES (async action indicator)
5. All components need? ❌ NO
   → **BUTTON-SPECIFIC**

**Pattern: Icon leading/trailing**

1. Required for accessibility? ❌ NO
2. Quality requirement? ❌ NO
3. Needed for styling? ❌ NO
4. Button-specific? ⚠️ PARTIAL (applies to some, not all)
5. All components need? ❌ NO
   → **BUTTON-SPECIFIC** (applies to linear text-based components only)

---

## 📋 Checklist for Other Components

When implementing a new base/ component:

### ✅ MUST Include (Universal Patterns)

- [ ] React Aria primitive integration
- [ ] Exported `styles` object with `sortCx`
- [ ] TypeScript strict mode types
- [ ] Exported interfaces
- [ ] JSDoc on all props
- [ ] Data attribute strategy for states
- [ ] Common + variant pattern
- [ ] "use client" directive
- [ ] cx() utility for class merging
- [ ] AI usage guidelines in JSDoc

### 🔍 EVALUATE (May or May Not Apply)

- [ ] Does component need polymorphism (like button/link)?
- [ ] Does component have loading states?
- [ ] Does component use icons?
- [ ] How many color variants does component need?
- [ ] How many size variants does component need?
- [ ] Does component need icon-only variant?
- [ ] What states/variants are component-specific?

### ⚠️ STUDY FIRST (Don't Assume from Button)

- [ ] Read UPSTREAM implementation for this component
- [ ] Identify component-specific patterns
- [ ] Document which Button patterns apply vs don't
- [ ] Create component-specific pattern list
- [ ] Review with user before implementing

---

## 🎯 Key Takeaways

1. **Not everything in Button is universal** - Many patterns are Button-specific

2. **Study each component individually** - Read UPSTREAM implementation first

3. **Universal patterns focus on:**

   - Accessibility (React Aria)
   - Code quality (TypeScript, JSDoc)
   - Styling consistency (cx, data attributes, sortCx)
   - AI consumption (documentation)

4. **Button-specific patterns are:**

   - Loading spinner implementation
   - Button/link polymorphism
   - 10 color variants
   - Link-specific variants
   - Icon-only handling
   - showTextWhileLoading

5. **When in doubt:**
   - Study the component in UPSTREAM/react
   - Document your analysis
   - Ask: "Does EVERY base/ component need this?"
   - Default to NO unless clear YES

---

**Status:** Pattern analysis complete. Ready to begin TDD implementation with clear understanding of what's universal vs Button-specific.
