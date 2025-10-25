# UntitledUI System Architecture

**Date:** 2025-10-25
**Purpose:** Complete system overview and architectural understanding
**Status:** Phase 0.5 Deliverable (Master Documentation Suite)

---

## Executive Summary

UntitledUI is a production-ready component library with **30 component types** organized across **5 major categories**, implemented in **79 core files** with **208+ total files** including demos, stories, and utilities. The system demonstrates sophisticated architectural patterns ranging from simple primitives (40% under 100 lines) to complex compositions (11% over 300 lines).

**Core Architectural Principles:**

1. **Category Separation** - base/ (primitives), application/ (compositions), foundations/ (design primitives)
2. **Variant as File** - Different behaviors = different files, not just props
3. **Selective Abstraction** - base-components/ used sparingly (only 3 components)
4. **React Aria Foundation** - Universal accessibility framework (23% of files)
5. **Composition Over Configuration** - Application components compose base components

**System Scope:**

- **React Component Library**: 30 component types, 79 implementation files
- **Next.js Starter Kit**: Marketing pages and compositions
- **Documentation Site**: ~1,200+ visual variants and page examples
- **Total Code Base**: 208+ files across 5 categories

---

## Critical Terminology: What "Component" Means in Different Contexts

**⚠️ WARNING:** The word "component" has DIFFERENT meanings. DO NOT conflate them.

**1. Primitive Component** (e.g., Input field, Toggle, Checkbox)

- Basic building block in the library
- Single responsibility
- **Location:** `base/`
- **Example:** Input field (`base/input/input.tsx`) - text input for forms
- **In library:** ✅ Yes

**2. Layout Component** (e.g., Sidebar navigation)

- Structural/organizational component
- Defines application structure
- **Location:** `application/app-navigation/`
- **Example:** Sidebar (`application/app-navigation/sidebar-navigation/sidebar-simple.tsx`)
- **In library:** ✅ Yes

**3. Application Component** (e.g., Table, Modal, Tabs)

- Complex composed UI
- Integrates multiple primitive components
- **Location:** `application/`
- **Example:** Table (`application/table/table.tsx`) - integrates Checkbox, Dropdown, Badge
- **In library:** ✅ Yes

**4. Specialized Display Component** (e.g., Code snippet, QR code, Illustration)

- Specific-purpose display
- Not general-purpose UI
- **Location:** `foundations/` or `shared-assets/`
- **Example:** QR code (`shared-assets/qr-code/`)
- **In library:** ✅ Yes

**5. Page Template** (e.g., 404 page, Login page) - ⚠️ **NOT A COMPONENT**

- Complete page composition
- USES library components, NOT IN the library
- **Location:** `pages/` or Next.js `src/app/`
- **Example:** 404 page = Illustration + Input + Button composed together
- **In library:** ❌ NO

**6. Component Library** (the entire project)

- Collection of components #1-4 above
- The system as a whole
- NOT a single component

---

## Part 1: High-Level System Architecture

### System Overview Diagram

```
UntitledUI System
│
├─── React Component Library (UPSTREAM/react/)
│    │
│    ├─── base/ (18 component types)
│    │    ├── Interactive primitives (Button, Toggle, Checkbox, Radio)
│    │    ├── Form inputs (Input, Textarea, Select, Slider)
│    │    ├── Visual feedback (Avatar, Badge, Tooltip, Progress)
│    │    └── Support components (ButtonGroup, Form, FileUploadTrigger)
│    │
│    ├─── application/ (12 component types)
│    │    ├── Navigation (AppNavigation)
│    │    ├── Data display (Table, Charts, Tabs)
│    │    ├── Overlays (Modals, SlideoutMenus)
│    │    ├── Navigation patterns (Pagination, Carousel)
│    │    └── Feedback (DatePicker, FileUpload, EmptyState, LoadingIndicator)
│    │
│    ├─── foundations/ (Design primitives - NOT interactive)
│    │    ├── Icons (FeaturedIcon, SocialIcons, PaymentIcons, Logo)
│    │    └── Visual elements (RatingBadge, RatingStars, DotIcon, PlayButton)
│    │
│    ├─── shared-assets/ (Visual elements - NOT interactive)
│    │    ├── Background patterns (circle, grid, square)
│    │    ├── Illustrations (box, cloud, credit-card, documents)
│    │    └── Visual components (CreditCard, QRCode, iPhoneMockup, SectionDivider)
│    │
│    └─── internal/ (Utilities)
│         └── Hooks, utils, contexts
│
└─── Next.js Starter Kit (UPSTREAM/untitledui-nextjs-starter-kit/)
     │
     ├─── components/marketing/ (1 component in React lib)
     │    └── header-navigation/
     │
     └─── src/app/ (Next.js pages - marketing compositions)
          ├── Page examples (landing, pricing, about, contact, etc.)
          └── Marketing sections (hero, features, testimonials, CTAs, footers)
```

