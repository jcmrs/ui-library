# Phase 2: Button Component - Complete Requirements

**Date:** 2025-01-24
**Status:** Requirements Complete - Ready for User Approval
**Source:** Complete study of UPSTREAM/react/ UntitledUI reference implementation

---

## Executive Summary

This document contains the **complete, validated requirements** for the Button component based on thorough analysis of the UntitledUI reference implementation. This is NOT an assumption-based plan - every requirement is derived from actual UntitledUI code.

**References Studied:**

- ✅ `UPSTREAM/react/components/base/buttons/button.tsx` (272 lines)
- ✅ `UPSTREAM/react/components/base/buttons/buttons.demo.tsx` (1023 lines)
- ✅ `UPSTREAM/react/components/base/buttons/buttons.story.tsx` (43 lines)
- ✅ `UPSTREAM/react/components/base/buttons/button-utility.tsx` (117 lines)
- ✅ `UPSTREAM/react/components/base/buttons/close-button.tsx` (43 lines)
- ✅ `UPSTREAM/react/styles/theme.css` (1334 lines - design token system)
- ✅ `UPSTREAM/react/utils/cx.ts` (cx utility)
- ✅ `UPSTREAM/react/utils/is-react-component.ts` (type guards)

---

## 1. Foundation Requirements

### 1.1 React Aria Integration (CRITICAL - FOUNDATIONAL)

**Why:** Provides WCAG 2.1 AA accessibility automatically for ALL components in the library.

**Implementation:**

```typescript
import { Button as AriaButton, Link as AriaLink } from 'react-aria-components';
```

**Requirements:**

- ALL button components must use React Aria primitives
- `AriaButton` for `<button>` elements
- `AriaLink` for `<a>` elements (when href provided)
- React Aria handles:
  - Keyboard navigation automatically
  - Focus management
  - ARIA attributes
  - Disabled state behavior
  - `isPending` state for loading

**Reference:** `button.tsx:4-7`, `button-utility.tsx:7`, `close-button.tsx:4`

---

### 1.2 Design Token System (CRITICAL - FOUNDATIONAL)

**Why:** Enables theming, dark mode, and consistent styling across entire library.

**Token Categories:**

1. **Background Tokens:**

   - `bg-brand-solid` - Primary button background
   - `bg-brand-solid_hover` - Primary button hover state
   - `bg-primary` - Secondary button background
   - `bg-primary_hover` - Secondary button hover
   - `text-white` - White text color

2. **Foreground/Text Tokens:**

   - `text-fg-quaternary` - Tertiary text color
   - `text-fg-quaternary_hover` - Tertiary hover
   - `text-fg-disabled_subtle` - Disabled text

3. **Border/Ring Tokens:**

   - `ring-primary` - Border ring color
   - `ring-primary_hover` - Border hover
   - `ring-transparent` - Transparent ring
   - `ring-inset` - Inset ring style

4. **Shadow Tokens:**

   - `shadow-xs-skeumorphic` - Skeumorphic shadow (primary buttons)
   - `shadow-xs` - Standard extra small shadow

5. **Focus Tokens:**
   - `outline-focus-ring` - Focus outline color
   - Focus outlines: `focus-visible:outline-2 focus-visible:outline-offset-2`

**Implementation:**

```typescript
// ❌ NEVER hardcode colors
className = 'bg-blue-600 text-white hover:bg-blue-700';

// ✅ ALWAYS use design tokens
className = 'bg-brand-solid text-white hover:bg-brand-solid_hover';
```

**Reference:** `button.tsx:19-140`, `theme.css:1-1334`

---

### 1.3 Polymorphic Component Pattern (CRITICAL - ARCHITECTURAL)

**Why:** Semantic HTML - buttons perform actions, links navigate. Screen readers and SEO depend on this.

**Implementation:**

```typescript
const href = 'href' in otherProps ? otherProps.href : undefined;
const Component = href ? AriaLink : AriaButton;

// Renders <button> OR <a> based on presence of href prop
```

**Behavior:**

- If `href` provided → renders as `<a>` using `AriaLink`
- If NO `href` → renders as `<button>` using `AriaButton`
- Type system enforces correct props for each variant

**Disabled Handling for Links:**

```typescript
// Links don't support disabled attribute
// Use data attributes for styling
{
  ...otherProps,
  href: isDisabled ? undefined : href,
  ...(isDisabled ? { "data-rac": true, "data-disabled": true } : {})
}
```

