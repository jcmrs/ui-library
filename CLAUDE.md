# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Documentation Imports

Core project documentation and protocols:

- Product vision and strategy: @.docs/PRODUCT-VISION.md
- Agent orchestration protocol: @.docs/AGENT-ORCHESTRATION-PROTOCOL.md
- Component development guide: @.docs/COMPONENT-DEVELOPMENT.md
- TDD methodology: @.docs/TDD-METHODOLOGY.md
- Architecture and design: @.docs/ARCHITECTURE-REDESIGN.md
- Project roadmap: @.docs/ROADMAP.md
- Automation infrastructure: @.claude/AUTOMATION.md
- Available npm commands: @package.json

## Project Overview

Production-ready UI component library built as a single source of truth for AI-assisted UI development. This library eliminates AI implementation failures by providing complete, unambiguous materials with accessibility-first components.

**Technology Stack:**

- React 19.1
- TypeScript 5.8
- Tailwind CSS 4.1
- React Aria (for accessibility)
- Storybook (for component documentation)

**Quality Standards:**

- WCAG 2.1 AA accessibility compliance
- Mobile-first responsive design
- Full TypeScript type safety
- Comprehensive Storybook documentation

## Development Commands

### Storybook Development

```bash
bun run storybook          # Start Storybook dev server on port 6006
bun run build-storybook    # Build static Storybook
```

### Code Quality

```bash
bun run test               # Run full test suite (type-check + lint + prettier)
bun run type-check         # TypeScript type checking only
bun run lint               # ESLint with auto-fix
bun run lint:check         # ESLint check without fixing
bun run prettier           # Format code with Prettier
bun run prettier:check     # Check formatting without changes
```

## Architecture

### Component Structure

Components organized in domain-specific directories:

- `components/base/` - Foundational primitives (buttons, inputs, etc.)
- `components/foundations/` - Design system foundations (colors, typography, spacing)
- `components/application/` - Complex application UI patterns
- `components/internal/` - Internal utilities and shared logic
- `components/shared-assets/` - Shared icons, images, and assets

### Reference Materials (UPSTREAM/)

Local clones of upstream repositories for reference and documentation:

- `UPSTREAM/agents/` - wshobson agent framework (orchestration patterns, TDD workflows)
- `UPSTREAM/react/` - UntitledUI React components (golden standard reference)
- `UPSTREAM/icons/` - UntitledUI Icons library
- `UPSTREAM/untitledui-vite-starter-kit/` - Vite integration patterns
- `UPSTREAM/untitledui-nextjs-starter-kit/` - Next.js integration patterns
- `UPSTREAM/dyad/` - Additional reference implementation

**UPSTREAM/ is gitignored** - these are local reference clones maintaining remote links.

## Component Development Guidelines

### Design Principles (from UPSTREAM/react)

1. **Accessibility First** - WCAG 2.1 AA compliance required
2. **Mobile-First** - Responsive by default
3. **Composable** - Components work together seamlessly
4. **Consistent** - Follow established UntitledUI patterns
5. **Minimal** - Avoid unnecessary complexity

### TypeScript Requirements

- Export all component prop interfaces
- Use strict type checking
- Provide JSDoc comments for complex props
- Leverage React Aria types for accessibility

### Component Checklist

- [ ] Fully typed with exported interfaces
- [ ] Semantic HTML with proper ARIA attributes
- [ ] Mobile-first responsive design
- [ ] Storybook stories with all variants
- [ ] Keyboard navigation support
- [ ] Focus management
- [ ] Screen reader tested

## Agent Orchestration

This project uses the wshobson agent framework for multi-agent coordination.

### Available Specialized Agents

- `frontend-developer` - React 19, TypeScript, Tailwind CSS expertise
- `tdd-orchestrator` - Test-driven development coordination
- `test-automator` - AI-powered test generation and validation
- `code-reviewer` - Code quality, security, performance analysis
- `architect-review` - Architecture patterns and design validation
- `docs-architect` - Technical documentation generation
- `accessibility-compliance:ui-visual-validator` - Visual UI validation

### Workflow Pattern

```
Sonnet (planning) → Haiku (execution) → Sonnet (review)
```

Use multi-agent coordination for:

- Complex component implementation (frontend-developer + architect-review)
- Test-driven development (tdd-orchestrator + test-automator)
- Accessibility validation (frontend-developer + ui-visual-validator)
- Documentation generation (docs-architect + api-documenter)

## Context Management

### Token Efficiency Strategy

- Read UPSTREAM/ references only when needed for specific patterns
- Use symbolic tools for targeted code exploration
- Leverage agent skills for progressive disclosure
- Avoid reading entire files unnecessarily

### Session Continuity

- Use TodoWrite tool for tracking multi-step tasks
- Mark todos as completed immediately after finishing
- Document architectural decisions in memory
- Create checkpoints at logical workflow boundaries

## Git Workflow

- Repository uses Gitflow branching model
- Feature branches: `feature/component-name`
- Bugfix branches: `bugfix/issue-description`
- Release branches: `release/version`

## AI Development Context

This library is designed specifically for AI-assisted development:

- Components follow predictable, consistent patterns
- Complete TypeScript types eliminate ambiguity
- Storybook provides visual reference for all states
- React Aria ensures accessibility compliance
- UPSTREAM/ references provide proven implementations

**Critical**: When implementing components, always reference UPSTREAM/react/ for patterns rather than inventing new approaches. This library improves upon UntitledUI standards while maintaining compatibility.
