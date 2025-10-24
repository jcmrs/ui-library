# Contributing to UI Library

Thank you for your interest in contributing! This document provides guidelines and instructions for contributing to the UI Library project.

## Code of Conduct

- Be respectful and constructive
- Focus on what is best for the community
- Show empathy towards other contributors
- Accept constructive criticism gracefully

## Getting Started

### Prerequisites

- Node.js >= 20.0.0
- npm >= 10.0.0
- Git
- Familiarity with React, TypeScript, and Tailwind CSS

### Development Setup

1. **Fork and Clone**

```bash
git clone https://github.com/YOUR_USERNAME/ui-library.git
cd ui-library
```

2. **Install Dependencies**

```bash
npm install
```

3. **Start Development Server**

```bash
npm run storybook
```

Storybook will open at `http://localhost:6006`

## Development Workflow

### Git Workflow

We use Gitflow branching model:

- `main` - Production-ready code
- `develop` - Integration branch
- `feature/*` - New features
- `bugfix/*` - Bug fixes
- `hotfix/*` - Production hotfixes

### Creating a Feature

1. **Create Feature Branch**

```bash
git checkout develop
git pull origin develop
git checkout -b feature/your-feature-name
```

2. **Make Changes**

Follow our coding standards (see below)

3. **Quality Gates**

All commits are automatically validated:

```bash
# Pre-commit hooks run automatically:
# - TypeScript type checking
# - ESLint with auto-fix
# - Prettier formatting
```

4. **Commit Changes**

We use conventional commits:

```bash
git add .
git commit -m "feat: add new button variant"
```

Commit types:

- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation only
- `style:` - Code style (formatting, whitespace)
- `refactor:` - Code refactoring
- `test:` - Adding tests
- `chore:` - Maintenance tasks

5. **Push and Create PR**

```bash
git push origin feature/your-feature-name
```

Then create a Pull Request on GitHub.

## Component Development

### Creating a New Component

Use the scaffolding script:

```bash
./scripts/create-component.sh ComponentName category
```

Categories: `base`, `application`, `marketing`, `pages`

This creates:

- `component.tsx` - Component implementation
- `component.test.tsx` - Tests
- `component.stories.tsx` - Storybook stories
- `component.patterns.md` - Usage patterns
- `component.checklist.json` - Quality checklist
- `index.ts` - Exports

### Component Requirements

Every component must include:

1. **TypeScript Types**

   - Export all prop interfaces
   - Use strict type checking
   - Provide JSDoc comments

2. **Accessibility**

   - WCAG 2.1 AA compliance
   - Semantic HTML
   - ARIA attributes
   - Keyboard navigation
   - Screen reader support

3. **Responsive Design**

   - Mobile-first approach
   - All breakpoints tested

4. **Storybook Stories**

   - All variants documented
   - Interactive controls
   - Accessibility tests

5. **Documentation**
   - Usage patterns
   - Code examples
   - Best practices

### Component Checklist

Before submitting a component:

- [ ] Fully typed with exported interfaces
- [ ] Semantic HTML with proper ARIA
- [ ] Mobile-first responsive design
- [ ] Storybook stories for all variants
- [ ] Keyboard navigation working
- [ ] Focus management correct
- [ ] Screen reader tested
- [ ] No ESLint errors
- [ ] Formatted with Prettier
- [ ] TypeScript compiles without errors

## Code Style

### TypeScript

```typescript
// ✅ Good - Explicit types, clear naming
interface ButtonProps {
  /** Button variant style */
  variant: 'primary' | 'secondary' | 'tertiary';
  /** Button size */
  size: 'sm' | 'md' | 'lg';
  /** Click handler */
  onClick?: () => void;
  children: React.ReactNode;
}

export function Button({ variant, size, onClick, children }: ButtonProps) {
  return <button className={getButtonClasses(variant, size)}>{children}</button>;
}
```

### React

- Use functional components
- Use React 19 features
- Leverage React Aria for accessibility
- Avoid inline styles (use Tailwind)

### Tailwind CSS

```typescript
// ✅ Good - Use utility classes, tailwind-merge for conditionals
import { cx } from '@/utils/cx';

function getButtonClasses(variant: string, size: string) {
  return cx(
    'rounded-lg font-medium transition-colors',
    variant === 'primary' && 'bg-blue-600 text-white hover:bg-blue-700',
    variant === 'secondary' && 'bg-gray-200 text-gray-900 hover:bg-gray-300',
    size === 'sm' && 'px-3 py-1.5 text-sm',
    size === 'md' && 'px-4 py-2 text-base',
    size === 'lg' && 'px-5 py-3 text-lg'
  );
}
```

### File Organization

```
src/components/base/button/
├── button.tsx              # Main component
├── button.test.tsx         # Tests
├── button.stories.tsx      # Storybook stories
├── button.patterns.md      # Usage patterns
├── button.checklist.json   # Quality checklist
└── index.ts                # Exports
```

## Testing

### Running Tests

```bash
# Run all quality checks
npm test

# Type checking only
npm run type-check

# Linting only
npm run lint

# Formatting check
npm run prettier:check
```

### Writing Tests

```typescript
import { render, screen } from '@testing-library/react';
import { Button } from './button';

describe('Button', () => {
  it('renders with children', () => {
    render(<Button>Click me</Button>);
    expect(screen.getByRole('button', { name: 'Click me' })).toBeInTheDocument();
  });

  it('applies variant classes', () => {
    render(<Button variant="primary">Primary</Button>);
    const button = screen.getByRole('button');
    expect(button).toHaveClass('bg-blue-600');
  });
});
```

## Pull Request Process

1. **Update Documentation**

   - Add/update README if needed
   - Update CHANGELOG.md
   - Document breaking changes

2. **Ensure Quality**

   - All tests pass
   - No ESLint errors
   - Code formatted with Prettier
   - TypeScript compiles

3. **Write Clear PR Description**

   - What does this PR do?
   - Why is this change needed?
   - How was it tested?
   - Screenshots for UI changes

4. **Request Review**

   - Assign reviewers
   - Address feedback promptly
   - Keep PR focused and small

5. **Squash and Merge**
   - PRs are squash-merged to main/develop
   - Ensure commit message follows conventions

## Automation

The project uses extensive automation:

### Pre-commit Hooks

Automatically run before every commit:

- TypeScript type checking
- ESLint with auto-fix
- Prettier formatting

### Post-commit Hooks

Automatically run after every commit:

- Session state updates
- Git status tracking

### Pre-push Hooks

Automatically run before every push:

- Checkpoint tag creation
- Backup creation

### CI/CD (GitHub Actions)

Automatically run on PRs and pushes:

- TypeScript validation
- ESLint validation
- Prettier check
- Test suite execution

## Getting Help

- **Issues**: [GitHub Issues](https://github.com/jcmrs/ui-library/issues)
- **Discussions**: [GitHub Discussions](https://github.com/jcmrs/ui-library/discussions)
- **Documentation**: [.docs/](.docs/) folder

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