**Reference:** `button.tsx:176-186`, `button-utility.tsx:62-85`

---

## 2. Component API Requirements

### 2.1 Color Variants (9 Required)

**Variant 1: `primary` (default)**

```typescript
color: 'primary';
// Visual: Solid brand color button with white text
// Usage: Main action on page (limit 1-2 per view)
// Style: bg-brand-solid, text-white, shadow-xs-skeumorphic
```

**Variant 2: `secondary`**

```typescript
color: 'secondary';
// Visual: White/gray background with border ring
// Usage: Alternative actions
// Style: bg-primary, ring-1 ring-primary ring-inset, shadow-xs-skeumorphic
```

**Variant 3: `tertiary`**

```typescript
color: 'tertiary';
// Visual: No background, only text with hover background
// Usage: Subtle actions
// Style: text-fg-quaternary, hover:bg-primary_hover
```

**Variant 4: `link-gray`**

```typescript
color: 'link-gray';
// Visual: Text-only link styled like tertiary but as semantic link
// Usage: Navigation links styled like buttons
// Style: Same as tertiary, uses AriaLink when href provided
```

**Variant 5: `link-color`**

```typescript
color: 'link-color';
// Visual: Brand-colored text link
// Usage: Branded navigation links
// Style: text-fg-brand-primary, hover:text-fg-brand-primary_hover
```

**Variant 6: `primary-destructive`**

```typescript
color: 'primary-destructive';
// Visual: Red solid button
// Usage: Primary destructive action (Delete, Remove main item)
// Style: bg-error-solid, text-white, shadow-xs-skeumorphic
```

**Variant 7: `secondary-destructive`**

```typescript
color: 'secondary-destructive';
// Visual: White/gray with red border
// Usage: Secondary destructive action
// Style: bg-primary, ring-error, text-fg-error-primary
```

**Variant 8: `tertiary-destructive`**

```typescript
color: 'tertiary-destructive';
// Visual: Red text only
// Usage: Subtle destructive action
// Style: text-fg-error-primary, hover:bg-error-primary
```

**Variant 9: `link-destructive`**

```typescript
color: 'link-destructive';
// Visual: Red text link
// Usage: Navigation to destructive action
// Style: text-fg-error-primary, uses AriaLink when href
```

**Reference:** `button.tsx:19-140`, `buttons.demo.tsx:12-893`, `buttons.story.tsx:15-37`

---

### 2.2 Size Variants (4 Required)

**Size: `sm` (Small)**

```typescript
size: 'sm';
// Padding: gap-1.5 px-3.5 py-2.5
// Text: text-sm (14px)
// Icon: size-5 (20px)
// Usage: Compact UIs, secondary actions
```

**Size: `md` (Medium - Default)**

```typescript
size: 'md';
// Padding: gap-2 px-4 py-2.5
// Text: text-sm (14px)
// Icon: size-5 (20px)
// Usage: Standard button size
```

**Size: `lg` (Large)**

```typescript
size: 'lg';
// Padding: gap-2 px-[1.125rem] py-2.5
// Text: text-base (16px)
// Icon: size-5 (20px)
// Usage: Prominent actions
```

**Size: `xl` (Extra Large)**

```typescript
size: 'xl';
// Padding: gap-2.5 px-[1.375rem] py-3
// Text: text-base (16px)
// Icon: size-6 (24px)
// Usage: Hero sections, landing pages
```

**Reference:** `button.tsx:144-148`, `buttons.demo.tsx:44-146`

---

### 2.3 Icon Support

**Icon Leading (Before Text):**

```typescript
iconLeading?: FC<{ className?: string }> | ReactNode
// Position: Before text content
// Spacing: Built into gap spacing
```

**Icon Trailing (After Text):**

```typescript
iconTrailing?: FC<{ className?: string }> | ReactNode
// Position: After text content
// Spacing: Built into gap spacing
```

**Icon-Only Detection (AUTOMATIC):**

```typescript
// Automatically detected when:
const isIcon = (IconLeading || IconTrailing) && !children;

// Changes behavior:
// 1. Applies square padding (not rectangular)
// 2. Sets data-icon-only={true} for CSS targeting
// 3. MUST have aria-label when icon-only
```

**Icon Sizing:**

```typescript
// Automatic based on button size
// sm, md, lg: size-5 (20px)
// xl: size-6 (24px)
```

**Icon Handling:**

```typescript
// Support both React components and elements
{isReactComponent(IconLeading) && <IconLeading data-icon />}
{isValidElement(IconLeading) && IconLeading}
```