---

## Part 2: Category Architecture

### Category 1: base/ - Primitive Components

**Purpose:** Foundational, reusable UI primitives with single responsibility

**Characteristics:**

- Minimal dependencies (only on React Aria, design tokens, cx())
- High reusability across different contexts
- Focus on accessibility and interaction patterns
- Well-defined, focused APIs

**Component Count:** 18 component types, 46 implementation files

**Complexity Distribution:**

- Simple (<100 lines): 40% - Toggle, Checkbox, Tooltip, Modal
- Medium (100-300 lines): 49% - Button, Input, Select, Pagination
- Complex (>300 lines): 11% - AppStoreButtons, Badges, Multi-Select

**Architecture Patterns:**

1. **Single-File Components** (40% of base/)

   ```
   toggle/
   ├── toggle.tsx (implementation)
   ├── toggle.demo.tsx (usage examples)
   └── toggle.story.tsx (storybook)
   ```

   - **Used When:** Simple, single-responsibility component
   - **Examples:** Toggle, Checkbox, Tooltip, Form
   - **Complexity:** <100 lines typically

2. **Variant-Heavy Components** (50% of base/)

   ```
   buttons/
   ├── button.tsx (core implementation)
   ├── social-button.tsx (social media styled)
   ├── app-store-buttons.tsx (app store styled)
   ├── button-utility.tsx (icon-only)
   ├── close-button.tsx (specialized close)
   ├── buttons.demo.tsx
   └── buttons.story.tsx
   ```

   - **Used When:** Different interaction models or specialized styling
   - **Examples:** Buttons (5 files), Select (6 files), Pagination (4 files)
   - **Complexity:** 100-300 lines per variant

