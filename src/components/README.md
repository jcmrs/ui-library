# Component Library Architecture

This document explains the organization and structure of the UI component library.

## Directory Structure

```
src/components/
├── base/                   Primitive UI components (28 types, 200+ variants)
├── application/            Dashboard/app UI (32 types, 300+ variants)
├── marketing/              Marketing website sections (17 types, 400+ variants)
├── pages/                  Complete page templates (160+ pages)
├── foundations/            Design primitives (icons, tokens, brand)
├── shared-assets/          Visual assets (illustrations, patterns, mockups)
└── internal/               Internal utilities (not exported)
```

## Component Categories

### Base Components (`base/`)

**Purpose**: Atomic, highly reusable UI primitives
**Examples**: Button, Input, Avatar, Badge, Dropdown, Checkbox
**Total**: 28 component types, 200+ variants

**Characteristics**:

- Small, focused, single-responsibility
- Minimal dependencies
- Highly composable
- Used across both application and marketing contexts

**Organization Pattern**:

```
base/
├── buttons/                     ← Component type directory
│   ├── base-components/         ← Shared sub-components
│   ├── button.tsx               ← Core component
│   ├── social-button.tsx        ← Variant
│   ├── app-store-buttons.tsx    ← Variant
│   ├── button-utility.tsx       ← Variant
│   ├── close-button.tsx         ← Variant
│   ├── button-group.tsx         ← Related component
│   ├── buttons.stories.tsx      ← Storybook stories (all variants)
│   ├── buttons.test.tsx         ← Tests (all variants)
│   ├── buttons.patterns.md      ← Usage documentation
│   ├── buttons.checklist.json   ← Validation checklist
│   └── index.ts                 ← Barrel export
```

**Key Insight**: Variants are **separate files**, not just prop configurations.
Example: A "social button" is not `<Button variant="social">`, it's `<SocialButton platform="twitter">`.

### Application UI Components (`application/`)

**Purpose**: Complex interface elements for dashboards and SaaS applications
**Examples**: Modal, Table, Chart, Navigation, Calendar, File Uploader
**Total**: 32 component types, 300+ variants

**Characteristics**:

- Complex state management
- Rich interactions
- Data-focused
- Constrained layouts (not full-width)
- Used in authenticated application contexts

**Categories**:

- **Navigation**: Headers, sidebars, breadcrumbs
- **Data Display**: Charts, metrics, tables
- **Interaction**: Modals, menus, pagination, carousels
- **Content**: Feeds, messaging, tabs
- **Feedback**: Alerts, notifications, loading states

**Example Structure**:

```
application/
├── modals/
│   ├── base-components/
│   ├── modal-basic.tsx
│   ├── modal-with-icon.tsx
│   ├── modal-centered.tsx
│   ├── modal-fullscreen.tsx
│   ├── ... (46 total modal variants)
│   ├── modals.stories.tsx
│   ├── modals.test.tsx
│   ├── modals.patterns.md
│   └── index.ts
```

### Marketing Components (`marketing/`)

**Purpose**: Full-width sections for public-facing marketing websites
**Examples**: Hero Section, Features, Pricing, Testimonials, Footer
**Total**: 17 section types, 400+ variants

**Characteristics**:

- Full-width, responsive layouts
- Content-heavy (marketing copy, images, CTAs)
- SEO considerations
- Scrolling page interactions
- Used in public/unauthenticated contexts

**Section Types**:

- Header sections (hero areas)
- Features, Pricing, CTAs
- Testimonials, Social proof
- Blog sections, Contact forms
- Team, Careers, FAQ
- Footers, Banners

**Example Structure**:

```
marketing/
├── header-sections/
│   ├── base-components/
│   ├── hero-simple.tsx
│   ├── hero-with-image.tsx
│   ├── hero-with-video.tsx
│   ├── hero-split-screen.tsx
│   ├── ... (44 total variants)
│   ├── header-sections.stories.tsx
│   ├── header-sections.test.tsx
│   ├── header-sections.patterns.md
│   └── index.ts
```

### Page Templates (`pages/`)

**Purpose**: Complete page implementations combining multiple components
**Examples**: Login Page, Landing Page, Pricing Page, 404 Page
**Total**: 160+ complete pages

**Characteristics**:

- Full-page compositions
- Multiple sections/components combined
- Ready-to-use with placeholder content
- Route-aware (for Next.js/React Router)

**Page Types**:

```
pages/
├── auth/
│   ├── login/              (16 variants)
│   ├── signup/             (21 variants)
│   ├── forgot-password/    (5 variants)
│   └── verification/       (3 variants)
├── marketing-pages/
│   ├── landing/            (20 variants)
│   ├── pricing/            (10 variants)
│   ├── blog/               (10 variants)
│   ├── about/              (10 variants)
│   ├── contact/            (10 variants)
│   ├── team/               (10 variants)
│   ├── legal/              (5 variants)
│   └── faq/                (10 variants)
├── error-pages/
│   └── 404/                (10 variants)
└── email-templates/        (10 templates)
```

**Example Structure**:

```
pages/auth/login/
├── login-simple.tsx
├── login-centered.tsx
├── login-split-screen.tsx
├── login-with-image.tsx
├── ... (16 total variants)
├── login.stories.tsx
├── login.patterns.md
└── index.ts
```

