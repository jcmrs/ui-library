# UntitledUI Reference Study Guide

**Date:** 2025-10-25
**Purpose:** How to effectively use UPSTREAM/ code and untitledui.com documentation as learning references
**Critical Lesson:** The reference is the specification - study it thoroughly before implementing

---

## Table of Contents

1. [Reference Resources Overview](#reference-resources-overview)
2. [UPSTREAM/ Navigation Guide](#upstream-navigation-guide)
3. [untitledui.com Usage Guide](#untitleduicom-usage-guide)
4. [Cross-Reference Workflow](#cross-reference-workflow)
5. [Progressive Learning Path](#progressive-learning-path)
6. [Common Pitfalls and Solutions](#common-pitfalls-and-solutions)
7. [Quick Reference Lookup](#quick-reference-lookup)
8. [Study Methodology](#study-methodology)

---

## Reference Resources Overview

### What We Have

**1. UPSTREAM/ Directory (Local Clone)**

- `UPSTREAM/react/` - Complete UntitledUI React component library
- `UPSTREAM/icons/` - UntitledUI Icons library
- `UPSTREAM/untitledui-nextjs-starter-kit/` - Next.js integration examples
- `UPSTREAM/untitledui-vite-starter-kit/` - Vite integration examples
- `UPSTREAM/agents/` - wshobson agent framework
- `UPSTREAM/dyad/` - Additional reference implementation

**2. Documentation Website**

- https://www.untitledui.com/react/components
- Visual documentation of all components
- All variants and states shown
- Usage examples and patterns
- Design specifications

**3. Project Documentation (This Repository)**

- `.docs/SYSTEM-ARCHITECTURE.md` - System overview
- `.docs/COMPONENT-TAXONOMY.md` - Component categories
- `.docs/PATTERN-LIBRARY.md` - Pattern catalog with scope
- `.docs/INTEGRATION-GUIDE.md` - Component integration
- `.docs/DOCUMENTATION-SITE-MAPPING.md` - Site to code mapping
- `.docs/REFERENCE-STUDY-GUIDE.md` - This document

### Resource Priority for Different Tasks

**When starting new component:**

1. ✅ untitledui.com - See visual variants and states
2. ✅ UPSTREAM/react - Study implementation
3. ✅ Project docs - Understand patterns and integration

**When stuck on implementation:**

1. ✅ UPSTREAM/react - Find similar component
2. ✅ Project PATTERN-LIBRARY.md - Check pattern scope
3. ✅ untitledui.com - Verify visual behavior

**When planning integration:**

1. ✅ Project INTEGRATION-GUIDE.md - Integration patterns
2. ✅ UPSTREAM/react - Real integration examples
3. ✅ untitledui.com - See components together

---

## UPSTREAM/ Navigation Guide

### Directory Structure

```
UPSTREAM/
├── react/                              ← Component library (PRIMARY REFERENCE)
│   ├── components/
│   │   ├── base/                       ← Primitive components
│   │   │   ├── avatar/
│   │   │   ├── badges/
│   │   │   ├── buttons/
│   │   │   ├── checkbox/
│   │   │   ├── dropdown/
│   │   │   ├── input/
│   │   │   ├── select/
│   │   │   ├── toggle/
│   │   │   └── ... (18 types total)
│   │   ├── application/                ← Complex app UI
│   │   │   ├── app-navigation/
│   │   │   ├── charts/
│   │   │   ├── date-picker/
│   │   │   ├── modals/
│   │   │   ├── table/
│   │   │   ├── tabs/
│   │   │   └── ... (12 types total)
│   │   ├── foundations/                ← Design primitives
│   │   │   ├── featured-icon/
│   │   │   ├── logo/
│   │   │   ├── payment-icons/
│   │   │   └── social-icons/
│   │   ├── shared-assets/              ← Visual assets
│   │   │   ├── background-patterns/
│   │   │   ├── credit-card/
│   │   │   └── illustrations/
│   │   └── internal/                   ← Utilities
│   ├── styles/
│   │   └── theme.css                   ← Design tokens
│   └── utils/
│       └── cx.ts                       ← Class utility
│
├── icons/                              ← Icon library
│   └── ... (separate icon system)
│
├── untitledui-nextjs-starter-kit/     ← Next.js examples
│   ├── components/
│   │   └── marketing/                  ← Marketing sections
│   └── src/app/                        ← Page examples
│
├── untitledui-vite-starter-kit/       ← Vite examples
│
└── agents/                             ← wshobson framework
    └── plugins/                        ← Agent plugins
```

### How to Find What You Need

**Scenario 1: "I need to implement Button component"**

```bash
Path: UPSTREAM/react/components/base/buttons/

Files to Study:
1. button.tsx                 ← Core implementation (272 lines)
2. social-button.tsx          ← Social media variant
3. app-store-buttons.tsx      ← App store variant
4. button-utility.tsx         ← Icon-only variant
5. close-button.tsx           ← Close button variant
6. buttons.demo.tsx           ← Usage examples
7. buttons.story.tsx          ← Storybook with all variants

Study Order:
1. buttons.demo.tsx - See how it's used
2. button.tsx - Core implementation
3. Other variants - Different interaction models
4. buttons.story.tsx - All visual states
```

**Scenario 2: "I need to understand Select component"**

```bash
Path: UPSTREAM/react/components/base/select/

Files to Study:
1. select.tsx                 ← Standard dropdown (226 lines)
2. combobox.tsx              ← Searchable select (195 lines)
3. multi-select.tsx          ← Multiple selections (363 lines)
4. select-native.tsx         ← Native select fallback
5. select-item.tsx           ← Option component
6. popover.tsx               ← Dropdown popover
7. select.demo.tsx           ← Usage examples
8. select.story.tsx          ← Storybook

Study Order:
1. select.demo.tsx - Understand usage
2. select.tsx - Core dropdown
3. combobox.tsx - Searchable variant (different interaction)
4. multi-select.tsx - Multi-select (different interaction)
5. Understand why variants are separate files
```

**Scenario 3: "I need to build a data table"**

```bash
Path: UPSTREAM/react/components/application/table/

Files to Study:
1. table.tsx                  ← Core table (300 lines)
2. table-card.tsx            ← Card layout variant
3. table.demo.tsx            ← Usage examples with integration
4. table.story.tsx           ← All table states

Integration Points (study these too):
- base/checkbox/              ← Row selection
- base/dropdown/              ← Row actions
- base/badges/                ← Status badges
- base/avatar/                ← User avatars
- base/tooltip/               ← Cell tooltips

Study Order:
1. table.demo.tsx - See complete integration
2. table.tsx - Core structure
3. Integration components - How they compose
```

**Scenario 4: "I need marketing page header"**

```bash
Path: UPSTREAM/untitledui-nextjs-starter-kit/components/marketing/header-navigation/

Files to Study:
1. header-navigation.tsx           ← Main implementation
2. header-navigation-*.tsx         ← Variants
3. base-components/               ← Shared sub-components
4. header-navigation.demo.tsx     ← Usage

ALSO Study:
Path: UPSTREAM/untitledui-nextjs-starter-kit/src/app/

Files:
1. page.tsx                       ← Landing page example
2. layout.tsx                     ← Root layout

Study Order:
1. src/app/page.tsx - See complete page
2. components/marketing/header-navigation/ - Component details
3. Understand composition strategy
```

### File Naming Patterns

**Component Files:**

- `component.tsx` - Core implementation
- `component-variant.tsx` - Named variant
- `component.demo.tsx` - Usage demos
- `component.story.tsx` - Storybook stories

**Supporting Files:**

- `base-components/` - Shared sub-components (rare - 10% of components)
- `utils.ts` - Component-specific utilities
- `config.ts` - Component configuration
- `types.ts` - Type definitions (rare - usually inline)

**Directory Patterns:**

- Single-file: `toggle/toggle.tsx` (40%)
- Multi-variant: `buttons/button.tsx + social-button.tsx + ...` (50%)
- With base-components: `avatar/avatar.tsx + base-components/` (10%)

---

## untitledui.com Usage Guide

### Site Navigation

**Homepage:** https://www.untitledui.com/react/components

**Main Categories:**

1. **Foundations** - Design system basics

   - Colors, typography, icons
   - NOT interactive components

2. **Base Components** - UI primitives

   - Browse by component type
   - All variants shown visually
   - Interactive examples

3. **Application UI** - Complex patterns

   - Navigation, data display, feedback
   - Full page examples
   - Integration patterns

4. **Pages** - Complete page templates

   - Authentication, errors, marketing
   - Full compositions

5. **Marketing Sections** - Marketing components
   - Headers, features, pricing
   - Newsletter, testimonials, CTAs

### How to Use the Site Effectively

**Step 1: Browse Visually**

```
Task: Implement Button component

1. Go to: untitledui.com/react/components
2. Find: Base Components → Buttons
3. Observe:
   - How many variants exist? (13+ button types)
   - What visual states? (default, hover, focus, disabled, loading)
   - What sizes? (4 sizes visible)
   - What color variants? (9 color variants)
4. Take Mental Notes:
   - Primary buttons have solid background
   - Secondary have ring border
   - Tertiary are transparent
   - Link variants have no background
   - Destructive variants use error colors
```

**Step 2: Examine Interactions**

```
On the site:
1. Hover over buttons - See hover states
2. Click buttons - See active states
3. Try keyboard navigation - Tab/Enter/Space
4. Check loading states
5. Check disabled states

Mental Model:
- What animations exist?
- How do focus indicators work?
- What keyboard interactions?
```

**Step 3: Note All Variants**

```
For Button, document:
1. Standard Buttons:
   - Primary
   - Secondary
   - Tertiary
   - Link (gray)
   - Link (color)

2. Destructive Variants:
   - Primary destructive
   - Secondary destructive
   - Tertiary destructive
   - Link destructive

3. Social Buttons:
   - Facebook, Twitter, Google, GitHub, etc.

4. App Store Buttons:
   - App Store, Google Play

5. Utility Buttons:
   - Icon-only, close button
```

**Step 4: Check Edge Cases**

```
Look for:
- Very long text in buttons
- Icon + text combinations
- Icon-only buttons
- Loading states with text
- Disabled + loading?
- Full-width variants?
```

### Site-Specific Tips

**Tip 1: Use Interactive Examples**

- Site has interactive playgrounds
- Change props in real-time
- See code examples generated

**Tip 2: Check Responsive Behavior**

- Resize browser window
- See mobile vs desktop variants
- Note breakpoint changes

**Tip 3: Inspect with DevTools**

- Right-click → Inspect
- See actual Tailwind classes used
- Understand token mapping

**Tip 4: Copy Example Code**

- Site provides code snippets
- Use as reference, not copy-paste
- Adapt to our patterns (React Aria, cx(), etc.)

---

## Cross-Reference Workflow

### The Reference-First Methodology

**Critical Rule:** ALWAYS study reference BEFORE planning implementation.

**Correct Workflow:**

```
1. Visual Understanding (untitledui.com)
   ↓
2. Implementation Study (UPSTREAM/react)
   ↓
3. Pattern Verification (Project docs)
   ↓
4. Create Implementation Plan
   ↓
5. Build with Continuous Reference
   ↓
6. Validate Against Reference
```

### Step-by-Step: Implementing New Component

**Phase 1: Visual Study (30-60 minutes)**

```
1. Go to untitledui.com/react/components
2. Find component category
3. Study ALL variants visually
4. Note ALL states (default, hover, active, focus, disabled, loading)
5. Test ALL interactions (click, keyboard, hover)
6. Document what you see:

   Example Notes for Button:
   - 9 color variants (not 4!)
   - 4 size variants (sm, md, lg, xl)
   - Loading state with spinner
   - Icon support (before/after text)
   - Icon-only detection
   - Polymorphic (button vs link based on href)
   - Focus ring on all variants
   - Smooth transitions on all states
```

**Phase 2: Code Study (1-2 hours)**

```
1. Navigate to UPSTREAM/react/components/[category]/[component]/
2. List all files:
   ls UPSTREAM/react/components/base/buttons/

   Output:
   - button.tsx (272 lines)
   - social-button.tsx
   - app-store-buttons.tsx
   - button-utility.tsx
   - close-button.tsx
   - buttons.demo.tsx
   - buttons.story.tsx

3. Read in order:
   a. *.demo.tsx - Usage examples
   b. Core *.tsx - Implementation
   c. Variant files - Different interaction models
   d. *.story.tsx - All visual combinations

4. Document findings:
   - Which patterns are used? (React Aria ✓, cx() ✓, design tokens ✓)
   - Why are variants separate files? (Different interaction models)
   - How are props structured? (color, size, loading, href)
   - What are the dependencies? (React Aria Button/Link)
```

**Phase 3: Pattern Verification (30 minutes)**

```
1. Open .docs/PATTERN-LIBRARY.md
2. Check pattern scope for each pattern found:
   - Polymorphic rendering → 🔧 COMPONENT: Button (DO NOT assume universal)
   - Color variants (9) → 🔧 COMPONENT: Button (DO NOT assume universal)
   - Icon-only detection → 🔧 COMPONENT: Button (DO NOT assume universal)
   - Design tokens → 🌐 UNIVERSAL (use everywhere)
   - cx() utility → 🌐 UNIVERSAL (use everywhere)
   - React Aria → 🌐 UNIVERSAL (for interactive components)

3. Document which patterns apply to YOUR component:
   If building Select:
   - ✅ Design tokens (UNIVERSAL)
   - ✅ cx() (UNIVERSAL)
   - ✅ React Aria (UNIVERSAL for interactive)
   - ❌ Polymorphic rendering (Button-specific)
   - ❌ Color variants (Button-specific)
   - ✅ Size variants (Select has 2: sm/md, different from Button's 4)
```

**Phase 4: Implementation Plan (30 minutes)**

```
Create detailed plan:

1. File Structure:
   - component.tsx
   - component-variant.tsx (if needed)
   - component.demo.tsx
   - component.story.tsx
   - component.test.tsx
   - component.patterns.md
   - component.checklist.json

2. Props Interface:
   - List all props from UntitledUI
   - Document default values
   - Note which are required

3. Implementation Approach:
   - Which React Aria components to use?
   - What design tokens needed?
   - How to handle variants?
   - Any Context API needed?

4. Testing Strategy:
   - All variants
   - All states
   - Keyboard navigation
   - Accessibility
```

**Phase 5: Implementation with Reference (2-4 hours)**

```
While Coding:

1. Keep UPSTREAM/react/[component] open
2. Reference constantly:
   - How did they structure this?
   - What classes did they use?
   - How did they handle this state?

3. DO NOT copy-paste blindly
   - Understand WHY each pattern
   - Adapt to our architecture
   - Use our utilities (cx(), design tokens)

4. Continuous Validation:
   - Does this match visual from untitledui.com?
   - Does this match implementation from UPSTREAM/?
   - Are we using correct pattern scope?
```

**Phase 6: Validation (30 minutes)**

```
1. Visual Check:
   - Compare with untitledui.com
   - All variants look correct?
   - All states work?

2. Code Check:
   - Compare with UPSTREAM/react
   - Similar structure?
   - Using same React Aria patterns?

3. Pattern Check:
   - All UNIVERSAL patterns applied?
   - No COMPONENT-specific patterns assumed?
   - Documentation complete?

4. Integration Check:
   - Does it compose with other components?
   - Accessibility maintained?
```

---

## Progressive Learning Path

### Level 1: Beginner (Primitive Component)

**Goal:** Understand the basics - simple building block component

**Recommended First Component:** Input (Form field primitive)

**What This Is:** A primitive component for text input in forms. Single responsibility. NOT a page template, NOT a layout component.

**Study Path:**

1. Visit untitledui.com → Base Components → Input
2. Observe: Text field, validation states, sizes
3. Study UPSTREAM/react/components/base/input/
   - input.tsx (core input field - ~270 lines)
   - input.demo.tsx (usage examples)
   - input.story.tsx (visual variants)
4. Note patterns:
   - React Aria TextField ✓
   - cx() utility ✓
   - Design tokens ✓
   - Size variants (sm/md) ✓
   - Validation states (error) ✓

**Time:** 3-4 hours total

**Success Criteria:**

- Input field works correctly
- Form integration works
- Validation states display correctly
- Accessibility for form field (label association, error announcements)
- Storybook shows all states

**What You Learn:**

- How a primitive form component works
- Difference between a reusable component vs a complete form (form = composition)
- Form accessibility patterns

---

### Level 2: Intermediate (Layout Component)

**Goal:** Understand structural/navigation components - different from primitives

**Recommended Component:** Sidebar Navigation

**What This Is:** A layout component that defines page structure. NOT a primitive building block. NOT a page template. It's for organizing/navigating within an application.

**Study Path:**

1. untitledui.com → Application UI → App Navigation → Sidebar
2. Observe: Left sidebar, navigation items, collapsible, different styles
3. Study UPSTREAM/react/components/application/app-navigation/sidebar-navigation/
   - sidebar-navigation-base.tsx (base implementation)
   - sidebar-simple.tsx (variant)
   - sidebar-dual-tier.tsx (variant with nested nav)
   - sidebar-section-dividers.tsx (variant with sections)
4. Note:
   - Layout positioning (fixed, left/right)
   - Navigation structure (hierarchical items)
   - State management (collapsed/expanded)
   - Different from primitive components (this is structural)

**Time:** 5-7 hours

**Success Criteria:**

- Sidebar renders and positions correctly
- Navigation items work
- Collapse/expand works
- Understand difference: Layout component vs Primitive component vs Page template

**What You Learn:**

- How layout components differ from primitives
- Structural component patterns
- Navigation accessibility patterns
- When to use layout components vs composing primitives

---

### Level 3: Advanced (Specialized Display Component)

**Goal:** Understand specific-purpose display components - different from general UI components

**Recommended Component:** Code Snippet (Specialized display)

**What This Is:** A specialized component for displaying code. NOT a general-purpose UI component like Button or Input. It has a specific display purpose.

**Study Path:**

1. untitledui.com → Application UI → Code Snippet
2. Observe: Syntax highlighting, copy button, line numbers
3. Study UPSTREAM/react/components/application/code-snippet/
   - code-snippet.tsx (specialized for code display)
   - code-snippet.demo.tsx
4. Note:
   - Specific purpose (display code, not general UI)
   - Integration with syntax highlighter library
   - Copy-to-clipboard functionality
   - Different from primitives (not a building block)
   - Different from layout (not structural)

**Time:** 4-6 hours

**Success Criteria:**

- Code displays with proper formatting
- Syntax highlighting works
- Copy functionality works
- Understand: Specialized component vs General-purpose component

**What You Learn:**

- When a component is specialized vs general-purpose
- Integration with third-party libraries
- Display-only components vs interactive primitives
- Not every component is a "building block"

---

### Level 4: Expert (Page Template - NOT A COMPONENT)

**Goal:** Understand complete pages - these are COMPOSITIONS of components, NOT components themselves

**Recommended Study:** 404 Error Page

**⚠️ CRITICAL:** A page template is NOT a component in the library. It's a composition that USES library components.

**What This Is:**

- Complete page layout
- Uses multiple library components (Input, Button, Illustration)
- NOT in the component library (in pages/ or Next.js app/)
- This is CONSUMING components, not CREATING a component

**Study Path:**

1. untitledui.com → Pages → 404 Pages
2. Observe: Complete page with layout, illustration, message, search, button
3. Study UPSTREAM/untitledui-nextjs-starter-kit/src/app/error/404/
   - NOT in UPSTREAM/react/components/ (it's a page, not a component)
   - page.tsx (Next.js page file)
4. Identify library components used:
   - Illustration component (from shared-assets/)
   - Input component (from base/)
   - Button component (from base/)
   - Layout structure (composition)

**Time:** 6-8 hours

**Success Criteria:**

- Understand: Page template ≠ Component
- Can identify which parts are library components
- Can identify which parts are page-specific composition
- Understand: 404 page USES the library, it's not IN the library

**What You Learn:**

- Difference between component and page template
- How to compose library components into pages
- What belongs in component library vs application code
- Why "page template" is misleading term (it's not a reusable component)

---

### Level 5: Master (Complex Component Integration)

**Goal:** Understand complex application component that integrates many library primitives

**Recommended Component:** Table (Application component that composes primitives)

**What This Is:** An application component (in the library) that integrates multiple primitive components. This IS a library component, but it's complex and composed.

**Study Path:**

1. untitledui.com → Application UI → Table
2. Observe: Table integrates Checkbox, Dropdown, Badge, Avatar, Tooltip
3. Study UPSTREAM/react/components/application/table/
   - table.tsx (301 lines, complex integration)
   - table-card.tsx (variant)
   - table.demo.tsx (shows integration with other components)
4. Study the integrated components:
   - base/checkbox/ (for row selection)
   - base/dropdown/ (for row actions)
   - base/badges/ (for status display)
   - base/avatar/ (for user display)
   - base/tooltip/ (for cell hints)

**Time:** 12-16 hours

**Success Criteria:**

- Understand: Application component vs Primitive component
- Table structure works correctly
- Integration with Checkbox, Dropdown, Badge, Avatar, Tooltip works
- Selection state management works
- Understand: This is IN the library (unlike 404 page which USES the library)

**What You Learn:**

- How application components integrate primitives
- Complex composition patterns
- State management for complex components
- All components integrated
- Responsive design working
- Accessibility throughout
- Error handling
- Loading states

---

## Learning Path Summary

**What You Learn at Each Level:**

| Level | Component Type        | Example      | In Library?           | Key Lesson                                        |
| ----- | --------------------- | ------------ | --------------------- | ------------------------------------------------- |
| **1** | Primitive Component   | Input field  | ✅ Yes (base/)        | Basic building block for forms                    |
| **2** | Layout Component      | Sidebar      | ✅ Yes (application/) | Structural/navigation (different from primitives) |
| **3** | Specialized Display   | Code snippet | ✅ Yes (application/) | Specific purpose (not general-purpose UI)         |
| **4** | Page Template         | 404 page     | ✅ Yes (pages/)       | Complete composition - NOT a reusable component   |
| **5** | Application Component | Table        | ✅ Yes (application/) | Complex integration of primitives                 |

**Critical Distinctions You Must Understand:**

### 1. Primitive Component (Input, Button, Toggle, Checkbox)

- Single responsibility
- Reusable building block
- **In component library:** ✅ Yes (base/)
- **Example:** Input field for text entry in forms

### 2. Layout Component (Sidebar, Header navigation)

- Structural/navigational purpose
- Defines page organization
- **In component library:** ✅ Yes (application/)
- **Example:** Sidebar navigation for app structure

### 3. Application Component (Table, Modal, Tabs)

- Complex, composed functionality
- Integrates multiple primitives
- **In component library:** ✅ Yes (application/)
- **Example:** Table that uses Checkbox, Dropdown, Badge, Avatar

### 4. Specialized Display (Code snippet, QR code, Illustration)

- Specific display purpose only
- Not general-purpose interactive UI
- **In component library:** ✅ Yes (foundations/ or shared-assets/)
- **Example:** Code snippet with syntax highlighting

### 5. Page Template (404 page, Login page) - ⚠️ NOT A COMPONENT

- Complete page composition
- USES components from library
- **In component library:** ❌ NO (in pages/ or Next.js app/ directories)
- **Example:** 404 page = Illustration + Input + Button composed together

### 6. Component Library (this entire project)

- Collection of components #1-4 above
- The system as a whole
- NOT a single component

**Why This Matters:**

When you read "component," you MUST ask:

- Is this a primitive (building block)?
- Is this a layout (structural)?
- Is this specialized (specific purpose)?
- Is this a page template (composition, not a component)?
- Are they talking about the library (collection)?

DO NOT assume "component" always means the same thing.

---

## Common Pitfalls and Solutions

### Pitfall 1: Not Studying Reference First ❌

**Mistake:**

```
Developer: "I know what a Button is, I'll just implement it"
[Implements simple button with 4 variants]
User: "You missed 9 color variants, polymorphic rendering, icon-only detection, loading states..."
```

**Solution:**

```
✅ ALWAYS study untitledui.com + UPSTREAM/ BEFORE planning
✅ Document ALL features found in reference
✅ Verify against reference continuously during implementation
```

**Time Saved:** 2-4 hours of rework

---

### Pitfall 2: Assuming Button Patterns Apply Universally ❌

**Mistake:**

```
Developer: "Button has 9 color variants, so Select should too"
[Implements Select with color prop]
Reality: Select has NO color variants, only validation states
```

**Solution:**

```
✅ Check PATTERN-LIBRARY.md for pattern scope
✅ Verify each pattern's scope label (🌐 UNIVERSAL / 🏗️ CATEGORY / 🔧 COMPONENT)
✅ Study specific component, don't assume from Button
```

**Reference:** `.docs/PATTERN-LIBRARY.md` - Pattern scope labels

---

### Pitfall 3: Copying Code Without Understanding ❌

**Mistake:**

```
Developer: *Copy-pastes button.tsx*
[Code doesn't work because context is different]
```

**Solution:**

```
✅ Read code to UNDERSTAND, not to copy
✅ Identify PATTERNS, then implement with our architecture
✅ Adapt to our utilities (cx(), design tokens, etc.)
✅ Don't copy hardcoded values
```

---

### Pitfall 4: Ignoring File Structure Patterns ❌

**Mistake:**

```
Developer: "I'll put all Select variants in one file"
Reality: UntitledUI has 6 separate files (select.tsx, combobox.tsx, multi-select.tsx, etc.)
Reason: Different interaction models need separate files
```

**Solution:**

```
✅ Study file structure in UPSTREAM/
✅ Understand WHY variants are separate files
✅ Separate files when interaction model changes
✅ Single file when only visual changes
```

**Decision Criteria:**

- Different interaction model → Separate file (Select vs Combobox)
- Same interaction, different style → Single file with variants (Badge variants)

---

### Pitfall 5: Missing Integration Patterns ❌

**Mistake:**

```
Developer: *Implements Table in isolation*
[Doesn't realize Table integrates Checkbox, Dropdown, Badge, Avatar, Tooltip]
```

**Solution:**

```
✅ Study *.demo.tsx files - show integration
✅ Read INTEGRATION-GUIDE.md
✅ Look for component usage in UPSTREAM/
✅ Test integration as you build
```

---

### Pitfall 6: Not Checking Edge Cases ❌

**Mistake:**

```
Developer: *Tests Button with normal text*
[Doesn't test: very long text, icon-only, loading + disabled, etc.]
```

**Solution:**

```
✅ Check all states on untitledui.com
✅ Study *.story.tsx for edge cases
✅ Test: empty, short, long, very long text
✅ Test: all state combinations
```

---

### Pitfall 7: Ignoring Accessibility ❌

**Mistake:**

```
Developer: "I'll add accessibility later"
[Builds button as <div onClick={...}>]
Result: Not keyboard accessible, no screen reader support
```

**Solution:**

```
✅ Use React Aria from the start (UNIVERSAL pattern for interactive components)
✅ Study UPSTREAM/ React Aria usage
✅ Test keyboard navigation immediately
✅ Screen reader test early
```

---

## Quick Reference Lookup

### Component Complexity Quick Reference

| Component    | Lines   | Complexity  | Study Time | File Structure              |
| ------------ | ------- | ----------- | ---------- | --------------------------- |
| Toggle       | ~80     | Simple      | 2-3 hrs    | Single file                 |
| Checkbox     | ~90     | Simple      | 2-3 hrs    | Single file                 |
| Tooltip      | ~95     | Simple      | 2-3 hrs    | Single file                 |
| Button       | 272     | Medium      | 4-6 hrs    | Multi-file (5 variants)     |
| Input        | 272     | Medium      | 6-8 hrs    | Multi-file (3 components)   |
| Badge        | 417     | Medium      | 4-6 hrs    | Single file (many variants) |
| Select       | 6 files | Medium-High | 8-12 hrs   | Multi-file (6 files)        |
| Table        | 301     | High        | 12-16 hrs  | Multi-file + integrations   |
| Multi-Select | 363     | High        | 10-14 hrs  | Complex single file         |

### Pattern Scope Quick Reference

| Pattern               | Scope        | Usage %          | Apply To                     |
| --------------------- | ------------ | ---------------- | ---------------------------- |
| Design tokens         | 🌐 UNIVERSAL | 100%             | ALL components               |
| cx() utility          | 🌐 UNIVERSAL | 100%             | ALL components               |
| React Aria            | 🌐 UNIVERSAL | 100% interactive | ALL interactive components   |
| TypeScript types      | 🌐 UNIVERSAL | 100%             | ALL components               |
| File triplet          | 🌐 UNIVERSAL | 100%             | ALL components               |
| Context API           | 🏗️ CATEGORY  | 6%               | Complex/composed only        |
| Composition           | 🏗️ CATEGORY  | 10%              | application/ + complex base/ |
| base-components/      | 🏗️ CATEGORY  | 10%              | Avatar, Tags, AppNav only    |
| Polymorphic rendering | 🔧 COMPONENT | 1.4%             | Button family ONLY           |
| Color variants (9)    | 🔧 COMPONENT | 0.5%             | Button ONLY                  |
| Icon-only detection   | 🔧 COMPONENT | 0.5%             | Button ONLY                  |
| Size systems          | 🔧 COMPONENT | 48%              | Each component defines own   |

### File Location Quick Reference

**Find Component Implementation:**

```
Simple component:
UPSTREAM/react/components/base/[component]/[component].tsx

Variant-heavy component:
UPSTREAM/react/components/base/[component]/
├── [component].tsx
├── [variant]-[component].tsx
└── ...

Application component:
UPSTREAM/react/components/application/[component]/[component].tsx

Marketing component:
UPSTREAM/untitledui-nextjs-starter-kit/components/marketing/[component]/
```

**Find Usage Examples:**

```
Demo file: UPSTREAM/react/components/[category]/[component]/[component].demo.tsx
Storybook: UPSTREAM/react/components/[category]/[component]/[component].story.tsx
Page example: UPSTREAM/untitledui-nextjs-starter-kit/src/app/page.tsx
```

**Find Integration Examples:**

```
Application components show integration:
UPSTREAM/react/components/application/table/table.demo.tsx
UPSTREAM/react/components/application/modals/modals.demo.tsx
```

---

## Study Methodology

### The 3-Pass Study Method

**Pass 1: Visual Survey (15-30 minutes per component)**

```
Goal: Understand what the component does visually

Steps:
1. Browse untitledui.com
2. Interact with component
3. Note ALL variants
4. Note ALL states
5. Test keyboard navigation
6. Test responsive behavior

Output: Visual specification document
```

**Pass 2: Code Structure (30-60 minutes per component)**

```
Goal: Understand implementation structure

Steps:
1. List all files in UPSTREAM/
2. Count lines per file
3. Identify file structure pattern (single vs multi-file)
4. Read *.demo.tsx for usage
5. Scan core *.tsx for structure (don't read details yet)

Output: Architecture notes (file structure, pattern type, complexity level)
```

**Pass 3: Deep Implementation (1-4 hours per component)**

```
Goal: Understand implementation details

Steps:
1. Read core *.tsx line by line
2. Understand each pattern used
3. Check pattern scope in PATTERN-LIBRARY.md
4. Study variant files
5. Study integration examples
6. Document findings

Output: Complete implementation notes ready for building
```

### Documentation Template for Study Notes

````markdown
# [Component Name] Study Notes

**Date Studied:** YYYY-MM-DD
**Time Spent:** X hours
**Complexity:** Simple / Medium / High
**Status:** Ready to implement / Need more study

## Visual Specification (from untitledui.com)

- **Variants:** [List all variants seen]
- **States:** [default, hover, active, focus, disabled, loading, etc.]
- **Sizes:** [List sizes]
- **Colors:** [List color variants if any]
- **Edge Cases:** [Very long text, icons, etc.]

## Code Structure (from UPSTREAM/)

**File Structure:**

- Pattern type: [Single file / Multi-file / With base-components]
- Main file: [filename] ([line count] lines)
- Variant files: [List variant files]
- Demo file: [filename]
- Story file: [filename]

**Dependencies:**

- React Aria: [Which components used]
- Other components: [List any integrated components]

## Patterns Used

**UNIVERSAL Patterns:**

- ✅ Design tokens
- ✅ cx() utility
- ✅ React Aria: [Which components]
- ✅ TypeScript types
- ✅ File triplet

**CATEGORY Patterns:**

- Context API: [Yes/No - if yes, what state shared]
- Composition: [Yes/No - if yes, what strategy]
- base-components/: [Yes/No]

**COMPONENT Patterns:**

- [List any component-specific patterns found]

## Props Interface

```typescript
export interface [Component]Props {
  // Document all props from reference
}
```
````

## Implementation Plan

1. [Step 1]
2. [Step 2]
   ...

## Questions / Uncertainties

- [List anything unclear]
- [List what needs user validation]

## References

- untitledui.com: [URL]
- UPSTREAM path: [Path to component]
- Project docs: [Relevant .docs/ files]

```

---

## Summary

### Reference-First Methodology Checklist

Before implementing ANY component:

- [ ] Study untitledui.com visually (30-60 min)
- [ ] Study UPSTREAM/ code structure (30-60 min)
- [ ] Study UPSTREAM/ implementation details (1-4 hours)
- [ ] Verify pattern scope in PATTERN-LIBRARY.md (15 min)
- [ ] Check integration in INTEGRATION-GUIDE.md (15 min)
- [ ] Create implementation plan (30 min)
- [ ] Get user approval of plan
- [ ] ONLY THEN: Begin implementation

### The Golden Rules

1. **Reference is the specification** - untitledui.com + UPSTREAM/ define requirements
2. **Study before planning** - Understand completely before creating plan
3. **Verify pattern scope** - Not all Button patterns apply to other components
4. **Continuous validation** - Reference constantly during implementation
5. **Document findings** - Create study notes for future reference

### Common Mistakes to Avoid

1. ❌ Not studying reference before implementing
2. ❌ Assuming Button patterns are universal
3. ❌ Copy-pasting without understanding
4. ❌ Ignoring file structure patterns
5. ❌ Missing integration examples
6. ❌ Not testing edge cases
7. ❌ Skipping accessibility (React Aria)

### Time Investment

**Upfront study time:** 2-8 hours per component (varies by complexity)
**Time saved in rework:** 4-16 hours per component
**Net benefit:** 2-8 hours saved + better quality

**The user's empirical evidence:** 0% success rate when skipping reference study

---

**Document Status:** Phase 0 Complete - All 6 master documents created

**Master Documentation Suite:**
1. ✅ SYSTEM-ARCHITECTURE.md
2. ✅ COMPONENT-TAXONOMY.md
3. ✅ DOCUMENTATION-SITE-MAPPING.md
4. ✅ PATTERN-LIBRARY.md
5. ✅ INTEGRATION-GUIDE.md
6. ✅ REFERENCE-STUDY-GUIDE.md (this document)

**Next:** Phase 0.6 - User validation before proceeding to any implementation

**Critical Success Factors:**
- Complete system understanding documented
- Pattern scope clearly labeled
- Integration strategies defined
- Reference study methodology established
- Ready for user validation
```
