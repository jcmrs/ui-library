# UntitledUI Pattern Library

**Date:** 2025-10-25
**Purpose:** Comprehensive pattern documentation with scope classification (UNIVERSAL / CATEGORY / COMPONENT)
**Critical Lesson:** Pattern scope determines applicability - never assume component-specific patterns are universal

---

## Table of Contents

1. [Pattern Classification System](#pattern-classification-system)
2. [Universal Patterns (100% Usage)](#universal-patterns-100-usage)
3. [Category-Specific Patterns](#category-specific-patterns)
4. [Component-Specific Patterns](#component-specific-patterns)
5. [Anti-Patterns (What NOT to Do)](#anti-patterns-what-not-to-do)
6. [Pattern Usage Statistics](#pattern-usage-statistics)
7. [Pattern Application Guide](#pattern-application-guide)
8. [Pattern Evolution Guidelines](#pattern-evolution-guidelines)

---

## Pattern Classification System

### Scope Labels

Every pattern is labeled with its scope:

**🌐 UNIVERSAL** - Used by 100% of components across all categories

- Apply to ALL new components without exception
- Documented with "UNIVERSAL" label
- Violation is architectural error

**🏗️ CATEGORY** - Used within specific component category (base/, application/, etc.)

- Apply only within designated category
- Documented with "CATEGORY: base/" or "CATEGORY: application/" label
- Cross-category usage requires explicit justification

**🔧 COMPONENT** - Unique to individual component or component family

- Apply only to specific component
- Documented with "COMPONENT: Button" or "COMPONENT: Select family" label
- DO NOT generalize to other components

### Critical Terminology: What "Component" Means

**⚠️ WARNING:** The word "component" has DIFFERENT meanings in different contexts. DO NOT conflate them.

**1. Primitive Component** (e.g., Input field, Toggle, Checkbox)

- Basic building block in the library
- Single responsibility
- Located in: `base/`
- Example: `base/input/input.tsx` - A text input field for forms

**2. Layout Component** (e.g., Sidebar navigation, Header)

- Structural/organizational component
- Defines page structure
- Located in: `application/app-navigation/`
- Example: `application/app-navigation/sidebar-navigation/sidebar-simple.tsx` - Left sidebar for app navigation

**3. Application Component** (e.g., Table, Modal, Tabs)

- Complex composed UI pattern
- Integrates multiple primitive components
- Located in: `application/`
- Example: `application/table/table.tsx` - Data table that integrates Checkbox, Dropdown, Badge components

**4. Specialized Display Component** (e.g., Code snippet, QR code, Illustration)

- Specific-purpose display element
- Not general-purpose UI
- Located in: `foundations/` or `shared-assets/`
- Example: `shared-assets/qr-code/` - QR code display (NOT a general UI component)

**5. Page Template** (e.g., 404 page, Login page) - ⚠️ **NOT A COMPONENT**

- Complete page composition using multiple components
- NOT in the component library
- Located in: `pages/` or Next.js `src/app/`
- Example: 404 page = Layout + Empty state component + Button component + Illustration

**6. Component Library** (the entire project)

- Collection of reusable components
- The system as a whole
- NOT a single component

### Pattern Discovery Process

When encountering a pattern in UntitledUI reference:

1. **Check Usage Count** - How many files use this pattern?

   - 208 files (100%) → UNIVERSAL
   - 10-50 files (~5-25%) → CATEGORY (check which categories)
   - 1-9 files (<5%) → COMPONENT

2. **Verify Across Categories** - Is pattern in base/ AND application/?

   - Yes → UNIVERSAL or CATEGORY (depends on percentages)
   - No → CATEGORY or COMPONENT

3. **Document Scope** - Label pattern with scope before using

---

## Universal Patterns (100% Usage)

These patterns appear in ALL components across ALL categories.

### 1. Design Token System 🌐 UNIVERSAL

**Status:** Used by 208/208 files (100%)

**Pattern:** All styling uses semantic design tokens, NEVER hardcoded values.

**Implementation:**

```typescript
// ✅ CORRECT - Semantic tokens
className = 'bg-brand-solid text-white'; // Primary brand color
className = 'bg-primary text-secondary'; // Secondary variant
className = 'text-fg-quaternary'; // Quaternary text color
className = 'ring-primary'; // Primary ring/border
className = 'shadow-xs'; // Extra small shadow

// ❌ WRONG - Hardcoded values
className = 'bg-blue-600 text-white'; // Specific blue shade
className = 'bg-gray-100 text-gray-900'; // Specific gray shades
className = 'text-[#64748B]'; // Arbitrary hex color
className = 'px-[13px]'; // Arbitrary spacing
```

**Design Token Categories:**

```typescript
// Background colors
bg - brand - solid; // Primary brand background
bg - primary; // Primary surface
bg - secondary; // Secondary surface
bg - tertiary; // Tertiary surface
bg - quaternary; // Quaternary surface
bg - primary - solid; // Solid primary
bg - error - solid; // Error background
bg - success - solid; // Success background
bg - warning - solid; // Warning background

// Foreground (text) colors
text - primary; // Primary text
text - secondary; // Secondary text
text - tertiary; // Tertiary text
text - quaternary; // Quaternary text
text - fg - white; // White text
text - fg - error; // Error text
text - fg - success; // Success text
text - fg - warning; // Warning text

// Border/Ring colors
ring - primary; // Primary ring
border - primary; // Primary border
border - secondary; // Secondary border
border - error; // Error border

// Shadow tokens
shadow - xs; // Extra small
shadow - sm; // Small
shadow - md; // Medium
shadow - lg; // Large
shadow - xl; // Extra large
```

**Rationale:**

- Enables theming (light/dark mode)
- Consistent visual language
- Single source of truth for colors
- Easier maintenance

**When Implementing:**

- ALWAYS use semantic tokens
- NEVER hardcode colors or spacing
- Reference `styles/theme.css` for available tokens
- If token doesn't exist, add to design system (don't hardcode)

---

### 2. cx() Utility for Class Merging 🌐 UNIVERSAL

**Status:** Used by 208/208 files (100%)

**Pattern:** All components use `cx()` utility for conditional class merging and user className overrides.

**Implementation:**

**Example 1: Primitive Component (Input field for forms)**

```typescript
import { cx } from '@/utils/cx';

export function Input({ size, error, disabled, className, ...props }: InputProps) {
  return (
    <input
      className={cx(
        // Base classes (always applied)
        'w-full rounded-lg border transition-all',
        'focus:outline-2 focus:outline-brand',

        // Conditional classes (size)
        size === 'sm' && 'px-3 py-1.5 text-sm',
        size === 'md' && 'px-4 py-2 text-base',

        // Conditional classes (state)
        error && 'border-error-solid ring-1 ring-error-solid',
        disabled && 'bg-quaternary cursor-not-allowed opacity-50',
        !error && !disabled && 'border-primary',

        // User-provided className (ALWAYS LAST)
        className
      )}
      disabled={disabled}
      {...props}
    />
  );
}
```

**Example 2: Layout Component (Sidebar navigation)**

```typescript
import { cx } from '@/utils/cx';

export function Sidebar({ collapsed, position, className, ...props }: SidebarProps) {
  return (
    <aside
      className={cx(
        // Base classes
        'fixed h-screen bg-primary border-r border-primary',
        'transition-all duration-300',

        // Conditional classes (collapsed state)
        collapsed ? 'w-16' : 'w-64',

        // Conditional classes (position)
        position === 'left' && 'left-0',
        position === 'right' && 'right-0',

        // User className
        className
      )}
      {...props}
    />
  );
}
```

**Example 3: Application Component (Modal)**

```typescript
import { cx } from '@/utils/cx';

export function Modal({ size, open, className, ...props }: ModalProps) {
  return (
    <div
      className={cx(
        // Base classes (always applied)
        'fixed inset-0 z-50',
        'flex items-center justify-center',
        'bg-black/50 backdrop-blur-sm',

        // Conditional classes (open state)
        open ? 'opacity-100' : 'opacity-0 pointer-events-none',

        // Conditional classes (size)
        size === 'sm' && 'max-w-sm',
        size === 'md' && 'max-w-md',
        size === 'lg' && 'max-w-lg',

        // User className
        className
      )}
      {...props}
    />
  );
}
```

**Example 4: NOT a component - Button (primitive) used INSIDE page template**

```typescript
// This is a 404 Page Template (NOT a component in the library)
// It USES components from the library

export function NotFoundPage() {
  return (
    <div className="flex min-h-screen items-center justify-center">
      {/* Using Illustration component (specialized display) */}
      <Illustration name="404" className="mb-8" />

      {/* Using Input component (form primitive) - example of composition */}
      <Input placeholder="Search..." size="md" />

      {/* Using Button component (primitive) */}
      <Button variant="primary" size="md">
        Go Home
      </Button>
    </div>
  );
}
// ⚠️ This page template is NOT in the component library
// It's a COMPOSITION of library components
```

**Original Example (Application Component - kept for reference):**

```typescript
export function Button({ variant, size, className, ...props }: ButtonProps) {
  return (
    <button
      className={cx(
        // Base classes (always applied)
        'inline-flex items-center justify-center',
        'rounded-lg font-semibold transition-all',
        'focus:outline-2 focus:outline-brand',

        // Conditional classes (variant)
        variant === 'primary' && [
          'bg-brand-solid text-white',
          'hover:bg-brand-solid-hover',
          'active:bg-brand-solid-pressed',
        ],
        variant === 'secondary' && [
          'bg-primary text-secondary',
          'ring-1 ring-inset ring-primary',
          'hover:bg-primary-hover',
        ],

        // Conditional classes (size)
        size === 'sm' && 'px-3 py-1.5 text-sm',
        size === 'md' && 'px-4 py-2 text-base',
        size === 'lg' && 'px-5 py-3 text-lg',

        // User-provided className (ALWAYS LAST)
        className
      )}
      {...props}
    />
  );
}
```

**Key Principles:**

1. **Base classes first** - Always-applied styles
2. **Conditionals next** - Variant/state-dependent styles
3. **User className last** - Allows user overrides
4. **Array grouping** - Group related conditionals in arrays

**Common Pattern:**

```typescript
className={cx(
  // 1. Layout and positioning
  'inline-flex items-center justify-center',

  // 2. Base styling
  'rounded-lg font-semibold',

  // 3. Transitions and animations
  'transition-all duration-200',

  // 4. Focus states
  'focus:outline-2 focus:outline-brand',

  // 5. Variant-specific (grouped in arrays)
  variant === 'primary' && [
    'bg-brand-solid text-white',
    'hover:bg-brand-solid-hover',
  ],

  // 6. Size-specific
  size === 'md' && 'px-4 py-2',

  // 7. State-specific
  disabled && 'opacity-50 cursor-not-allowed',

  // 8. User overrides (LAST)
  className
)}
```

**Rationale:**

- Tailwind Merge built into cx() - no class conflicts
- Predictable override behavior
- Clean conditional class application
- User customization support

---

### 3. React Aria Components Foundation 🌐 UNIVERSAL (for interactive components)

**Status:** Used by 47/47 interactive component files (100% of interactive)

**Pattern:** ALL interactive components use React Aria as accessibility foundation.

**Usage Statistics:**

- 47 files use React Aria (23% of all files)
- 100% of base/ interactive components
- 100% of application/ interactive components
- 0% of foundations/ (not interactive)
- 0% of shared-assets/ (not interactive)

**Implementation Examples:**

```typescript
// Example 1: Button with AriaButton
import { Button as AriaButton } from 'react-aria-components';

export function Button({ children, ...props }: ButtonProps) {
  return (
    <AriaButton
      className={cx(/* ... */)}
      {...props}
    >
      {children}
    </AriaButton>
  );
}

// Example 2: Select with AriaSelect + AriaPopover
import {
  Select as AriaSelect,
  SelectValue,
  Button,
  Popover,
  ListBox,
  ListBoxItem,
} from 'react-aria-components';

export function Select({ options, ...props }: SelectProps) {
  return (
    <AriaSelect {...props}>
      <Button>{/* trigger */}</Button>
      <Popover>
        <ListBox>
          {options.map(option => (
            <ListBoxItem key={option.value}>{option.label}</ListBoxItem>
          ))}
        </ListBox>
      </Popover>
    </AriaSelect>
  );
}

// Example 3: Toggle with AriaSwitch
import { Switch as AriaSwitch } from 'react-aria-components';

export function Toggle({ ...props }: ToggleProps) {
  return (
    <AriaSwitch className={cx(/* ... */)} {...props}>
      {/* switch UI */}
    </AriaSwitch>
  );
}
```

**React Aria Components Used:**

| Base Component | React Aria Component                     | Accessibility Features                                    |
| -------------- | ---------------------------------------- | --------------------------------------------------------- |
| Button         | `Button`                                 | Keyboard (Space/Enter), disabled state, aria-pressed      |
| Toggle         | `Switch`                                 | Keyboard (Space), aria-checked, role="switch"             |
| Checkbox       | `Checkbox`                               | Keyboard (Space), aria-checked, indeterminate             |
| Radio          | `RadioGroup` + `Radio`                   | Keyboard (arrows), aria-checked, role="radiogroup"        |
| Select         | `Select` + `Popover` + `ListBox`         | Keyboard navigation, aria-expanded, aria-activedescendant |
| Input          | `TextField` + `Input`                    | Label association, aria-invalid, aria-describedby         |
| Slider         | `Slider` + `SliderTrack` + `SliderThumb` | Keyboard (arrows), aria-valuemin/max/now                  |
| Tooltip        | `TooltipTrigger` + `Tooltip`             | Hover/focus triggers, aria-describedby, role="tooltip"    |

**Automatic Accessibility Features:**

1. **Semantic HTML** - Correct element types
2. **ARIA Attributes** - All required ARIA automatically
3. **Keyboard Navigation** - Tab, Space, Enter, Arrows
4. **Focus Management** - Correct focus order and trap
5. **Screen Reader Support** - Proper announcements
6. **State Management** - Selected, disabled, invalid states

**When NOT to Use React Aria:**

- Non-interactive components (foundations/, shared-assets/)
- Pure visual elements (illustrations, patterns, icons)
- Static content (text, images, dividers)

**Rationale:**

- Accessibility is HARD - React Aria solves 80%
- WCAG 2.1 AA compliance built-in
- Consistent behavior across components
- Browser compatibility handled
- Keyboard interactions standardized

---

### 4. TypeScript Type Safety 🌐 UNIVERSAL

**Status:** Used by 208/208 files (100%)

**Pattern:** All components are fully typed with exported interfaces.

**Implementation:**

```typescript
// ✅ CORRECT - Full typing with exported interface
import { ComponentPropsWithoutRef } from 'react';

/**
 * Button component props
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
}

export function Button({
  variant = 'primary',
  size = 'md',
  fullWidth = false,
  loading = false,
  children,
  className,
  ...props
}: ButtonProps) {
  // Implementation
}

// ❌ WRONG - No interface export
function Button({
  variant,
  size,
  ...props
}: {
  variant?: string;
  size?: string;
  // ... other props
}) {
  // Implementation
}
```

**TypeScript Patterns:**

```typescript
// Pattern 1: Extend HTML element props
export interface ButtonProps extends ComponentPropsWithoutRef<'button'> {
  variant?: 'primary' | 'secondary';
}

// Pattern 2: Discriminated unions for complex props
export type AlertProps =
  | { variant: 'success'; onClose: () => void }
  | { variant: 'error'; error: Error; onDismiss?: () => void };

// Pattern 3: Generic components
export interface SelectProps<T> {
  options: T[];
  value: T;
  onChange: (value: T) => void;
  getOptionLabel: (option: T) => string;
  getOptionValue: (option: T) => string;
}

export function Select<T>({ options, value, onChange, ... }: SelectProps<T>) {
  // Implementation
}

// Pattern 4: Ref forwarding types
export interface InputProps extends ComponentPropsWithoutRef<'input'> {
  label?: string;
}

export const Input = forwardRef<HTMLInputElement, InputProps>(
  ({ label, ...props }, ref) => {
    // Implementation
  }
);
```

**JSDoc Documentation:**

```typescript
/**
 * Button component for primary user actions
 *
 * @example
 * // Primary button
 * <Button variant="primary">Save</Button>
 *
 * @example
 * // With loading state
 * <Button loading>Saving...</Button>
 */
export interface ButtonProps extends ComponentPropsWithoutRef<'button'> {
  /**
   * Visual style variant
   * @default 'primary'
   */
  variant?: 'primary' | 'secondary' | 'tertiary' | 'ghost';

  /**
   * Button size
   * @default 'md'
   */
  size?: 'sm' | 'md' | 'lg' | 'xl';

  /**
   * Makes button full width of container
   * @default false
   */
  fullWidth?: boolean;
}
```

**Rationale:**

- Type safety prevents runtime errors
- IntelliSense/autocomplete for developers
- Self-documenting code
- Refactoring confidence
- AI tools can parse types

---

### 5. Component File Triplet Pattern 🌐 UNIVERSAL

**Status:** Used by 208/208 files (100%)

**Pattern:** Every component has three associated files: implementation, demo, and story.

**File Structure:**

```
component-name/
├── component-name.tsx       ← Implementation
├── component-name.demo.tsx  ← Usage demos
└── component-name.story.tsx ← Storybook stories
```

**Example: toggle/**

```
toggle/
├── toggle.tsx        ← React Aria Switch implementation
├── toggle.demo.tsx   ← Demo with form integration
└── toggle.story.tsx  ← Storybook with all states
```

**File Purposes:**

**1. Implementation File (.tsx)**

```typescript
// toggle.tsx
import { Switch as AriaSwitch } from 'react-aria-components';
import { cx } from '@/utils/cx';

export interface ToggleProps {
  // Props definition
}

export function Toggle({ ...props }: ToggleProps) {
  // Implementation
}
```

**2. Demo File (.demo.tsx)**

```typescript
// toggle.demo.tsx
import { Toggle } from './toggle';

export function ToggleDemo() {
  return (
    <div>
      <h2>Toggle Examples</h2>

      <section>
        <h3>Basic Usage</h3>
        <Toggle>Enable notifications</Toggle>
      </section>

      <section>
        <h3>Disabled State</h3>
        <Toggle isDisabled>Disabled toggle</Toggle>
      </section>
    </div>
  );
}
```

**3. Story File (.story.tsx)**

```typescript
// toggle.story.tsx
import type { Meta, StoryObj } from '@storybook/react';
import { Toggle } from './toggle';

const meta = {
  title: 'Base/Toggle',
  component: Toggle,
  tags: ['autodocs'],
} satisfies Meta<typeof Toggle>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {
  args: {
    children: 'Enable notifications',
  },
};

export const Disabled: Story = {
  args: {
    children: 'Disabled toggle',
    isDisabled: true,
  },
};
```

**Rationale:**

- Separation of concerns
- Interactive documentation (Storybook)
- Usage examples (demos)
- Visual testing (stories)
- Consistent structure

---

## Category-Specific Patterns

Patterns used within specific component categories.

### 1. Context API for State Sharing 🏗️ CATEGORY: Complex Components Only

**Status:** Used by 13/208 files (6%)

**Applicable To:**

- Complex base/ components (ButtonGroup, Input, PinInput)
- Most application/ components (Tabs, Table, Pagination, Carousel)

**NOT Applicable To:**

- Simple base/ components (Button, Toggle, Checkbox)
- Foundations (icons, visual elements)

**Pattern:** Components with multiple sub-components sharing state use React Context.

**Implementation Example (Tabs):**

```typescript
// tabs.tsx

import { createContext, useContext, useState } from 'react';

interface TabsContextValue {
  selectedTab: string;
  setSelectedTab: (tab: string) => void;
}

const TabsContext = createContext<TabsContextValue | null>(null);

function useTabs() {
  const context = useContext(TabsContext);
  if (!context) throw new Error('Tabs components must be wrapped in Tabs');
  return context;
}

// Parent component
export function Tabs({ defaultTab, children }: TabsProps) {
  const [selectedTab, setSelectedTab] = useState(defaultTab);

  return (
    <TabsContext.Provider value={{ selectedTab, setSelectedTab }}>
      <div className="tabs">
        {children}
      </div>
    </TabsContext.Provider>
  );
}

// Sub-component
export function TabsList({ children }: TabsListProps) {
  return <div className="tabs-list">{children}</div>;
}

// Sub-component
export function Tab({ value, children }: TabProps) {
  const { selectedTab, setSelectedTab } = useTabs();

  return (
    <button
      className={cx(
        'tab',
        selectedTab === value && 'tab-active'
      )}
      onClick={() => setSelectedTab(value)}
    >
      {children}
    </button>
  );
}

// Sub-component
export function TabPanel({ value, children }: TabPanelProps) {
  const { selectedTab } = useTabs();

  if (selectedTab !== value) return null;

  return <div className="tab-panel">{children}</div>;
}

// Usage
<Tabs defaultTab="profile">
  <TabsList>
    <Tab value="profile">Profile</Tab>
    <Tab value="settings">Settings</Tab>
  </TabsList>
  <TabPanel value="profile">Profile content</TabPanel>
  <TabPanel value="settings">Settings content</TabPanel>
</Tabs>
```

**When to Use:**

- Component has 3+ sub-components
- Sub-components need to share state
- Parent-child communication is complex
- State updates affect multiple parts

**When NOT to Use:**

- Simple components with no sub-components
- State can be passed via props
- Only 1-2 sub-components

**Components Using This:**

- radio-buttons (RadioGroup context)
- select (Select context)
- multi-select (MultiSelect context)
- tags (Tags context)
- input (Input context for label/hint/error)
- pin-input (PinInput context for digit management)
- button-group (ButtonGroup context)
- tabs (Tabs context)
- table (Table context for sorting/selection)
- empty-state (EmptyState context)
- pagination (Pagination context)
- carousel (Carousel context)

**Complexity Indicator:**
If component needs Context API → Medium to Complex component (100-300+ lines)

---

### 2. Composition Architecture 🏗️ CATEGORY: application/ + Complex base/

**Status:** Used by ~20 files (10%)

**Applicable To:**

- ALL application/ components
- Complex base/ components (Input, Select, ButtonGroup)

**NOT Applicable To:**

- Simple base/ components
- Foundations/shared-assets

**Pattern:** Component.SubComponent namespace pattern for composed components.

**Implementation Example (Table):**

```typescript
// table.tsx

// Main component
export function Table({ children, ...props }: TableProps) {
  return (
    <table className="table" {...props}>
      {children}
    </table>
  );
}

// Sub-components
Table.Header = function TableHeader({ children }: TableHeaderProps) {
  return <thead className="table-header">{children}</thead>;
};

Table.Body = function TableBody({ children }: TableBodyProps) {
  return <tbody className="table-body">{children}</tbody>;
};

Table.Row = function TableRow({ children }: TableRowProps) {
  return <tr className="table-row">{children}</tr>;
};

Table.HeaderCell = function TableHeaderCell({ children, sortable }: TableHeaderCellProps) {
  return (
    <th className={cx('table-cell', sortable && 'sortable')}>
      {children}
    </th>
  );
};

Table.Cell = function TableCell({ children }: TableCellProps) {
  return <td className="table-cell">{children}</td>;
};

// Usage
<Table>
  <Table.Header>
    <Table.Row>
      <Table.HeaderCell sortable>Name</Table.HeaderCell>
      <Table.HeaderCell>Email</Table.HeaderCell>
    </Table.Row>
  </Table.Header>
  <Table.Body>
    <Table.Row>
      <Table.Cell>John Doe</Table.Cell>
      <Table.Cell>john@example.com</Table.Cell>
    </Table.Row>
  </Table.Body>
</Table>
```

**Alternative Pattern (Named Exports):**

```typescript
// table.tsx

export function Table({ children }: TableProps) {
  return <table className="table">{children}</table>;
}

export function TableHeader({ children }: TableHeaderProps) {
  return <thead className="table-header">{children}</thead>;
}

export function TableBody({ children }: TableBodyProps) {
  return <tbody className="table-body">{children}</tbody>;
}

// Usage
import { Table, TableHeader, TableBody, TableRow, TableCell } from './table';

<Table>
  <TableHeader>
    <TableRow>
      <TableCell>Name</TableCell>
    </TableRow>
  </TableHeader>
  <TableBody>...</TableBody>
</Table>
```

**When to Use:**

- Component has clear parent-child relationship
- Sub-components only make sense within parent
- Want namespace clarity (Table.Row vs Row)

**When NOT to Use:**

- Sub-components can be used independently
- Simple single-component implementations

**Components Using This:**

- Table (Table.Header, Table.Row, Table.Cell)
- Input (Input, InputBase, TextField)
- Select (Select, SelectItem, SelectGroup)
- Modal (Modal.Header, Modal.Body, Modal.Footer)
- Card (Card.Header, Card.Body, Card.Footer)

---

### 3. base-components/ Subdirectory Pattern 🏗️ CATEGORY: Only 3 Components

**Status:** Used by 3/30 component types (10%)

**Applicable To:**

- Avatar (avatar/, avatar-label-group/, avatar-profile-photo/)
- Tags (tag variants sharing sub-components)
- App-Navigation (navigation variants sharing nav items)

**NOT Applicable To:**

- 90% of components (27 out of 30 component types)

**Pattern:** Variants share >50% implementation via base-components/ subdirectory.

**File Structure:**

```
avatar/
├── avatar.tsx                        ← Core avatar
├── avatar-label-group.tsx            ← Variant with labels
├── avatar-profile-photo.tsx          ← Variant for profiles
├── base-components/                  ← Shared sub-components
│   ├── avatar-add-button.tsx
│   ├── avatar-company-icon.tsx
│   ├── avatar-online-indicator.tsx
│   └── verified-tick.tsx
├── utils.ts                          ← Shared utilities
├── avatar.demo.tsx
└── avatar.story.tsx
```

**Implementation Example:**

```typescript
// avatar.tsx (Core)
import { AvatarOnlineIndicator } from './base-components/avatar-online-indicator';
import { VerifiedTick } from './base-components/verified-tick';

export function Avatar({ online, verified, ...props }: AvatarProps) {
  return (
    <div className="avatar">
      <img {...props} />
      {online && <AvatarOnlineIndicator />}
      {verified && <VerifiedTick />}
    </div>
  );
}

// avatar-label-group.tsx (Variant)
import { AvatarOnlineIndicator } from './base-components/avatar-online-indicator';
import { VerifiedTick } from './base-components/verified-tick';

export function AvatarLabelGroup({
  avatars,
  online,
  verified,
}: AvatarLabelGroupProps) {
  return (
    <div className="avatar-group">
      {avatars.map(avatar => (
        <div key={avatar.id}>
          <img src={avatar.src} />
          {online && <AvatarOnlineIndicator />}
          {verified && <VerifiedTick />}
          <span>{avatar.label}</span>
        </div>
      ))}
    </div>
  );
}

// base-components/avatar-online-indicator.tsx (Shared)
export function AvatarOnlineIndicator() {
  return <div className="online-indicator" />;
}
```

**Decision Criteria:**

```
Should I use base-components/?

YES if ALL true:
✓ 2+ variants exist
✓ Variants share >50% implementation
✓ Shared code is 3+ sub-components
✓ Sub-components are NOT useful outside this component

NO if ANY true:
✗ Only 1 variant exists
✗ Variants share <50% implementation
✗ Shared code is just utilities (use utils.ts)
✗ Sub-components could be used elsewhere (make separate components)
```

**Statistics:**

- Only 3 components use this pattern out of 30 types (10%)
- Avatar: Most complex (4 shared sub-components)
- Tags: Medium (2 shared sub-components)
- App-Navigation: Navigation items shared

**Common Mistake:**
Creating base-components/ for every component → 90% don't need it

---

## Component-Specific Patterns

Patterns unique to individual components or component families.

### 1. Polymorphic Rendering (Button Family) 🔧 COMPONENT: Button

**Status:** Used by 3/208 files (1.4%)

**Applicable To:**

- button.tsx
- button-utility.tsx
- social-button.tsx

**NOT Applicable To:**

- 205 other files (98.6%)
- Other clickable components (Toggle, Checkbox, etc. use React Aria)

**Pattern:** Component renders as `<button>` or `<a>` based on `href` prop.

**Implementation:**

```typescript
// button.tsx

import { Button as AriaButton, Link as AriaLink } from 'react-aria-components';

export interface ButtonProps {
  /** Makes button render as link when provided */
  href?: string;
  /** Link target (only with href) */
  target?: '_blank' | '_self';
  // ... other props
}

export function Button({ href, target, children, ...props }: ButtonProps) {
  const classes = cx(/* shared classes */);

  // Polymorphic rendering
  if (href) {
    return (
      <AriaLink
        href={href}
        target={target}
        className={classes}
        {...props}
      >
        {children}
      </AriaLink>
    );
  }

  return (
    <AriaButton className={classes} {...props}>
      {children}
    </AriaButton>
  );
}

// Usage
<Button>Click me</Button>                       // Renders <button>
<Button href="/dashboard">Go to dashboard</Button>  // Renders <a>
```

**Why Button-Specific:**

- Buttons often styled as links (CTAs, navigation buttons)
- Other interactive components don't have this pattern:
  - Toggle: Always `<div role="switch">`
  - Checkbox: Always `<input type="checkbox">`
  - Select: Always custom component structure

**DO NOT Apply To:**

- Input components
- Toggle/Checkbox/Radio components
- Select/Dropdown components
- Other base/ or application/ components

**Lesson from Root Cause Analysis:**
This pattern was incorrectly assumed to be universal. It's BUTTON-SPECIFIC.

---

### 2. Color Variant System (Button Only) 🔧 COMPONENT: Button

**Status:** Used by 1/208 files (0.5%)

**Applicable To:**

- button.tsx ONLY

**NOT Applicable To:**

- 207 other files (99.5%)

**Pattern:** 9 sophisticated color variants with destructive states.

**Implementation:**

```typescript
// button.tsx

export interface ButtonProps {
  /**
   * Color variant
   *
   * Primary variants:
   * - primary: Main brand actions
   * - secondary: Alternative actions
   * - tertiary: Subtle actions
   * - link-gray: Text-only link style
   * - link-color: Colored text-only link
   *
   * Destructive variants:
   * - primary-destructive: Critical delete actions
   * - secondary-destructive: Secondary delete style
   * - tertiary-destructive: Subtle destructive
   * - link-destructive: Link-style destructive
   */
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
}

const colorStyles = {
  primary: 'bg-brand-solid text-white hover:bg-brand-solid-hover',
  secondary: 'bg-primary text-secondary ring-1 ring-primary',
  tertiary: 'text-tertiary hover:bg-tertiary',
  'link-gray': 'text-tertiary hover:text-secondary',
  'link-color': 'text-brand-solid hover:text-brand-solid-hover',
  'primary-destructive': 'bg-error-solid text-white',
  'secondary-destructive': 'bg-error-secondary text-error-primary ring-1 ring-error-primary',
  'tertiary-destructive': 'text-error-primary hover:bg-error-secondary',
  'link-destructive': 'text-error-primary hover:text-error-secondary',
};
```

**Why Button-Specific:**
Other components don't have color variants:

```typescript
// Input - NO color variants
export interface InputProps {
  // No color prop
  isInvalid?: boolean; // Validation state, not color variant
}

// Toggle - NO color variants
export interface ToggleProps {
  // No color prop
  // Uses semantic states only
}

// Table - NO color variants
export interface TableProps {
  size?: 'sm' | 'md'; // Size only
  // No color prop
}

// Select - NO color variants
export interface SelectProps {
  // No color prop
  isInvalid?: boolean; // Validation only
}
```

**Lesson from Root Cause Analysis:**
After studying Button (272 lines), I assumed 9 color variants were universal. WRONG. Only Button has this.

**DO NOT Apply To:**
ANY other component. Each component defines its own variant system based on its needs.

---

### 3. Icon-Only Detection (Button Only) 🔧 COMPONENT: Button

**Status:** Used by 1/208 files (0.5%)

**Applicable To:**

- button.tsx ONLY

**Pattern:** Automatically detects and styles icon-only buttons (no text children).

**Implementation:**

```typescript
// button.tsx

import { Children } from 'react';

export function Button({ children, iconBefore, iconAfter, ...props }: ButtonProps) {
  // Detect icon-only button
  const childrenArray = Children.toArray(children);
  const hasTextChildren = childrenArray.some(
    child => typeof child === 'string' || typeof child === 'number'
  );
  const isIconOnly = !hasTextChildren && (iconBefore || iconAfter);

  return (
    <AriaButton
      className={cx(
        // Base classes
        'inline-flex items-center',

        // Icon-only specific
        isIconOnly ? 'justify-center p-2' : 'justify-start gap-2 px-4 py-2',

        // ... rest of classes
      )}
      {...props}
    >
      {iconBefore}
      {children}
      {iconAfter}
    </AriaButton>
  );
}

// Usage
<Button iconBefore={<PlusIcon />}>Add Item</Button>  // Normal button
<Button iconBefore={<CloseIcon />} />                 // Icon-only detected
```

**Why Button-Specific:**
Other components handle icons differently:

```typescript
// Input - Icons are explicit props
<Input iconBefore={<SearchIcon />} placeholder="Search" />
// NOT auto-detected

// Select - Icons part of dropdown structure
<Select>
  <SelectTrigger icon={<ChevronIcon />} />
  {/* ... */}
</Select>
// NOT auto-detected

// Toggle - No icon support
<Toggle>Enable notifications</Toggle>
// No icon-only concept
```

**DO NOT Apply To:**
Other components. They use explicit icon props or don't support icons.

---

### 4. Size Systems (Varies by Component) 🔧 COMPONENT: Each Defines Own

**Status:** Used by 100/208 files (48%)

**Pattern:** EACH component defines its OWN size system. NOT standardized.

**Examples:**

```typescript
// Button - 4 sizes
export interface ButtonProps {
  size?: 'sm' | 'md' | 'lg' | 'xl';
}
// sm: px-3 py-1.5 text-sm
// md: px-4 py-2 text-base
// lg: px-5 py-3 text-lg
// xl: px-6 py-4 text-xl

// Input - 2 sizes
export interface InputProps {
  size?: 'sm' | 'md';
}
// sm: px-3 py-2 text-sm
// md: px-4 py-3 text-base

// Avatar - 5 sizes
export interface AvatarProps {
  size?: 'xs' | 'sm' | 'md' | 'lg' | 'xl';
}
// xs: 24px
// sm: 32px
// md: 40px
// lg: 48px
// xl: 56px

// Table - 2 sizes
export interface TableProps {
  size?: 'sm' | 'md';
}
// sm: Compact spacing
// md: Comfortable spacing

// Modal - NO size prop
export interface ModalProps {
  // No size system
  // Uses fullWidth or specific width classes
}

// Featured Icon - 6 sizes
export interface FeaturedIconProps {
  size?: 'xs' | 'sm' | 'md' | 'lg' | 'xl' | '2xl';
}
```

**Lesson from Root Cause Analysis:**
I assumed Button's 4-size system (sm/md/lg/xl) was standard. WRONG. Each component defines its own.

**Implementation Rule:**

```typescript
// When creating new component:
// 1. Check UntitledUI reference for THIS component
// 2. Document size system from reference
// 3. DO NOT assume another component's sizes apply

// ❌ WRONG - Assuming Button sizes
export interface NewComponent {
  size?: 'sm' | 'md' | 'lg' | 'xl'; // Copied from Button
}

// ✅ CORRECT - Check NewComponent in UntitledUI
export interface NewComponent {
  // If UntitledUI NewComponent has 2 sizes:
  size?: 'sm' | 'md';

  // If UntitledUI NewComponent has no sizes:
  // Don't add size prop
}
```

---

### 5. showTextWhileLoading Pattern (Button Only) 🔧 COMPONENT: Button

**Status:** Used by 1/208 files (0.5%)

**Applicable To:**

- button.tsx ONLY

**Pattern:** Loading state with option to show/hide text during loading.

**Implementation:**

```typescript
// button.tsx

export interface ButtonProps {
  /** Show loading spinner */
  loading?: boolean;
  /** Keep text visible during loading (default: false) */
  showTextWhileLoading?: boolean;
}

export function Button({
  loading,
  showTextWhileLoading = false,
  children,
  ...props
}: ButtonProps) {
  return (
    <AriaButton disabled={loading} {...props}>
      {loading && <LoadingSpinner />}
      {(!loading || showTextWhileLoading) && children}
    </AriaButton>
  );
}

// Usage
<Button loading>Saving...</Button>
// Shows: [spinner] (no text)

<Button loading showTextWhileLoading>Saving...</Button>
// Shows: [spinner] Saving...
```

**Why Button-Specific:**
Other components handle loading differently:

```typescript
// Input - No loading state
export interface InputProps {
  // No loading prop
  isDisabled?: boolean;  // Disabled only
}

// Select - No loading state (uses Popover loading)
export interface SelectProps {
  // No loading prop
}

// Table - Loading is separate component
<Table>
  {loading ? <TableLoadingSkeleton /> : <TableBody>...</TableBody>}
</Table>

// Form - Loading at form level
<Form onSubmit={handleSubmit} isLoading={loading}>
  {/* ... */}
</Form>
```

**DO NOT Apply To:**
Other components. They use component-specific loading patterns.

---

## Anti-Patterns (What NOT to Do)

Critical mistakes to avoid when implementing components.

### Anti-Pattern 1: Over-Using base-components/ ❌

**Problem:** Creating base-components/ subdirectory for every component.

**Reality:** Only 3 out of 30 component types use this pattern (10%).

**Incorrect Usage:**

```
// ❌ WRONG - Creating base-components/ unnecessarily

toggle/
├── toggle.tsx
├── base-components/              ← NOT NEEDED
│   └── toggle-track.tsx          ← Just inline this
├── toggle.demo.tsx
└── toggle.story.tsx

checkbox/
├── checkbox.tsx
├── base-components/              ← NOT NEEDED
│   └── checkbox-check-icon.tsx   ← Just inline this
├── checkbox.demo.tsx
└── checkbox.story.tsx
```

**Correct Usage:**

```
// ✅ CORRECT - Inline simple sub-components

toggle/
├── toggle.tsx                    ← Includes track inline
├── toggle.demo.tsx
└── toggle.story.tsx

checkbox/
├── checkbox.tsx                  ← Includes check icon inline
├── checkbox.demo.tsx
└── checkbox.story.tsx
```

**Decision Criteria:**

```
Create base-components/ ONLY if ALL true:
✓ 2+ variants exist
✓ Variants share >50% implementation
✓ Shared code is 3+ sub-components
✓ Sub-components NOT useful outside this component

Otherwise: Inline the code
```

**Reality Check:**

- Avatar: 4 shared sub-components ✓ (needs base-components/)
- Tags: 2 shared sub-components ✓ (needs base-components/)
- Button: 0 shared sub-components ✗ (DON'T use base-components/)
- Input: 0 shared sub-components ✗ (DON'T use base-components/)

---

### Anti-Pattern 2: Assuming Button Patterns Apply Universally ❌

**Problem:** Studying Button (272 lines), then assuming its patterns apply to all components.

**This was my ACTUAL mistake from Root Cause Analysis.**

**Incorrect Assumptions:**

```typescript
// ❌ WRONG - Assuming Button patterns apply everywhere

// Polymorphic rendering
export function Input({ href, ...props }: InputProps) {
  // NO! Input doesn't render as link
}

// Color variants
export function Toggle({ color, ...props }: ToggleProps) {
  // NO! Toggle doesn't have color variants
}

// Icon-only detection
export function Checkbox({ iconBefore, ...props }: CheckboxProps) {
  // NO! Checkbox doesn't have icon detection
}

// 9 color variants
export function Select({ color, ...props }: SelectProps) {
  // NO! Select doesn't have color prop
}
```

**Correct Approach:**

```typescript
// ✅ CORRECT - Check UntitledUI for EACH component

// Input - validation states, NOT color variants
export interface InputProps {
  isInvalid?: boolean;
  isDisabled?: boolean;
  // No color prop
}

// Toggle - state only
export interface ToggleProps {
  isDisabled?: boolean;
  // No color, no icons
}

// Checkbox - state only
export interface CheckboxProps {
  isIndeterminate?: boolean;
  isDisabled?: boolean;
  // No icons, no color
}

// Select - size and validation
export interface SelectProps {
  size?: 'sm' | 'md'; // Different from Button's 4 sizes
  isInvalid?: boolean;
  // No color variants
}
```

**Lesson:** Each component defines its OWN API based on its purpose. NO universal variant pattern.

---

### Anti-Pattern 3: Hardcoding Colors or Spacing ❌

**Problem:** Using hardcoded Tailwind values instead of design tokens.

**Incorrect Usage:**

```typescript
// ❌ WRONG - Hardcoded values

className = 'bg-blue-600 text-white'; // Specific blue
className = 'hover:bg-blue-700'; // Specific hover
className = 'border border-gray-300'; // Specific gray
className = 'px-4 py-2'; // OK for this one
className = 'text-[#64748B]'; // Arbitrary color
className = 'shadow-[0_1px_2px_rgba(0,0,0,0.05)]'; // Arbitrary shadow
```

**Correct Usage:**

```typescript
// ✅ CORRECT - Semantic design tokens

className = 'bg-brand-solid text-white'; // Brand color
className = 'hover:bg-brand-solid-hover'; // Brand hover
className = 'border border-primary'; // Primary border
className = 'px-4 py-2'; // Standard spacing (OK)
className = 'text-fg-quaternary'; // Quaternary text
className = 'shadow-xs'; // Extra small shadow
```

**Why This Matters:**

1. **Theming:** Design tokens enable light/dark mode
2. **Consistency:** Single source of truth for colors
3. **Maintenance:** Change token, updates everywhere
4. **Brand:** Easy brand color customization

**Exception:**
Standard spacing (`px-4 py-2`) is OK because Tailwind spacing scale is semantic.

---

### Anti-Pattern 4: Creating All Variants in Single File ❌

**Problem:** Putting all variants as props on single component instead of separate files.

**Incorrect Usage:**

```typescript
// ❌ WRONG - All variants in one file via props

export interface ButtonProps {
  variant?: 'standard' | 'social' | 'appStore' | 'utility' | 'close';
  socialPlatform?: 'facebook' | 'twitter' | 'google' | 'github';
  appStore?: 'apple' | 'google';
  isUtility?: boolean;
  isClose?: boolean;
}

export function Button({ variant, socialPlatform, appStore, ...props }: ButtonProps) {
  if (variant === 'social') {
    // Social button logic + styling
  }
  if (variant === 'appStore') {
    // App store button logic + styling
  }
  // ... 500+ lines of conditional logic
}
```

**Correct Usage:**

```typescript
// ✅ CORRECT - Separate files for different interaction models

buttons/
├── button.tsx              ← Core button (272 lines)
├── social-button.tsx       ← Social media buttons
├── app-store-buttons.tsx   ← App store buttons
├── button-utility.tsx      ← Icon-only utility buttons
├── close-button.tsx        ← Specialized close button
├── buttons.demo.tsx
└── buttons.story.tsx
```

**Decision Criteria:**

```
Create separate variant file when:
✓ Different interaction model (Select vs MultiSelect)
✓ Platform-specific (iOS vs Android button)
✓ Specialized styling (Social media buttons)
✓ Significantly different prop API

Use props for variants when:
✓ Same interaction, different styling (primary/secondary)
✓ Size variations (sm/md/lg)
✓ State variations (loading/disabled)
```

**Why Separate Files:**

- Type safety (each variant has specific props)
- Discoverability (file explorer shows all variants)
- Maintainability (smaller, focused files)
- API clarity (clear component names)

---

### Anti-Pattern 5: Not Using React Aria for Interactive Components ❌

**Problem:** Building interactive components without React Aria foundation.

**Incorrect Usage:**

```typescript
// ❌ WRONG - Manual accessibility implementation

export function Toggle({ checked, onChange }: ToggleProps) {
  return (
    <div
      role="switch"                          // Manual role
      aria-checked={checked}                 // Manual aria
      tabIndex={0}                           // Manual focus
      onClick={() => onChange(!checked)}     // Manual click
      onKeyDown={(e) => {                    // Manual keyboard
        if (e.key === ' ') onChange(!checked);
      }}
      className="toggle"
    >
      {/* ... */}
    </div>
  );
}
// Missing: Focus management, disabled state, screen reader announcements, etc.
```

**Correct Usage:**

```typescript
// ✅ CORRECT - React Aria foundation

import { Switch } from 'react-aria-components';

export function Toggle(props: ToggleProps) {
  return (
    <Switch className="toggle" {...props}>
      {/* ... */}
    </Switch>
  );
}
// Includes: Correct ARIA, keyboard navigation, focus management, disabled state,
//           screen reader support, state management, browser compatibility
```

**What React Aria Provides Automatically:**

1. **Semantic HTML** - Correct element types
2. **ARIA Attributes** - All required ARIA
3. **Keyboard Navigation** - Tab, Space, Enter, Arrows
4. **Focus Management** - Correct focus order and trap
5. **Screen Reader Support** - Proper announcements
6. **State Management** - Selected, disabled, invalid
7. **Browser Compatibility** - Cross-browser consistency

**When NOT to Use React Aria:**

- Non-interactive visual elements (illustrations, patterns)
- Static content (text, images, dividers)
- foundations/ components (icons, visual primitives)

**Reality:** 100% of interactive components in UntitledUI use React Aria.

---

## Pattern Usage Statistics

Quantitative data from Phase 0.1 analysis across 208 component files.

### Universal Patterns (100% Usage)

| Pattern                  | Files Using | Percentage          | Scope Label  |
| ------------------------ | ----------- | ------------------- | ------------ |
| Design token system      | 208/208     | 100%                | 🌐 UNIVERSAL |
| cx() utility             | 208/208     | 100%                | 🌐 UNIVERSAL |
| TypeScript types         | 208/208     | 100%                | 🌐 UNIVERSAL |
| Component file triplet   | 208/208     | 100%                | 🌐 UNIVERSAL |
| React Aria (interactive) | 47/47       | 100% of interactive | 🌐 UNIVERSAL |

### Category Patterns

| Pattern                       | Files Using | Percentage | Scope Label                               |
| ----------------------------- | ----------- | ---------- | ----------------------------------------- |
| React Aria Components         | 47/208      | 23%        | 🏗️ CATEGORY: Interactive                  |
| Context API                   | 13/208      | 6%         | 🏗️ CATEGORY: Complex                      |
| Composition architecture      | 20/208      | 10%        | 🏗️ CATEGORY: application/ + complex base/ |
| base-components/ subdirectory | 3/30 types  | 10%        | 🏗️ CATEGORY: Avatar, Tags, AppNavigation  |

### Component-Specific Patterns

| Pattern                           | Files Using | Percentage | Scope Label                    |
| --------------------------------- | ----------- | ---------- | ------------------------------ |
| Polymorphic rendering             | 3/208       | 1.4%       | 🔧 COMPONENT: Button family    |
| Color variant system (9 variants) | 1/208       | 0.5%       | 🔧 COMPONENT: Button           |
| Icon-only detection               | 1/208       | 0.5%       | 🔧 COMPONENT: Button           |
| showTextWhileLoading              | 1/208       | 0.5%       | 🔧 COMPONENT: Button           |
| Size systems (varies)             | 100/208     | 48%        | 🔧 COMPONENT: Each defines own |

### File Structure Patterns

| Pattern                        | Components Using | Percentage |
| ------------------------------ | ---------------- | ---------- |
| Simple component (single .tsx) | 12/30 types      | 40%        |
| Variant-heavy (multiple files) | 15/30 types      | 50%        |
| With base-components/          | 3/30 types       | 10%        |
| Complex with subdirectories    | 2/30 types       | 7%         |

### Complexity Distribution (base/ components)

| Complexity | Line Count    | Files | Percentage |
| ---------- | ------------- | ----- | ---------- |
| Simple     | <100 lines    | 19/46 | 40%        |
| Medium     | 100-300 lines | 23/46 | 49%        |
| Complex    | >300 lines    | 5/46  | 11%        |

**Largest Components:**

1. app-store-buttons.tsx: 567 lines
2. badges.tsx: 417 lines
3. file-upload-base.tsx: 396 lines
4. multi-select.tsx: 363 lines
5. pagination-base.tsx: 378 lines

---

## Pattern Application Guide

How to apply patterns when creating new components.

### Step 1: Identify Component Category

```
Is this component:
├─ Interactive primitive? → base/
├─ Complex application UI? → application/
├─ Visual element/icon? → foundations/ or shared-assets/
└─ Internal utility? → internal/
```

### Step 2: Check Universal Patterns (ALWAYS Apply)

```typescript
// ✅ ALWAYS include:
1. Design tokens (NOT hardcoded colors)
2. cx() utility for class merging
3. TypeScript types with exported interface
4. Component file triplet (.tsx, .demo.tsx, .story.tsx)
5. React Aria (if interactive)
```

### Step 3: Check Category Patterns

```
base/ component:
├─ Simple (<100 lines)? → Single file, no Context
├─ Medium (100-300 lines)? → Check if needs variants
└─ Complex (>300 lines)? → Consider Context API or variants

application/ component:
├─ Always uses composition (Component.SubComponent)
├─ Often uses Context API
└─ Composes base/ components
```

### Step 4: Check Component-Specific Patterns

```
DO NOT assume patterns from other components.

Check UntitledUI reference for THIS component:
1. Does it have size system? (many do, but sizes vary)
2. Does it have color variants? (rare - mostly Button)
3. Does it have icon support? (varies by component)
4. Does it render polymorphically? (rare - Button family)
```

### Step 5: Verify Pattern Scope

```
Before using a pattern:
1. Label it: UNIVERSAL / CATEGORY / COMPONENT
2. Verify: Check usage statistics above
3. Validate: Does this match UntitledUI reference?
```

### Example: Creating New Component

```typescript
// Creating new "Badge" component

// Step 1: Category
// Badge is interactive primitive → base/

// Step 2: Universal patterns
import { cx } from '@/utils/cx';  ✅
// Use design tokens ✅
// Export interface ✅
// Create .demo.tsx and .story.tsx ✅

// Step 3: Category patterns (base/)
// Check UntitledUI badges.tsx:
// - 417 lines (Complex)
// - 25+ variants
// Decision: Use variant files

// Step 4: Component-specific
// Check UntitledUI badges.tsx:
// - No polymorphic rendering ✅
// - No color prop (uses variant names instead) ✅
// - No icon-only detection ✅
// - Has size system: Check UntitledUI sizes

// Step 5: Verify
// ALL patterns labeled and verified against UntitledUI
```

---

## Pattern Evolution Guidelines

How patterns should evolve as the library grows.

### Adding New Patterns

**Before adding a new pattern:**

1. **Check if pattern exists** in UntitledUI reference
2. **Document scope** (UNIVERSAL / CATEGORY / COMPONENT)
3. **Verify usage** across multiple components
4. **Get user approval** before generalizing

**Example:**

```
Discovered pattern: "Badge count indicator on avatars"

Check UntitledUI:
✓ Avatar has badge count
✗ Button does NOT have badge count
✗ Input does NOT have badge count

Conclusion: COMPONENT-specific (Avatar only)
Label: 🔧 COMPONENT: Avatar
DO NOT generalize to other components
```

### Promoting Patterns

**Pattern promotion path:**

```
COMPONENT (1-2 files)
    ↓ (If used by 3+ components in same category)
CATEGORY (3-10 files in same category)
    ↓ (If used by ALL categories)
UNIVERSAL (100% usage)
```

**Criteria for promotion:**

```
COMPONENT → CATEGORY:
✓ Used by 3+ components in same category
✓ Provides clear value
✓ Consistent implementation

CATEGORY → UNIVERSAL:
✓ Used by 100% of components in that category
✓ Used by ALL categories (base/, application/, etc.)
✓ No exceptions
```

### Deprecating Patterns

**When to deprecate:**

```
Deprecate if:
✗ Used by <2 components
✗ Better pattern exists
✗ Creates more complexity than value
✗ Conflicts with React Aria
```

### Pattern Documentation Requirements

**Every pattern must document:**

1. **Scope label** (🌐 UNIVERSAL / 🏗️ CATEGORY / 🔧 COMPONENT)
2. **Usage statistics** (X/Y files, Z%)
3. **Applicable to** (which components/categories)
4. **NOT applicable to** (which components/categories)
5. **Implementation example**
6. **Rationale** (why this pattern exists)
7. **Decision criteria** (when to use/not use)

---

## Summary

### Pattern Scope Distribution

- **🌐 UNIVERSAL (5 patterns):** Design tokens, cx(), React Aria, TypeScript, File triplet
- **🏗️ CATEGORY (4 patterns):** Context API, Composition, base-components/, Integration
- **🔧 COMPONENT (5+ patterns):** Polymorphic, Color variants, Icon-only, showTextWhileLoading, Size systems

### Critical Lessons

1. **Pattern scope determines applicability** - Label everything
2. **Button patterns are NOT universal** - Check each component
3. **Only 3 components use base-components/** - Don't overuse
4. **100% of interactive components use React Aria** - No exceptions
5. **Each component defines its own API** - No standard variant system

### Implementation Checklist

When creating new component:

- [ ] Apply all 5 UNIVERSAL patterns
- [ ] Check category-specific patterns
- [ ] DO NOT assume component-specific patterns apply
- [ ] Verify against UntitledUI reference
- [ ] Label all patterns with scope
- [ ] Document any new patterns discovered

---

**Document Status:** Phase 0.5 Complete (4 of 5 master documents)

**Next:** INTEGRATION-GUIDE.md - How components work together, composition strategies, dependency graph

**See Also:**

- COMPONENT-TAXONOMY.md - Component organization and categories
- SYSTEM-ARCHITECTURE.md - Overall system architecture
- DOCUMENTATION-SITE-MAPPING.md - Site to code mapping
