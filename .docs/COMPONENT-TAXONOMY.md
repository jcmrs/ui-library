# UntitledUI Component Taxonomy

**Date:** 2025-10-24
**Purpose:** Complete categorization of all 208 component files in UPSTREAM/react
**Source:** Quantitative analysis of UPSTREAM/react/components/
**Status:** Phase 0.2 - IN PROGRESS

---

## Executive Summary

UntitledUI contains **30 component types** organized into **5 major categories**, comprising **79 implementation files**, **~130 demo/story files**, and numerous sub-components. This taxonomy provides a complete map of the component library's structure.

**Key Statistics:**

- **30 component types** across all categories
- **79 implementation files** (excluding demos/stories)
- **18 base component types** (primitive UI elements)
- **12 application component types** (complex application patterns)
- **Complexity range**: 42 lines (Modal) to 567 lines (App Store Buttons)

---

## Category 1: Base Components

**Directory:** `components/base/`
**Purpose:** Foundational, reusable UI primitives
**Component Types:** 18
**Implementation Files:** 46
**Complexity:** 40% simple, 49% medium, 11% complex

### 1.1 Interactive Inputs

#### Buttons (buttons/)

**Files:** 13 total
**Variants:**

- button.tsx (271 lines) - Core button with 9 color variants
- social-button.tsx - Social media branded buttons (Facebook, Twitter, etc.)
- app-store-buttons.tsx (567 lines) - App Store and Google Play buttons
- app-store-buttons-outline.tsx (378 lines) - Outline versions
- button-utility.tsx - Icon-only utility buttons
- close-button.tsx - Specialized close button

**Patterns:**

- Polymorphic rendering (button vs link based on href)
- 9 color variants (primary, secondary, tertiary, link-gray, link-color, + destructive versions)
- 4 sizes (sm, md, lg, xl)
- Icon support (leading/trailing)
- Loading states

**Complexity:** Medium-High (271-567 lines per variant)
**React Aria:** Yes (AriaButton, AriaLink)

#### Checkbox (checkbox/)

**Files:** 3
**Variants:**

- checkbox.tsx
- checkbox.demo.tsx
- checkbox.story.tsx

**Patterns:**

- Form selection
- Indeterminate state support
- Label integration

**Complexity:** Simple-Medium
**React Aria:** Yes

#### Radio Buttons (radio-buttons/)

**Files:** 4
**Patterns:**

- Exclusive selections
- Group management
- Radio group context

**Complexity:** Simple-Medium
**React Aria:** Yes

#### Toggle (toggle/)

**Files:** 4
**Patterns:**

- Boolean switches
- On/off states
- Label positioning

**Complexity:** Simple
**React Aria:** Yes

### 1.2 Text Inputs

#### Input (input/)

**Files:** 5
**Variants:**

- input.tsx (271 lines) - Main input component
- input-group.tsx - Grouped inputs
- inputs.demo.tsx (758 lines)

**Patterns:**

- Context API for state sharing
- Multiple components: Input, InputBase, TextField
- Validation states (isInvalid)
- Icon support
- Label, hint, tooltip integration

**Complexity:** Medium-High (271 lines)
**React Aria:** Yes (AriaTextField)
**Sub-components:** Yes (Input, InputBase, TextField, Label, HintText)

#### Textarea (textarea/)

**Files:** 3
**Patterns:**

- Multi-line text input
- Auto-resize support
- Character count

**Complexity:** Simple-Medium
**React Aria:** Yes

#### Pin Input (pin-input/)

**Files:** 3
**Patterns:**

- OTP/verification codes
- Auto-focus next field
- Paste support

**Complexity:** Medium
**React Aria:** Yes

### 1.3 Selection Controls

#### Dropdown (dropdown/)

**Files:** 4
**Variants:**

- dropdown.tsx (163 lines)

**Patterns:**

- Menu/select patterns
- Popover positioning
- Keyboard navigation

**Complexity:** Medium (163 lines)
**React Aria:** Yes

#### Select (select/)

**Files:** 9
**Variants:**

- select.tsx
- select-native.tsx - Native browser select
- combobox.tsx - Searchable select
- multi-select.tsx (363 lines) - Multi-selection
- select-item.tsx
- popover.tsx

