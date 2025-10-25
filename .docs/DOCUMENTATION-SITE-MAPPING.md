# UntitledUI Documentation Site Mapping

**Date:** 2025-10-25
**Purpose:** Bridge the gap between user-facing documentation site and implementation code structure
**Status:** Phase 0.4 Deliverable

---

## Executive Summary

The UntitledUI documentation site (untitledui.com) and code repository (UPSTREAM/) organize components differently to serve different purposes. This document maps between them and provides navigation guidance.

**Key Insight:** Documentation site is organized by **use case** (what users want to build), code is organized by **implementation structure** (how components are built). Understanding this distinction is critical for effective learning.

**Total Scope:**

- **Documentation Site**: ~1,200+ components/variants/pages across 5 major categories
- **Code Repository**: 30 component types, 79 implementation files, 208+ total files

---

## Part 1: Documentation Site Organization

### Category 1: Base Components (28 types, 200+ variants)

**Site Organization: By Component Type + Visual Variants**

Documentation site presents base components as discrete types with visual variant explorers:

```
Base Components/
├── Buttons
│   ├── Buttons (13 variants) - Primary, secondary, tertiary, etc.
│   ├── Social buttons (12 variants) - Facebook, Twitter, Google, etc.
│   ├── App store buttons (8 variants) - App Store, Google Play, filled/outlined
│   ├── Utility buttons (5 variants) - Icon-only, close, etc.
│   └── Button groups (6 variants) - Horizontal, vertical, etc.
├── Badges
│   ├── Badges (25 variants) - Colors, sizes, with icons, with dots
│   └── Badge groups (20 variants) - Grouped badges, stacked, etc.
├── Form Inputs
│   ├── Inputs - Text fields, search, email, etc.
│   ├── Textareas - Single, with counter, etc.
│   ├── Select - Dropdown, multi-select, searchable
│   ├── Checkboxes - Single, groups, indeterminate
│   ├── Radio buttons - Single, groups, cards
│   ├── Toggles - Switch, with labels
│   └── Verification code inputs - PIN, OTP
├── Selection & Navigation
│   ├── Dropdowns - Menu dropdowns
│   ├── Sliders - Range, single value
│   └── Tags - Removable, with icons
├── Visual Feedback
│   ├── Avatars - User, group, with status
│   ├── Tooltips - Top, bottom, left, right
│   ├── Progress indicators - Linear, circular
│   └── Rating badges and stars
└── Media & Special
    ├── Video players
    ├── Credit cards
    ├── QR codes
    └── Illustrations
```

**User Journey:** "I need a button" → Browse button variants → Choose visual style → See code example

---

### Category 2: Application UI Components (32 types, 300+ components)

**Site Organization: By Application Pattern + Subcategories**

Documentation site groups by common application UI patterns:

```
Application UI/
├── Navigation (19 components)
│   ├── Page headers (6 variants) - Simple, with breadcrumbs, with tabs, etc.
│   ├── Card headers (2 variants)
│   ├── Section headers (7 variants)
│   ├── Section footers (4 variants)
│   ├── Sidebar navigations (5 variants) - Collapsed, expanded, multi-tier
│   └── Header navigations (2 variants)
├── Data Display (29 components)
│   ├── Charts
│   │   ├── Line & bar charts (4 variants)
│   │   ├── Activity gauges (4 variants)
│   │   ├── Pie charts (4 variants)
│   │   └── Radar charts (1 variant)
│   └── Metrics (16 variants) - KPI cards, stat groups, trend indicators
├── Interaction Patterns (96 components)
│   ├── Modals (46 variants) - Simple, with icon, centered, fullscreen, stacked, etc.
│   ├── Command menus (9 variants) - Search, keyboard shortcuts, nested
│   ├── Slideout menus (20 variants) - Right, left, full-height, with footer
│   ├── Inline CTAs (7 variants)
│   ├── Paginations (14 variants) - Numbers, dots, lines, simple/complex
│   ├── Carousels (2 variants)
│   └── Progress steps (18 variants) - Linear, numbered, with icons
├── Content (21 components)
│   ├── Activity feeds (4 variants)
│   ├── Messaging (4 variants)
│   ├── Tabs (10 variants) - Underline, pills, buttons
│   ├── Tables (12 variants) - Simple, sortable, with selection, nested
│   └── Breadcrumbs (3 variants)
└── Feedback (51 components)
    ├── Alerts (12 variants) - Success, error, warning, info
    ├── Notifications (9 variants) - Toast, inline, with actions
    ├── Date pickers (6 variants)
    ├── Calendars (3 variants)
    ├── File uploaders (5 variants)
    ├── Content dividers (18 variants)
    ├── Loading indicators (3 variants)
    ├── Empty states (3 variants)
    └── Code snippets (1 variant)
```