**Reference:** `button.tsx:127-133`, `buttons.demo.tsx:12-143`, `button-utility.tsx:102-104`

---

### 2.4 Loading State

**Basic Loading:**

```typescript
isLoading?: boolean
// Behavior:
// - Shows loading spinner
// - Disables button interaction
// - Sets data-loading={true} for CSS
```

**Advanced Loading:**

```typescript
showTextWhileLoading?: boolean
// When true:
// - Spinner shown in leading position
// - Text remains visible
// - "Submitting..." or "Saving..." text shown

// When false (default):
// - Spinner centered absolutely
// - Text hidden (visibility-hidden)
// - Icon-only appearance
```

**Loading Spinner:**

```typescript
// SVG spinner icon
// - Animates automatically
// - Size matches button size
// - Positioned based on showTextWhileLoading
```

**Reference:** `button.tsx:203-226`, `buttons.demo.tsx:69-145`

---

### 2.5 State Management

**State Data Attributes:**

```typescript
data-loading={loading ? true : undefined}
data-icon-only={isIcon ? true : undefined}
data-disabled={isDisabled && href ? true : undefined}  // For links only
data-rac={isDisabled && href ? true : undefined}       // React Aria link marker
```

**Purpose:**

- CSS can target states: `data-loading:bg-brand-solid_hover`
- JavaScript can query state
- Screen readers announce properly

**Reference:** `button.tsx:228-229`, `button-utility.tsx:76`

---

### 2.6 Complete Props Interface

```typescript
/**
 * Button component props - supports both button and link variants
 */
export interface ButtonProps {
  /** Button text content */
  children?: ReactNode;

  /** Visual color variant */
  color?:
    | 'primary' // Solid brand button (default)
    | 'secondary' // Bordered button
    | 'tertiary' // Text-only button
    | 'link-gray' // Gray text link
    | 'link-color' // Brand color link
    | 'primary-destructive' // Solid red button
    | 'secondary-destructive' // Bordered red button
    | 'tertiary-destructive' // Red text button
    | 'link-destructive'; // Red text link

  /** Button size */
  size?: 'sm' | 'md' | 'lg' | 'xl';

  /** Icon to display before text */
  iconLeading?: FC<{ className?: string }> | ReactNode;

  /** Icon to display after text */
  iconTrailing?: FC<{ className?: string }> | ReactNode;

  /** Whether button is in loading state */
  isLoading?: boolean;

  /** Whether to show text while loading (default: false) */
  showTextWhileLoading?: boolean;

  /** Whether button is disabled */
  isDisabled?: boolean;

  /** Custom CSS classes */
  className?: string;

  /**
   * If provided, renders as <a> link instead of <button>
   * Automatically uses AriaLink component
   */
  href?: string;

  /** Additional button/link props */
  // Extends either ButtonHTMLAttributes or AnchorHTMLAttributes based on href
}
```

**Reference:** `button.tsx:150-174`

---

## 3. Styling Requirements

### 3.1 Base Styles (All Buttons)

```typescript
// Common styles applied to all variants
const baseStyles = [
  // Layout
  'relative inline-flex items-center justify-center',
  'gap-2', // Spacing between icons and text

  // Border radius
  'rounded-lg',

  // Typography
  'font-semibold',
  'whitespace-nowrap',

  // Transitions
  'transition duration-100 ease-linear',

  // Focus management
  'outline-hidden',
  'focus-visible:outline-2 focus-visible:outline-offset-2 outline-focus-ring',

  // Disabled cursor
  'disabled:cursor-not-allowed',
];
```

**Reference:** `button.tsx:150-160`

---

### 3.2 Size-Specific Styles

```typescript
const sizeStyles = {
  sm: {
    root: 'gap-1.5 px-3.5 py-2.5 text-sm',
    icon: 'size-5',
  },
  md: {
    root: 'gap-2 px-4 py-2.5 text-sm',
    icon: 'size-5',
  },
  lg: {
    root: 'gap-2 px-[1.125rem] py-2.5 text-base',
    icon: 'size-5',
  },
  xl: {
    root: 'gap-2.5 px-[1.375rem] py-3 text-base',
    icon: 'size-6',
  },
};
```

**Reference:** `button.tsx:144-148`

---

### 3.3 Color-Specific Styles

**Primary:**