**Patterns:**

- Context API (multi-select)
- Single vs multi-selection
- Search/filter functionality
- Native fallback

**Complexity:** Medium-High (363 lines for multi-select)
**React Aria:** Yes

#### Slider (slider/)

**Files:** 3
**Patterns:**

- Range inputs
- Value display
- Min/max constraints

**Complexity:** Simple-Medium
**React Aria:** Yes

### 1.4 Content Organization

#### Tags (tags/)

**Files:** 6
**Variants:**

- tags.tsx (163 lines)
- base-components/ subdirectory

**Sub-components:**

- tag-checkbox.tsx
- tag-close-x.tsx

**Patterns:**

- Removable tags
- Checkbox integration
- Tag groups

**Complexity:** Medium (163 lines)
**React Aria:** Yes
**Has base-components/:** Yes

#### Badges (badges/)

**Files:** 6
**Variants:**

- badges.tsx (417 lines) - Main badge component
- badge-groups.tsx (176 lines) - Badge grouping

**Patterns:**

- 25+ badge variants
- Badge groups (20+ configurations)
- Status indicators
- Pill shapes, dot indicators

**Complexity:** High (417 lines)
**React Aria:** No (presentational)

#### Badge Groups (badge-groups/)

**Included in badges/**
**Patterns:**

- Multiple badges displayed together
- Overflow handling
- Responsive stacking

**Complexity:** Medium (176 lines)

### 1.5 Visual Feedback

#### Avatar (avatar/)

**Files:** 10 total
**Variants:**

- avatar.tsx - Main avatar component
- avatar-profile-photo.tsx - Profile photo variant
- avatar-label-group.tsx - Avatar with label
- base-components/ subdirectory

**Sub-components (base-components/):**

- avatar-add-button.tsx
- avatar-company-icon.tsx
- avatar-online-indicator.tsx
- verified-tick.tsx

**Patterns:**

- 5 sizes (xs, sm, md, lg, xl)
- Online indicators
- Verified badges
- Company icons
- Group avatars

**Complexity:** Simple-Medium
**React Aria:** No (presentational)
**Has base-components/:** Yes

#### Progress Indicators (progress-indicators/)

**Files:** 5
**Variants:**

- progress-indicators.tsx
- progress-circles.tsx (176 lines)

**Patterns:**

- Linear progress bars
- Circular progress
- Percentage display

**Complexity:** Medium (176 lines)
**React Aria:** No (presentational)

#### Tooltip (tooltip/)

**Files:** 3
**Patterns:**

- Contextual hints
- Positioning
- Trigger patterns

**Complexity:** Simple
**React Aria:** Yes

### 1.6 Supporting Components

#### Button Group (button-group/)

**Files:** 3
**Patterns:**

- Related buttons grouped together
- Connected styling
- Split buttons

**Complexity:** Simple-Medium
**React Aria:** No (composition)

#### Form (form/)

**Files:** 3
**Patterns:**

- Form container
- Validation integration
- Submit handling

**Complexity:** Simple-Medium
**React Aria:** Yes

#### File Upload Trigger (file-upload-trigger/)

**Files:** 3
**Patterns:**

- File input trigger
- Button-like appearance
- File selection

**Complexity:** Simple
**React Aria:** Yes

---

## Category 2: Application Components

**Directory:** `components/application/`
**Purpose:** Complex, composed application patterns
**Component Types:** 12
**Implementation Files:** 33
**Complexity:** Generally higher than base components

### 2.1 Navigation

#### App Navigation (app-navigation/)

**Files:** 14 total
**Variants:**

- header-navigation.tsx (204 lines)
- sidebar-navigation-base.tsx
- sidebar-navigation/ subdirectory
- base-components/ subdirectory

**Sidebar Variants (sidebar-navigation/):**

- sidebar-dual-tier.tsx
- sidebar-section-dividers.tsx
- sidebar-simple.tsx
- sidebar-slim.tsx (228 lines)

**Base Components (base-components/):**

- mobile-header.tsx
- nav-account-card.tsx (211 lines)
- nav-item-button.tsx
- nav-item.tsx
- featured-cards.demo.tsx

**Patterns:**

- Responsive navigation
- Mobile vs desktop layouts
- Nested navigation
- Active state management
- Sidebar collapse

**Complexity:** High (204-228 lines per variant)
**React Aria:** Yes
**Has base-components/:** Yes
**Has subdirectory:** Yes (sidebar-navigation/)

### 2.2 Data Display

#### Table (table/)

**Files:** 3
**Variants:**

- table.tsx (300 lines)

**Patterns:**

- Context API for size sharing
- Deep composition (Table.Header, Table.Row, Table.Cell, etc.)
- Integration with base components:
  - Checkbox for selection
  - Dropdown for actions
  - Badge for status
  - Tooltip for truncated content
- Sorting, filtering (via composition)
- Responsive table cards

**Complexity:** High (300 lines)
**React Aria:** Yes (AriaTable)
**Integrations:** Checkbox, Dropdown, Badge, Tooltip

#### Charts (charts/)

**Files:** 6+
**Variants:**

- Line charts
- Bar charts
- Progress circles
- Pie charts (implied)
- Radar charts (implied)
- Activity gauges (implied)

**Patterns:**

- Data visualization
- Recharts integration
- Responsive sizing

**Complexity:** Medium-High
**React Aria:** No (data visualization)

#### Tabs (tabs/)

**Files:** 3
**Variants:**

- tabs.tsx (225 lines)

**Patterns:**

- Tab navigation
- Content panels
- Active state management
- Keyboard navigation

**Complexity:** Medium (225 lines)
**React Aria:** Yes (AriaTabs)

### 2.3 Overlays & Modals

#### Modals (modals/)

**Files:** 3+
**Variants:**

- Multiple modal patterns (46 variants per documentation)
- Basic modals
- Icon modals
- Centered modals
- Fullscreen modals

**Patterns:**

- Overlay backdrop
- Focus trapping
- Close on escape
- Scroll locking

**Complexity:** Simple-Medium (42 lines for basic modal)
**React Aria:** Yes (AriaModal, AriaDialog)

#### Slideout Menus (slideout-menus/)

**Files:** 3+
**Variants:**

- slideout-menu.tsx
- Multiple slideout patterns (20 variants per documentation)

**Patterns:**

- Side panels
- Slide animations
- Focus management
- Overlay backdrop

**Complexity:** Medium
**React Aria:** Yes

### 2.4 Navigation Patterns

#### Pagination (pagination/)

**Files:** 6
**Variants:**

- pagination.tsx (330 lines)
- pagination-base.tsx (378 lines)
- pagination-dot.tsx - Dot indicators
- pagination-line.tsx - Line indicators

**Patterns:**

- Page navigation
- Dot indicators
- Line progress
- Previous/next buttons

**Complexity:** High (330-378 lines)
**React Aria:** No (navigation)

#### Carousel (carousel/)

**Files:** 3+
**Variants:**

- carousel-base.tsx (308 lines)

**Patterns:**

- Image/content sliders
- Navigation controls
- Auto-play
- Dot indicators

**Complexity:** High (308 lines)
**React Aria:** No (presentation)

### 2.5 Date & Time

#### Date Picker (date-picker/)

**Files:** 7
**Variants:**

- date-picker.tsx
- date-range-picker.tsx - Date range selection
- calendar.tsx
- range-calendar.tsx
- cell.tsx - Calendar cell component

**Patterns:**

- Single date selection
- Date range selection
- Calendar navigation
- Date validation

**Complexity:** Medium-High
**React Aria:** Yes (AriaDatePicker, AriaCalendar)

### 2.6 File Management

#### File Upload (file-upload/)

**Files:** 4+
**Variants:**

- file-upload-base.tsx (396 lines)
- draggable.tsx - Drag and drop support

**Patterns:**

- Drag and drop
- File selection
- Upload progress
- File previews

**Complexity:** High (396 lines)
**React Aria:** Yes

### 2.7 Feedback & Status

#### Empty State (empty-state/)

**Files:** 3
**Patterns:**

- No data placeholders
- Call to action
- Illustrations

**Complexity:** Simple-Medium
**React Aria:** No (presentational)

#### Loading Indicator (loading-indicator/)

**Files:** 3
**Variants:**

- loading-indicator.tsx

**Patterns:**

- Page-level loading
- Spinners
- Skeletons (implied)

**Complexity:** Simple-Medium
**React Aria:** No (presentational)

---

## Category 3: Foundations

**Directory:** `components/foundations/`
**Purpose:** Design system primitives, icons, visual elements
**Note:** These are NOT interactive components

### 3.1 Icons

#### Featured Icon (featured-icon/)

**Files:** 3
**Patterns:**

- 6 sizes (xs, sm, md, lg, xl, 2xl)
- Icon backgrounds
- Color themes

**Complexity:** Simple-Medium
**React Aria:** No

#### Social Icons

**Patterns:**

- Social media platform icons
- Consistent sizing

**Complexity:** Simple
**React Aria:** No

#### Payment Icons

**Patterns:**

- Payment method icons
- Card brand icons

**Complexity:** Simple
**React Aria:** No

#### Logo

**Files:** Includes untitledui-logo-minimal.tsx (172 lines)
**Patterns:**

- Brand logos
- SVG-based

**Complexity:** Simple
**React Aria:** No

### 3.2 Visual Elements

#### Rating Badge

**Patterns:**

- Star ratings
- Numeric ratings

**Complexity:** Simple
**React Aria:** No

#### Rating Stars

**Patterns:**

- Star displays
- Half-star support

**Complexity:** Simple
**React Aria:** No

#### Dot Icon

**Patterns:**

- Status dots
- Indicator dots

**Complexity:** Simple
**React Aria:** No

#### Play Button Icon

**Patterns:**

- Video play controls
- Icon styling

**Complexity:** Simple
**React Aria:** No

---

## Category 4: Shared Assets

**Directory:** `components/shared-assets/`
**Purpose:** Visual assets, illustrations, graphics
**Note:** Purely visual, no interactivity

### 4.1 Background Patterns

**Files:**

- circle.tsx
- grid.tsx (233 lines)
- grid-check.tsx (2520 lines - massive SVG)
- square.tsx (182 lines)

**Patterns:**

- Decorative backgrounds
- SVG patterns
- Repeating motifs

**Complexity:** Simple-Massive (SVG generation)
**React Aria:** No

### 4.2 Illustrations

**Files:**

- box.tsx (259 lines)
- cloud.tsx (283 lines)
- credit-card.tsx (305 lines)
- documents.tsx (540 lines)

**Patterns:**

- Decorative illustrations
- Empty state graphics
- Feature graphics

**Complexity:** Medium-High (SVG illustrations)
**React Aria:** No

### 4.3 Visual Components

#### Credit Card (credit-card/)

**Files:** credit-card.tsx (237 lines)
**Patterns:**

- Credit card displays
- Card brand detection

**Complexity:** Medium
**React Aria:** No

#### QR Code

**Patterns:**

- QR code generation
- Customization

**Complexity:** Simple-Medium
**React Aria:** No

#### iPhone Mockup

**Files:** iphone-mockup.tsx (172 lines)
**Patterns:**

- Device mockups
- App screenshots

**Complexity:** Medium
**React Aria:** No

#### Section Divider

**Patterns:**

- Visual separators
- Section breaks

**Complexity:** Simple
**React Aria:** No

---

## Category 5: Internal

**Directory:** `components/internal/`
**Purpose:** Internal utilities, not exposed in public API
**Note:** Not analyzed in detail (implementation details)

---

## Complexity Analysis

### By Line Count

**Simple (<100 lines):**

- 19 base components (40% of base/)
- Typical: Modal (42 lines), simple wrappers around React Aria

**Medium (100-300 lines):**

- 23 base components (49% of base/)
- Examples: Dropdown (163), Tags (163), Badge Groups (176), Tabs (225), Input (271), Button (271), Table (300)

**High (300-500 lines):**

- 5 base components (11% of base/)
- Examples: Carousel (308), Pagination (330), Multi-Select (363), Pagination Base (378), App Store Buttons Outline (378), File Upload (396), Badges (417)

**Very High (>500 lines):**

- App Store Buttons (567 lines) - Most complex component

**Outliers:**

- Grid Check (2520 lines) - Massive generated SVG, not typical component

### By Category

**Base Components:**

- Range: 40% simple, 49% medium, 11% complex
- Average complexity: Medium
- Most are focused, single-purpose

**Application Components:**

- Range: Generally medium to high complexity
- Average complexity: Higher than base
- More composition, integration, state management

**Foundations:**

- Range: Simple to medium
- Average complexity: Simple
- Mostly presentational SVG

**Shared Assets:**

- Range: Simple to very high (SVG illustrations)
- Average complexity: Medium
- Complexity driven by SVG detail

---

## Architectural Patterns by Category

### Base Components

**Characteristics:**

- Single responsibility (focused purpose)
- Highly reusable
- Minimal external dependencies
- Direct React Aria integration
- Mostly self-contained

**Patterns:**

- React Aria foundation (47 files total use this)
- Design tokens for styling (100%)
- cx() utility for class merging (100%)
- Variants as separate files (not props)
- Optional base-components/ for sub-components (3 use this)

### Application Components

**Characteristics:**

- Composed from base components
- Application-specific logic
- Complex interactions
- State management needs
- Integration patterns

**Patterns:**

- Context API for state sharing (more common here)
- Deep composition (Component.SubComponent)
- Integration with multiple base components
- Responsive patterns
- More complex React Aria usage

### Foundations

**Characteristics:**

- Purely visual
- No interactivity
- SVG-based
- Consistent sizing systems

**Patterns:**

- Size props (6 sizes for featured icons)
- Color/theme props
- No React Aria (nothing to interact with)

### Shared Assets

**Characteristics:**

- Visual graphics
- Decorative elements
- Large SVG definitions
- No behavior

**Patterns:**

- SVG components
- Size/theme customization
- No React Aria
- No state management

---

## Component Interdependencies

### Base Components (Standalone)

Most base components are independent:

- Avatar: Standalone (uses sub-components internally)
- Badges: Standalone
- Buttons: Standalone (all variants independent)
- Checkbox: Standalone
- Input: Standalone (but composes InputBase + TextField internally)
- Tags: Standalone (uses sub-components internally)

### Application Components (Highly Integrated)

**Table** integrates:

- Checkbox (for row selection)
- Dropdown (for row actions)
- Badge (for status display)
- Tooltip (for truncated content)

**App Navigation** integrates:

- Buttons
- Dropdowns
- Avatars (in account card)

**Modals** integrate:

- Buttons (for actions)
- Forms (for content)
- Various base components as content

**File Upload** integrates:

- Buttons (for triggers)
- Progress indicators

**Date Picker** integrates:

- Inputs (for value display)
- Buttons (for calendar toggle)

---

## Variant Implementation Strategy

### Pattern: Variants as Separate Files

Components with multiple distinct variants implement each as a separate file rather than using variant props:

**Example 1: Select (Most Variants)**

- select.tsx - Standard dropdown select
- select-native.tsx - Native browser select fallback
- combobox.tsx - Searchable/filterable select
- multi-select.tsx (363 lines) - Multi-selection with checkboxes
- select-item.tsx - Individual select item
- popover.tsx - Popover container

**Example 2: Pagination (Different Interaction Models)**

- pagination.tsx (330 lines) - Standard page numbers
- pagination-base.tsx (378 lines) - Base pagination logic
- pagination-dot.tsx - Dot indicators (carousel-style)
- pagination-line.tsx - Line progress indicators

**Example 3: Avatar (Visual Variants)**

- avatar.tsx - Base avatar
- avatar-profile-photo.tsx - Profile photo display
- avatar-label-group.tsx - Avatar with text labels

**Example 4: App Store Buttons (Platform Variants)**

- app-store-buttons.tsx (567 lines) - Filled versions
- app-store-buttons-outline.tsx (378 lines) - Outlined versions
- Different platforms: Apple App Store, Google Play

**Rationale:**

- Variants have different props/APIs
- Reduces complexity in single file
- Each variant optimized for its use case
- Easier to maintain
- Clearer imports for consumers

### Pattern: base-components/ for Shared Sub-Components

When variants share internal components, they use base-components/:

**Avatar (base-components/):**

- avatar-add-button.tsx
- avatar-company-icon.tsx
- avatar-online-indicator.tsx
- verified-tick.tsx

**Tags (base-components/):**

- tag-checkbox.tsx
- tag-close-x.tsx

**App Navigation (base-components/):**

- mobile-header.tsx
- nav-account-card.tsx
- nav-item-button.tsx
- nav-item.tsx

**Rationale:**

- Shared logic/UI extracted
- Reused across variants
- Better organization
- Easier testing

---

## Component File Patterns

### Pattern 1: Simple Component (40% of base/)

**Example: Toggle, Checkbox, Tooltip**

```
toggle/
├── toggle.tsx                 # Main implementation
├── toggle.demo.tsx            # Interactive demos
├── toggle.story.tsx           # Storybook stories
```

### Pattern 2: Component with Variants (Common)

**Example: Select, Pagination, Badges**

```
select/
├── select.tsx                 # Standard select
├── select-native.tsx          # Browser native fallback
├── combobox.tsx               # Searchable variant
├── multi-select.tsx           # Multi-selection variant
├── select-item.tsx            # Shared item component
├── popover.tsx                # Shared popover
├── select.demo.tsx            # Demo for all variants
└── select.story.tsx           # Stories for all variants
```

### Pattern 3: Component with Shared Sub-Components

**Example: Avatar, Tags, App-Navigation**

```
avatar/
├── avatar.tsx                 # Core avatar
├── avatar-profile-photo.tsx   # Variant
├── avatar-label-group.tsx     # Variant
├── base-components/           # Shared internals
│   ├── avatar-add-button.tsx
│   ├── avatar-company-icon.tsx
│   ├── avatar-online-indicator.tsx
│   └── verified-tick.tsx
├── avatar.demo.tsx
├── avatar.story.tsx
└── utils.ts
```

### Pattern 4: Complex Component with Subdirectories

**Example: App-Navigation**

```
app-navigation/
├── header-navigation.tsx      # Header variant
├── sidebar-navigation-base.tsx # Sidebar base
├── sidebar-navigation/        # Sidebar variants subdirectory
│   ├── sidebar-dual-tier.tsx
│   ├── sidebar-section-dividers.tsx
│   ├── sidebar-simple.tsx
│   └── sidebar-slim.tsx
├── base-components/           # Shared sub-components
│   ├── mobile-header.tsx
│   ├── nav-account-card.tsx
│   ├── nav-item-button.tsx
│   └── nav-item.tsx
├── config.ts                  # Configuration
├── header-navigation.demo.tsx
├── sidebar-navigation.demo.tsx
└── *.story.tsx
```

---

## Key Takeaways

### Taxonomy Structure

1. **5 Major Categories**: base, application, foundations, shared-assets, internal
2. **30 Component Types**: Across categories
3. **79 Implementation Files**: Actual component code (excluding demos/stories)

### Complexity Distribution

1. **40% Simple**: Wrappers, presentational
2. **49% Medium**: Most components (100-300 lines)
3. **11% Complex**: High-feature components (>300 lines)

### Pattern Scope

1. **Universal**: Design tokens, cx(), React Aria (for interactive)
2. **Category-Specific**: Context API (complex components), base-components/ (some)
3. **Component-Specific**: Color variants (Button), size systems (varies), polymorphism (Button only)

### Architectural Insights

1. **Variants are separate files**, not prop configurations
2. **base-components/** used by 3 components for shared sub-components
3. **Application components** integrate multiple base components
4. **Complexity varies dramatically** even within same category
5. **Cannot study one component and assume patterns apply to all**

---

## Usage for AI Implementation

When implementing a new component:

1. **Identify Category**: base, application, or other
2. **Find Similar Components**: Same category, similar complexity
3. **Study 2-3 Examples**: Don't assume from just one
4. **Identify Pattern Scope**:
   - Universal patterns (all components use)
   - Category patterns (this type uses)
   - Component-specific patterns (unique to this)
5. **Match Complexity**: Simple wrapper vs medium vs complex composition
6. **Choose File Structure**: Single file vs variants vs base-components/

**DO NOT**:

- Study Button and assume all components work the same
- Assume variant system from one component applies to others
- Miss that application components integrate base components
- Overlook that complexity requires different architecture

---

**Status**: Phase 0.2 COMPLETE - Component taxonomy documented
**Next**: Phase 0.3 - Multi-role analysis of system architecture