**User Journey:** "I need to build a dashboard" → Browse navigation patterns → See sidebar navigation variants → Choose multi-tier → See integration with page headers

---

### Category 3: Shared Page Examples (6 types, 65 pages)

**Site Organization: By Page Purpose**

Pre-built complete pages for common authentication/error scenarios:

```
Shared Pages/
├── Authentication
│   ├── Log in pages (16 variants) - Simple, centered, split, with social
│   ├── Sign up pages (21 variants) - Single-step, multi-step, with terms
│   ├── Verification pages (3 variants) - Email, phone, 2FA
│   └── Forgot password pages (5 variants)
├── Error Pages
│   └── 404 pages (10 variants) - Simple, illustrated, with search
└── Email Templates (10 templates)
    - Welcome, verification, password reset, etc.
```

**User Journey:** "I need a login page" → Browse login variants → Choose centered with social → Copy complete page code

---

### Category 4: Marketing Components (17 types, 400+ components)

**Site Organization: By Marketing Section Purpose**

Full-width marketing sections organized by landing page construction:

```
Marketing Components/
├── Page Top
│   ├── Header navigations (20 variants) - Transparent, solid, with mega menu
│   └── Header sections (44 variants) - Hero with image/video, centered, split
├── Value Proposition
│   ├── Features sections (42 variants) - Grid, list, with images, with icons
│   ├── Pricing sections (22 variants) - Cards, table, tiers, compare
│   └── Metrics sections (16 variants) - Stats, counters, with logos
├── Social Proof
│   ├── Testimonial sections (26 variants) - Cards, carousel, with images
│   ├── Social proof sections (12 variants) - Logos, quotes, ratings
│   └── Team sections (14 variants) - Grid, list, with roles
├── Content
│   ├── Blog sections (24 variants) - Grid, list, featured
│   ├── Content & rich text sections (22 variants)
│   └── FAQ sections (16 variants) - Accordion, tabs, with search
├── Conversion
│   ├── CTA sections (20 variants) - Centered, split, with image
│   ├── Newsletter CTA sections (16 variants) - Inline, popup, footer
│   └── Contact sections (36 variants) - Form, map, info cards
├── Specialized
│   ├── Careers sections (12 variants) - Job listings, openings
│   └── Banners (16 variants) - Announcement, cookie consent
└── Page Bottom
    └── Footers (40 variants) - Simple, multi-column, with newsletter
```

**User Journey:** "I need to build a landing page" → Choose header section → Add features section → Add testimonials → Add CTA → Add footer

---

### Category 5: Marketing Page Examples (9 types, 95 pages)

**Site Organization: By Page Type**

Complete marketing page templates:

```
Marketing Pages/
├── Primary Pages
│   ├── Landing pages (20 variants) - SaaS, product, service
│   ├── Pricing pages (10 variants) - Tiers, compare, FAQ
│   └── About pages (10 variants) - Company, mission, team
├── Content Pages
│   ├── Blogs (10 variants) - Grid, sidebar, featured
│   ├── Blog posts (10 variants) - Single column, with sidebar
│   └── FAQ pages (10 variants) - Categorized, searchable
├── Contact
│   ├── Contact pages (10 variants) - Form, map, multiple locations
│   └── Team pages (10 variants) - Grid, list, with bios
├── Specialized
│   └── Legal pages (5 variants) - Privacy, terms, cookies
```

**User Journey:** "I need a pricing page" → Browse pricing page examples → Choose tiers with FAQ → Customize content

---

## Part 2: Code Repository Organization

### UPSTREAM/react/ - Component Library

**Code Organization: By Implementation Structure**

Code organized by technical component category and file purpose:

```
UPSTREAM/react/components/
├── base/ (18 component types, 46 implementation files)
│   │
│   ├── buttons/
│   │   ├── button.tsx (271 lines) - Core button implementation
│   │   ├── social-button.tsx - Facebook, Twitter, etc. styled
│   │   ├── app-store-buttons.tsx (567 lines) - App Store/Google Play
│   │   ├── app-store-buttons-outline.tsx (378 lines) - Outlined versions
│   │   ├── button-utility.tsx - Icon-only utility buttons
│   │   ├── close-button.tsx - Specialized close button
│   │   ├── buttons.demo.tsx - Interactive demos
│   │   └── buttons.story.tsx - Storybook stories
│   │
│   ├── badges/
│   │   ├── badges.tsx (417 lines) - All badge variants in single file
│   │   ├── badges.demo.tsx
│   │   └── badges.story.tsx
│   │
│   ├── avatar/
│   │   ├── avatar.tsx - Base avatar
│   │   ├── avatar-profile-photo.tsx - Profile photo display
│   │   ├── avatar-label-group.tsx - Avatar with text labels
│   │   ├── base-components/ - Shared sub-components
│   │   │   ├── avatar-add-button.tsx
│   │   │   ├── avatar-company-icon.tsx
│   │   │   ├── avatar-online-indicator.tsx
│   │   │   └── verified-tick.tsx
│   │   ├── avatar.demo.tsx
│   │   ├── avatar.story.tsx
│   │   └── utils.ts
│   │
│   ├── select/
│   │   ├── select.tsx - Standard dropdown select
│   │   ├── select-native.tsx - Native browser select
│   │   ├── combobox.tsx - Searchable/filterable select
│   │   ├── multi-select.tsx (363 lines) - Multi-selection
│   │   ├── select-item.tsx - Individual select item
│   │   ├── popover.tsx - Popover container
│   │   ├── select.demo.tsx
│   │   └── select.story.tsx
│   │
│   └── [15 more component types...]
│       - button-group, checkbox, dropdown, file-upload-trigger
│       - form, input, pin-input, progress-indicators
│       - radio-buttons, slider, tags, textarea, toggle, tooltip
│
├── application/ (12 component types, 33 implementation files)
│   │
│   ├── app-navigation/ (14 files - most complex)
│   │   ├── header-navigation.tsx
│   │   ├── sidebar-navigation-base.tsx
│   │   ├── sidebar-navigation/
│   │   │   ├── sidebar-dual-tier.tsx
│   │   │   ├── sidebar-section-dividers.tsx
│   │   │   ├── sidebar-simple.tsx
│   │   │   └── sidebar-slim.tsx
│   │   ├── base-components/
│   │   │   ├── mobile-header.tsx
│   │   │   ├── nav-account-card.tsx
│   │   │   ├── nav-item-button.tsx
│   │   │   └── nav-item.tsx
│   │   ├── config.ts
│   │   ├── header-navigation.demo.tsx
│   │   ├── sidebar-navigation.demo.tsx
│   │   └── *.story.tsx files
│   │
│   ├── modals/
│   │   ├── modal.tsx (42 lines) - Simple wrapper around React Aria
│   │   ├── modals.demo.tsx - 46 modal variants demonstrated
│   │   └── modals.story.tsx
│   │
│   ├── table/
│   │   ├── table.tsx (300 lines) - Integrates Checkbox, Dropdown, Badge, Tooltip
│   │   ├── table.demo.tsx
│   │   └── table.story.tsx
│   │
│   ├── pagination/
│   │   ├── pagination.tsx (330 lines) - Standard page numbers
│   │   ├── pagination-base.tsx (378 lines) - Base pagination logic
│   │   ├── pagination-dot.tsx - Dot indicators
│   │   ├── pagination-line.tsx - Line progress
│   │   ├── pagination.demo.tsx
│   │   └── pagination.story.tsx
│   │
│   └── [9 more component types...]
│       - carousel, charts, date-picker, empty-state
│       - file-upload, loading-indicator, slideout-menus, tabs
│
├── foundations/ (Design primitives, NOT interactive components)
│   ├── featured-icon/ - Icon component for featured icons
│   ├── logo/ - Logo components
│   ├── payment-icons/ - Credit card brand icons
│   ├── social-icons/ - Social media icons
│   ├── rating-badge/ - Rating display
│   ├── rating-stars/ - Star rating display
│   ├── play-button-icon/ - Video play button
│   └── dot-icon/ - Dot indicator
│
├── shared-assets/ (Visual elements, NOT interactive)
│   ├── background-patterns/ - Circle, grid, square patterns
│   ├── illustrations/ - Box, cloud, credit-card, documents, etc.
│   ├── credit-card/ - Credit card visual
│   ├── iphone-mockup/ - iPhone device frame
│   ├── qr-code/ - QR code display
│   └── section-divider/ - Section divider lines
│
└── internal/ (Utilities, not analyzed)
    - hooks, utils, contexts
```

