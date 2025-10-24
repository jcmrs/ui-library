# UI Library

Production-ready UI component library built as a single source of truth for AI-assisted UI development. This library eliminates AI implementation failures by providing complete, unambiguous materials with accessibility-first components.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](./LICENSE)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.7-blue)](https://www.typescriptlang.org/)
[![React](https://img.shields.io/badge/React-19.1-blue)](https://react.dev/)
[![Tailwind CSS](https://img.shields.io/badge/Tailwind-4.1-blue)](https://tailwindcss.com/)

## Features

- **Accessibility-First**: WCAG 2.1 AA compliance with React Aria
- **Mobile-First**: Responsive design from the ground up
- **Type-Safe**: Full TypeScript support with comprehensive type definitions
- **AI-Native**: Designed specifically for AI-assisted development
- **Storybook**: Complete visual documentation for all components
- **Comprehensive**: Base components, application UI, marketing, and page templates

## Technology Stack

- **React 19.1** - Latest React with modern features
- **TypeScript 5.8** - Full type safety
- **Tailwind CSS 4.1** - Utility-first styling
- **React Aria** - Accessible component primitives
- **Storybook 8.5** - Component documentation and development

## Quick Start

### Installation

```bash
npm install ui-library
```

### Basic Usage

```tsx
import { Button } from 'ui-library';

function App() {
  return (
    <Button variant="primary" size="md">
      Click me
    </Button>
  );
}
```

## Development

### Prerequisites

- Node.js >= 20.0.0
- npm >= 10.0.0

### Setup

```bash
# Clone the repository
git clone https://github.com/jcmrs/ui-library.git
cd ui-library

# Install dependencies
npm install

# Start Storybook development server
npm run storybook
```

### Available Commands

```bash
# Development
npm run storybook        # Start Storybook on port 6006
npm run dev             # Alias for storybook

# Building
npm run build           # Build library and Storybook
npm run build:lib       # Build library only
npm run build-storybook # Build Storybook only

# Quality Gates
npm run test            # Run all quality checks
npm run type-check      # TypeScript type checking
npm run lint            # ESLint with auto-fix
npm run lint:check      # ESLint check only
npm run prettier        # Format code
npm run prettier:check  # Check formatting
```

## Component Categories

### Base Components

Foundational UI primitives: buttons, inputs, badges, avatars, toggles, etc.

```tsx
import { Button, Badge, Input } from 'ui-library/base';
```

### Application UI

Complex application patterns: navigation, data display, modals, tables, charts, etc.

```tsx
import { Modal, Table, PageHeader } from 'ui-library/application';
```

### Marketing Components

Landing page sections: headers, features, pricing, testimonials, CTAs, etc.

```tsx
import { HeroSection, PricingSection, Footer } from 'ui-library/marketing';
```

### Pages

Complete page templates: authentication, error pages, email templates, etc.

```tsx
import { LoginPage, SignUpPage, NotFoundPage } from 'ui-library/pages';
```

## Documentation

- **[Storybook](http://localhost:6006)** - Interactive component documentation
- **[Roadmap](.docs/ROADMAP.md)** - Project roadmap and phases
- **[Contributing](./CONTRIBUTING.md)** - Contribution guidelines
- **[Architecture](.docs/ARCHITECTURE-REDESIGN.md)** - Technical architecture
- **[Product Vision](.docs/PRODUCT-VISION.md)** - Product strategy and goals
- **[Component Development](.docs/COMPONENT-DEVELOPMENT.md)** - How to create components

## Quality Standards

All components must meet these standards:

- ✅ WCAG 2.1 AA accessibility compliance
- ✅ Mobile-first responsive design
- ✅ Full TypeScript type safety
- ✅ Comprehensive Storybook documentation
- ✅ Keyboard navigation support
- ✅ Screen reader compatibility
- ✅ Zero ESLint errors
- ✅ Formatted with Prettier

Quality gates are automatically enforced via pre-commit hooks.

## Project Philosophy

This library is designed specifically for AI-assisted development:

1. **Complete Examples**: Every component includes all variants and states
2. **Explicit Documentation**: No implicit knowledge required
3. **Predictable Patterns**: Consistent API across all components
4. **Type-Driven**: TypeScript types eliminate ambiguity
5. **Accessibility Built-In**: React Aria ensures compliance

## License

MIT © JCMRS

## Links

- **Repository**: [https://github.com/jcmrs/ui-library](https://github.com/jcmrs/ui-library)
- **Issues**: [https://github.com/jcmrs/ui-library/issues](https://github.com/jcmrs/ui-library/issues)
- **Documentation**: [Storybook](http://localhost:6006)

## Acknowledgments

Built upon the foundation of [UntitledUI](https://www.untitledui.com) design system with enhancements for AI-native development.