```typescript
[
  'bg-brand-solid text-white shadow-xs-skeumorphic',
  'ring-1 ring-transparent ring-inset',
  'hover:bg-brand-solid_hover',
  'disabled:shadow-xs disabled:ring-disabled_subtle',
];
```

**Secondary:**

```typescript
[
  'bg-primary text-fg-secondary shadow-xs-skeumorphic',
  'ring-1 ring-primary ring-inset',
  'hover:bg-primary_hover hover:text-fg-secondary_hover',
  'disabled:shadow-xs disabled:ring-disabled_subtle',
];
```

**Tertiary:**

```typescript
['text-fg-secondary', 'hover:bg-primary_hover hover:text-fg-secondary_hover'];
```

**Reference:** `button.tsx:19-140`

---

### 3.4 Icon-Only Styles

```typescript
// When icon-only detected:
'data-icon-only:size-9'; // sm: 36px square
'data-icon-only:size-10'; // md: 40px square
'data-icon-only:size-11'; // lg: 44px square
'data-icon-only:size-[3.25rem]'; // xl: 52px square
```

**Reference:** `button.tsx:162-165`

---

### 3.5 Loading State Styles

```typescript
// Loading spinner position
!showTextWhileLoading && 'absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2';

// Hide content when loading (not showTextWhileLoading)
loading && !showTextWhileLoading && 'invisible';

// Disable pointer events
('data-loading:pointer-events-none');
```

**Reference:** `button.tsx:213-226`

---

## 4. Accessibility Requirements

### 4.1 WCAG 2.1 AA Compliance

**Required Features:**

- ✅ Semantic HTML (button vs anchor)
- ✅ Keyboard navigation (Space/Enter for button, Enter for link)
- ✅ Focus indicators visible (outline-focus-ring)
- ✅ Disabled state announced (via React Aria)
- ✅ Loading state announced (via React Aria isPending)
- ✅ Icon-only buttons have aria-label
- ✅ Color contrast meets AA standards (design tokens ensure this)

**Reference:** React Aria handles automatically

---

### 4.2 ARIA Attributes

**Automatic (via React Aria):**

- `role="button"` or `role="link"` (implicit from element)
- `aria-disabled="true"` when disabled
- `aria-busy="true"` when loading
- `tabindex` management

**Manual (when required):**

- `aria-label` REQUIRED for icon-only buttons

```typescript
// Icon-only MUST have aria-label
<Button iconLeading={TrashIcon} aria-label="Delete item" />
```

**Reference:** `buttons.demo.tsx:139-143`, `close-button.tsx:29`

---

### 4.3 Keyboard Navigation

**Button Element:**

- `Space` key → activates
- `Enter` key → activates

**Link Element:**

- `Enter` key → navigates
- `Space` key → scrolls (standard browser behavior)

**Handled by:** React Aria automatically

---

## 5. Testing Requirements

### 5.1 Unit Tests (Required)

**Rendering Tests:**

```typescript
it('renders with children');
it('renders as button by default');
it('renders as link when href provided');
it('applies correct color variant classes');
it('applies correct size classes');
it('forwards ref correctly');
```

**Interaction Tests:**

```typescript
it('calls onClick when clicked');
it('prevents interaction when disabled');
it('prevents interaction when loading');
it('navigates when href provided and clicked');
```

**Icon Tests:**

```typescript
it('renders icon leading');
it('renders icon trailing');
it('renders both icons');
it('applies icon-only styles when no children');
it('renders icon-only with correct size');
```

**Loading Tests:**

```typescript
it('shows spinner when loading');
it('hides content when loading without showTextWhileLoading');
it('shows content when loading with showTextWhileLoading');
it('disables interaction when loading');
```

**Accessibility Tests:**

```typescript
it('has no axe violations');
it('requires aria-label for icon-only');
it('applies disabled state correctly');
it('is keyboard navigable');
```

**Reference:** TDD-METHODOLOGY.md

---

### 5.2 Storybook Stories (Required)

**Stories Needed:**

```typescript
// One story per color variant (9 stories)
export const Primary = () => <AllSizesAndStates color="primary" />
export const Secondary = () => <AllSizesAndStates color="secondary" />
export const Tertiary = () => <AllSizesAndStates color="tertiary" />
export const LinkGray = () => <AllSizesAndStates color="link-gray" />
export const LinkColor = () => <AllSizesAndStates color="link-color" />
export const PrimaryDestructive = () => <AllSizesAndStates color="primary-destructive" />
export const SecondaryDestructive = () => <AllSizesAndStates color="secondary-destructive" />
export const TertiaryDestructive = () => <AllSizesAndStates color="tertiary-destructive" />
export const LinkDestructive = () => <AllSizesAndStates color="link-destructive" />

// Each story shows:
// - All 4 sizes (sm, md, lg, xl)
// - Default state
// - Disabled state
// - Loading state (with showTextWhileLoading)
// - With leading icon
// - With trailing icon
// - With both icons
// - Icon-only
```