### Foundations (`foundations/`)

**Purpose**: Design system primitives - NOT components
**Contents**: Icons, design tokens, brand assets

**NOT a component category** - these are primitives that components import.

**Structure**:

```
foundations/
├── icons/
│   ├── featured-icons/     ← Icon wrapper components
│   ├── social-icons/       ← Social platform logos
│   ├── payment-icons/      ← Payment method logos
│   └── logos/              ← Product/brand logos
├── tokens/
│   ├── colors.ts           ← Color palette
│   ├── typography.ts       ← Font system
│   ├── spacing.ts          ← Spacing scale
│   ├── breakpoints.ts      ← Responsive breakpoints
│   ├── shadows.ts          ← Shadow system
│   └── borders.ts          ← Border system
└── brand/
    └── guidelines.ts       ← Brand guidelines
```

### Shared Assets (`shared-assets/`)

**Purpose**: Reusable visual assets (illustrations, patterns, mockups)
**Examples**: Background patterns, illustrations, device mockups

### Internal (`internal/`)

**Purpose**: Internal utilities not exported from the library
**Examples**: Custom hooks, utility functions, shared contexts

**NOT part of the public API**.

## Component Organization Patterns

### Single Component

For simple components with no variants:

```
component-name/
├── component-name.tsx
├── component-name.stories.tsx
├── component-name.test.tsx
├── component-name.patterns.md
├── component-name.checklist.json
└── index.ts
```

### Component with Variants

For components with multiple variants:

```
component-name/
├── base-components/           ← Shared sub-components
├── component-core.tsx         ← Core implementation
├── component-variant-a.tsx    ← Variant A
├── component-variant-b.tsx    ← Variant B
├── component-name.stories.tsx ← Stories for all variants
├── component-name.test.tsx    ← Tests for all variants
├── component-name.patterns.md ← Documentation for all
├── component-name.checklist.json
└── index.ts                   ← Exports all variants
```

### Component Group

For related components that share documentation:

```
component-group/
├── base-components/
├── component-a.tsx
├── component-b.tsx
├── component-c.tsx
├── component-group.stories.tsx
├── component-group.test.tsx
├── component-group.patterns.md
├── component-group.checklist.json
└── index.ts
```

## File Naming Conventions

- **Component files**: `kebab-case.tsx` (e.g., `social-button.tsx`)
- **Test files**: `kebab-case.test.tsx`
- **Story files**: `kebab-case.stories.tsx` (or component group name)
- **Documentation**: `kebab-case.patterns.md`
- **Checklist**: `kebab-case.checklist.json`
- **Exports**: `index.ts`

## Required Files

Every component/component group must have:

1. ✅ Implementation file(s) (`.tsx`)
2. ✅ Storybook stories (`.stories.tsx`)
3. ✅ Tests (`.test.tsx`)
4. ✅ Usage patterns documentation (`.patterns.md`)
5. ✅ Validation checklist (`.checklist.json`)
6. ✅ Barrel export (`index.ts`)

## Design Principles

### 1. AI-First Documentation

Every component has comprehensive documentation designed for AI consumption:

- **patterns.md**: Human and AI-readable usage patterns
- **checklist.json**: Machine-readable validation criteria
- **Storybook stories**: Visual documentation with variants
- **TypeScript types**: Complete type definitions with JSDoc

### 2. Accessibility First

All components:

- Meet WCAG 2.1 AA standards
- Use React Aria where applicable
- Include proper ARIA attributes
- Support keyboard navigation
- Tested with screen readers

### 3. Mobile First

All components:

- Responsive by default
- Touch-friendly hit targets
- Optimized for mobile performance

### 4. Composability

Components work together seamlessly:

- Consistent prop patterns
- Predictable composition behavior
- Minimal prop drilling

### 5. Type Safety

All components:

- Fully typed with TypeScript
- Exported prop interfaces
- JSDoc comments for complex props
- Strict type checking

## Development Workflow

1. **Create component**: `./scripts/create-component.sh ComponentName category`
2. **Implement**: Fill in component implementation
3. **Document**: Add stories, tests, patterns
4. **Validate**: `./scripts/validate-component.sh ComponentName category`
5. **Review**: Quality gates (TypeScript, ESLint, Prettier, Tests)
6. **Complete**: Commit with automated quality checks

## Scale

**Total Library Scope**:

- **Base**: 28 types, 200+ variants
- **Application**: 32 types, 300+ variants
- **Marketing**: 17 types, 400+ variants
- **Pages**: 160+ templates
- **Total**: ~1,200+ components/variants/pages

This is an **industry-standard comprehensive UI library** comparable to:

- Material UI (500+ components)
- Ant Design (600+ components)
- Chakra UI (400+ components)
- UntitledUI (1,200+ components) ← Our reference

## References

- [UntitledUI Documentation](https://www.untitledui.com/react/components)
- [UntitledUI React Library](UPSTREAM/react/)
- [Next.js Starter Kit](UPSTREAM/untitledui-nextjs-starter-kit/)
- [Architecture Redesign Document](.docs/ARCHITECTURE-REDESIGN.md)