**Developer Journey:** "I need to implement a button" → Navigate to base/buttons/ → See all button variants as separate files → Choose button.tsx or social-button.tsx → Read implementation

---

### UPSTREAM/untitledui-nextjs-starter-kit/ - Marketing + Pages

**Code Organization: By Next.js App Router + Page Type**

Marketing components and pages organized by Next.js structure:

```
UPSTREAM/untitledui-nextjs-starter-kit/
├── components/
│   └── marketing/
│       └── header-navigation/ (Only 1 marketing component in React repo)
│           ├── base-components/
│           └── *.tsx
│
└── src/app/ (Next.js app directory - where pages live)
    ├── page.tsx - Landing page
    ├── layout.tsx - Root layout
    ├── pricing/
    │   └── page.tsx - Pricing page
    ├── about/
    │   └── page.tsx - About page
    ├── contact/
    │   └── page.tsx - Contact page
    ├── blog/
    │   ├── page.tsx - Blog index
    │   └── [slug]/
    │       └── page.tsx - Blog post
    ├── login/
    │   └── page.tsx - Login page
    └── signup/
        └── page.tsx - Signup page
```

**Note:** Marketing components (17 types, 400+ variants shown on site) are primarily in Next.js starter kit, not the React component library. React library focuses on base/ and application/ components.

---

## Part 3: Documentation Site ↔ Code Mapping

### Mapping Strategy

**Documentation Site → Code Repository mapping follows these patterns:**

1. **Base Components**: Direct 1:1 mapping with variant fan-out
2. **Application Components**: Some 1:1, some demonstrated in demos only
3. **Marketing Components**: Mostly in Next.js starter kit, not React library
4. **Page Examples**: Compositions shown in demos/stories + Next.js pages

---

### Base Components Mapping

| Site Category           | Site Presentation                  | Code Location                                             | Mapping Pattern                          |
| ----------------------- | ---------------------------------- | --------------------------------------------------------- | ---------------------------------------- |
| **Buttons**             | Shows 13 button variants visually  | `base/buttons/`                                           | 1:many - Multiple files                  |
| - Buttons               | Primary, secondary, tertiary, etc. | `button.tsx`                                              | Single file, multiple variants           |
| - Social buttons        | Facebook, Twitter, Google, etc.    | `social-button.tsx`                                       | Single file                              |
| - App store buttons     | App Store, Google Play             | `app-store-buttons.tsx` + `app-store-buttons-outline.tsx` | 2 files (filled/outlined)                |
| - Utility buttons       | Icon-only, close, etc.             | `button-utility.tsx` + `close-button.tsx`                 | 2 files                                  |
| - Button groups         | Horizontal, vertical               | `base/button-group/`                                      | Separate component type                  |
| **Badges**              | Shows 25 badge variants            | `base/badges/badges.tsx` (417 lines)                      | 1:1 - All variants in single file        |
| **Badge groups**        | Shows 20 badge group variants      | `base/badges/badges.tsx`                                  | Same file as badges                      |
| **Inputs**              | Text, search, email variants       | `base/input/input.tsx` (271 lines)                        | 1:1 - All variants in single file        |
| **Select**              | Dropdown, multi-select, searchable | `base/select/`                                            | 1:many - 6 separate files                |
| - Standard select       | Dropdown                           | `select.tsx`                                              | Core implementation                      |
| - Native select         | Browser select                     | `select-native.tsx`                                       | Native fallback                          |
| - Searchable select     | With filtering                     | `combobox.tsx`                                            | Separate component                       |
| - Multi-select          | Multiple selections                | `multi-select.tsx` (363 lines)                            | Separate component                       |
| **Checkboxes**          | Single, groups, indeterminate      | `base/checkbox/`                                          | 1:1                                      |
| **Radio buttons**       | Single, groups, cards              | `base/radio-buttons/`                                     | 1:1                                      |
| **Toggles**             | Switch, with labels                | `base/toggle/`                                            | 1:1                                      |
| **Avatars**             | User, group, with status           | `base/avatar/`                                            | 1:many - 3 main files + base-components/ |
| **Tooltips**            | Top, bottom, left, right           | `base/tooltip/`                                           | 1:1 - Position via props                 |
| **Progress indicators** | Linear, circular                   | `base/progress-indicators/`                               | 1:1                                      |