**Reference:** `buttons.story.tsx`, `buttons.demo.tsx`

---

## 6. Documentation Requirements

### 6.1 Inline Documentation (JSDoc)

**Component-Level:**

```typescript
/**
 * Button component - Primary interactive element
 *
 * ## Architecture
 * - Built on React Aria for WCAG 2.1 AA accessibility
 * - Polymorphic: renders as <button> or <a> based on href
 * - Uses design token system for theming and dark mode
 *
 * ## When to Use
 * - Form submissions: primary variant with type="submit"
 * - Primary actions: primary variant (limit 1-2 per view)
 * - Secondary actions: secondary or tertiary variants
 * - Navigation styled as button: link-* variants with href
 * - Destructive actions: *-destructive variants
 *
 * ## AI Usage Guidelines
 *
 * **DO:**
 * - Use descriptive text ("Save Changes", not "Submit")
 * - Use primary for main action only
 * - Disable during loading states
 * - Provide aria-label for icon-only buttons
 * - Use href for navigation, onClick for actions
 *
 * **DO NOT:**
 * - Use multiple primary buttons in same context
 * - Use buttons for navigation (use Link components with href)
 * - Nest buttons inside buttons
 * - Hardcode colors (use design tokens via color prop)
 *
 * @example
 * // Basic usage
 * <Button color="primary" size="md">Save Changes</Button>
 *
 * @example
 * // With loading state
 * <Button color="primary" isLoading={saving} showTextWhileLoading>
 *   {saving ? 'Saving...' : 'Save'}
 * </Button>
 *
 * @example
 * // Icon-only button (requires aria-label)
 * <Button
 *   color="tertiary"
 *   iconLeading={<TrashIcon />}
 *   aria-label="Delete item"
 * />
 *
 * @example
 * // Link styled as button
 * <Button color="primary" href="/dashboard">
 *   Go to Dashboard
 * </Button>
 */
export const Button = forwardRef<...>(...);
```

**Prop-Level:**

```typescript
export interface ButtonProps {
  /**
   * Button text content
   *
   * Omit for icon-only buttons (MUST provide aria-label)
   */
  children?: ReactNode;

  /**
   * Visual color variant
   *
   * **Variants:**
   * - `primary`: Main action (solid brand color)
   * - `secondary`: Alternative action (bordered)
   * - `tertiary`: Subtle action (text-only)
   * - `link-gray`: Navigation link (gray text)
   * - `link-color`: Navigation link (brand color)
   * - `primary-destructive`: Primary delete/remove
   * - `secondary-destructive`: Secondary delete/remove
   * - `tertiary-destructive`: Subtle delete/remove
   * - `link-destructive`: Navigation to destructive action
   *
   * @default "primary"
   */
  color?: "primary" | "secondary" | ...;

  // ... etc for all props
}
```

**Reference:** COMPONENT-DEVELOPMENT.md, ROADMAP.md Phase 2

---

### 6.2 Usage Patterns Document

**File:** `button.patterns.md`

**Content:**

- Basic usage examples
- All 9 color variants with use cases
- Icon patterns (leading, trailing, icon-only)
- Loading state patterns
- Link button patterns
- Form integration examples
- Accessibility best practices
- Common pitfalls to avoid

**Reference:** COMPONENT-DEVELOPMENT.md

---

## 7. Implementation Checklist

### Phase 2.1: Foundation Setup (4-6 hours)

- [ ] Install `react-aria-components` dependency
- [ ] Create design token Tailwind configuration
- [ ] Set up `cx` utility (tailwind-merge)
- [ ] Set up `isReactComponent` utility
- [ ] Define all 9 color variant styles using design tokens
- [ ] Define all 4 size variant styles
- [ ] Create loading spinner component/SVG

### Phase 2.2: Core Button Implementation (4-6 hours)

- [ ] Create ButtonProps interface with all props
- [ ] Implement polymorphic pattern (AriaButton vs AriaLink)
- [ ] Implement icon-only detection logic
- [ ] Implement loading state logic
- [ ] Apply all styling (base, size, color, states)
- [ ] Add data attributes for state management
- [ ] Handle disabled state for both button and link
- [ ] Add forwardRef support

