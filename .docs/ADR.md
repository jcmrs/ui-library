# Architecture Decision Records (ADR)

**Project:** AI-Native UI Component Library
**Version:** 1.0.0
**Last Updated:** 2025-01-23
**Status:** Active

---

## Overview

This document captures key architectural decisions made during the design and implementation of the UI component library. Each ADR follows a structured format documenting the context, decision, rationale, consequences, and alternatives considered.

---

## Table of Contents

1. [ADR-001: Automated Foundation First](#adr-001-automated-foundation-first)
2. [ADR-002: Button as Reference Component](#adr-002-button-as-reference-component)
3. [ADR-003: Vertical Slice Validation](#adr-003-vertical-slice-validation)
4. [ADR-004: Zero-Configuration Automation](#adr-004-zero-configuration-automation)
5. [ADR-005: Machine-Readable Checklists](#adr-005-machine-readable-checklists)
6. [ADR-006: 90%+ Test Coverage Requirement](#adr-006-90-test-coverage-requirement)
7. [ADR-007: Rewrite UntitledUI with AI-Native Enhancements](#adr-007-rewrite-untitledui-with-ai-native-enhancements)
8. [ADR-008: Technology Stack Selection](#adr-008-technology-stack-selection)
9. [ADR-009: Inline Documentation Strategy](#adr-009-inline-documentation-strategy)
10. [ADR-010: Component Scaffolding System](#adr-010-component-scaffolding-system)
11. [ADR-011: Pre-commit Quality Gates](#adr-011-pre-commit-quality-gates)
12. [ADR-012: React Aria for Accessibility](#adr-012-react-aria-for-accessibility)

---

## ADR-001: Automated Foundation First

**Status:** Accepted
**Date:** 2025-01-23
**Decision Makers:** Multi-role analysis (AI Systems Engineer, Frontend Architect, DX Engineer, QA Engineer, Technical PM)

### Context

Claude Code has demonstrated consistent failures in UI implementation:

- Configuration drift causes npm/dependency issues
- Manual validation steps get skipped or forgotten
- No automated scaffolding leads to inconsistent component structure
- Quality issues discovered too late in development

Without automation infrastructure, Claude Code cannot reliably:

- Set up projects from scratch
- Create components with consistent structure
- Validate quality before committing code
- Follow established patterns

### Decision

**Build automated foundation infrastructure (Phase 1) before implementing any components.**

Phase 1 deliverables:

- Project setup automation (`scripts/setup-new-project.sh`)
- Component scaffolding system (`scripts/create-component.sh`)
- Quality validation pipeline (`scripts/quality/validate-all.sh`)
- Configuration templates (package.json, tsconfig, eslint, tailwind)
- Git hooks (pre-commit validation)
- CI/CD workflows (GitHub Actions)

### Rationale

1. **Compensates for AI Limitations**: External systems eliminate need for conceptual understanding of setup/configuration
2. **Prevents Configuration Drift**: Idempotent scripts ensure consistent environment
3. **Enforces Quality**: Automated validation prevents manual checking failures
4. **Enables Scaling**: Once foundation works, component creation becomes repeatable
5. **Early Validation**: Tests automation before investing in component library

### Consequences

**Positive:**

- Zero-configuration setup experience
- Consistent component structure across library
- Quality gates prevent broken code from being committed
- Reduced time debugging configuration issues
- Foundation can be reused across multiple projects

**Negative:**

- 2-3 days investment before any visible UI components
- Additional maintenance burden for automation scripts
- Learning curve for understanding automation tooling

**Risks:**

- Automation scripts themselves could be brittle
- Over-automation could make debugging harder
- Scripts need to be platform-agnostic (Windows/Mac/Linux)

### Alternatives Considered

1. **Jump Directly to Components**

   - Rejected: Historical evidence shows configuration issues derail projects
   - Risk: High probability of npm drama and linting microfixing cycles

2. **Manual Setup with Documentation**

   - Rejected: Claude Code doesn't reliably follow manual setup instructions
   - Risk: Configuration drift across development sessions

3. **Use Existing Component Library Generator**
   - Rejected: Generic generators don't address AI-specific needs
   - Risk: Would still need custom scaffolding for AI-friendly patterns

### Implementation Notes

- All scripts must be idempotent (safe to run multiple times)
- Error messages must be actionable and specific
- Scripts must validate prerequisites before executing
- Documentation must explain both usage and internals

---

## ADR-002: Multi-Category Component Architecture

**Status:** ✅ Accepted (Revised 2025-10-25)
**Date:** 2025-01-23 (Original), 2025-10-25 (Revision)
**Decision Makers:** Multi-role analysis (Frontend Architect, AI Systems Engineer, Information Architect)

### Context

**Original Decision (2025-01-23):** Build Button as single reference component for entire library

**Why This Was Wrong:**

Phase 0 system study (complete analysis of 208 UntitledUI components) revealed:

- Component complexity varies dramatically (Modal: 42 lines → Table: 301 lines)
- Patterns have different scopes (universal vs category-specific vs component-specific)
- Categories serve different purposes (base primitives vs application UI vs marketing sections)
- Cannot derive system architecture from single component

**Critical Lessons from Phase 0:**

1. **Button is ONE approach for ONE type** - Base/primitive components
2. **Application components are MORE complex** - Deep composition, Context API, state management
3. **Marketing components have DIFFERENT patterns** - Full-width sections, content-heavy, responsive
4. **Page templates are COMPOSITIONS** - Multiple sections, not scaled-up components

**Attempting to use Button patterns for entire library = architectural failure**

### Revised Decision

**Build component library using multi-category architecture approach:**

1. **Study component category FIRST** before implementing any component
2. **Identify category-specific patterns** by analyzing 2-3 similar components in UPSTREAM/
3. **Document universal vs category-specific patterns** for each component type
4. **Never assume patterns from one category apply to another**

### Component Categories and Architectures

**1. base/ - Primitive UI Components**

- **Architecture:** Single responsibility, minimal composition, highly reusable
- **Examples:** Button (272 lines), Modal (42 lines), Input (272 lines with composition)
- **Patterns:** React Aria integration, size systems vary by component, variant systems component-specific
- **Reference Component:** Button (represents medium-complexity base component)

**2. application/ - Complex Application Patterns**

- **Architecture:** Deep composition, Context API, complex state management
- **Examples:** Table (301 lines), Modals (46 variants), Navigation systems
- **Patterns:** Composition (Table.Row, Table.Cell), integration with base components, responsive patterns
- **Cannot use Button patterns** - Requires studying application component architecture

**3. marketing/ - Marketing Website Components**

- **Architecture:** Full-width sections, content-driven, SEO-focused
- **Examples:** Hero sections (44 variants), Features, Pricing, Testimonials
- **Patterns:** Full-width layouts, responsive breakpoints, content composition
- **Cannot use Button patterns** - Completely different architecture

**4. pages/ - Page Templates**

- **Architecture:** Complete page compositions, multiple sections, routing integration
- **Examples:** Login pages (16 variants), Landing pages, Dashboard pages
- **Patterns:** Layout composition, section coordination, responsive structure
- **Cannot use Button patterns** - Composition architecture, not component architecture

### Universal Patterns (ALL components)

**Identified in Phase 0 analysis:**

1. **React Aria for Interactivity** - ALL interactive components (23% of total)
2. **Design Token System** - 100% of components use semantic tokens
3. **cx() Utility** - 100% of components for class merging
4. **TypeScript Type Safety** - Full typing with exported interfaces

**These patterns WILL be consistent across all categories**

### Category-Specific Patterns (DO NOT assume universal)

**Examples from Phase 0:**

- **Context API:** Only complex/composed components (13 files, 6%)
- **Polymorphic Rendering:** Button-specific (3 files, button/link variants)
- **Color Variant System:** Button-specific (primary/secondary/tertiary)
- **Size Systems:** Each component defines its own (Button: 4, Input: 2, Avatar: 5, Modal: 0)

**Must study EACH category before implementing**

### Implementation Approach

**For Each New Component:**

1. **Identify Category** - Which category does this belong to?
2. **Study Similar Components** - Find 2-3 similar components in UPSTREAM/react
3. **Identify Patterns:**
   - Universal patterns (apply to all)
   - Category patterns (apply to this type)
   - Component patterns (unique to this one)
4. **Document Findings** - Create architecture notes for component
5. **Implement Component** - Following identified patterns
6. **Validate Against Category** - Does it match category architecture?

### Rationale for Multi-Category Approach

1. **Prevents Button Fixation** - Different components need different architectures
2. **Reduces Architectural Errors** - Study before assuming patterns
3. **Enables Correct Complexity** - Match architecture to component needs
4. **Future-Proof** - Can add new categories with different patterns
5. **Evidence-Based** - Based on quantitative analysis of 208 components

### Consequences

**Positive:**

- Correct architecture for each component category
- Prevents applying inappropriate patterns
- Enables proper complexity matching
- Scalable to all component types
- Evidence-based approach

**Negative:**

- More upfront study required per component
- Cannot blindly copy Button patterns
- Requires category-specific documentation
- Longer ramp-up for new component categories

**Risks:**

- Could slow initial development (mitigated by documentation)
- Requires discipline to study before implementing
- May discover new categories requiring new patterns

### Alternatives Considered

1. **Keep Button as Universal Reference**

   - Rejected: Phase 0 proved this approach fundamentally flawed
   - Risk: Repeating architectural mistakes

2. **No Reference Components**

   - Rejected: Some guidance needed for consistency
   - Risk: Inconsistency across components

3. **One Reference Per Category**
   - Accepted as part of multi-category approach
   - Button = reference for base/ primitives
   - Table = reference for application/ complexity
   - Hero = reference for marketing/ sections
   - Dashboard = reference for pages/ templates

### References

- **PHASE-0-SYSTEM-STUDY.md** - Complete system analysis (208 components)
- **SYSTEM-ARCHITECTURE-ANALYSIS.md** - Quantitative pattern analysis
- **COMPONENT-TAXONOMY.md** - Component categorization
- **PATTERN-LIBRARY.md** - Universal vs specific patterns

### Implementation Notes

**When Building Button (Phase 2):**

- ✅ Follow as reference for base/ primitives ONLY
- ✅ Document which patterns are Button-specific
- ✅ Document which patterns are universal
- ❌ DO NOT assume patterns apply to other categories
- ❌ DO NOT use as template for application/marketing/pages components

**For Future Components:**

- Study component category first
- Reference appropriate category documentation
- Validate against category patterns
- Document deviations with rationale

---

## ADR-003: Vertical Slice Validation

**Status:** Accepted
**Date:** 2025-01-23
**Decision Makers:** Multi-role analysis (Technical PM, QA Engineer)

### Context

Building full component library (150+ components, 20 weeks) without validating approach creates massive risk:

- Approach might not work with Claude Code
- Problems discovered after significant investment
- No feedback loop to adjust methodology
- All-or-nothing outcome

Historical evidence shows Claude Code has unpredictable UI implementation behavior. Need early validation that compensatory scaffolding approach actually works.

### Decision

**Implement Phases 1-4 (11 days) as vertical slice proof-of-concept with explicit decision point before scaling to full library (Phases 5-10).**

Vertical slice includes:

- Phase 1: Automated Foundation (2-3 days)
- Phase 2: Reference Component - Button (3-4 days)
- Phase 3: Simple Page Template - Dashboard (2 days)
- Phase 4: Validation Test with fresh Claude Code instance (1 day)

**Decision Point After Phase 4:**

- If successful → Proceed to Phase 5 (Base Components Library)
- If failures occur → Analyze root causes, adjust approach, re-test

### Rationale

1. **Early Risk Mitigation**: Discovers fatal flaws before major investment
2. **Fast Feedback**: 11 days vs 20 weeks to validate approach
3. **Proves End-to-End**: Foundation → Component → Page → Validation
4. **Adaptive Approach**: Can pivot based on learnings
5. **Clear Success Criteria**: Fresh Claude Code instance must complete all tests
6. **Manageable Scope**: Can complete vertical slice in 2 weeks

### Consequences

**Positive:**

- Validates approach works before scaling
- Opportunity to refine methodology based on real results
- Lower sunk cost if approach doesn't work
- Can demonstrate success to stakeholders early
- Builds confidence incrementally

**Negative:**

- 11-day investment before knowing if full library is feasible
- Might discover approach doesn't work (failure is possible)
- Pressure to "prove it works" might rush implementation

**Risks:**

- Phase 4 validation might give false positive (test not comprehensive enough)
- Phase 4 validation might give false negative (test too strict)
- Pivot after Phase 4 could delay overall timeline

### Alternatives Considered

1. **Build Entire Library First**

   - Rejected: Too much risk without validation
   - Risk: 5 months wasted if approach doesn't work

2. **Build Only Phase 1 and Validate**

   - Rejected: Doesn't prove component implementation works
   - Risk: Automation might work but component patterns fail

3. **Iterate with User Feedback Instead of Decision Point**
   - Rejected: Needs objective validation with fresh Claude Code instance
   - Risk: Confirmation bias from same developer/AI pair

### Implementation Notes

- Phase 4 validation uses fresh Claude Code conversation
- Tests must be comprehensive but not impossible
- Document failures thoroughly if they occur
- Decision point requires explicit documentation of next steps

---

## ADR-004: Zero-Configuration Automation

**Status:** Accepted
**Date:** 2025-01-23
**Decision Makers:** Multi-role analysis (DX Engineer, AI Systems Engineer)

### Context

Claude Code consistently encounters configuration issues:

- npm/dependency version conflicts
- Incorrect tsconfig/eslint/tailwind settings
- Missing or misconfigured build tools
- Storybook setup failures
- Testing framework configuration errors

Manual setup instructions fail because:

- Claude Code doesn't reliably follow multi-step processes
- Configuration drift occurs across sessions
- Troubleshooting consumes excessive time
- "npm drama" derails development momentum

### Decision

**Implement zero-configuration automation where setup, scaffolding, and validation require zero manual steps.**

Automation includes:

- `setup-new-project.sh` - One command sets up entire project
- `create-component.sh` - One command scaffolds new component
- `validate-all.sh` - One command validates quality gates
- Locked dependency versions (no `^` or `~` ranges)
- Configuration templates with inline explanations
- Pre-commit hooks for automatic validation
- CI/CD workflows enforcing quality

### Rationale

1. **Eliminates Configuration Drift**: Same configuration every time
2. **Reduces Cognitive Load**: No decisions about setup
3. **Idempotent Operations**: Safe to run multiple times
4. **Actionable Error Messages**: Clear guidance when issues occur
5. **Platform Agnostic**: Works on Windows/Mac/Linux
6. **Prevents "npm drama"**: Locked versions prevent dependency conflicts

### Consequences

**Positive:**

- Setup works reliably across machines
- New developers/AI instances onboard instantly
- Configuration never drifts from standard
- Quality gates enforced automatically
- Troubleshooting time dramatically reduced

**Negative:**

- Upfront investment creating automation scripts
- Scripts need maintenance when dependencies update
- Less flexibility for custom configurations
- Debugging automation issues requires different skills

**Risks:**

- Scripts could be brittle on different platforms
- Over-automation makes system opaque
- Locked dependency versions could lag behind security patches

### Alternatives Considered

1. **Comprehensive Setup Documentation**

   - Rejected: Claude Code doesn't reliably follow documentation
   - Risk: Configuration drift inevitable

2. **Use Existing Starter Templates**

   - Rejected: Generic templates don't address AI-specific needs
   - Risk: Would still need extensive customization

3. **Docker-based Development Environment**
   - Rejected: Adds complexity, overkill for this project
   - Risk: Docker itself becomes configuration challenge

### Implementation Notes

- Scripts must validate prerequisites before executing
- Error messages must provide actionable next steps
- Scripts must be cross-platform (use Node.js for portability)
- Configuration templates include inline documentation
- All scripts exit with appropriate codes (0 = success, non-zero = failure)

---

## ADR-005: Machine-Readable Checklists

**Status:** Accepted
**Date:** 2025-01-23
**Decision Makers:** Multi-role analysis (AI Systems Engineer, QA Engineer)

### Context

Claude Code skips validation steps when using human-readable checklists:

- Markdown checkboxes treated as suggestions
- Manual checking is unreliable
- No programmatic verification
- Quality issues discovered too late

Need validation system that:

- Cannot be skipped by AI
- Provides objective pass/fail results
- Can be automated in CI/CD
- Works with existing tooling

### Decision

**Use machine-readable JSON checklists for component validation, with automated scripts that parse and verify each requirement.**

Example checklist format:

```json
{
  "component": "Button",
  "validations": [
    {
      "id": "typescript-exports",
      "description": "Component exports TypeScript interface",
      "validation": "check-exports",
      "required": true
    },
    {
      "id": "accessibility-aria",
      "description": "Proper ARIA attributes present",
      "validation": "check-aria",
      "required": true
    },
    {
      "id": "test-coverage",
      "description": "90%+ test coverage",
      "validation": "check-coverage",
      "threshold": 90,
      "required": true
    }
  ]
}
```

Validation script:

```bash
./scripts/validate-component.sh button
# Parses JSON checklist
# Runs each validation
# Reports pass/fail with details
# Exits with error code if any required validation fails
```

### Rationale

1. **Objective Validation**: No ambiguity about pass/fail
2. **Automation-Friendly**: Can run in CI/CD pipelines
3. **Cannot Be Skipped**: Script failures block commits
4. **Clear Requirements**: JSON structure is explicit
5. **Extensible**: Easy to add new validation types
6. **Tooling Integration**: Works with ESLint, TypeScript, Jest

### Consequences

**Positive:**

- Validation is objective and consistent
- Can enforce quality gates automatically
- AI cannot skip or misinterpret requirements
- Easy to see exactly what's missing
- Can be reused across components

**Negative:**

- More complex than markdown checklists
- Requires writing validation scripts
- Adds tooling dependency
- JSON maintenance overhead

**Risks:**

- Validation scripts themselves could have bugs
- Over-specification could slow development
- False negatives could block valid code

### Alternatives Considered

1. **Markdown Checklists**

   - Rejected: Claude Code treats as suggestions, not requirements
   - Risk: Validation steps get skipped

2. **Manual Code Review**

   - Rejected: Time-consuming, inconsistent
   - Risk: Human error, checklist fatigue

3. **Linting Rules Only**
   - Rejected: Doesn't cover all validation types (Storybook, accessibility)
   - Risk: Incomplete validation

### Implementation Notes

- Validation scripts exit with error codes for CI/CD
- Each validation provides detailed failure messages
- Checklists versioned alongside components
- Can run individual validations or full suite
- Results logged for debugging

---

## ADR-006: 90%+ Test Coverage Requirement

**Status:** Accepted
**Date:** 2025-01-23
**Decision Makers:** Multi-role analysis (QA Engineer, Frontend Architect)

### Context

UI component libraries require high reliability:

- Components used across entire application
- Bugs multiply across all usage sites
- Visual regressions hard to catch manually
- Accessibility compliance is critical

Historical issues with lower coverage:

- Edge cases discovered in production
- Variant interactions not tested
- Accessibility bugs slip through
- Refactoring breaks unexpected cases

Need objective quality bar that ensures:

- All public APIs are tested
- Edge cases are covered
- Accessibility is validated
- Safe refactoring is possible

### Decision

**Require 90%+ test coverage for all components with specific thresholds:**

```typescript
// vitest.config.ts
export default defineConfig({
  test: {
    coverage: {
      provider: 'v8',
      reporter: ['text', 'json', 'html'],
      thresholds: {
        statements: 90,
        branches: 85,
        functions: 90,
        lines: 90,
      },
      exclude: ['**/*.stories.tsx', '**/*.test.tsx', '**/types.ts'],
    },
  },
});
```

Test categories required:

- Unit tests (component behavior)
- Integration tests (component composition)
- Accessibility tests (WCAG compliance)
- Visual regression tests (Chromatic/Percy)

### Rationale

1. **Industry Standard**: 90% coverage is established best practice
2. **Catches Edge Cases**: High coverage reveals untested paths
3. **Safe Refactoring**: Can refactor with confidence
4. **Documentation via Tests**: Tests show how to use components
5. **Accessibility Enforcement**: Ensures WCAG compliance
6. **CI/CD Integration**: Automated quality gate

### Consequences

**Positive:**

- High confidence in component reliability
- Edge cases discovered during development
- Safe to refactor internal implementation
- Tests serve as usage documentation
- Accessibility validated automatically

**Negative:**

- More time writing tests than implementation
- Coverage doesn't guarantee quality
- May encourage "coverage theater" (tests that don't validate behavior)
- Maintenance burden for test suites

**Risks:**

- Over-focus on coverage numbers vs meaningful tests
- Brittle tests that break on refactoring
- False confidence from high coverage of trivial code

### Alternatives Considered

1. **80% Coverage**

   - Rejected: Too permissive, important edge cases might be missed
   - Risk: Lower quality bar

2. **100% Coverage**

   - Rejected: Diminishing returns, encourages coverage theater
   - Risk: Testing trivial getters/setters wastes time

3. **No Coverage Requirements**
   - Rejected: Historical evidence shows quality issues
   - Risk: Insufficient testing, production bugs

### Implementation Notes

- Pre-commit hook runs tests on changed files
- CI/CD pipeline blocks merge if coverage drops
- Coverage reports published with each PR
- Exclude Stories and type definitions from coverage
- Focus on meaningful tests, not coverage numbers

---

## ADR-007: Rewrite UntitledUI with AI-Native Enhancements

**Status:** Accepted
**Date:** 2025-01-23
**Decision Makers:** Multi-role analysis (AI Systems Engineer, Frontend Architect)

### Context

UntitledUI is industry-standard component library:

- Comprehensive component catalog
- Excellent visual design
- Strong accessibility foundation
- Well-architected codebase

However, UntitledUI has AI-specific gaps:

- Minimal inline documentation (3 comments for 272 lines)
- Implicit patterns and conventions
- Complex utility dependencies (cx, cn, sortCx)
- No AI usage guidance
- Assumes developer conceptual understanding

Claude Code has demonstrated inability to:

- Infer implicit patterns from examples
- Understand composition from structure alone
- Reason about spatial layouts
- Follow conventions without explicit guidance

### Decision

**Rewrite UntitledUI components using their structure as baseline, enhancing with AI-native features:**

Enhancements include:

1. **Exhaustive Inline Documentation**

   - Every line has explanatory comment
   - WHY decisions were made, not just WHAT
   - Edge cases and gotchas documented

2. **Explicit AI Usage Guidance**

   - JSDoc on all props with usage examples
   - DO/DON'T sections for common mistakes
   - Composition patterns documented

3. **Simplified Dependencies**

   - Replace complex utilities with explicit code
   - Document all external dependencies
   - No magic or implicit behavior

4. **Machine-Readable Metadata**

   - JSON validation checklists
   - Explicit variant definitions
   - Composition rules codified

5. **Complete Storybook Coverage**
   - Every variant combination shown
   - Interactive controls for all props
   - Visual specifications with annotations

### Rationale

1. **UntitledUI is Industry Standard**: Proven design patterns, accessibility
2. **Compensates for AI Limitations**: Explicit documentation replaces conceptual understanding
3. **Maintains Quality**: UntitledUI architecture is solid
4. **Adds AI-Specific Value**: Inline guidance prevents deviations
5. **Reusable Patterns**: Enhancements work across all components
6. **Future-Proof**: AI-native design benefits future LLMs too

### Consequences

**Positive:**

- Components follow proven industry patterns
- AI can use components without conceptual understanding
- Documentation serves both AI and human developers
- UntitledUI visual design maintained
- Accessibility baseline preserved

**Negative:**

- Rewriting takes longer than using as-is
- More verbose code due to inline documentation
- Maintenance burden keeping enhancements updated
- Diverges from UntitledUI updates

**Risks:**

- Enhancements might not be sufficient for Claude Code
- Rewriting introduces new bugs
- Documentation overhead slows development

### Alternatives Considered

1. **Use UntitledUI As-Is**

   - Rejected: Lacks AI-specific guidance, Claude Code would still fail
   - Risk: Repeats historical failures

2. **Fork UntitledUI and Add Documentation**

   - Rejected: Upstream changes difficult to merge
   - Risk: Divergence over time

3. **Build Components From Scratch**

   - Rejected: Reinventing wheel, no proven patterns
   - Risk: Lower quality than industry standard

4. **Use Different Component Library (Shadcn, Chakra)**
   - Rejected: UntitledUI has better AI-friendly structure
   - Risk: Would still need same enhancements

### Implementation Notes

- UPSTREAM/ directory maintains UntitledUI reference
- Each component copies UntitledUI structure as starting point
- Enhancements follow consistent pattern across all components
- Document deviations from UntitledUI in ADR updates

---

## ADR-008: Technology Stack Selection

**Status:** Accepted
**Date:** 2025-01-23
**Decision Makers:** Multi-role analysis (Frontend Architect, AI Systems Engineer)

### Context

Component library needs modern, stable foundation:

- React ecosystem is industry standard
- TypeScript provides type safety
- Styling solution must be flexible
- Accessibility must be first-class
- Build tooling must be fast
- Testing must be reliable

Previous projects encountered:

- React 18 compatibility issues
- CSS-in-JS performance problems
- Build tool configuration complexity
- Accessibility implementation gaps

### Decision

**Use the following technology stack:**

**Core Framework:**

- React 19.1.1 (latest stable, Server Components support)
- TypeScript 5.8+ (strict mode, latest features)

**Styling:**

- Tailwind CSS 4.1.11 (utility-first, native cascade layers)
- CSS Variables for theming

**Accessibility:**

- React Aria 3.44+ (WAI-ARIA primitives)
- React Aria Components 1.13+ (higher-level patterns)

**Development:**

- Bun 1.1+ (fast package manager and runtime)
- Storybook 9.x (component documentation)
- Vite (fast build tool)

**Testing:**

- Vitest (fast, Vite-native)
- React Testing Library (user-centric testing)
- jest-axe (accessibility testing)

**Linting/Formatting:**

- ESLint 9.x (flat config)
- Prettier 3.x (code formatting)

### Rationale

**React 19.1:**

- Latest stable release with Server Components
- Best-in-class ecosystem and tooling
- Industry standard for component libraries
- Excellent TypeScript support

**TypeScript 5.8+:**

- Strict type safety prevents runtime errors
- Enhanced developer experience with IntelliSense
- Self-documenting code through types
- Catches issues at compile time

**Tailwind CSS 4.1:**

- Utility-first scales without CSS bloat
- Native cascade layers (no CSS-in-JS complexity)
- Excellent developer experience
- Performance optimized
- Easy theming with CSS variables

**React Aria:**

- Complete WAI-ARIA primitives
- Keyboard navigation built-in
- Focus management handled
- Screen reader tested
- Reduces accessibility implementation burden

**Bun:**

- 10x faster than npm
- Built-in TypeScript support
- Excellent DX
- Compatible with Node.js packages

**Storybook 9.x:**

- Industry standard component documentation
- Interactive component explorer
- Visual testing integration
- Supports all frameworks

**Vitest:**

- Vite-native (fast)
- Jest-compatible API
- Excellent TypeScript support
- Built-in coverage

### Consequences

**Positive:**

- Modern, performant foundation
- Excellent developer experience
- Industry-standard tools
- Strong TypeScript integration
- First-class accessibility support
- Fast build and test times

**Negative:**

- Cutting-edge versions may have bugs
- Breaking changes in major updates
- Learning curve for some tools
- Dependency lock-in

**Risks:**

- React 19 Server Components still maturing
- Tailwind 4.x major version could have issues
- Bun adoption not as widespread as npm

### Alternatives Considered

1. **React 18**

   - Rejected: Missing Server Components, older patterns
   - Risk: Technical debt from day one

2. **CSS-in-JS (Emotion, Styled Components)**

   - Rejected: Performance overhead, complexity
   - Risk: Runtime styling issues

3. **Vanilla CSS Modules**

   - Rejected: Less flexible than Tailwind
   - Risk: CSS bloat as library grows

4. **npm/pnpm Instead of Bun**

   - Rejected: Slower, less integrated
   - Risk: Longer development cycles

5. **Jest Instead of Vitest**
   - Rejected: Slower, requires more configuration
   - Risk: Poor Vite integration

### Implementation Notes

- Lock all dependency versions (no `^` or `~`)
- Document upgrade path for each major dependency
- Test compatibility matrix (React 19 + Tailwind 4 + React Aria)
- Include polyfills if needed for older browsers

---

## ADR-009: Inline Documentation Strategy

**Status:** Accepted
**Date:** 2025-01-23
**Decision Makers:** Multi-role analysis (AI Systems Engineer, Frontend Architect)

### Context

Claude Code demonstrates conceptual blindness to UI patterns:

- Cannot infer patterns from structure alone
- Deviates from examples when creating similar components
- Lacks understanding of spatial layouts
- Ignores implicit conventions

Traditional documentation approaches fail:

- External documentation gets ignored
- README files not consulted during development
- Markdown guides not referenced when needed
- Assumes developer will seek out documentation

Need documentation strategy that:

- Cannot be missed or ignored
- Provides context exactly where needed
- Explains WHY, not just WHAT
- Includes AI-specific usage guidance

### Decision

**Implement exhaustive inline documentation directly in component source code:**

Documentation requirements:

1. **Every Line Explained**

   ```typescript
   // Button uses relative positioning to contain absolutely-positioned loading spinner
   // This prevents layout shift when transitioning between loading and normal states
   className = 'relative inline-flex items-center';
   ```

2. **JSDoc on All Exports**

   ```typescript
   /**
    * Button component for primary user actions
    *
    * @example
    * // Primary call-to-action
    * <Button color="primary" size="lg">Get Started</Button>
    *
    * @example
    * // Form submission with loading state
    * <Button type="submit" isLoading={isSubmitting}>Save Changes</Button>
    *
    * ## AI Usage Guidelines
    *
    * **When to use:**
    * - Form submissions (Save, Submit, Create)
    * - Primary CTAs (Get Started, Sign Up)
    * - Dangerous actions with destructive variant (Delete, Remove)
    *
    * **DO:**
    * - Use descriptive text ("Save Changes", not "Submit")
    * - Use primary for most important action
    * - Disable during loading states
    * - Provide visual feedback for state changes
    *
    * **DO NOT:**
    * - Use multiple primary buttons in same context
    * - Use for navigation (use Link component instead)
    * - Forget to handle loading and disabled states
    */
   ```

3. **WHY Documentation**

   ```typescript
   // We use Tailwind's peer-* utilities instead of JavaScript state management
   // WHY: Reduces bundle size, leverages CSS cascade, improves performance
   // ALTERNATIVE CONSIDERED: useState + conditional classes (rejected: more complex)
   ```

4. **Edge Cases Documented**

   ```typescript
   // Edge case: Icon-only buttons need aria-label for screen readers
   // Example: <Button aria-label="Close dialog"><XIcon /></Button>
   ```

5. **Composition Guidance**
   ```typescript
   // Common compositions:
   // - Icon leading: <Button><SearchIcon />Search</Button>
   // - Icon trailing: <Button>Next<ArrowRightIcon /></Button>
   // - Icon only: <Button aria-label="Settings"><SettingsIcon /></Button>
   ```

### Rationale

1. **Cannot Be Missed**: Documentation is in the code being read/modified
2. **Contextual**: Explains exactly what's happening right where it happens
3. **Explains WHY**: Helps AI understand intent, not just implementation
4. **AI-Specific**: Includes DO/DON'T guidance for common AI mistakes
5. **Self-Contained**: No need to search external docs
6. **Maintenance Friendly**: Docs stay in sync with code

### Consequences

**Positive:**

- Documentation always visible when reading code
- Reduces need to search external documentation
- Explains intent and rationale, not just implementation
- AI-specific guidance prevents common mistakes
- Benefits human developers too
- Documentation stays in sync with code

**Negative:**

- More verbose code (10x-20x more lines)
- Harder to skim code for structure
- Maintenance burden keeping comments updated
- Could become noise if overdone
- Larger file sizes

**Risks:**

- Documentation could become stale
- Over-documentation creates noise
- Balance needed between helpful and overwhelming
- Comments could be wrong/misleading

### Alternatives Considered

1. **External Documentation Only (README, Docs Site)**

   - Rejected: Claude Code doesn't consult external docs during development
   - Risk: Documentation ignored when needed

2. **JSDoc Only (No Inline Comments)**

   - Rejected: Doesn't explain implementation details or WHY
   - Risk: AI still lacks context for internal logic

3. **Minimal Comments (Standard Practice)**

   - Rejected: Historical evidence shows Claude Code needs extensive guidance
   - Risk: Repeats previous UI implementation failures

4. **AI-Specific README in Each Component Directory**
   - Rejected: Still external, might not be read
   - Risk: Documentation separated from code

### Implementation Notes

- Documentation template provided in scaffolding
- Every line comment explains purpose, not just paraphrase
- JSDoc includes examples, DO/DON'T, edge cases
- Document alternatives considered and why rejected
- Update comments when code changes

---

## ADR-010: Component Scaffolding System

**Status:** Accepted
**Date:** 2025-01-23
**Decision Makers:** Multi-role analysis (DX Engineer, AI Systems Engineer)

### Context

Creating new components involves many repetitive steps:

- Directory structure
- TypeScript component file
- Test file
- Storybook story
- Types definition
- Export from index
- Validation checklist

Manual component creation leads to:

- Inconsistent structure across components
- Missing files (tests, stories, types)
- Incorrect naming conventions
- Forgotten exports
- No validation checklist

Claude Code particularly struggles with:

- Maintaining consistent file structure
- Creating all required files
- Following naming conventions
- Setting up test boilerplate

### Decision

**Implement component scaffolding system that generates complete, consistent component structure with one command:**

```bash
bun run scaffold button --type=base --category=buttons
```

Generated structure:

```
components/base/buttons/button/
├── button.tsx              # Component implementation
├── button.test.tsx         # Unit tests
├── button.stories.tsx      # Storybook stories
├── button.types.ts         # TypeScript types
├── button.validation.json  # Validation checklist
├── index.ts                # Exports
└── README.md               # Component-specific docs
```

Scaffold generates:

- Component template with inline documentation
- Test boilerplate with common cases
- Storybook story with all controls
- TypeScript interfaces
- Validation checklist
- README with AI usage guidance

### Rationale

1. **Consistency**: Same structure every time
2. **Completeness**: All required files generated
3. **Time Savings**: 5 minutes → 30 seconds
4. **Error Prevention**: Can't forget required files
5. **Best Practices Enforced**: Templates include patterns
6. **AI-Friendly**: Reduces decisions AI needs to make

### Consequences

**Positive:**

- Perfect consistency across all components
- All required files present from start
- Documentation template included
- Validation checklist created automatically
- Reduces cognitive load
- Fast component creation

**Negative:**

- Scaffold script needs maintenance
- Templates become out of date
- Less flexibility for unique components
- Generated code might include unnecessary boilerplate

**Risks:**

- Templates could have bugs
- Over-scaffolding creates bloat
- Updates to template don't propagate to existing components

### Alternatives Considered

1. **Manual Component Creation with Checklist**

   - Rejected: Claude Code doesn't reliably follow checklists
   - Risk: Missing files, inconsistent structure

2. **Copy-Paste from Reference Component**

   - Rejected: Manual process, error-prone
   - Risk: Inconsistent updates across components

3. **Use Generic Component Generator (Plop, Hygen)**
   - Rejected: Doesn't include AI-specific enhancements
   - Risk: Still need extensive customization

### Implementation Notes

- Scaffold script validates component name
- Checks for existing component (prevents overwrite)
- Generates all files atomically (all or nothing)
- Includes TODO comments for required customization
- Updates parent index.ts with exports

---

## ADR-011: Pre-commit Quality Gates

**Status:** Accepted
**Date:** 2025-01-23
**Decision Makers:** Multi-role analysis (QA Engineer, DX Engineer)

### Context

Code quality issues discovered too late:

- Linting errors caught during PR review
- TypeScript errors found in CI
- Test failures break main branch
- Formatting inconsistencies waste review time

Manual quality checks fail:

- Developers forget to run checks
- Claude Code skips validation steps
- Issues compound across commits
- Debugging is harder with multiple bad commits

Need automatic enforcement that:

- Runs before code is committed
- Provides fast feedback
- Cannot be skipped accidentally
- Catches issues early

### Decision

**Implement pre-commit hooks using Husky that automatically run quality gates before allowing commits:**

Pre-commit checks:

```bash
# .husky/pre-commit

# Run type checking on staged files
bun run type-check

# Run linting with auto-fix on staged files
bun run lint

# Run prettier on staged files
bun run prettier

# Run tests related to changed files
bun run test --changed --bail

# Exit with error if any check fails
```

Quality gates:

- TypeScript strict mode compliance
- ESLint zero errors/warnings
- Prettier formatting
- Tests pass for changed code
- 90%+ coverage maintained

### Rationale

1. **Automatic Enforcement**: Cannot commit broken code
2. **Fast Feedback**: Issues caught immediately
3. **Prevents Compound Issues**: Each commit is quality-checked
4. **Reduces PR Review Time**: No formatting/linting comments
5. **Works with AI**: Claude Code cannot skip checks
6. **Developer Experience**: Auto-fix applied when possible

### Consequences

**Positive:**

- Code quality enforced automatically
- Fast feedback loop
- Cannot accidentally commit broken code
- Consistent code style across codebase
- Reduces PR review burden
- Works seamlessly with AI tools

**Negative:**

- Commit process takes longer (10-30 seconds)
- Can be frustrating if checks fail repeatedly
- Requires fixing issues before committing
- May slow down rapid prototyping

**Risks:**

- Overly strict checks could slow development
- Hooks can be bypassed with --no-verify
- Slow checks discourage frequent commits

### Alternatives Considered

1. **Manual Quality Checks**

   - Rejected: Unreliable, frequently skipped
   - Risk: Quality issues reach main branch

2. **CI-Only Checks**

   - Rejected: Feedback too slow, issues compound
   - Risk: Waste time in PR review

3. **IDE-Only Linting**

   - Rejected: Not enforced, developer-dependent
   - Risk: Inconsistent standards

4. **Post-Commit Hooks**
   - Rejected: Too late, commit already created
   - Risk: Bad commits in history

### Implementation Notes

- Husky installs hooks automatically on `npm install`
- Hooks run on staged files only (performance)
- Auto-fix applied when possible (prettier, eslint --fix)
- Clear error messages when checks fail
- Can skip with --no-verify in emergencies (discouraged)

---

## ADR-012: React Aria for Accessibility

**Status:** Accepted
**Date:** 2025-01-23
**Decision Makers:** Multi-role analysis (Frontend Architect, AI Systems Engineer)

### Context

Accessibility is complex and error-prone:

- WAI-ARIA patterns have many rules
- Keyboard navigation requires careful implementation
- Focus management is subtle
- Screen reader support needs testing
- Different patterns for different components

Manual ARIA implementation leads to:

- Missing attributes
- Incorrect keyboard behavior
- Focus traps
- Screen reader issues
- WCAG compliance failures

Claude Code particularly struggles with:

- Remembering all ARIA attributes
- Implementing keyboard navigation
- Focus management edge cases
- Screen reader announcements

### Decision

**Use React Aria as the accessibility foundation for all components:**

React Aria provides:

- Complete WAI-ARIA primitives (useButton, useDialog, useMenu, etc.)
- Keyboard navigation built-in
- Focus management handled
- Screen reader tested
- Cross-browser compatible
- Mobile-friendly

Usage pattern:

```typescript
import { useButton } from 'react-aria';

function Button(props: ButtonProps) {
  const ref = useRef<HTMLButtonElement>(null);

  // React Aria handles all ARIA attributes, keyboard, focus
  const { buttonProps, isPressed } = useButton(props, ref);

  return (
    <button {...buttonProps} ref={ref}>
      {props.children}
    </button>
  );
}
```

### Rationale

1. **Adobe-Maintained**: Industry-standard, battle-tested
2. **Complete Coverage**: All WAI-ARIA patterns implemented
3. **Reduces Implementation Burden**: Don't reinvent accessibility
4. **Eliminates ARIA Errors**: Correct by default
5. **Cross-Platform**: Works across browsers and devices
6. **AI-Friendly**: Simple hook API, well-documented
7. **WCAG Compliance**: Meets WCAG 2.1 AA by default

### Consequences

**Positive:**

- WCAG 2.1 AA compliance automatic
- Keyboard navigation works correctly
- Focus management handled
- Screen reader support built-in
- Reduces accessibility bugs
- Faster development (no manual ARIA)
- Tested across browsers/devices

**Negative:**

- Dependency on external library
- Learning curve for React Aria patterns
- Less control over implementation details
- Bundle size increase
- API constraints limit customization

**Risks:**

- React Aria updates could break components
- Not all patterns might be available
- May need custom ARIA for unique components

### Alternatives Considered

1. **Manual ARIA Implementation**

   - Rejected: Error-prone, time-consuming, hard to maintain
   - Risk: WCAG compliance failures

2. **Radix UI Primitives**

   - Rejected: More opinionated, larger bundle
   - Risk: Harder to customize

3. **Headless UI**

   - Rejected: Less comprehensive than React Aria
   - Risk: Missing patterns for some components

4. **Reach UI**
   - Rejected: Less actively maintained
   - Risk: Future support uncertain

### Implementation Notes

- Use React Aria hooks for all interactive components
- Supplement with manual ARIA only when necessary
- Test with screen readers (NVDA, JAWS, VoiceOver)
- Document any deviations from React Aria patterns
- Include accessibility tests in all component test suites

---

## Version History

| Version | Date       | Changes                                             |
| ------- | ---------- | --------------------------------------------------- |
| 1.0.0   | 2025-01-23 | Initial ADR document with 12 architecture decisions |

---

## Maintenance

This ADR document should be updated when:

- New architecture decisions are made
- Existing decisions are revisited or changed
- Consequences become apparent that weren't predicted
- Implementation reveals flaws in original decision

**Review Frequency:** After each phase completion (Phase 1-4), then monthly

---

---

## ADR-013: GitHub Actions CI/CD Integration

**Date:** 2025-01-24
**Status:** ✅ Accepted
**Context:** Phase 1.0 Automation Infrastructure

### Decision

Implement GitHub Actions workflows for automated quality validation on every push and pull request.

### Implementation

Two workflows created:

1. **`.github/workflows/validate-pr.yml`**

   - Triggers on PR to main/develop
   - Runs TypeScript, ESLint, Prettier, Tests
   - Blocks merge if quality gates fail

2. **`.github/workflows/validate-push.yml`**
   - Triggers on push to main/develop/feature branches
   - Same quality gates as PR workflow
   - Provides immediate feedback

### Rationale

1. **Prevent Bad Code from Merging**: Quality gates enforced by GitHub
2. **Consistent Validation**: Same checks locally (pre-commit) and remotely (CI/CD)
3. **Team Collaboration**: Validates code from all contributors
4. **Status Visibility**: GitHub PR UI shows pass/fail status
5. **No Manual Review for Quality**: Automated checks free reviewers for logic review

### Consequences

**Positive:**

- Bad code cannot merge to protected branches
- Quality maintained across all contributors
- CI/CD status badges available
- Automated testing on every change

**Negative:**

- GitHub Actions usage costs (free tier: 2000 min/month)
- Adds ~2-3 minutes to PR merge time
- Requires GitHub repository

---

## ADR-014: Automatic Session State Updates

**Date:** 2025-01-24
**Status:** ✅ Accepted
**Context:** Phase 1.0 Automation Infrastructure

### Decision

Implement post-commit hook that automatically updates `.claude/session-state.json` after every commit.

### Implementation

**`.husky/post-commit` hook:**

- Updates `timing.last_activity` timestamp
- Updates `git_state` (commits ahead, modified files, etc.)
- Updates `checkpoint.commit` with latest commit hash
- Non-blocking (failures don't prevent commit)

### Rationale

1. **Zero Manual Effort**: Session state always current
2. **Accurate Tracking**: Real-time git state information
3. **Recovery Support**: Always know last known good state
4. **Context Preservation**: Claude Code can resume accurately

### Consequences

**Positive:**

- Session state always accurate
- No manual JSON editing required
- Better context for recovery scenarios
- Enables future automation (auto-checkpoint logic)

**Negative:**

- Adds ~100ms to each commit
- Requires Node.js installed
- Hook failures logged but not blocking

---

## ADR-015: Automatic Checkpoint Creation

**Date:** 2025-01-24
**Status:** ✅ Accepted
**Context:** Phase 1.0 Automation Infrastructure

### Decision

Implement pre-push hook that automatically creates checkpoint git tags before pushing to remote.

### Implementation

**`.husky/pre-push` hook:**

- Creates lightweight git tag: `checkpoint-YYYYMMDD-HHMMSS-<hash>`
- Tag format: `checkpoint-20250124-143022-a1b2c3d`
- Non-blocking (push continues even if tag creation fails)
- Automatic naming prevents conflicts

### Rationale

1. **Safety Net**: Every push creates recovery point
2. **Zero Effort**: No manual tag creation required
3. **Granular Recovery**: Can restore to any push
4. **Timestamp Tracking**: Know when each push occurred
5. **Work Preservation**: Never lose pushed work

### Consequences

**Positive:**

- Automatic backup before every push
- Granular recovery points
- No manual checkpoint management
- Timestamped for easy identification

**Negative:**

- Creates many tags over time (cleanup needed eventually)
- Adds ~50ms to each push
- Tags clutter git history (mitigated by naming convention)

**Future Enhancement:**

- Periodic tag cleanup (delete checkpoints older than 30 days)
- Push tags to remote for backup
- Integrate with `/checkpoint` slash command

---

## Next Steps

1. ✅ ADR.md created
2. ✅ Phase 1.0 automation complete (actual implementation)
3. ⏳ Test automation end-to-end
4. ⏳ Begin Phase 1.1 implementation
5. ⏳ Review ADRs after Phase 4 validation
