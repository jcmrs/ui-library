# Agent Orchestration Protocol

**Project:** UI Library
**Version:** 1.0.0
**Last Updated:** 2025-01-24
**Purpose:** Structured guidelines for AI-assisted development using wshobson agent framework

---

## Table of Contents

1. [Protocol Overview](#protocol-overview)
2. [When to Use Agents](#when-to-use-agents)
3. [Agent Selection Guide](#agent-selection-guide)
4. [Orchestration Patterns](#orchestration-patterns)
5. [Component Development Workflow](#component-development-workflow)
6. [Quality Assurance Workflow](#quality-assurance-workflow)
7. [Documentation Workflow](#documentation-workflow)
8. [Context Management](#context-management)
9. [Error Handling](#error-handling)
10. [Session Continuity](#session-continuity)
11. [Examples](#examples)

---

## Protocol Overview

### Purpose

This protocol ensures consistent, efficient use of the wshobson agent framework throughout the UI Library project development lifecycle.

### Core Principles

1. **Specialization Over Generalization** - Use specialized agents for their domain expertise
2. **Parallel When Possible** - Execute independent tasks simultaneously
3. **Sequential When Required** - Chain dependent tasks properly
4. **Context Efficiency** - Load only what's needed, when it's needed
5. **Quality First** - Always include review/validation agents
6. **Document Everything** - Every agent output gets documented

### Framework Capabilities

- **85 specialized agents** across 8 domains
- **47 progressive skills** for deep expertise
- **15 workflow orchestrators** for complex coordination
- **Hybrid model strategy** (Haiku speed + Sonnet reasoning)

---

## When to Use Agents

### ✅ **USE AGENTS FOR:**

1. **Component Implementation**

   - Complex components requiring expertise
   - Accessibility-critical implementations
   - Multi-variant component systems
   - Integration with React Aria

2. **Architecture & Design**

   - System design decisions
   - API design and interfaces
   - Data model design
   - Pattern selection

3. **Quality Assurance**

   - Code review before commits
   - Security auditing
   - Performance analysis
   - Accessibility validation

4. **Documentation**

   - Technical documentation generation
   - API documentation
   - Architecture decision records
   - Tutorial creation

5. **Testing**
   - Test suite generation
   - Test-driven development workflows
   - Integration test design
   - E2E test automation

### ❌ **DO NOT USE AGENTS FOR:**

1. **Simple File Operations**

   - Reading single files
   - Basic edits
   - File creation from templates

2. **Trivial Tasks**

   - Formatting fixes
   - Simple string replacements
   - Single-line changes

3. **Exploration**

   - Browsing codebase structure
   - Finding files
   - Searching for patterns

4. **Git Operations**
   - Commits (use automation)
   - Checkpoints (use automation)
   - Status checks

---

## Agent Selection Guide

### Frontend Development

**Agent:** `frontend-mobile-development:frontend-developer`
**Model:** Sonnet (complex reasoning required)
**Use For:**

- React component implementation
- React Aria integration
- State management patterns
- Component composition
- Responsive design
- Tailwind CSS styling

**Example:**

```typescript
Task(
  subagent_type: "frontend-mobile-development:frontend-developer",
  prompt: "Implement Button component with all variants (primary, secondary, tertiary, ghost), all sizes (sm, md, lg, xl), loading state, icons, and full accessibility using React Aria. Follow patterns from UPSTREAM/react/ reference."
)
```

### Architecture Review

**Agent:** `code-review-ai:architect-review`
**Model:** Sonnet (deep analysis required)
**Use For:**

- Component API design validation
- Architecture pattern review
- Scalability assessment
- Design principle adherence

**Example:**

```typescript
Task(
  subagent_type: "code-review-ai:architect-review",
  prompt: "Review Button component architecture: API design, variant system, composition patterns, extensibility, and alignment with design system principles."
)
```

### Code Quality Review

**Agent:** `code-documentation:code-reviewer`
**Model:** Sonnet (comprehensive analysis)
**Use For:**

- Code quality analysis
- Security vulnerability detection
- Performance optimization
- Best practice verification

**Example:**

```typescript
Task(
  subagent_type: "code-documentation:code-reviewer",
  prompt: "Review Button component implementation: TypeScript types, React patterns, performance, security, error handling, and code quality."
)
```

### Accessibility Validation

**Agent:** `accessibility-compliance:ui-visual-validator`
**Model:** Sonnet (detailed validation)
**Use For:**

- WCAG 2.1 AA compliance verification
- ARIA attribute validation
- Keyboard navigation testing
- Screen reader compatibility

**Example:**

```typescript
Task(
  subagent_type: "accessibility-compliance:ui-visual-validator",
  prompt: "Validate Button component accessibility: WCAG 2.1 AA compliance, ARIA attributes, keyboard navigation, focus management, screen reader announcements."
)
```

### Test Automation

**Agent:** `unit-testing:test-automator`
**Model:** Haiku (fast execution)
**Use For:**

- Test suite generation
- Unit test creation
- Integration test design
- Test coverage analysis

**Example:**

```typescript
Task(
  subagent_type: "unit-testing:test-automator",
  prompt: "Generate comprehensive test suite for Button component: render tests, interaction tests, variant tests, accessibility tests, edge cases."
)
```

### Documentation Generation

**Agent:** `code-documentation:docs-architect`
**Model:** Sonnet (comprehensive documentation)
**Use For:**

- Technical documentation
- API reference generation
- Architecture documentation
- Usage guides

**Example:**

```typescript
Task(
  subagent_type: "code-documentation:docs-architect",
  prompt: "Generate comprehensive documentation for Button component: usage patterns, API reference, examples, accessibility notes, best practices."
)
```

### Backend Architecture

**Agent:** `backend-development:backend-architect`
**Model:** Sonnet (complex design)
**Use For:**

- API design
- Service architecture
- Data model design
- Integration patterns

**Example:**

```typescript
Task(
  subagent_type: "backend-development:backend-architect",
  prompt: "Design component metadata API: schema definition, GraphQL types, query patterns, caching strategy."
)
```

### Database Design

**Agent:** `database-design:database-architect`
**Model:** Sonnet (data modeling)
**Use For:**

- Schema design
- Data model optimization
- Query optimization
- Migration planning

**Example:**

```typescript
Task(
  subagent_type: "database-design:database-architect",
  prompt: "Design component registry schema: component metadata, variant relationships, tag system, search optimization."
)
```

---

## Orchestration Patterns

### Pattern 1: Sequential Chain (Dependencies)

**When:** Tasks depend on previous results
**How:** Wait for each agent to complete before launching next

```typescript
// Step 1: Architecture design
Task('architect-review', 'Design Button API');
// WAIT for result
// Step 2: Implementation
Task('frontend-developer', 'Implement Button with approved API');
// WAIT for result
// Step 3: Testing
Task('test-automator', 'Generate tests for Button');
// WAIT for result
// Step 4: Review
Task('code-reviewer', 'Review Button implementation');
```

**Use Cases:**

- TDD workflow (design → implement → test → review)
- Migration (analyze → plan → implement → validate)
- Feature development (architect → build → test → document)

### Pattern 2: Parallel Execution (Independence)

**When:** Tasks are independent and can run simultaneously
**How:** Launch all agents in single message

```typescript
// Single message with multiple Task calls
Task('architect-review', 'Review Button architecture');
Task('code-reviewer', 'Review Button code quality');
Task('ui-visual-validator', 'Validate Button accessibility');
Task('security-auditor', 'Audit Button security');
```

**Use Cases:**

- Multi-perspective review (architecture + quality + security + accessibility)
- Documentation generation (API docs + usage guide + examples)
- Testing (unit + integration + E2E)

### Pattern 3: Hybrid Orchestration (Mixed)

**When:** Some tasks parallel, some sequential
**How:** Parallel within stages, sequential between stages

```typescript
// Stage 1: Parallel Analysis
Task('architect-review', 'Analyze current architecture');
Task('code-reviewer', 'Analyze code quality');
// WAIT for both
// Stage 2: Sequential Implementation based on findings
Task('frontend-developer', 'Implement improvements');
// WAIT
// Stage 3: Parallel Validation
Task('test-automator', 'Generate tests');
Task('ui-visual-validator', 'Validate accessibility');
```

**Use Cases:**

- Refactoring workflows
- Performance optimization
- Comprehensive audits

### Pattern 4: Iterative Refinement

**When:** Work requires feedback loops
**How:** Agent → Review → Agent → Review

```typescript
// Iteration 1
Task('frontend-developer', 'Implement Button v1');
// WAIT
Task('code-reviewer', 'Review and suggest improvements');
// WAIT - analyze feedback
// Iteration 2
Task('frontend-developer', 'Implement improvements from review');
// WAIT
Task('ui-visual-validator', 'Final accessibility check');
```

**Use Cases:**

- Complex component development
- API design refinement
- Performance tuning

---

## Component Development Workflow

### Standard Component Creation Process

**Phase 1: Planning & Design (Sequential)**

1. **Architecture Design**

   ```typescript
   Task(
     subagent_type: "code-review-ai:architect-review",
     prompt: "Design [Component] architecture: API, variants, composition patterns, accessibility requirements. Reference UPSTREAM/react/ for UntitledUI patterns."
   )
   ```

2. **Review Architecture**
   - Validate API design
   - Confirm accessibility approach
   - Approve variant system

**Phase 2: Implementation (Sequential)**

3. **Create Component**

   ```typescript
   Task(
     subagent_type: "frontend-mobile-development:frontend-developer",
     prompt: "Implement [Component] following approved architecture. Include: TypeScript types, all variants, React Aria integration, Tailwind styling, full accessibility."
   )
   ```

4. **Generate Tests**
   ```typescript
   Task(
     subagent_type: "unit-testing:test-automator",
     prompt: "Generate comprehensive test suite for [Component]: render tests, interaction tests, variant tests, accessibility tests, edge cases."
   )
   ```

**Phase 3: Quality Assurance (Parallel)**

5. **Multi-Perspective Review**
   ```typescript
   // Launch all in parallel
   Task('code-reviewer', 'Review code quality, performance, best practices');
   Task('ui-visual-validator', 'Validate WCAG 2.1 AA compliance');
   Task('security-auditor', 'Security audit');
   ```

**Phase 4: Documentation (Sequential)**

6. **Generate Documentation**
   ```typescript
   Task(
     subagent_type: "code-documentation:docs-architect",
     prompt: "Generate documentation: usage patterns, API reference, accessibility notes, examples, best practices."
   )
   ```

**Phase 5: Integration**

7. **Manual Integration**
   - Update component index exports
   - Add to Storybook
   - Update component README
   - Run quality gates (automated)

**Phase 6: Finalization**

8. **Commit with Automation**
   ```bash
   /commit
   ```
   - Pre-commit hooks validate
   - Conventional commit message generated
   - Post-commit hooks update session state

### Workflow Diagram

```
┌─────────────────────────────────────────┐
│ Phase 1: Planning (Sequential)          │
│ ┌─────────────────────────────────────┐ │
│ │ 1. architect-review: Design API     │ │
│ └─────────────────────────────────────┘ │
│              ↓                          │
│ ┌─────────────────────────────────────┐ │
│ │ 2. Manual: Review & Approve         │ │
│ └─────────────────────────────────────┘ │
└─────────────────────────────────────────┘
              ↓
┌─────────────────────────────────────────┐
│ Phase 2: Implementation (Sequential)     │
│ ┌─────────────────────────────────────┐ │
│ │ 3. frontend-developer: Implement    │ │
│ └─────────────────────────────────────┘ │
│              ↓                          │
│ ┌─────────────────────────────────────┐ │
│ │ 4. test-automator: Generate tests   │ │
│ └─────────────────────────────────────┘ │
└─────────────────────────────────────────┘
              ↓
┌─────────────────────────────────────────┐
│ Phase 3: Quality (Parallel)             │
│ ┌───────────┐ ┌───────────┐ ┌─────────┐│
│ │code-      │ │ui-visual- │ │security-││
│ │reviewer   │ │validator  │ │auditor  ││
│ └───────────┘ └───────────┘ └─────────┘│
└─────────────────────────────────────────┘
              ↓
┌─────────────────────────────────────────┐
│ Phase 4: Documentation (Sequential)     │
│ ┌─────────────────────────────────────┐ │
│ │ 6. docs-architect: Generate docs    │ │
│ └─────────────────────────────────────┘ │
└─────────────────────────────────────────┘
              ↓
┌─────────────────────────────────────────┐
│ Phase 5: Integration (Manual)           │
│ - Update exports                        │
│ - Add Storybook stories                 │
│ - Update README                         │
└─────────────────────────────────────────┘
              ↓
┌─────────────────────────────────────────┐
│ Phase 6: Finalization (Automated)       │
│ - /commit (automated validation)        │
│ - Post-commit state update              │
└─────────────────────────────────────────┘
```

---

## Quality Assurance Workflow

### Pre-Commit Review (Parallel)

Before committing any significant code changes:

```typescript
// Launch all reviewers in parallel
Task(
  subagent_type: "code-documentation:code-reviewer",
  prompt: "Review [files]: code quality, performance, security, best practices"
)

Task(
  subagent_type: "comprehensive-review:architect-review",
  prompt: "Review architecture: design patterns, scalability, maintainability"
)

Task(
  subagent_type: "comprehensive-review:security-auditor",
  prompt: "Security audit: vulnerabilities, sensitive data, attack vectors"
)
```

### Pull Request Review (Comprehensive)

For pull requests requiring thorough review:

```typescript
// Stage 1: Parallel Analysis
Task('code-reviewer', 'Comprehensive code review');
Task('architect-review', 'Architecture assessment');
Task('security-auditor', 'Security audit');
Task('performance-engineer', 'Performance analysis');

// Stage 2: Generate review summary
Task('docs-architect', 'Summarize findings and create PR review');
```

---

## Documentation Workflow

### Component Documentation (Sequential)

```typescript
// 1. API Documentation
Task(
  subagent_type: "documentation-generation:api-documenter",
  prompt: "Generate API documentation for [Component]"
)

// 2. Usage Guide
Task(
  subagent_type: "documentation-generation:tutorial-engineer",
  prompt: "Create usage tutorial for [Component]"
)

// 3. Examples
Task(
  subagent_type: "code-documentation:docs-architect",
  prompt: "Generate comprehensive examples for [Component]"
)
```

### Architecture Documentation (Parallel)

```typescript
Task('mermaid-expert', 'Create architecture diagrams');
Task('docs-architect', 'Generate architecture documentation');
Task('reference-builder', 'Create API reference');
```

---

## Context Management

### Token Efficiency Rules

1. **Load plugins only when needed**

   ```bash
   # Don't preload everything
   # Install specific plugins for current task
   /plugin install frontend-mobile-development
   ```

2. **Use progressive disclosure**

   - Skills activate automatically
   - Don't manually load unnecessary context

3. **Leverage session state**

   - Post-commit hooks track state automatically
   - Reference `.claude/session-state.json` for context

4. **Use Serena memories**
   - Read memories before starting work
   - Update memories with new knowledge
   - Never delete memories

### Memory Management

**Before Each Session:**

```typescript
// Check relevant memories
mcp__serena__list_memories();
mcp__serena__read_memory('architecture-v2-correct.md');
mcp__serena__read_memory('codebase_structure.md');
```

**After Significant Work:**

```typescript
// Update memories with new knowledge
mcp__serena__write_memory(
  memory_name: "component-patterns.md",
  content: "Document new patterns discovered during [Component] development"
)
```

---

## Error Handling

### Agent Failures

**If agent fails:**

1. Review agent prompt for clarity
2. Check if agent has necessary context
3. Try breaking task into smaller subtasks
4. Use different agent if available
5. Fall back to manual implementation

**Example Recovery:**

```typescript
// Original (failed)
Task('frontend-developer', 'Implement entire form system');

// Recovery (smaller scope)
Task('frontend-developer', 'Implement Input component only');
// Then:
Task('frontend-developer', 'Implement Form wrapper');
// Then:
Task('frontend-developer', 'Implement validation system');
```

### Quality Gate Failures

**Pre-commit hook blocks commit:**

1. Review errors from hook output
2. Fix issues (TypeScript, ESLint, Prettier)
3. Use agents for complex fixes:
   ```typescript
   Task('code-reviewer', 'Fix TypeScript errors in [files]');
   ```
4. Re-attempt commit

### Integration Issues

**Agent output doesn't integrate:**

1. Review agent deliverable
2. Check compatibility with existing code
3. Use architect-review to reconcile:
   ```typescript
   Task(
     'architect-review',
     'Reconcile [agent output] with [existing code], suggest integration approach'
   );
   ```

---

## Session Continuity

### Starting New Session

**Checklist:**

1. Read session state: `.claude/session-state.json`
2. Check git status
3. Review recent memories
4. Check current phase from ROADMAP.md
5. Review TASKS.md for pending work

**Commands:**

```bash
# Check project state
mcp__serena__get_current_config()

# Read session state
Read(".claude/session-state.json")

# Check git status
git status

# List available memories
mcp__serena__list_memories()
```

### Ending Session

**Checklist:**

1. Commit all work: `/commit`
2. Update session state (automatic via post-commit)
3. Push to remote (triggers checkpoint)
4. Update Serena memory with session learnings

**Commands:**

```bash
# Commit work
/commit

# Push (creates checkpoint automatically)
git push origin develop

# Update memory
mcp__serena__write_memory(
  memory_name: "session-[date].md",
  content: "Session summary and learnings"
)
```

---

## Examples

### Example 1: Create New Button Component

```typescript
// Phase 1: Design
Task(
  subagent_type: "code-review-ai:architect-review",
  description: "Design Button API",
  prompt: `Design Button component API:
  - Required variants: primary, secondary, tertiary, ghost
  - Required sizes: sm, md, lg, xl
  - Features: icons, loading state, full width
  - Accessibility: React Aria integration
  - Reference: UPSTREAM/react/button/ for UntitledUI patterns

  Deliver: TypeScript interface definition, variant specifications, accessibility requirements`
)

// WAIT - Review API design, approve

// Phase 2: Implement
Task(
  subagent_type: "frontend-mobile-development:frontend-developer",
  description: "Implement Button component",
  prompt: `Implement Button component following approved API:
  - File: src/components/base/button/button.tsx
  - Use React Aria for accessibility
  - Use Tailwind CSS for styling (via cx utility)
  - All variants and sizes
  - Loading state with spinner
  - Icon support (before/after)
  - Full TypeScript types
  - JSDoc comments

  Deliver: Complete button.tsx implementation`
)

// WAIT - Component implemented

// Phase 3: Test
Task(
  subagent_type: "unit-testing:test-automator",
  description: "Generate Button tests",
  prompt: `Generate comprehensive test suite for Button:
  - File: src/components/base/button/button.test.tsx
  - Render tests for all variants
  - Interaction tests (click, keyboard)
  - Accessibility tests
  - Loading state tests
  - Icon tests
  - Edge cases

  Deliver: Complete test suite`
)

// WAIT - Tests generated

// Phase 4: Quality Review (Parallel)
Task(
  subagent_type: "code-documentation:code-reviewer",
  description: "Review Button code quality",
  prompt: `Review Button component:
  - Code quality and best practices
  - TypeScript usage
  - Performance considerations
  - Error handling

  Deliver: Review findings and recommendations`
)

Task(
  subagent_type: "accessibility-compliance:ui-visual-validator",
  description: "Validate Button accessibility",
  prompt: `Validate Button accessibility:
  - WCAG 2.1 AA compliance
  - ARIA attributes correctness
  - Keyboard navigation
  - Screen reader compatibility
  - Focus management

  Deliver: Accessibility audit report`
)

// WAIT - Reviews complete

// Phase 5: Documentation
Task(
  subagent_type: "code-documentation:docs-architect",
  description: "Generate Button documentation",
  prompt: `Generate Button documentation:
  - File: src/components/base/button/button.patterns.md
  - Usage patterns with examples
  - All variants showcased
  - Accessibility notes
  - Best practices
  - Common pitfalls

  Deliver: Complete usage documentation`
)

// WAIT - Documentation complete

// Phase 6: Manual Integration
// - Create button.stories.tsx
// - Update src/components/base/index.ts
// - Update src/components/base/button/index.ts
// - Update src/components/README.md

// Phase 7: Commit
// /commit
```

### Example 2: Comprehensive Code Review

```typescript
// Parallel multi-perspective review
Task(
  subagent_type: "code-documentation:code-reviewer",
  description: "Code quality review",
  prompt: "Review all files in src/components/base/button/ for code quality, performance, best practices"
)

Task(
  subagent_type: "code-review-ai:architect-review",
  description: "Architecture review",
  prompt: "Review Button component architecture: API design, patterns, scalability, maintainability"
)

Task(
  subagent_type: "comprehensive-review:security-auditor",
  description: "Security audit",
  prompt: "Security audit Button component: XSS risks, injection vulnerabilities, unsafe practices"
)

Task(
  subagent_type: "accessibility-compliance:ui-visual-validator",
  description: "Accessibility validation",
  prompt: "Validate Button WCAG 2.1 AA compliance: ARIA, keyboard, screen reader, focus"
)

Task(
  subagent_type: "full-stack-orchestration:performance-engineer",
  description: "Performance analysis",
  prompt: "Analyze Button performance: render performance, bundle size, optimization opportunities"
)

// WAIT - All reviews complete
// Analyze findings, address issues
```

### Example 3: Refactoring Workflow

```typescript
// Stage 1: Analysis (Parallel)
Task(
  subagent_type: "code-documentation:code-reviewer",
  description: "Analyze current code",
  prompt: "Analyze [component] for refactoring opportunities: code smells, duplication, complexity"
)

Task(
  subagent_type: "code-review-ai:architect-review",
  description: "Analyze architecture",
  prompt: "Analyze [component] architecture: pattern violations, coupling issues, design improvements"
)

// WAIT - Analysis complete

// Stage 2: Planning (Sequential)
Task(
  subagent_type: "code-review-ai:architect-review",
  description: "Create refactoring plan",
  prompt: "Based on analysis findings, create detailed refactoring plan: steps, risks, rollback strategy"
)

// WAIT - Plan approved

// Stage 3: Implementation (Sequential)
Task(
  subagent_type: "code-refactoring:legacy-modernizer",
  description: "Execute refactoring",
  prompt: "Execute refactoring plan for [component]: implement changes, maintain backward compatibility"
)

// WAIT - Refactoring complete

// Stage 4: Validation (Parallel)
Task("test-automator", "Update tests for refactored code")
Task("code-reviewer", "Review refactored implementation")
Task("performance-engineer", "Compare performance before/after")

// WAIT - Validation complete
```

---

## Protocol Compliance

### Pre-Task Checklist

Before starting any significant task:

- [ ] Identified appropriate agents for task
- [ ] Determined orchestration pattern (sequential/parallel/hybrid)
- [ ] Checked session state and git status
- [ ] Reviewed relevant Serena memories
- [ ] Confirmed task aligns with current phase (ROADMAP.md)
- [ ] Planned quality assurance approach

### Post-Task Checklist

After completing task:

- [ ] All agent deliverables received
- [ ] Quality review completed
- [ ] Code integrated and tested
- [ ] Documentation updated
- [ ] Quality gates passed (TypeScript, ESLint, Prettier)
- [ ] Changes committed via `/commit`
- [ ] Session state updated (automatic)
- [ ] Serena memory updated if needed

### Quality Standards

Every agent-generated deliverable must:

- [ ] Meet TypeScript strict mode requirements
- [ ] Pass ESLint validation
- [ ] Be formatted with Prettier
- [ ] Include comprehensive documentation
- [ ] Meet WCAG 2.1 AA accessibility standards
- [ ] Follow project patterns and conventions
- [ ] Include tests (when applicable)

---

## Conclusion

This protocol ensures:

1. **Consistent Quality** - All work meets project standards
2. **Efficient Workflows** - Right agents, right orchestration
3. **Context Preservation** - Knowledge persists across sessions
4. **Automation Integration** - Agent work flows through our automation
5. **Scalability** - Protocol scales with project complexity

**Always refer to this protocol when:**

- Starting a new component
- Conducting code review
- Generating documentation
- Planning complex workflows
- Recovering from errors
- Transitioning between sessions

---

## References

- [wshobson-agents-framework.md](./wshobson-agents-framework.md) - Complete framework reference
- [agents.md](./agents.md) - Agent operation mechanics
- [COMPONENT-DEVELOPMENT.md](./COMPONENT-DEVELOPMENT.md) - Component development guide
- [TDD-METHODOLOGY.md](./TDD-METHODOLOGY.md) - Test-driven development
- [AUTOMATION.md](../.claude/AUTOMATION.md) - Automation infrastructure
- [SESSION-STATE.md](./SESSION-STATE.md) - Session state management