**Key Pattern:**

- Simple components (toggle, checkbox): 1 site entry = 1 code file
- Variant-heavy components (buttons, select): 1 site entry = multiple code files
- Complex components (avatar): 1 site entry = multiple files + subdirectory

---

### Application Components Mapping

| Site Category           | Site Presentation                | Code Location                                      | Mapping Pattern                       |
| ----------------------- | -------------------------------- | -------------------------------------------------- | ------------------------------------- |
| **Page headers**        | 6 variants                       | `application/app-navigation/header-navigation.tsx` | Demonstrated in demos                 |
| **Sidebar navigations** | 5 variants                       | `application/app-navigation/sidebar-navigation/`   | Subdirectory with 4 files             |
| **Modals**              | 46 variants                      | `application/modals/modal.tsx` (42 lines) + demos  | Simple wrapper, variants in demos     |
| **Tables**              | 12 variants                      | `application/table/table.tsx` (300 lines) + demos  | Core component + demos                |
| **Paginations**         | 14 variants                      | `application/pagination/`                          | 4 files (pagination, base, dot, line) |
| **Tabs**                | 10 variants                      | `application/tabs/`                                | Demonstrated in demos                 |
| **Charts**              | Line, bar, pie, radar (13 total) | `application/charts/`                              | Uses recharts library                 |
| **Alerts**              | 12 variants                      | **NOT in UPSTREAM/react**                          | Likely in starter kit or docs only    |
| **Notifications**       | 9 variants                       | **NOT in UPSTREAM/react**                          | Likely in starter kit or docs only    |
| **File uploaders**      | 5 variants                       | `application/file-upload/`                         | Implementation in code                |
| **Date pickers**        | 6 variants                       | `application/date-picker/`                         | Implementation in code                |
| **Empty states**        | 3 variants                       | `application/empty-state/`                         | Implementation in code                |

**Key Observation:** Some application UI shown on site (alerts, notifications, breadcrumbs, activity feeds, messaging, metrics, CTAs, progress steps, command menus, code snippets, calendars, content dividers) are NOT in the `UPSTREAM/react/components/application/` directory. They may be:

- In Next.js starter kit only
- Demonstrated in documentation only
- Not yet implemented in React library

---

### Marketing Components Mapping

| Site Category                             | Code Location                                                   | Mapping Status                          |
| ----------------------------------------- | --------------------------------------------------------------- | --------------------------------------- |
| **Header navigations** (20)               | `components/marketing/header-navigation/` (Next.js starter kit) | Partial - 1 component in React library  |
| **All other marketing** (380+ components) | `src/app/` pages (Next.js starter kit)                          | **NOT in React component library**      |
| - Header sections                         | Next.js pages                                                   | Compositions, not standalone components |
| - Features sections                       | Next.js pages                                                   | Compositions, not standalone components |
| - Pricing sections                        | Next.js pages                                                   | Compositions, not standalone components |
| - Testimonials                            | Next.js pages                                                   | Compositions, not standalone components |
| - CTAs                                    | Next.js pages                                                   | Compositions, not standalone components |
| - Footers                                 | Next.js pages                                                   | Compositions, not standalone components |
| - All others                              | Next.js pages                                                   | Compositions, not standalone components |

**Critical Insight:** Marketing components on documentation site are primarily **page compositions** in Next.js starter kit, NOT standalone reusable components in the React library. The React library focuses on base/ and application/ primitives that marketing pages compose.