### Phase 2.3: Testing (4-6 hours)

- [ ] Write rendering tests (all variants, all sizes)
- [ ] Write interaction tests (click, keyboard, disabled)
- [ ] Write icon tests (leading, trailing, icon-only)
- [ ] Write loading state tests
- [ ] Write accessibility tests (axe, keyboard, aria)
- [ ] Achieve 90%+ test coverage

### Phase 2.4: Storybook Documentation (2-4 hours)

- [ ] Create story for each color variant (9 stories)
- [ ] Each story shows all sizes and states
- [ ] Add interactive controls
- [ ] Enable accessibility addon
- [ ] Verify all variants render correctly

### Phase 2.5: Documentation (2-3 hours)

- [ ] Write comprehensive JSDoc for component
- [ ] Document all props with examples
- [ ] Create button.patterns.md with usage examples
- [ ] Document accessibility requirements
- [ ] Document AI usage guidelines
- [ ] Create button.checklist.json

### Phase 2.6: Validation (1-2 hours)

- [ ] All tests pass
- [ ] No TypeScript errors
- [ ] No ESLint warnings
- [ ] Prettier formatted
- [ ] All Storybook stories render
- [ ] Quality gates pass
- [ ] User approval obtained

**Total Estimated Time:** 16-24 hours (2-3 days)

---

## 8. Success Criteria

### Technical Requirements

- ✅ Uses React Aria (AriaButton, AriaLink)
- ✅ Uses design token system (no hardcoded colors)
- ✅ Implements polymorphic pattern (button vs link)
- ✅ All 9 color variants implemented
- ✅ All 4 size variants implemented
- ✅ Icon support (leading, trailing, icon-only)
- ✅ Loading state with showTextWhileLoading option
- ✅ State data attributes (data-loading, data-icon-only)
- ✅ 90%+ test coverage
- ✅ WCAG 2.1 AA compliant
- ✅ All quality gates pass

### Documentation Requirements

- ✅ Comprehensive JSDoc on all props
- ✅ AI usage guidelines included
- ✅ All 9 variants have Storybook stories
- ✅ Usage patterns document complete
- ✅ Examples show all features
- ✅ Accessibility notes comprehensive

### AI Validation

- ✅ Claude Code can use component correctly from documentation
- ✅ Claude Code can create new variant using this as reference
- ✅ All patterns are explicit (zero implicit knowledge required)
- ✅ Error messages guide correct usage

---

## 9. What Changed from Initial Plan

### What I Got Wrong (Before Studying Reference)

1. **Missing React Aria** - Didn't know it was foundational
2. **Missing Polymorphic Pattern** - Didn't know button could be link
3. **Wrong Number of Variants** - Thought 5, actually 9
4. **Missing Icon-Only Support** - Didn't see this pattern
5. **Simplified Loading** - Missed showTextWhileLoading option
6. **Hardcoded Colors** - Didn't understand design token system
7. **Missing State Data Attributes** - Didn't see this pattern

### What I Got Right (Before Studying Reference)

1. ✅ `fullWidth` prop (good DX addition not in UntitledUI)
2. ✅ Basic size variants (sm, md, lg, xl)
3. ✅ Basic loading state concept
4. ✅ Icon support concept (iconBefore, iconAfter)
5. ✅ Disabled state
6. ✅ forwardRef pattern

### Key Lesson

**I should have studied the reference FIRST before making ANY plan.** This requirements document is what I should have created from the beginning, based on thorough analysis of UntitledUI, not assumptions.

---

## 10. Next Steps

**Awaiting User Approval:**

1. Do these requirements accurately reflect what needs to be built?
2. Is the 16-24 hour estimate acceptable?
3. Should I proceed with Phase 2.1 (Foundation Setup)?
4. Any questions or clarifications needed?

**After Approval:**

Proceed with implementation following the checklist in Section 7, validating against this requirements document at every step.

---

## References

- **UPSTREAM/react/components/base/buttons/button.tsx** - Main reference
- **UPSTREAM/react/styles/theme.css** - Design token system
- **ROADMAP.md Phase 2** - Project goals
- **COMPONENT-DEVELOPMENT.md** - Development patterns
- **TDD-METHODOLOGY.md** - Testing approach
- **ROOT-CAUSE-ANALYSIS.md** - Process lessons learned