3. **Components with base-components/** (6% of base/)
   ```
   avatar/
   ├── avatar.tsx
   ├── avatar-profile-photo.tsx
   ├── avatar-label-group.tsx
   ├── base-components/ (shared sub-components)
   │   ├── avatar-add-button.tsx
   │   ├── avatar-company-icon.tsx
   │   ├── avatar-online-indicator.tsx
   │   └── verified-tick.tsx
   ├── avatar.demo.tsx
   ├── avatar.story.tsx
   └── utils.ts
   ```
   - **Used When:** Variants share significant implementation (>50%)
   - **Examples:** Avatar, Tags, AppNavigation (only 3 components)
   - **Complexity:** 100-200 lines + shared sub-components

**Component Types:**

| Category             | Components                          | Files    | Complexity Range |
| -------------------- | ----------------------------------- | -------- | ---------------- |
| Interactive Inputs   | Buttons, Toggle, Checkbox, Radio    | 11 files | 42-567 lines     |
| Form Inputs          | Input, Textarea, PinInput           | 3 files  | 163-271 lines    |
| Selection Controls   | Dropdown, Select, Slider            | 8 files  | 163-363 lines    |
| Content Organization | Tags, Badges, ButtonGroup           | 3 files  | 163-417 lines    |
| Visual Feedback      | Avatar, Tooltip, ProgressIndicators | 5 files  | 42-163 lines     |
| Support Components   | Form, FileUploadTrigger             | 2 files  | 163 lines avg    |

---

### Category 2: application/ - Complex Application UI

**Purpose:** Complex, composed application patterns for dashboard/SaaS interfaces

**Characteristics:**

- Compose multiple base components
- Higher complexity (average 200+ lines)
- Application-specific logic and state management
- Context API usage (for complex state sharing)

**Component Count:** 12 component types, 33 implementation files

**Complexity Distribution:**

- Simple (42 lines): Modal (wrapper around React Aria)
- Medium (100-300 lines): Tabs, FileUpload, EmptyState
- Complex (>300 lines): Table (300), Pagination (330), App-Navigation (14 files)

**Architecture Patterns:**

1. **Simple Wrappers** (17% of application/)

   ```
   modals/
   ├── modal.tsx (42 lines - wraps React Aria)
   ├── modals.demo.tsx (demonstrates 46 variants)
   └── modals.story.tsx
   ```

   - **Used When:** React Aria provides core functionality, just need styling
   - **Examples:** Modal
   - **Pattern:** Thin wrapper, variants in demos/compositions

2. **Composition-Heavy Components** (50% of application/)

   ```
   table/
   ├── table.tsx (300 lines)
   │   Integrates: Checkbox, Dropdown, Badge, Tooltip
   ├── table.demo.tsx
   └── table.story.tsx
   ```

   - **Used When:** Component needs multiple base components
   - **Examples:** Table, AppNavigation, Tabs
   - **Pattern:** Import and compose base components

3. **Complex with Subdirectories** (8% of application/)
   ```
   app-navigation/ (14 files total)
   ├── header-navigation.tsx
   ├── sidebar-navigation-base.tsx
   ├── sidebar-navigation/
   │   ├── sidebar-dual-tier.tsx
   │   ├── sidebar-section-dividers.tsx
   │   ├── sidebar-simple.tsx
   │   └── sidebar-slim.tsx
   ├── base-components/
   │   ├── mobile-header.tsx
   │   ├── nav-account-card.tsx
   │   ├── nav-item-button.tsx
   │   └── nav-item.tsx
   ├── config.ts
   ├── *.demo.tsx
   └── *.story.tsx
   ```
   - **Used When:** Multiple variant families + shared sub-components
   - **Examples:** AppNavigation (only 1 component at this scale)
   - **Pattern:** Subdirectories for variant families, base-components/ for shared code

**Component Integration Map:**

```
Application Components → Base Components

Table →
  ├── Checkbox (row selection)
  ├── Dropdown (actions menu)
  ├── Badge (status indicators)
  └── Tooltip (info hints)

AppNavigation →
  ├── Button (nav items, CTAs)
  ├── Avatar (user profile)
  ├── Badge (notification counts)
  └── Dropdown (user menu)

Tabs →
  └── Button (tab buttons)

FileUpload →
  ├── Button (upload trigger)
  └── ProgressIndicators (upload progress)

DatePicker →
  └── Input (date input field)
```

**Component Types:**

| Subcategory  | Components                                           | Complexity      | Integration                          |
| ------------ | ---------------------------------------------------- | --------------- | ------------------------------------ |
| Navigation   | AppNavigation                                        | High (14 files) | Button, Avatar, Badge, Dropdown      |
| Data Display | Table, Charts, Tabs                                  | Medium-High     | Checkbox, Dropdown, Badge, Tooltip   |
| Overlays     | Modals, SlideoutMenus                                | Low-Medium      | Simple wrappers or basic composition |
| Patterns     | Pagination, Carousel                                 | Medium          | Button (for navigation)              |
| Feedback     | DatePicker, FileUpload, EmptyState, LoadingIndicator | Medium          | Input, Button, ProgressIndicators    |

---

### Category 3: foundations/ - Design Primitives

**Purpose:** Design system foundations and visual primitives (NOT interactive components)

**Characteristics:**

- Visual elements, not interactive UI components
- Icons and branding assets
- Used by both base/ and application/ components
- No React Aria (nothing to interact with)

**Components:**

- **Icons:** FeaturedIcon, SocialIcons, PaymentIcons, Logo
- **Visual Elements:** RatingBadge, RatingStars, PlayButtonIcon, DotIcon

**Usage Pattern:**

- Base components import icons: Button uses icons for iconBefore/iconAfter
- Application components use icons: Table uses icons for sort indicators
- NOT standalone interactive components

**Key Distinction:** foundations/ provides visual primitives, NOT interactive components. If it handles user interaction, it belongs in base/ or application/.

---

### Category 4: shared-assets/ - Visual Assets

**Purpose:** Shared visual elements and graphics (NOT interactive components)

**Characteristics:**

- Purely visual, no interaction
- Illustrations and background patterns
- Used for visual richness in pages
- SVG-based graphics

**Assets:**

- **Background Patterns:** Circle, grid, square patterns
- **Illustrations:** Box, cloud, credit-card, documents, etc.
- **Visual Components:** CreditCard, QRCode, iPhoneMockup, SectionDivider

**Usage Pattern:**

- Marketing pages use for visual enhancement
- Not composed with interactive components
- Static visual elements

---

### Category 5: internal/ - Utilities

**Purpose:** Internal utilities not exposed in public API

**Characteristics:**

- Hooks, utils, contexts
- Implementation details
- Not analyzed in Phase 0 (not public API)

---

## Part 3: Cross-Category Patterns

### Universal Patterns (100% Usage)

These patterns appear in ALL interactive components:

1. **Design Token System**

   - Semantic color tokens: `bg-brand-solid`, `text-fg-quaternary`, `ring-primary`
   - NO hardcoded colors: `bg-blue-600`, `text-gray-900`
   - Enables theming and dark mode
   - **Usage:** 100% of components

2. **cx() Utility for Class Merging**

   - Handles conditional classes
   - Merges with user-provided className prop
   - Pattern: `cx(baseClasses, conditionalClasses, props.className)`
   - **Usage:** 100% of components

3. **TypeScript Type Safety**

   - All components fully typed
   - Props interfaces exported
   - React Aria types leveraged
   - **Usage:** 100% of components

4. **Component File Triplet**
   - component.tsx (implementation)
   - component.demo.tsx (usage examples)
   - component.story.tsx (storybook stories)
   - **Usage:** 100% of component types

---

### Category Patterns (6-23% Usage)

These patterns appear within specific categories:

1. **React Aria Components** (23% of all files)

   - ALL base/ interactive components use React Aria
   - ALL application/ components use React Aria
   - foundations/ and shared-assets/ do NOT use React Aria
   - **Provides:** Accessibility, keyboard navigation, ARIA attributes, focus management
   - **Usage:** 47 files (100% of interactive components)

2. **Context API** (6% of all files)

   - Used by complex/composed components only
   - Pattern: Share state between parent and children
   - **Examples:** RadioButtons, Select, MultiSelect, Tags, Input, PinInput, ButtonGroup, Tabs, Table, EmptyState, Pagination, Carousel
   - **Usage:** 13 files (complex components only)

3. **base-components/ Subdirectory** (1.5% of component types)
   - Used when variants share significant implementation
   - **Examples:** Avatar (shared: add-button, company-icon, online-indicator, verified-tick), Tags, AppNavigation (shared: nav items, account card)
   - **Usage:** 3 components only
   - **Criterion:** 2+ variants share >50% implementation

---

### Component-Specific Patterns (<5% Usage)

These patterns appear in individual components only:

1. **Polymorphic Rendering** (href → AriaLink) (1.4% of files)

   - Button renders as `<button>` or `<a>` based on href prop
   - Semantic HTML: buttons perform actions, links navigate
   - **Examples:** button.tsx, button-utility.tsx, social-button.tsx
   - **Usage:** 3 files (Button family only)
   - **NOT universal** - Other components don't use this pattern

2. **Color Variant System** (0.5% of files)

   - 9 color variants: primary, secondary, tertiary, link-gray, link-color, primary-destructive, secondary-destructive, tertiary-destructive, link-destructive
   - **Examples:** button.tsx
   - **Usage:** 1 file (Button only)
   - **NOT universal** - Other components use different variant strategies

3. **Size Systems** (48% of files)

   - sm/md/lg/xl sizing, but VARIES by component
   - Button: 4 sizes (sm, md, lg, xl)
   - Input: 2 sizes (sm, md)
   - Avatar: 5 sizes (xs, sm, md, lg, xl)
   - FeaturedIcon: 6 sizes (xs, sm, md, lg, xl, 2xl)
   - Modal: No size prop
   - **Usage:** 100 files (48% of total)
   - **Pattern:** Each component defines its own size system

4. **Icon-Only Detection** (Button-specific)
   - Detects when button has no text children
   - Applies square padding (not rectangular)
   - **Examples:** button.tsx
   - **Usage:** Button only
   - **NOT universal**

---

## Part 4: Dependency Architecture

### Dependency Hierarchy

```
┌─────────────────────────────────────────────────────────┐
│ Next.js Pages (Marketing compositions)                  │
│ Landing, Pricing, About, Contact, Blog, etc.           │
└─────────────────────────────────────────────────────────┘
                           ↓ uses
┌─────────────────────────────────────────────────────────┐
│ application/ Components                                 │
│ AppNavigation, Table, Modals, Tabs, etc.               │
└─────────────────────────────────────────────────────────┘
                           ↓ composes
┌─────────────────────────────────────────────────────────┐
│ base/ Components                                        │
│ Button, Input, Checkbox, Avatar, Badge, etc.           │
└─────────────────────────────────────────────────────────┘
                           ↓ uses
┌─────────────────────────────────────────────────────────┐
│ foundations/ + Design Tokens + React Aria              │
│ Icons, Design tokens, cx() utility, React Aria         │
└─────────────────────────────────────────────────────────┘
```

**Dependency Rules:**

1. **application/** may depend on **base/**
2. **base/** may depend on **foundations/** and **React Aria**
3. **foundations/** has no component dependencies
4. **base/** components do NOT depend on each other (exception: ButtonGroup depends on Button)
5. **Circular dependencies** are NOT allowed

---

### Integration Dependency Map

**Table Component Integration:**

```
Table (application/)
│
├─→ Checkbox (base/) - Row selection
├─→ Dropdown (base/) - Action menus
├─→ Badge (base/) - Status indicators
└─→ Tooltip (base/) - Information hints
```

**AppNavigation Component Integration:**

```
AppNavigation (application/)
│
├─→ Button (base/) - Nav items, CTAs
├─→ Avatar (base/) - User profile
├─→ Badge (base/) - Notification counts
└─→ Dropdown (base/) - User menu
```

**Button Component Dependencies:**

```
Button (base/)
│
├─→ React Aria (AriaButton, AriaLink)
├─→ Design tokens (bg-brand-solid, etc.)
├─→ cx() utility (class merging)
└─→ FeaturedIcon (foundations/) - Optional icon support
```

**Select Component Family:**

```
Select Family (base/select/)
│
├─→ select.tsx (core)
├─→ combobox.tsx (extends core)
├─→ multi-select.tsx (extends core)
├─→ select-native.tsx (fallback)
│
Shared:
├─→ select-item.tsx (used by all)
└─→ popover.tsx (used by all)
```

---

## Part 5: Variant Architecture Strategy

### Why "Variant as File" Pattern

**Alternative Rejected:** Single component file with variant props

```typescript
// ❌ NOT how UntitledUI works
<Button variant="social" platform="facebook" />
<Button variant="appStore" store="apple" />
<Button variant="utility" iconOnly />
```

**Actual Pattern:** Separate files for different interaction models

```typescript
// ✅ How UntitledUI actually works
<Button color="primary" size="md">Click</Button>
<SocialButton platform="facebook" />
<AppStoreButton store="apple" />
<ButtonUtility icon={<CloseIcon />} />
```

**Rationale:**

1. **Different Behavior**: Social buttons have platform-specific styling, app store buttons have store-specific layouts
2. **Type Safety**: Each variant has different prop types (Button doesn't have `platform` prop)
3. **API Clarity**: `<SocialButton platform="facebook" />` clearer than `<Button variant="social" platform="facebook" />`
4. **Discoverability**: File explorer shows all variants, don't need to read docs

---

### Variant Decision Criteria

**When to Create Separate Variant File:**

1. **Different Interaction Model**

   - Example: Select (dropdown) vs. Combobox (searchable) vs. MultiSelect (checkboxes)
   - Different user interaction patterns

2. **Platform-Specific Implementation**

   - Example: AppStoreButton (iOS), AppStoreButton (Android)
   - Different visual specifications per platform

3. **Specialized Styling** that doesn't fit into size/color variants
   - Example: SocialButton (brand-specific colors), CloseButton (specialized icon-only)

**When to Use Props Instead:**

1. **Size Variations** (sm/md/lg/xl)

   - Same behavior, different dimensions
   - Example: `<Button size="lg" />`

2. **Color Variations** within same interaction model

   - Same behavior, different colors
   - Example: `<Button color="primary" />` vs `<Button color="secondary" />`

3. **State Variations** (loading, disabled, error)
   - Temporary states, not persistent variants
   - Example: `<Button loading />`

---

### Variant Naming Conventions

**Pattern:** `{ComponentName}-{SpecializationType}.tsx`

**Examples:**

- `button.tsx` - Core/default implementation
- `social-button.tsx` - Social media specialized
- `app-store-buttons.tsx` - App store specialized
- `button-utility.tsx` - Utility specialized (icon-only)
- `close-button.tsx` - Close action specialized

**Pattern:** `{ComponentName}-{InteractionModel}.tsx`

**Examples:**

- `select.tsx` - Standard dropdown
- `combobox.tsx` - Searchable dropdown
- `multi-select.tsx` - Multiple selection
- `select-native.tsx` - Native browser select

**Pattern:** `{ComponentName}-{VisualVariant}.tsx`

**Examples:**

- `avatar.tsx` - Standard avatar
- `avatar-profile-photo.tsx` - Profile photo style
- `avatar-label-group.tsx` - With text labels

---

## Part 6: Complexity Management

### Component Complexity Spectrum

**Simple Components (<100 lines) - 40% of base/**

**Characteristics:**

- Single responsibility
- Minimal props (5-8 props)
- No composition
- Thin wrapper around React Aria or simple implementation

**Examples:** Toggle, Checkbox, Tooltip, Modal

**File Structure:**

```
toggle/
├── toggle.tsx (1 file, <100 lines)
├── toggle.demo.tsx
└── toggle.story.tsx
```

**When to Use This Pattern:**

- Component has clear, narrow scope
- No significant variations needed
- Interaction model is standard (React Aria handles it)

---

**Medium Components (100-300 lines) - 49% of base/**

**Characteristics:**

- Multiple responsibilities or configurations
- Moderate props (12-15 props)
- May include icon support, loading states
- Variant system via props

**Examples:** Button (271 lines), Input (271 lines), Select (core)

**File Structure (Simple Variant):**

```
button/
├── button.tsx (1 file, 271 lines)
├── buttons.demo.tsx
└── buttons.story.tsx
```

**File Structure (Variant-Heavy):**

```
select/
├── select.tsx (core, 100-200 lines)
├── combobox.tsx (variant, 100-200 lines)
├── multi-select.tsx (variant, 363 lines)
├── select-native.tsx (fallback)
├── select-item.tsx (shared)
├── popover.tsx (shared)
├── select.demo.tsx
└── select.story.tsx
```

**When to Use This Pattern:**

- Component needs configuration options
- Multiple interaction variations exist
- Some shared sub-components needed

---

**Complex Components (>300 lines) - 11% of base/**

**Characteristics:**

- Multiple responsibilities and deep composition
- Many props (20+ props) or sub-component APIs
- Significant state management
- May use Context API
- Often integrates multiple base components

**Examples:** Table (300 lines), Pagination (330 lines + variants), AppStoreButtons (567 lines), AppNavigation (14 files)

**File Structure (Integrated):**

```
table/
├── table.tsx (300 lines, integrates 4 base components)
├── table.demo.tsx
└── table.story.tsx
```

**File Structure (Maximum Complexity):**

```
app-navigation/ (14 files total)
├── header-navigation.tsx
├── sidebar-navigation-base.tsx
├── sidebar-navigation/
│   ├── sidebar-dual-tier.tsx
│   ├── sidebar-section-dividers.tsx
│   ├── sidebar-simple.tsx
│   └── sidebar-slim.tsx
├── base-components/
│   ├── mobile-header.tsx
│   ├── nav-account-card.tsx
│   ├── nav-item-button.tsx
│   └── nav-item.tsx
├── config.ts
├── *.demo.tsx
└── *.story.tsx
```

**When to Use This Pattern:**

- Component orchestrates multiple sub-components
- Multiple variant families exist
- Significant shared implementation across variants
- Complex state management required

---

### Complexity Thresholds

| Threshold    | Line Count    | Recommended Action                              |
| ------------ | ------------- | ----------------------------------------------- |
| Simple       | <100 lines    | Keep as single file                             |
| Medium       | 100-300 lines | Consider variant files if >3 variants           |
| Complex      | 300-500 lines | Split into variants or use base-components/     |
| Very Complex | >500 lines    | MUST split into multiple files + subdirectories |

**Red Flags:**

- Single file >500 lines → Need to split
- 5+ variants in single file → Need separate variant files
- 3+ repeated sub-components → Need base-components/

---

## Part 7: File Organization Patterns

### Pattern 1: Simple Component (40%)

**Structure:**

```
component-name/
├── component-name.tsx
├── component-name.demo.tsx
└── component-name.story.tsx
```

**When Used:** Simple, single-responsibility component

**Examples:** Toggle, Checkbox, Tooltip, Form

---

### Pattern 2: Variant-Heavy Component (50%)

**Structure:**

```
component-name/
├── component-name.tsx (core)
├── variant-1.tsx
├── variant-2.tsx
├── variant-3.tsx
├── component-name.demo.tsx (all variants)
└── component-name.story.tsx (all variants)
```

**When Used:** Multiple interaction models or specialized variants

**Examples:** Buttons (5 files), Select (6 files), Pagination (4 files)

---

### Pattern 3: Component with base-components/ (6%)

**Structure:**

```
component-name/
├── component-name.tsx
├── variant-1.tsx
├── variant-2.tsx
├── base-components/
│   ├── shared-sub-1.tsx
│   ├── shared-sub-2.tsx
│   └── shared-sub-3.tsx
├── component-name.demo.tsx
├── component-name.story.tsx
└── utils.ts (optional)
```

**When Used:** Variants share significant implementation (>50%)

**Examples:** Avatar, Tags, AppNavigation

**Criterion:** 2+ variants AND shared implementation >50%

---

### Pattern 4: Complex with Subdirectories (8%)

**Structure:**

```
component-name/
├── core-component.tsx
├── variant-family-1/
│   ├── variant-1a.tsx
│   ├── variant-1b.tsx
│   └── variant-1c.tsx
├── variant-family-2/
│   ├── variant-2a.tsx
│   └── variant-2b.tsx
├── base-components/
│   ├── shared-sub-1.tsx
│   └── shared-sub-2.tsx
├── config.ts
├── *.demo.tsx files
└── *.story.tsx files
```

**When Used:** Multiple variant families + shared sub-components

**Examples:** AppNavigation (only component at this complexity)

---

## Part 8: System-Level Patterns

### Pattern: React Aria as Accessibility Foundation

**Strategy:** Use React Aria Components for ALL interactive elements

**Benefits:**

1. WCAG 2.1 AA compliance automatic
2. Keyboard navigation built-in
3. Screen reader support guaranteed
4. Focus management handled
5. ARIA attributes correct

**Implementation:**

```typescript
// ALL interactive base/ components use React Aria
import { Button as AriaButton } from 'react-aria-components';
import { Checkbox as AriaCheckbox } from 'react-aria-components';
import { TextField as AriaTextField } from 'react-aria-components';

// Non-interactive components do NOT use React Aria
// foundations/: Icons, visual elements
// shared-assets/: Illustrations, patterns
```

**Coverage:** 47 files (100% of interactive components)

---

### Pattern: Design Token System

**Strategy:** Semantic tokens, never hardcoded values

**Examples:**

```typescript
// ✅ Correct - Semantic tokens
'bg-brand-solid'; // Primary brand color
'text-fg-quaternary'; // Quaternary text color
'ring-primary'; // Primary ring color
'shadow-xs-skeumorphic'; // Subtle shadow

// ❌ Wrong - Hardcoded values
'bg-blue-600'; // Specific blue
'text-gray-900'; // Specific gray
'ring-gray-300'; // Specific border
'shadow-sm'; // Generic shadow
```

**Benefits:**

1. Themeable - Change brand color globally
2. Dark mode support - Tokens map to different colors
3. Semantic - Token names describe purpose, not appearance
4. Maintainable - Change once, affects all components

**Coverage:** 100% of components

---

### Pattern: cx() Utility for Class Merging

**Purpose:** Merge conditional classes and allow className overrides

**Implementation:**

```typescript
import { cx } from '@/utils/cx';

className={cx(
  // Base classes (always applied)
  'inline-flex items-center justify-center',
  'rounded-lg font-medium transition-all',

  // Conditional classes (based on props)
  variant === 'primary' && 'bg-brand-solid text-white',
  variant === 'secondary' && 'bg-primary text-secondary',
  size === 'sm' && 'px-3 py-1.5 text-sm',
  size === 'md' && 'px-4 py-2 text-base',

  // User override (last, takes precedence)
  props.className
)}
```

**Benefits:**

1. Clean conditional class logic
2. User can override via className prop
3. Handles class conflicts (Tailwind merge)
4. Type-safe

**Coverage:** 100% of components

---

### Pattern: Component File Triplet

**Files for Each Component:**

1. **component.tsx** - Implementation
2. **component.demo.tsx** - Usage examples with real scenarios
3. **component.story.tsx** - All visual variants for Storybook

**Purpose:**

- Implementation: How it's built
- Demo: How to use it in context
- Story: Visual exploration of all variants

**Coverage:** 100% of component types

---

## Part 9: Anti-Patterns (What NOT to Do)

### Anti-Pattern 1: Over-Using base-components/

**❌ Wrong:** Creating base-components/ for every component

**Reality:** Only 3 components use this pattern (Avatar, Tags, AppNavigation)

**Criterion:** 2+ variants share >50% implementation

**Example of Over-Abstraction:**

```
button/
├── button.tsx
├── social-button.tsx
├── base-components/  ← ❌ WRONG - buttons don't share implementation
│   └── button-core.tsx
```

**Correct Pattern:** Separate variant files without base-components/

```
buttons/
├── button.tsx (independent)
├── social-button.tsx (independent)
└── app-store-buttons.tsx (independent)
```

---

### Anti-Pattern 2: Assuming Button Patterns Apply Universally

**❌ Wrong:** "Button has 9 color variants, therefore all components should have color variants"

**Reality:**

- Button: 9 color variants (unique to Button)
- Input: validation states (isInvalid, isDisabled), no color variants
- Table: size prop only, no color variants
- Modal: no size or color props

**Lesson:** Each component defines its own API based on its purpose

---

### Anti-Pattern 3: Hardcoding Colors or Spacing

**❌ Wrong:**

```typescript
className = 'bg-blue-600 px-4';
```

**✅ Correct:**

```typescript
className = 'bg-brand-solid px-button-horizontal-md';
```

**Reason:** Tokens enable theming, dark mode, and global changes

---

### Anti-Pattern 4: Creating All Variants in Single File

**❌ Wrong for Select:**

```typescript
// select.tsx - 1000+ lines
function Select({ variant, ...props }) {
  if (variant === 'combobox') return <ComboboxImplementation />
  if (variant === 'multi') return <MultiSelectImplementation />
  if (variant === 'native') return <NativeSelectImplementation />
  return <StandardSelectImplementation />
}
```

**✅ Correct:**

```
select/
├── select.tsx (standard dropdown)
├── combobox.tsx (searchable)
├── multi-select.tsx (multiple selection)
└── select-native.tsx (native)
```

**Reason:** Different interaction models = different files

---

### Anti-Pattern 5: Not Using React Aria for Interactive Components

**❌ Wrong:**

```typescript
function Button({ onClick, disabled, children }) {
  return (
    <button
      onClick={onClick}
      disabled={disabled}
      // Missing: keyboard support, focus management, ARIA
    >
      {children}
    </button>
  );
}
```

**✅ Correct:**

```typescript
import { Button as AriaButton } from "react-aria-components";

function Button(props) {
  return <AriaButton {...props} />;
  // Includes: keyboard support, focus management, ARIA
}
```

**Reason:** React Aria provides accessibility automatically

---

## Part 10: Key Architectural Decisions

### Decision 1: Category-Based Organization

**Decision:** Separate base/, application/, foundations/, shared-assets/, internal/

**Rationale:**

- Clear dependency hierarchy
- Enables progressive learning
- Prevents circular dependencies
- Supports different reusability levels

**Impact:** Developers know where to find components and where to create new ones

---

### Decision 2: Variant as File

**Decision:** Different interaction models = different files, not props

**Rationale:**

- Better type safety (each variant has different props)
- Clearer API (no complex variant prop combinations)
- Better discoverability (file explorer shows variants)
- Easier to maintain (each variant is independent)

**Impact:** More files, but clearer architecture

---

### Decision 3: React Aria Foundation

**Decision:** Use React Aria for ALL interactive components

**Rationale:**

- Accessibility is hard to get right manually
- Keyboard navigation is complex
- ARIA attributes are error-prone
- React Aria solves 80% of accessibility automatically

**Impact:** WCAG 2.1 AA compliance built-in, reduced implementation burden

---

### Decision 4: Selective base-components/ Usage

**Decision:** Only use base-components/ when variants share >50% implementation

**Rationale:**

- Avoid premature abstraction
- Keep components simple when possible
- Only abstract when duplication is significant

**Impact:** Only 3 components use this pattern, keeping most components simple

---

### Decision 5: Design Token System

**Decision:** Semantic tokens, never hardcoded values

**Rationale:**

- Enable theming and brand customization
- Support dark mode
- Enable global design changes
- Improve maintainability

**Impact:** All colors, spacing, and styles are themeable

---

## Conclusion

**System Architecture Summary:**

1. **5 Categories** with clear purposes and dependency hierarchy
2. **30 Component Types** across base/ and application/
3. **4 File Organization Patterns** based on complexity
4. **3 Complexity Tiers** (simple <100, medium 100-300, complex >300 lines)
5. **Universal Patterns** (React Aria, design tokens, cx()) used by 100% of components
6. **Selective Patterns** (Context API 6%, base-components/ 6%) used sparingly
7. **Component-Specific Patterns** (polymorphism 1.4%, color variants 0.5%) used minimally

**Architectural Principles:**

- Category separation for clear dependencies
- Variant as file for better architecture
- Selective abstraction to avoid over-engineering
- React Aria for universal accessibility
- Composition over configuration

**Next Steps:**

- Use this understanding for PATTERN-LIBRARY.md
- Apply architectural knowledge to INTEGRATION-GUIDE.md
- Reference these decisions when implementing components

---

**Document Status:** Phase 0.5 Complete (1 of 5 master documents)
**Next:** PATTERN-LIBRARY.md - Document universal/category/component patterns with scope