---

### Page Examples Mapping

| Site Category            | Code Location                                  | Mapping Pattern                |
| ------------------------ | ---------------------------------------------- | ------------------------------ |
| **Login pages** (16)     | `src/app/login/page.tsx` (Next.js starter kit) | Compositions shown in demos    |
| **Signup pages** (21)    | `src/app/signup/page.tsx`                      | Compositions shown in demos    |
| **404 pages** (10)       | `src/app/404/page.tsx` or custom error page    | Compositions shown in demos    |
| **Email templates** (10) | Likely separate email template directory       | Not in React component library |

---

## Part 4: How to Navigate Between Site and Code

### Use Case 1: "I want to build a button"

**Documentation Site Path:**

1. Browse to Base Components → Buttons
2. See visual examples of all button variants
3. Choose variant (e.g., Social buttons with Facebook icon)

**Code Repository Path:**

1. Navigate to `UPSTREAM/react/components/base/buttons/`
2. Open `social-button.tsx` for implementation
3. Open `buttons.demo.tsx` to see usage examples
4. Open `buttons.story.tsx` for Storybook stories

**Learning Path:**

- **Visual First**: See what it looks like on site
- **Implementation Second**: Read the code file
- **Usage Third**: See demos and stories

---

### Use Case 2: "I want to build a dashboard with sidebar navigation"

**Documentation Site Path:**

1. Browse to Application UI → Navigation → Sidebar navigations
2. See 5 visual variants (collapsed, expanded, multi-tier, etc.)
3. Choose multi-tier variant

**Code Repository Path:**

1. Navigate to `UPSTREAM/react/components/application/app-navigation/`
2. This is a complex component with subdirectories:
   - `sidebar-navigation/sidebar-dual-tier.tsx` - Multi-tier implementation
   - `base-components/` - Shared navigation items
   - `config.ts` - Navigation configuration
3. Open `sidebar-navigation.demo.tsx` to see integration
4. Open `sidebar-navigation.story.tsx` for Storybook

**Learning Path:**

- **Pattern First**: Understand this is composition-heavy (uses base-components/)
- **Structure Second**: See subdirectory organization
- **Integration Third**: Study how it composes nav items
- **Configuration Fourth**: See config.ts for data structure

---

### Use Case 3: "I want to build a landing page"

**Documentation Site Path:**

1. Browse to Marketing Page Examples → Landing pages
2. See 20 complete landing page examples
3. Choose SaaS landing page variant
4. See sections: Header + Hero + Features + Testimonials + CTA + Footer

**Code Repository Path:**

1. **IMPORTANT**: Marketing pages are NOT in `UPSTREAM/react/`
2. Navigate to `UPSTREAM/untitledui-nextjs-starter-kit/src/app/page.tsx`
3. See how page **composes** marketing sections
4. Each section is a **composition** using base components, not a standalone component

**Learning Path:**

- **Page Structure First**: See how sections are arranged
- **Section Composition Second**: See how base components compose each section
- **Base Components Third**: Navigate to base/ for button, input, avatar implementations
- **Integration Fourth**: Study how sections integrate with each other

**Critical Pitfall:** Looking for "features section component" in `UPSTREAM/react/components/marketing/` - it doesn't exist as a standalone component. It's a page composition pattern.

---

### Use Case 4: "I want to understand Select component architecture"

**Documentation Site Path:**

1. Browse to Base Components → Select
2. See dropdown variants, multi-select, searchable select

**Code Repository Path:**

1. Navigate to `UPSTREAM/react/components/base/select/`
2. See 6 files - each is a different variant:
   - `select.tsx` - Standard dropdown (where to start)
   - `combobox.tsx` - Searchable variant
   - `multi-select.tsx` - Multi-selection variant
   - `select-native.tsx` - Native browser select
   - `select-item.tsx` - Shared item component
   - `popover.tsx` - Shared popover wrapper

**Learning Path:**

- **Start Simple**: Read `select.tsx` first (core implementation)
- **Understand Extension**: See how `combobox.tsx` extends select behavior
- **Understand Composition**: See how both use `select-item.tsx` and `popover.tsx`
- **Pattern Recognition**: Recognize this is variant-as-file pattern

---

## Part 5: Common Pitfalls and Solutions

### Pitfall 1: Expecting 1:1 Site-to-Code Mapping

**Problem:** Documentation site shows "46 modal variants" → Expecting 46 modal files in code

**Reality:** `modal.tsx` is 42 lines, wraps React Aria Modal. All 46 variants demonstrated in `modals.demo.tsx` through different compositions and prop combinations.

**Solution:** Understand that site shows **visual variants** (different compositions/styles), code provides **implementation primitives** (core components).

---

### Pitfall 2: Looking for Marketing Components in React Library

**Problem:** Site shows "Header sections (44 variants)" → Looking in `UPSTREAM/react/components/marketing/`

**Reality:** Marketing sections are **page compositions** in Next.js starter kit, not standalone React components. React library provides base components (Button, Input, etc.) that marketing pages compose.

**Solution:**

- For reusable primitives: Use `UPSTREAM/react/components/base/` and `application/`
- For marketing patterns: Use `UPSTREAM/untitledui-nextjs-starter-kit/src/app/` as reference
- Build marketing sections by composing base components

---

### Pitfall 3: Not Understanding Variant-as-File Pattern

**Problem:** Seeing `buttons/` directory with multiple .tsx files → Confused about which file to use

**Reality:** Each file is a different button variant:

- `button.tsx` - Standard buttons (primary, secondary, tertiary)
- `social-button.tsx` - Social media buttons
- `app-store-buttons.tsx` - App store download buttons

**Solution:**

- File names indicate variant type
- Start with most general file (e.g., `button.tsx`)
- Use specialized files when needed (e.g., `social-button.tsx` for Facebook button)

---

### Pitfall 4: Assuming All Site Components Exist in Code

**Problem:** Site shows "Command menus (9 variants)" → Can't find in code

**Reality:** Some components shown on site may be:

- In Next.js starter kit only (not React library)
- Demonstrations only (not implemented as components)
- Future components (site shows roadmap)

**Solution:**

- Check `UPSTREAM/react/components/` first
- If not found, check `UPSTREAM/untitledui-nextjs-starter-kit/components/`
- If still not found, may need to build as composition of existing components

---

### Pitfall 5: Overlooking Demo and Story Files

**Problem:** Reading `button.tsx` implementation only → Missing how to actually use it

**Reality:**

- `button.tsx` - Implementation
- `buttons.demo.tsx` - Usage examples with real scenarios
- `buttons.story.tsx` - All variants in Storybook

**Solution:** ALWAYS read all three files:

1. Implementation (.tsx) - How it's built
2. Demo (.demo.tsx) - How to use it in real scenarios
3. Story (.story.tsx) - All visual variants and prop combinations

---

### Pitfall 6: Not Recognizing base-components/ Pattern

**Problem:** Seeing `avatar/base-components/` subdirectory → Confused about purpose

**Reality:** Only 3 components use base-components/ (avatar, tags, app-navigation) - it's for shared sub-components used by multiple variants.

**Solution:**

- Recognize this pattern is RARE (only 3 components)
- Understand it's for significant shared implementation
- Don't over-apply this pattern to other components

---

## Part 6: Progressive Learning Path

### Level 1: Beginner - Simple Base Components

**Objective:** Understand basic component structure and patterns

**Components to Study:**

1. `base/toggle/` - Simplest (single file, minimal complexity)
2. `base/checkbox/` - Form control basics
3. `base/tooltip/` - Positioning and overlay patterns

**What to Learn:**

- Single-file component structure
- React Aria integration basics
- Props interface design
- Demo and story file purpose

**Time Investment:** 2-3 hours

---

### Level 2: Intermediate - Variant-Heavy Components

**Objective:** Understand variant-as-file pattern and complexity scaling

**Components to Study:**

1. `base/select/` - 6 files, moderate complexity
2. `base/pagination/` - 4 files, different interaction models
3. `base/avatar/` - 3 files + base-components/, composition pattern

**What to Learn:**

- When to create separate variant files
- How variants share sub-components (base-components/)
- File naming conventions for variants
- Integration between related variants

**Time Investment:** 4-6 hours

---

### Level 3: Advanced - Application Components

**Objective:** Understand composition, integration, and complexity management

**Components to Study:**

1. `application/table/` - Integrates 4 base components
2. `application/modals/` - Simple wrapper + complex demos
3. `application/app-navigation/` - Most complex, subdirectories

**What to Learn:**

- How application components compose base components
- Context API usage for state sharing
- Complex subdirectory organization
- Integration patterns (Table + Checkbox + Dropdown)

**Time Investment:** 6-8 hours

---

### Level 4: Expert - System Understanding

**Objective:** Understand entire system architecture and patterns

**Study Activities:**

1. Compare base/ vs application/ vs foundations/ organization
2. Study all base-components/ usage (3 components)
3. Map dependencies (which application components use which base components)
4. Compare React library vs Next.js starter kit organization

**What to Learn:**

- When to create base vs application components
- When to extract base-components/
- How marketing pages compose base components
- System-level architectural patterns

**Time Investment:** 8-12 hours

---

### Level 5: Master - Full System + AI Documentation

**Objective:** Understand system well enough to document for AI consumption

**Study Activities:**

1. Study all 30 component types
2. Document universal vs category vs component-specific patterns
3. Create pattern libraries and integration guides
4. Test understanding by implementing new components

**What to Learn:**

- Pattern scope (universal/category/component)
- Variant decision criteria
- base-components/ decision criteria
- Documentation strategies for AI

**Time Investment:** 20-30 hours (Phase 0 scope)

---

## Part 7: Quick Reference Tables

### Component Count by Category

| Category             | Site Presentation         | Code Files          | Mapping Type                    |
| -------------------- | ------------------------- | ------------------- | ------------------------------- |
| Base Components      | 28 types, 200+ variants   | 18 types, 46 files  | Partial - most primitives exist |
| Application UI       | 32 types, 300+ components | 12 types, 33 files  | Partial - core patterns exist   |
| Shared Pages         | 6 types, 65 pages         | Next.js starter kit | Compositions, not components    |
| Marketing Components | 17 types, 400+ components | 1 type in React lib | Mostly Next.js compositions     |
| Marketing Pages      | 9 types, 95 pages         | Next.js starter kit | Complete page examples          |

---

### File Pattern Quick Reference

| Pattern                | Example Component  | Files                                                        | When Used                         |
| ---------------------- | ------------------ | ------------------------------------------------------------ | --------------------------------- |
| Simple                 | Toggle, Checkbox   | 1 .tsx + demo + story                                        | Simple, single-responsibility     |
| Variant-Heavy          | Select, Pagination | Multiple .tsx + demo + story                                 | Different interaction models      |
| With base-components/  | Avatar, Tags       | Multiple .tsx + base-components/ + demo + story              | Variants share significant code   |
| Complex Subdirectories | App-Navigation     | Subdirectories + base-components/ + config + demos + stories | Highly complex with many variants |

---

### Complexity Quick Reference

| Complexity | Line Count    | Example Components                  | Learning Time  |
| ---------- | ------------- | ----------------------------------- | -------------- |
| Simple     | <100 lines    | Toggle, Checkbox, Tooltip           | 30 min each    |
| Medium     | 100-300 lines | Button, Input, Select, Pagination   | 1-2 hours each |
| Complex    | >300 lines    | Table, App-Navigation, Multi-Select | 2-4 hours each |

---

## Conclusion

**Key Takeaways:**

1. **Documentation Site = User View** (organized by use case, shows visual variants)
2. **Code Repository = Implementation View** (organized by structure, provides primitives)
3. **Mapping is Not 1:1** (site shows compositions, code provides building blocks)
4. **React Library ≠ Complete Site** (marketing is in Next.js starter kit)
5. **Always Read 3 Files** (implementation + demo + story)
6. **Respect Variant Patterns** (separate files, base-components/, subdirectories)

**Next Steps After Reading This:**

1. Choose your level (beginner/intermediate/advanced/expert)
2. Follow progressive learning path
3. Study components in order of complexity
4. Always map site → code → usage
5. Build understanding before building components

**When to Reference This Document:**

- Starting to learn UntitledUI system
- Can't find a component shown on site
- Confused about file organization
- Planning new component implementation
- Teaching others about the system

---

**Document Status:** Phase 0.4 Complete
**Next:** Phase 0.5 - Create master documentation suite (5 documents)
