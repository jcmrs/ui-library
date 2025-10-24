# wshobson Agents Framework - Complete Reference Manual

**Version:** 1.2.0
**Last Updated:** 2025-01-23
**Author:** Seth Hobson (@wshobson)

This document serves as the definitive manual for using the wshobson agents framework within Claude Code. It is designed for AI-First consumption - enabling any new Claude Code instance to fully understand and utilize the complete framework.

---

## Table of Contents

1. [Framework Overview](#framework-overview)
2. [Core Concepts](#core-concepts)
3. [Installation & Setup](#installation--setup)
4. [Agent Operation Mechanics](#agent-operation-mechanics) ⭐ NEW
   - [How Agents Actually Work](#how-agents-actually-work)
   - [Agent Invocation Syntax](#agent-invocation-syntax)
   - [Sequential Orchestration Mechanics](#sequential-orchestration-mechanics)
   - [Parallel Orchestration Mechanics](#parallel-orchestration-mechanics)
   - [Your First Agent Workflow](#your-first-agent-workflow)
   - [Troubleshooting Agent Orchestration](#troubleshooting-agent-orchestration)
5. [Architecture Principles](#architecture-principles)
6. [Complete Plugin Catalog](#complete-plugin-catalog)
7. [All 85 Agents Reference](#all-85-agents-reference)
8. [All 47 Skills Reference](#all-47-skills-reference)
9. [All 44+ Commands Reference](#all-44-commands-reference)
10. [Multi-Agent Orchestration Patterns](#multi-agent-orchestration-patterns)
11. [Practical Usage Examples](#practical-usage-examples)
12. [Model Configuration Strategy](#model-configuration-strategy)
13. [Best Practices & Workflows](#best-practices--workflows)
14. [Quick Reference](#quick-reference)

---

## Framework Overview

### What Is This Framework?

The **wshobson agents framework** is a comprehensive production-ready system providing:

- **63 focused, single-purpose plugins** optimized for minimal token usage and composability
- **85 specialized AI agents** - domain experts across architecture, languages, infrastructure, quality, data/AI, documentation, business, and SEO
- **47 agent skills** - modular knowledge packages with progressive disclosure for specialized expertise
- **44 development tools** - optimized utilities including scaffolding, security scanning, test automation, and infrastructure setup
- **15 workflow orchestrators** - multi-agent coordination systems for complex operations

### Why Does It Exist?

**Problem:** Claude Code users need specialized expertise across many domains, but loading all knowledge into every conversation wastes tokens and degrades performance.

**Solution:** Granular plugin architecture where you install only what you need. Each plugin loads specific agents, commands, and skills - nothing more.

### Key Differentiators

1. **Granular Design** - Average 3.4 components per plugin (vs monolithic alternatives)
2. **100% Agent Coverage** - Every plugin includes at least one specialized agent
3. **Progressive Disclosure** - Skills load knowledge only when activated
4. **Hybrid Model Strategy** - 47 Haiku agents (fast execution) + 97 Sonnet agents (complex reasoning)
5. **Production-Ready** - Battle-tested workflows, not experimental tools

---

## Core Concepts

### Plugins

**What:** Self-contained packages grouping related agents, commands, and skills.

**Structure:**

```
plugins/{plugin-name}/
├── agents/               # Specialized agents (optional)
├── commands/             # Tools and workflows (optional)
└── skills/               # Knowledge packages (optional)
```

**Requirements:** At least one agent OR one command

**Installation:**

```bash
/plugin install plugin-name
```

### Agents

**What:** Specialized AI personas with deep domain expertise.

**Types:**

- **Architecture Agents:** backend-architect, cloud-architect, database-architect
- **Language Agents:** python-pro, typescript-pro, rust-pro
- **Quality Agents:** code-reviewer, security-auditor, test-automator
- **Operations Agents:** devops-troubleshooter, incident-responder, observability-engineer

**Invocation:**

- Natural language: "Use backend-architect to design the authentication API"
- Via commands: `/backend-development:feature-development`

**Model Assignment:**

- 47 Haiku agents - fast execution tasks
- 97 Sonnet agents - complex reasoning

### Skills

**What:** Modular knowledge packages following Anthropic's Agent Skills Specification.

**Progressive Disclosure:**

1. **Metadata** (Frontmatter) - Name and activation criteria (always loaded)
2. **Instructions** - Core guidance (loaded when activated)
3. **Resources** - Examples and templates (loaded on demand)

**Activation:** Automatic when Claude detects matching patterns in requests

**Example:**

```
User: "Set up Kubernetes deployment with Helm"
→ Activates: helm-chart-scaffolding + k8s-manifest-generator skills
```

### Commands

**What:** Slash commands for direct invocation of tools and workflows.

**Format:**

```bash
/plugin-name:command-name [arguments]
```

**Benefits:**

- Direct invocation (no natural language needed)
- Structured arguments for precise control
- Composable for complex workflows
- Discoverable via `/plugin` command

---

## Installation & Setup

### Step 1: Add Marketplace

Add the marketplace to Claude Code (one-time setup):

```bash
/plugin marketplace add wshobson/agents
```

**Result:** Makes all 63 plugins available for installation, but **does not load any agents or tools** into context.

### Step 2: Browse Plugins

View available plugins:

```bash
/plugin
```

### Step 3: Install What You Need

Install specific plugins based on your work:

```bash
# Essential development
/plugin install code-documentation
/plugin install debugging-toolkit
/plugin install git-pr-workflows

# Backend development
/plugin install backend-development
/plugin install python-development
/plugin install database-design

# Frontend/Mobile
/plugin install frontend-mobile-development
/plugin install multi-platform-apps

# Testing & Quality
/plugin install unit-testing
/plugin install code-review-ai
/plugin install tdd-workflows

# Infrastructure
/plugin install cloud-infrastructure
/plugin install kubernetes-operations
/plugin install cicd-automation

# Security
/plugin install security-scanning
/plugin install security-compliance

# Full-stack workflows
/plugin install full-stack-orchestration
```

**Each installed plugin loads ONLY its specific agents, commands, and skills.**

---

## Agent Operation Mechanics

This section explains the concrete mechanics of HOW agents work, HOW to invoke them, and HOW orchestration functions in practice.

### How Agents Actually Work

**Technical Architecture:**

Agents in the wshobson framework are **specialized system prompts** that get loaded into Claude Code's context when their parent plugin is installed. Each agent is:

1. **A Markdown File** - Located in `plugins/{plugin-name}/agents/{agent-name}.md`
2. **A System Prompt** - Contains specialized instructions, expertise, and patterns
3. **Model-Specific** - Configured to run on either Haiku (fast) or Sonnet (reasoning)
4. **Context-Aware** - Has access to your codebase and previous conversation

**What Happens When You Install a Plugin:**

```
/plugin install python-development
  ↓
Loads into context:
  - agents/python-pro.md
  - agents/django-pro.md
  - agents/fastapi-pro.md
  - commands/python-scaffold.md
  - skills/async-python-patterns/SKILL.md (metadata only)
  - skills/python-testing-patterns/SKILL.md (metadata only)
  - skills/python-packaging/SKILL.md (metadata only)
  - skills/python-performance-optimization/SKILL.md (metadata only)
  - skills/uv-package-manager/SKILL.md (metadata only)
```

**Agent vs Claude Code:**

- **Claude Code (You)** - The main conversation interface with general capabilities
- **Agents** - Specialized personas Claude Code can "become" by loading their system prompts
- **Activation** - When you invoke an agent, Claude Code adopts that agent's expertise and instructions

Think of it as Claude Code temporarily specializing by loading expert knowledge into the current context.

### Agent Invocation Syntax

There are **three ways** to invoke agents:

#### Method 1: Natural Language (Implicit Invocation)

Claude Code automatically selects and activates the appropriate agent based on your request:

```
"Use backend-architect to design a RESTful API for user authentication with OAuth2"
```

**What Happens:**

1. Claude Code parses your request
2. Identifies `backend-architect` agent is needed (from backend-development plugin)
3. Loads backend-architect's system prompt into context
4. Responds with backend-architect's specialized expertise
5. Returns control to main Claude Code instance

**Visibility:** You see the agent's output directly in the conversation

#### Method 2: Slash Commands (Explicit Invocation)

Commands explicitly invoke specific workflows that coordinate one or more agents:

```bash
/backend-development:feature-development user authentication with OAuth2
```

**What Happens:**

1. Command is parsed: plugin=`backend-development`, command=`feature-development`
2. Loads `plugins/backend-development/commands/feature-development.md`
3. Command contains orchestration logic defining which agents to invoke
4. Agents are activated in sequence or parallel per command logic
5. Results are aggregated and returned

**Visibility:** Each agent's contribution may be shown as a distinct step

#### Method 3: Task Tool (Sub-Agent Invocation)

For complex orchestration, Claude Code uses the Task tool to invoke agents as separate execution contexts:

```
Claude Code: I'll use the Task tool to invoke backend-architect
<Task subagent_type="backend-development:backend-architect"
      prompt="Design RESTful API for user authentication with OAuth2, PostgreSQL, JWT tokens" />
```

**What Happens:**

1. Task tool creates new execution context
2. Specified agent is loaded with provided prompt
3. Agent executes autonomously in isolation
4. Returns complete result to main Claude Code instance
5. Main Claude Code integrates result into conversation

**Visibility:** You see both Claude Code's coordination and the agent's output

### Sequential Orchestration Mechanics

Sequential orchestration means **one agent completes before the next begins**, with each agent building on previous outputs.

#### How Sequential Orchestration Works

**Method 1: Command-Driven Sequential Flow**

When you invoke a command with built-in orchestration:

```bash
/backend-development:feature-development payment processing API
```

**Internal Execution Flow:**

```
Step 1: backend-architect (Sonnet) activated
  Input: "payment processing API"
  Output: API design document with endpoints, schemas, security
  Duration: ~30 seconds

  ↓ (backend-architect output passed as input)

Step 2: database-architect (Sonnet) activated
  Input: API design + "design database schema"
  Output: PostgreSQL schema with tables, indexes, constraints
  Duration: ~25 seconds

  ↓ (combined outputs passed as input)

Step 3: fastapi-pro (Sonnet) activated
  Input: API design + schema + "implement FastAPI endpoints"
  Output: Complete Python code for API endpoints
  Duration: ~40 seconds

  ↓ (all previous outputs + code passed as input)

Step 4: test-automator (Haiku) activated
  Input: API code + "generate comprehensive tests"
  Output: Pytest test suite with unit and integration tests
  Duration: ~20 seconds

  ↓ (all outputs passed as input)

Step 5: code-reviewer (Sonnet) activated
  Input: Complete implementation + "review for production readiness"
  Output: Review feedback, security assessment, recommendations
  Duration: ~30 seconds
```

**Total Duration:** ~145 seconds (agents run sequentially, not parallel)

**What You See:**

```
Working on payment processing API...

✓ API architecture designed (5 endpoints, OAuth2 security)
✓ Database schema created (4 tables, optimized indexes)
✓ FastAPI endpoints implemented (async patterns, Pydantic validation)
✓ Test suite generated (47 tests, 95% coverage)
✓ Code review completed (2 security improvements suggested)

Complete implementation ready at:
- src/api/payments.py
- src/models/payment.py
- tests/test_payments.py
- alembic/versions/001_payment_schema.py
```

**Method 2: Natural Language Sequential Coordination**

Claude Code can coordinate multiple agents sequentially based on natural language:

```
"Design, implement, and test a password reset feature with email verification"
```

**Execution:**

```
Claude Code coordinates:

1. Invokes backend-architect
   → Designs password reset flow, email verification logic

2. Waits for completion, then invokes database-architect
   → Designs password_reset_tokens table

3. Waits for completion, then invokes fastapi-pro
   → Implements /reset-password and /verify-reset endpoints

4. Waits for completion, then invokes test-automator
   → Generates tests for reset flow, token expiration, edge cases

5. Aggregates all outputs
   → Returns complete implementation
```

**Method 3: Manual Sequential Invocation**

You can manually invoke agents sequentially:

```
You: "Use backend-architect to design a notification system"
Claude: [backend-architect designs system]

You: "Now use database-architect to design the schema for this notification system"
Claude: [database-architect designs schema based on previous design]

You: "Now implement this with fastapi-pro"
Claude: [fastapi-pro implements based on design + schema]
```

**Key Characteristics:**

- Each step builds on previous outputs
- Cannot proceed to next step until current completes
- Context accumulates across steps
- Later agents see all previous agent outputs
- More predictable, easier to debug
- Takes longer (sum of all agent durations)

#### Sequential Orchestration Example: Full Implementation

**Command:**

```bash
/full-stack-orchestration:full-stack-feature "user profile dashboard with avatar upload"
```

**Sequential Flow:**

```
[Step 1] backend-architect (Sonnet) - 30s
  ├─ Designs REST API: GET /profile, PUT /profile, POST /avatar
  ├─ Defines response schemas
  └─ Specifies authentication requirements

  ↓ Output: API specification (JSON)

[Step 2] database-architect (Sonnet) - 25s
  ├─ Designs users table updates
  ├─ Designs user_avatars table
  └─ Plans S3 storage strategy

  ↓ Output: Schema DDL + migration plan

[Step 3] backend-implementation (Haiku) - 35s
  ├─ Implements FastAPI endpoints
  ├─ Adds S3 upload logic
  └─ Implements validation

  ↓ Output: Python source code

[Step 4] frontend-developer (Sonnet) - 40s
  ├─ Creates ProfileDashboard component
  ├─ Creates AvatarUpload component
  ├─ Implements API integration
  └─ Adds responsive styling

  ↓ Output: React components (TypeScript)

[Step 5] test-automator (Haiku) - 25s
  ├─ Backend tests (pytest)
  ├─ Frontend tests (Jest + React Testing Library)
  └─ E2E tests (Playwright)

  ↓ Output: Complete test suites

[Step 6] security-auditor (Sonnet) - 20s
  ├─ Reviews authentication
  ├─ Validates file upload security
  ├─ Checks CORS configuration
  └─ Verifies S3 bucket policies

  ↓ Output: Security review + recommendations

[Step 7] deployment-engineer (Haiku) - 15s
  ├─ CI/CD pipeline configuration
  ├─ Docker configurations
  └─ Environment variables

  ↓ Output: Deployment artifacts

Total Duration: ~190 seconds (~3 minutes)
```

**Final Output Structure:**

```
backend/
├── api/profile.py              (from backend-implementation)
├── models/user.py              (from backend-implementation)
├── services/avatar_service.py  (from backend-implementation)
└── tests/test_profile.py       (from test-automator)

frontend/
├── components/ProfileDashboard.tsx  (from frontend-developer)
├── components/AvatarUpload.tsx      (from frontend-developer)
└── __tests__/ProfileDashboard.test.tsx  (from test-automator)

infrastructure/
├── .github/workflows/deploy.yml     (from deployment-engineer)
├── docker-compose.yml               (from deployment-engineer)
└── terraform/s3-buckets.tf          (from deployment-engineer)

docs/
├── api-spec.json                    (from backend-architect)
├── schema.sql                       (from database-architect)
└── security-review.md               (from security-auditor)
```

### Parallel Orchestration Mechanics

Parallel orchestration means **multiple agents execute simultaneously**, ideal when tasks are independent and can be performed concurrently.

#### How Parallel Orchestration Works

**Key Difference from Sequential:**

- Agents start at the same time
- Do NOT wait for each other
- Outputs are merged/aggregated afterward
- Dramatically faster for independent tasks
- Requires careful coordination to merge results

**Method 1: Command-Driven Parallel Execution**

Some commands internally coordinate parallel agent execution:

```bash
/comprehensive-review:full-review
```

**Internal Parallel Execution:**

```
Command coordinates 3 agents IN PARALLEL:

┌─────────────────────────────────────────┐
│                                         │
│  [Agent 1] code-reviewer (Sonnet)     │─┐
│  Focus: Code quality, patterns         │ │
│  Duration: ~35 seconds                  │ │
│                                         │ │
├─────────────────────────────────────────┤ │
│                                         │ ├─→ Start simultaneously
│  [Agent 2] architect-review (Sonnet)   │ │
│  Focus: Architecture, design            │ │
│  Duration: ~40 seconds                  │ │
│                                         │ │
├─────────────────────────────────────────┤ │
│                                         │ │
│  [Agent 3] security-auditor (Sonnet)   │─┘
│  Focus: Vulnerabilities, OWASP         │
│  Duration: ~30 seconds                  │
│                                         │
└─────────────────────────────────────────┘

Wait for ALL to complete (total: ~40s, not 105s)

Then MERGE outputs:
  ├─ Code quality issues (from code-reviewer)
  ├─ Architecture concerns (from architect-review)
  └─ Security vulnerabilities (from security-auditor)

Present unified review report
```

**Time Savings:** 40 seconds (parallel) vs 105 seconds (sequential) = **62% faster**

**Method 2: Claude Code Parallel Coordination**

Claude Code can invoke multiple agents in parallel using the Task tool:

```
User: "Review this codebase for code quality, architecture, and security - use parallel agents"

Claude Code coordinates:

  <Task subagent_type="code-review-ai:code-reviewer" prompt="Review code quality..." />
  <Task subagent_type="code-review-ai:architect-review" prompt="Review architecture..." />
  <Task subagent_type="security-scanning:security-auditor" prompt="Security audit..." />

  [All three Task calls in single message = parallel execution]

  Waits for all three to complete...

  Merges results into unified review
```

**What You See:**

```
Running comprehensive review with 3 agents in parallel...

⏳ code-reviewer analyzing code quality...
⏳ architect-review analyzing architecture...
⏳ security-auditor performing security audit...

✓ code-reviewer completed (35s)
✓ security-auditor completed (30s)
✓ architect-review completed (40s)

Merging results...

COMPREHENSIVE REVIEW RESULTS:

Code Quality (code-reviewer):
  - 15 issues found
  - Key patterns to improve...

Architecture (architect-review):
  - Service boundaries need clarification
  - Recommendations...

Security (security-auditor):
  - 3 high-severity issues
  - OWASP Top 10 assessment...
```

**Method 3: Multi-Platform Parallel Development**

Building for multiple platforms simultaneously:

```bash
/multi-platform-apps:multi-platform "settings screen with theme toggle"
```

**Parallel Execution:**

```
┌──────────────────────────────────────┐
│  [Agent 1] frontend-developer        │─┐
│  Platform: Web (React)               │ │
│  Deliverable: SettingsPage.tsx       │ │
│  Duration: ~45 seconds               │ │
├──────────────────────────────────────┤ │
│  [Agent 2] mobile-developer          │ ├─→ Execute in parallel
│  Platform: React Native              │ │
│  Deliverable: SettingsScreen.tsx     │ │
│  Duration: ~50 seconds               │ │
├──────────────────────────────────────┤ │
│  [Agent 3] ios-developer             │ │
│  Platform: iOS (Swift)               │ │
│  Deliverable: SettingsView.swift     │─┘
│  Duration: ~40 seconds               │
└──────────────────────────────────────┘

Total time: ~50 seconds (longest agent)
Sequential would take: ~135 seconds
Speedup: 2.7x faster
```

**Shared Context for Consistency:**

All agents receive:

- Design system specifications
- Color palette and typography
- API contract definitions
- Accessibility requirements

**Output Coordination:**

```
Platforms ready:

✓ Web (React + Tailwind CSS)
  - components/SettingsPage.tsx
  - Dark/light theme toggle
  - Responsive layout

✓ Mobile (React Native)
  - screens/SettingsScreen.tsx
  - Native theme persistence
  - Platform-specific adaptations

✓ iOS (Swift + SwiftUI)
  - Views/SettingsView.swift
  - Native iOS design patterns
  - UserDefaults integration

All implementations follow consistent design system
API integration uses shared contract
```

#### When to Use Parallel vs Sequential

**Use Parallel Orchestration When:**

- ✓ Tasks are completely independent
- ✓ Speed is critical
- ✓ Multiple platforms/formats needed
- ✓ Agents don't need each other's outputs
- ✓ Results can be aggregated afterward

**Examples:**

- Multi-platform app development (web + mobile + iOS)
- Comprehensive code review (quality + architecture + security)
- Documentation generation (API docs + tutorials + diagrams)
- Multi-language implementation (Python + TypeScript + Go)

**Use Sequential Orchestration When:**

- ✓ Each step depends on previous outputs
- ✓ Building something with clear stages
- ✓ Later stages need context from earlier stages
- ✓ Debugging is important (easier to trace)

**Examples:**

- Feature development (design → implement → test → deploy)
- TDD workflow (write test → implement → refactor)
- Migration (analyze → plan → execute → verify)
- Incident response (diagnose → fix → verify → prevent)

#### Hybrid: Sequential + Parallel Combined

Many workflows use BOTH:

```bash
/full-stack-orchestration:full-stack-feature "user authentication"
```

**Hybrid Flow:**

```
[Sequential Stage 1] Architecture & Design
  ├─ backend-architect: API design
  └─ database-architect: Schema design
  Duration: 55s sequential

  ↓ Designs complete, now implement in parallel ↓

[Parallel Stage 2] Implementation
  ┌─ backend-implementation: FastAPI code (40s)
  ├─ frontend-developer: React components (45s)
  └─ mobile-developer: React Native screens (50s)
  Duration: 50s parallel (longest agent)

  ↓ Implementations complete, now test in parallel ↓

[Parallel Stage 3] Testing
  ┌─ test-automator: Backend tests (25s)
  ├─ test-automator: Frontend tests (30s)
  └─ test-automator: Mobile tests (28s)
  Duration: 30s parallel

  ↓ Tests complete, final review ↓

[Sequential Stage 4] Review & Deploy
  ├─ security-auditor: Security review
  ├─ code-reviewer: Code review
  └─ deployment-engineer: CI/CD setup
  Duration: 55s sequential
```

**Total Time:** 55s + 50s + 30s + 55s = **190 seconds (~3 min)**
**If Fully Sequential:** 55s + 135s + 83s + 55s = **328 seconds (~5.5 min)**
**Time Saved:** 42% faster with hybrid approach

### Your First Agent Workflow

Let's walk through a complete example from installation to successful orchestration.

#### Scenario: Build a FastAPI Microservice with Tests

**Goal:** Create a production-ready FastAPI service for managing TODO items with PostgreSQL, comprehensive tests, and documentation.

#### Step 1: Install Required Plugins

```bash
# Add marketplace (if not already added)
/plugin marketplace add wshobson/agents

# Install necessary plugins
/plugin install python-development
/plugin install backend-development
/plugin install unit-testing
/plugin install code-documentation
```

**Expected Output:**

```
✓ Marketplace added: wshobson/agents (63 plugins available)
✓ Installed python-development (3 agents, 1 command, 5 skills)
✓ Installed backend-development (3 agents, 1 command, 3 skills)
✓ Installed unit-testing (2 agents, 1 command)
✓ Installed code-documentation (3 agents, 2 commands)
```

#### Step 2: Invoke Sequential Workflow

**Natural Language Approach:**

```
"Create a FastAPI microservice for TODO management with PostgreSQL,
CRUD operations, async patterns, comprehensive pytest tests, and API documentation"
```

**What Happens Behind the Scenes:**

```
Claude Code analyzes request and coordinates:

[Step 1] Activates: python-pro + fastapi-pro agents
         Skills: fastapi-templates, async-python-patterns

[Step 2] Creates project structure:
  todo_service/
  ├── app/
  │   ├── __init__.py
  │   ├── main.py
  │   ├── api/
  │   │   ├── __init__.py
  │   │   └── todos.py
  │   ├── models/
  │   │   ├── __init__.py
  │   │   └── todo.py
  │   └── database.py
  ├── tests/
  │   ├── __init__.py
  │   └── test_todos.py
  ├── requirements.txt
  ├── Dockerfile
  └── README.md

[Step 3] Implements FastAPI endpoints:
  - GET /todos (list with pagination)
  - POST /todos (create)
  - GET /todos/{id} (retrieve)
  - PUT /todos/{id} (update)
  - DELETE /todos/{id} (delete)

[Step 4] Invokes test-automator agent
         Generates pytest suite with:
           - 25 unit tests
           - Integration tests with test database
           - Fixtures for common scenarios
           - 93% code coverage

[Step 5] Invokes api-documenter agent
         Generates OpenAPI/Swagger documentation
```

**Expected Output:**

```
✓ Project structure created (FastAPI with async patterns)
✓ PostgreSQL models defined with SQLAlchemy 2.0
✓ CRUD operations implemented (5 endpoints)
✓ Async patterns configured (connection pooling)
✓ Test suite generated (25 tests, 93% coverage)
✓ API documentation created (OpenAPI 3.1 spec)
✓ Docker configuration added

Complete microservice ready!

Run locally:
  cd todo_service
  docker-compose up -d  # Starts PostgreSQL
  pip install -r requirements.txt
  uvicorn app.main:app --reload

Access docs at: http://localhost:8000/docs
Run tests: pytest tests/ -v
```

#### Step 3: Verify the Implementation

**Run Type Check and Tests:**

```bash
# Type checking
mypy app/

# Run tests
pytest tests/ -v --cov=app
```

**Expected Test Output:**

```
tests/test_todos.py::test_create_todo PASSED
tests/test_todos.py::test_get_todo PASSED
tests/test_todos.py::test_list_todos PASSED
tests/test_todos.py::test_update_todo PASSED
tests/test_todos.py::test_delete_todo PASSED
tests/test_todos.py::test_pagination PASSED
...

---------- coverage: 93% -----------
```

#### Step 4: Request Security Review

```bash
/security-scanning:security-sast
```

**What Happens:**

1. Invokes `security-auditor` agent
2. Performs static analysis
3. Checks OWASP Top 10 vulnerabilities
4. Reviews dependency security

**Expected Output:**

```
SECURITY AUDIT COMPLETE

✓ No SQL injection vulnerabilities (using SQLAlchemy ORM)
✓ No hardcoded secrets
✓ CORS properly configured
⚠ Recommendation: Add rate limiting middleware
⚠ Recommendation: Implement request validation with Pydantic

Dependencies:
  ✓ fastapi==0.104.1 (no known vulnerabilities)
  ✓ sqlalchemy==2.0.23 (no known vulnerabilities)
  ⚠ uvicorn==0.24.0 (update to 0.24.1 recommended)
```

#### Step 5: Generate Comprehensive Documentation

```bash
/code-documentation:doc-generate "complete API and architecture documentation"
```

**What Happens:**

1. Invokes `docs-architect` agent
2. Analyzes codebase structure
3. Generates documentation

**Expected Output:**

```
Documentation generated:

docs/
├── API.md                    # Complete API reference
├── ARCHITECTURE.md           # System design and patterns
├── SETUP.md                  # Development setup guide
├── TESTING.md               # Testing strategy
└── DEPLOYMENT.md            # Deployment instructions

✓ 5 documentation files created
✓ Includes code examples and diagrams
✓ API endpoints fully documented
✓ Architecture decisions explained
```

#### Complete First Workflow Summary

**What You Accomplished:**

- ✓ Installed 4 plugins with 11 agents and 9 skills
- ✓ Built complete FastAPI microservice
- ✓ Generated 25 tests with 93% coverage
- ✓ Performed security audit
- ✓ Created comprehensive documentation

**Agents Automatically Invoked:**

1. `python-pro` - Python project structure
2. `fastapi-pro` - FastAPI implementation
3. `test-automator` - Test generation
4. `api-documenter` - API documentation
5. `security-auditor` - Security review
6. `docs-architect` - Complete documentation

**Skills Automatically Activated:**

- `fastapi-templates`
- `async-python-patterns`
- `python-testing-patterns`

**Total Time:** ~4 minutes for complete production-ready microservice

### Troubleshooting Agent Orchestration

Common issues and how to resolve them.

#### Issue 1: Agent Not Activating

**Symptom:** Request doesn't invoke expected agent

**Example:**

```
You: "Create API endpoints"
Claude: [Generic response without specialized agent]
```

**Solutions:**

**A) Be More Specific About Agent:**

```
"Use backend-architect to design RESTful API endpoints for user management"
```

**B) Use Explicit Command:**

```bash
/backend-development:feature-development user management API
```

**C) Check Plugin Installation:**

```bash
/plugin  # Lists installed plugins
```

If not installed:

```bash
/plugin install backend-development
```

#### Issue 2: Wrong Agent Activated

**Symptom:** Different agent than expected responds

**Example:**

```
You: "Design database schema"
Expected: database-architect
Actual: backend-architect (more general)
```

**Solutions:**

**A) Explicitly Name the Agent:**

```
"Use database-architect to design a PostgreSQL schema for e-commerce orders"
```

**B) Use Specific Plugin Command:**

```bash
/database-design:schema-design e-commerce orders
```

#### Issue 3: Orchestration Fails Mid-Flow

**Symptom:** Sequential workflow stops after one agent

**Example:**

```
/full-stack-orchestration:full-stack-feature "user profile"

✓ Backend API designed
✗ Workflow stopped (frontend not implemented)
```

**Solutions:**

**A) Check Error Messages:**

- Look for dependency errors
- Check for missing files
- Review logs for failures

**B) Run Steps Manually:**

```
"Use backend-architect to design user profile API"
[Wait for completion]

"Now use frontend-developer to implement the UI for this API"
[Wait for completion]

"Now use test-automator to create tests"
```

**C) Simplify the Request:**

- Break into smaller pieces
- Complete one stage fully before next
- Verify outputs at each step

#### Issue 4: Parallel Agents Produce Conflicts

**Symptom:** Parallel agents create incompatible outputs

**Example:**

```
Multi-platform development produced:
  - Web: Uses REST API
  - Mobile: Uses GraphQL API
  ✗ Mismatch in API contract
```

**Solutions:**

**A) Provide Shared Context First:**

```
Step 1: "Use backend-architect to design unified API contract for multi-platform app"
Step 2: [After contract is ready] "Now build web, mobile, and iOS implementations in parallel using this contract"
```

**B) Use Sequential for Critical Coordination:**

```
Sequential: Design API contract
Parallel: Implement platforms (all use same contract)
Sequential: Integration testing
```

**C) Specify Consistency Requirements:**

```
"Build multi-platform app ensuring all platforms use the same REST API contract"
```

#### Issue 5: Skill Not Activating

**Symptom:** Expected skill knowledge not appearing

**Example:**

```
You: "Create Kubernetes deployment"
Expected: k8s-manifest-generator skill
Actual: Generic Kubernetes knowledge
```

**Solutions:**

**A) Use Activation Keywords:**

```
"Create Kubernetes Deployment manifest with Service and ConfigMap"
(Keywords: "Kubernetes", "Deployment", "manifest" trigger skill)
```

**B) Install Plugin with Skills:**

```bash
/plugin install kubernetes-operations  # Contains 4 K8s skills
```

**C) Be Specific About Patterns:**

```
"Generate production-ready Kubernetes manifests following best practices"
(Phrase "production-ready" and "best practices" signal skill activation)
```

#### Issue 6: Agent Output Incomplete

**Symptom:** Agent provides partial implementation

**Example:**

```
✓ FastAPI endpoints created
✗ No tests generated
✗ No error handling
✗ No documentation
```

**Solutions:**

**A) Request Complete Implementation:**

```
"Create COMPLETE FastAPI microservice including:
- All CRUD endpoints
- Error handling middleware
- Input validation with Pydantic
- Comprehensive pytest tests
- OpenAPI documentation
- Docker configuration"
```

**B) Follow Up with Specific Agents:**

```
First: "Use fastapi-pro to implement user API endpoints"
Then: "Use test-automator to generate tests for these endpoints"
Then: "Use api-documenter to create OpenAPI documentation"
```

**C) Use Orchestration Command:**

```bash
/backend-development:feature-development "complete user API with tests and docs"
```

#### Issue 7: Token Limit Exceeded

**Symptom:** Agent fails due to context window limits

**Solutions:**

**A) Break into Smaller Pieces:**

```
Instead of: "Build entire e-commerce platform"
Use: "Build product catalog service"
Then: "Build shopping cart service"
Then: "Build order processing service"
```

**B) Use Progressive Implementation:**

```
Phase 1: Core models and database
Phase 2: API endpoints
Phase 3: Tests and documentation
```

**C) Install Only Needed Plugins:**

```bash
# Don't install everything at once
/plugin install backend-development  # For current work
# Add more plugins as needed later
```

#### Issue 8: Debugging Agent Behavior

**How to Understand What's Happening:**

**A) Ask for Explanation:**

```
"Explain which agents you invoked and why"
```

**B) Request Verbose Output:**

```
"Show me which agents you're using at each step as you build this feature"
```

**C) Check Installed Plugins and Agents:**

```bash
/plugin  # List installed plugins and their agents
```

**D) Review Plugin Documentation:**

```
"What agents are available in the backend-development plugin?"
"What does the backend-architect agent specialize in?"
```

### Agent Orchestration Decision Tree

Use this to decide HOW to invoke agents:

```
START: Do you know which specific agent you need?
  │
  ├─ YES: Do you need just one agent?
  │   │
  │   ├─ YES → Use natural language:
  │   │        "Use {agent-name} to {task}"
  │   │
  │   └─ NO: Do tasks depend on each other?
  │       │
  │       ├─ YES → Use SEQUENTIAL:
  │       │        Command or step-by-step natural language
  │       │
  │       └─ NO → Use PARALLEL:
  │                Command or explicit "use agents in parallel"
  │
  └─ NO: Is this a well-defined workflow?
      │
      ├─ YES → Use COMMAND:
      │        /plugin-name:command-name
      │
      └─ NO → Use NATURAL LANGUAGE:
               Describe what you want, let Claude Code choose agents
```

---

## Architecture Principles

### Single Responsibility

- Each plugin does **one thing well** (Unix philosophy)
- Clear, focused purposes (describable in 5-10 words)
- Average plugin size: **3.4 components**
- Zero bloated plugins

### Composability Over Bundling

- Mix and match plugins for complex workflows
- Workflow orchestrators compose focused plugins
- No forced feature bundling
- Clear boundaries between plugins

### Context Efficiency

- Smaller tools = faster processing
- Better fit in LLM context windows
- More accurate, focused responses
- Install only what you need

### Maintainability

- Single-purpose = easier updates
- Clear boundaries = isolated changes
- Less duplication = simpler maintenance
- Isolated dependencies

---

## Complete Plugin Catalog

**Total: 63 plugins organized into 23 categories**

### 🎨 Development (4 plugins)

| Plugin                          | Description                               | Agents                                                                                                 | Commands            | Skills   |
| ------------------------------- | ----------------------------------------- | ------------------------------------------------------------------------------------------------------ | ------------------- | -------- |
| **debugging-toolkit**           | Interactive debugging and DX optimization | debugger, dx-optimizer                                                                                 | smart-debug         | -        |
| **backend-development**         | Backend API design with GraphQL and TDD   | backend-architect, graphql-architect, tdd-orchestrator                                                 | feature-development | 3 skills |
| **frontend-mobile-development** | Frontend UI and mobile development        | frontend-developer, mobile-developer                                                                   | component-scaffold  | -        |
| **multi-platform-apps**         | Cross-platform app coordination           | frontend-developer, mobile-developer, ios-developer, flutter-expert, ui-ux-designer, backend-architect | multi-platform      | -        |

### 📚 Documentation (2 plugins)

| Plugin                       | Description                                   | Agents                                                               | Commands                   |
| ---------------------------- | --------------------------------------------- | -------------------------------------------------------------------- | -------------------------- |
| **code-documentation**       | Documentation generation and code explanation | docs-architect, tutorial-engineer, code-reviewer                     | doc-generate, code-explain |
| **documentation-generation** | OpenAPI specs, Mermaid diagrams, tutorials    | api-documenter, reference-builder, tutorial-engineer, mermaid-expert | doc-generate               |

### 🔄 Workflows (3 plugins)

| Plugin                       | Description                         | Agents                                                                      | Commands                                    |
| ---------------------------- | ----------------------------------- | --------------------------------------------------------------------------- | ------------------------------------------- |
| **git-pr-workflows**         | Git automation and PR enhancement   | code-reviewer                                                               | pr-enhance, onboard, git-workflow           |
| **full-stack-orchestration** | End-to-end feature orchestration    | test-automator, security-auditor, performance-engineer, deployment-engineer | full-stack-feature                          |
| **tdd-workflows**            | Test-driven development methodology | tdd-orchestrator, code-reviewer                                             | tdd-cycle, tdd-red, tdd-green, tdd-refactor |

### ✅ Testing (2 plugins)

| Plugin            | Description                         | Agents                          | Commands                                    |
| ----------------- | ----------------------------------- | ------------------------------- | ------------------------------------------- |
| **unit-testing**  | Automated unit test generation      | test-automator, debugger        | test-generate                               |
| **tdd-workflows** | Test-driven development methodology | tdd-orchestrator, code-reviewer | tdd-cycle, tdd-red, tdd-green, tdd-refactor |

### 🔍 Quality (3 plugins)

| Plugin                         | Description                            | Agents                                            | Commands                |
| ------------------------------ | -------------------------------------- | ------------------------------------------------- | ----------------------- |
| **code-review-ai**             | AI-powered architectural review        | code-reviewer, architect-review                   | ai-review               |
| **comprehensive-review**       | Multi-perspective code analysis        | code-reviewer, architect-review, security-auditor | full-review, pr-enhance |
| **performance-testing-review** | Performance analysis and test coverage | performance-engineer, test-automator              | ai-review               |

### 🤖 AI & ML (4 plugins)

| Plugin                   | Description                         | Agents                                      | Commands                                       | Skills   |
| ------------------------ | ----------------------------------- | ------------------------------------------- | ---------------------------------------------- | -------- |
| **llm-application-dev**  | LLM apps and prompt engineering     | ai-engineer, prompt-engineer                | langchain-agent, ai-assistant, prompt-optimize | 4 skills |
| **agent-orchestration**  | Multi-agent system optimization     | context-manager                             | multi-agent-optimize, improve-agent            | -        |
| **context-management**   | Context persistence and restoration | context-manager                             | context-save, context-restore                  | -        |
| **machine-learning-ops** | ML training pipelines and MLOps     | data-scientist, ml-engineer, mlops-engineer | ml-pipeline                                    | 1 skill  |

### 📊 Data (2 plugins)

| Plugin                    | Description                        | Agents                           | Commands                           |
| ------------------------- | ---------------------------------- | -------------------------------- | ---------------------------------- |
| **data-engineering**      | ETL pipelines and data warehouses  | data-engineer, backend-architect | data-pipeline, data-driven-feature |
| **data-validation-suite** | Schema validation and data quality | backend-security-coder           | -                                  |

### 🗄️ Database (2 plugins)

| Plugin                  | Description                             | Agents                      | Commands                                |
| ----------------------- | --------------------------------------- | --------------------------- | --------------------------------------- |
| **database-design**     | Database architecture and schema design | database-architect, sql-pro | -                                       |
| **database-migrations** | Database migration automation           | database-admin              | sql-migrations, migration-observability |

### 🚨 Operations (4 plugins)

| Plugin                       | Description                           | Agents                                                                             | Commands                     |
| ---------------------------- | ------------------------------------- | ---------------------------------------------------------------------------------- | ---------------------------- |
| **incident-response**        | Production incident management        | incident-responder, devops-troubleshooter                                          | incident-response, smart-fix |
| **error-diagnostics**        | Error tracing and root cause analysis | error-detective, debugger                                                          | smart-debug                  |
| **distributed-debugging**    | Distributed system tracing            | devops-troubleshooter, error-detective                                             | debug-trace                  |
| **observability-monitoring** | Metrics, logging, tracing, SLO        | observability-engineer, performance-engineer, database-optimizer, network-engineer | monitor-setup, slo-implement |

### ⚡ Performance (2 plugins)

| Plugin                          | Description                                | Agents                                                           | Commands                 |
| ------------------------------- | ------------------------------------------ | ---------------------------------------------------------------- | ------------------------ |
| **application-performance**     | Application profiling and optimization     | frontend-developer, observability-engineer, performance-engineer | performance-optimization |
| **database-cloud-optimization** | Database query and cloud cost optimization | database-optimizer                                               | cost-optimize            |

### ☁️ Infrastructure (5 plugins)

| Plugin                    | Description                                 | Agents                                                                                                  | Commands          | Skills   |
| ------------------------- | ------------------------------------------- | ------------------------------------------------------------------------------------------------------- | ----------------- | -------- |
| **deployment-strategies** | Deployment patterns and rollback automation | deployment-engineer, terraform-specialist                                                               | -                 | -        |
| **deployment-validation** | Pre-deployment checks and validation        | cloud-architect                                                                                         | config-validate   | -        |
| **kubernetes-operations** | K8s manifests and GitOps workflows          | kubernetes-architect                                                                                    | -                 | 4 skills |
| **cloud-infrastructure**  | AWS/Azure/GCP cloud architecture            | cloud-architect, hybrid-cloud-architect, deployment-engineer, terraform-specialist                      | -                 | 4 skills |
| **cicd-automation**       | CI/CD pipeline configuration                | cloud-architect, deployment-engineer, devops-troubleshooter, kubernetes-architect, terraform-specialist | workflow-automate | 4 skills |

### 🔒 Security (4 plugins)

| Plugin                       | Description                              | Agents                                         | Commands                                                 | Skills  |
| ---------------------------- | ---------------------------------------- | ---------------------------------------------- | -------------------------------------------------------- | ------- |
| **security-scanning**        | SAST analysis and vulnerability scanning | security-auditor                               | security-hardening, security-sast, security-dependencies | 1 skill |
| **security-compliance**      | SOC2/HIPAA/GDPR compliance               | security-auditor                               | compliance-check                                         | -       |
| **backend-api-security**     | API security and authentication          | backend-security-coder                         | -                                                        | -       |
| **frontend-mobile-security** | XSS/CSRF prevention and mobile security  | frontend-security-coder, mobile-security-coder | xss-scan                                                 | -       |

### 💻 Languages (7 plugins)

| Plugin                          | Description                        | Agents                               | Commands            | Skills   |
| ------------------------------- | ---------------------------------- | ------------------------------------ | ------------------- | -------- |
| **python-development**          | Python 3.12+ with Django/FastAPI   | python-pro, django-pro, fastapi-pro  | python-scaffold     | 5 skills |
| **javascript-typescript**       | JavaScript/TypeScript with Node.js | javascript-pro, typescript-pro       | typescript-scaffold | 4 skills |
| **systems-programming**         | Rust, Go, C, C++                   | rust-pro, golang-pro, c-pro, cpp-pro | rust-project        | -        |
| **jvm-languages**               | Java, Scala, C#                    | java-pro, scala-pro, csharp-pro      | -                   | -        |
| **web-scripting**               | PHP and Ruby                       | php-pro, ruby-pro                    | -                   | -        |
| **functional-programming**      | Elixir with OTP                    | elixir-pro                           | -                   | -        |
| **arm-cortex-microcontrollers** | ARM Cortex-M firmware              | arm-cortex-expert                    | -                   | -        |

### 🔄 Modernization (2 plugins)

| Plugin                  | Description                      | Agents                        | Commands                                     | Skills   |
| ----------------------- | -------------------------------- | ----------------------------- | -------------------------------------------- | -------- |
| **framework-migration** | Framework upgrades and migration | legacy-modernizer             | legacy-modernize, code-migrate, deps-upgrade | 4 skills |
| **codebase-cleanup**    | Technical debt reduction         | test-automator, code-reviewer | deps-audit, tech-debt                        | -        |

### 🌐 API (2 plugins)

| Plugin                        | Description                 | Agents                                                        | Commands | Skills  |
| ----------------------------- | --------------------------- | ------------------------------------------------------------- | -------- | ------- |
| **api-scaffolding**           | REST/GraphQL API generation | backend-architect, django-pro, fastapi-pro, graphql-architect | -        | 1 skill |
| **api-testing-observability** | API testing and monitoring  | api-documenter                                                | api-mock | -       |

### 💼 Business (3 plugins)

| Plugin                        | Description                          | Agents                            |
| ----------------------------- | ------------------------------------ | --------------------------------- |
| **business-analytics**        | KPI tracking and financial reporting | business-analyst                  |
| **hr-legal-compliance**       | HR policies and legal templates      | hr-pro, legal-advisor             |
| **customer-sales-automation** | Support and sales automation         | customer-support, sales-automator |

### 📢 Marketing (4 plugins)

| Plugin                         | Description                             | Agents                                                                                  |
| ------------------------------ | --------------------------------------- | --------------------------------------------------------------------------------------- |
| **seo-content-creation**       | SEO content writing and planning        | seo-content-writer, seo-content-planner, seo-content-auditor                            |
| **seo-technical-optimization** | Meta tags, keywords, schema markup      | seo-meta-optimizer, seo-keyword-strategist, seo-structure-architect, seo-snippet-hunter |
| **seo-analysis-monitoring**    | Content analysis and authority building | seo-content-refresher, seo-cannibalization-detector, seo-authority-builder              |
| **content-marketing**          | Content strategy and web research       | content-marketer, search-specialist                                                     |

### 🔗 Blockchain (1 plugin)

| Plugin              | Description                        | Agents               | Skills   |
| ------------------- | ---------------------------------- | -------------------- | -------- |
| **blockchain-web3** | Smart contracts and DeFi protocols | blockchain-developer | 4 skills |

### 💰 Finance (1 plugin)

| Plugin                   | Description                             | Agents                      |
| ------------------------ | --------------------------------------- | --------------------------- |
| **quantitative-trading** | Algorithmic trading and risk management | quant-analyst, risk-manager |

### 💳 Payments (1 plugin)

| Plugin                 | Description               | Agents              | Skills   |
| ---------------------- | ------------------------- | ------------------- | -------- |
| **payment-processing** | Stripe/PayPal integration | payment-integration | 4 skills |

### 🎮 Gaming (1 plugin)

| Plugin               | Description                 | Agents                                |
| -------------------- | --------------------------- | ------------------------------------- |
| **game-development** | Unity and Minecraft plugins | unity-developer, minecraft-bukkit-pro |

### ♿ Accessibility (1 plugin)

| Plugin                       | Description                        | Agents              |
| ---------------------------- | ---------------------------------- | ------------------- |
| **accessibility-compliance** | WCAG auditing and inclusive design | ui-visual-validator |

### 🛠️ Utilities (4 plugins)

| Plugin                    | Description                           | Agents                    |
| ------------------------- | ------------------------------------- | ------------------------- |
| **code-refactoring**      | Code cleanup and technical debt       | legacy-modernizer         |
| **dependency-management** | Dependency auditing and versions      | legacy-modernizer         |
| **error-debugging**       | Error analysis and trace debugging    | debugger, error-detective |
| **team-collaboration**    | Team workflows and standup automation | dx-optimizer              |

---

## All 85 Agents Reference

### Architecture & System Design (12 agents)

| Agent                      | Model  | Plugin                   | Primary Use Case                                              |
| -------------------------- | ------ | ------------------------ | ------------------------------------------------------------- |
| **backend-architect**      | sonnet | backend-development      | RESTful API design, microservice boundaries, database schemas |
| **frontend-developer**     | sonnet | multi-platform-apps      | React components, responsive layouts, client-side state       |
| **graphql-architect**      | sonnet | backend-development      | GraphQL schemas, resolvers, federation architecture           |
| **architect-review**       | sonnet | comprehensive-review     | Architectural consistency analysis and pattern validation     |
| **cloud-architect**        | sonnet | cloud-infrastructure     | AWS/Azure/GCP infrastructure design and cost optimization     |
| **hybrid-cloud-architect** | sonnet | cloud-infrastructure     | Multi-cloud strategies across cloud and on-premises           |
| **kubernetes-architect**   | sonnet | kubernetes-operations    | Cloud-native infrastructure with Kubernetes and GitOps        |
| **ui-ux-designer**         | sonnet | multi-platform-apps      | Interface design, wireframes, design systems                  |
| **ui-visual-validator**    | sonnet | accessibility-compliance | Visual regression testing and UI verification                 |
| **mobile-developer**       | sonnet | multi-platform-apps      | React Native and Flutter application development              |
| **ios-developer**          | sonnet | multi-platform-apps      | Native iOS development with Swift/SwiftUI                     |
| **flutter-expert**         | sonnet | multi-platform-apps      | Advanced Flutter development with state management            |

### Programming Languages (20 agents)

| Agent                    | Model  | Plugin                      | Primary Use Case                                                     |
| ------------------------ | ------ | --------------------------- | -------------------------------------------------------------------- |
| **python-pro**           | sonnet | python-development          | Python development with advanced features and optimization           |
| **django-pro**           | sonnet | api-scaffolding             | Django development with ORM and async views                          |
| **fastapi-pro**          | sonnet | api-scaffolding             | FastAPI with async patterns and Pydantic                             |
| **javascript-pro**       | sonnet | javascript-typescript       | Modern JavaScript with ES6+, async patterns, Node.js                 |
| **typescript-pro**       | sonnet | javascript-typescript       | Advanced TypeScript with type systems and generics                   |
| **rust-pro**             | sonnet | systems-programming         | Memory-safe systems programming with ownership patterns              |
| **golang-pro**           | sonnet | systems-programming         | Concurrent programming with goroutines and channels                  |
| **c-pro**                | sonnet | systems-programming         | System programming with memory management and OS interfaces          |
| **cpp-pro**              | sonnet | systems-programming         | Modern C++ with RAII, smart pointers, STL algorithms                 |
| **java-pro**             | sonnet | jvm-languages               | Modern Java with streams, concurrency, JVM optimization              |
| **scala-pro**            | sonnet | jvm-languages               | Enterprise Scala with functional programming and distributed systems |
| **csharp-pro**           | sonnet | jvm-languages               | C# development with .NET frameworks and patterns                     |
| **ruby-pro**             | sonnet | web-scripting               | Ruby with metaprogramming, Rails patterns, gem development           |
| **php-pro**              | sonnet | web-scripting               | Modern PHP with frameworks and performance optimization              |
| **elixir-pro**           | sonnet | functional-programming      | Elixir with OTP patterns and Phoenix frameworks                      |
| **sql-pro**              | sonnet | database-design             | Complex SQL queries and database optimization                        |
| **unity-developer**      | sonnet | game-development            | Unity game development and optimization                              |
| **minecraft-bukkit-pro** | sonnet | game-development            | Minecraft server plugin development                                  |
| **arm-cortex-expert**    | sonnet | arm-cortex-microcontrollers | ARM Cortex-M firmware and peripheral driver development              |
| **blockchain-developer** | sonnet | blockchain-web3             | Web3 apps, smart contracts, DeFi protocols                           |

### Infrastructure & Operations (12 agents)

| Agent                      | Model  | Plugin                   | Primary Use Case                                                    |
| -------------------------- | ------ | ------------------------ | ------------------------------------------------------------------- |
| **devops-troubleshooter**  | sonnet | incident-response        | Production debugging, log analysis, deployment troubleshooting      |
| **deployment-engineer**    | sonnet | cloud-infrastructure     | CI/CD pipelines, containerization, cloud deployments                |
| **terraform-specialist**   | sonnet | cloud-infrastructure     | Infrastructure as Code with Terraform modules and state management  |
| **dx-optimizer**           | sonnet | team-collaboration       | Developer experience optimization and tooling improvements          |
| **database-architect**     | sonnet | database-design          | Database design from scratch, technology selection, schema modeling |
| **database-optimizer**     | sonnet | observability-monitoring | Query optimization, index design, migration strategies              |
| **database-admin**         | sonnet | database-migrations      | Database operations, backup, replication, monitoring                |
| **incident-responder**     | sonnet | incident-response        | Production incident management and resolution                       |
| **network-engineer**       | sonnet | observability-monitoring | Network debugging, load balancing, traffic analysis                 |
| **observability-engineer** | sonnet | observability-monitoring | Production monitoring, distributed tracing, SLI/SLO management      |
| **performance-engineer**   | sonnet | application-performance  | Application profiling and optimization                              |
| **context-manager**        | haiku  | agent-orchestration      | Multi-agent context management                                      |

### Quality Assurance & Security (13 agents)

| Agent                       | Model  | Plugin                   | Primary Use Case                                             |
| --------------------------- | ------ | ------------------------ | ------------------------------------------------------------ |
| **code-reviewer**           | sonnet | comprehensive-review     | Code review with security focus and production reliability   |
| **security-auditor**        | sonnet | comprehensive-review     | Vulnerability assessment and OWASP compliance                |
| **backend-security-coder**  | sonnet | data-validation-suite    | Secure backend coding practices, API security implementation |
| **frontend-security-coder** | sonnet | frontend-mobile-security | XSS prevention, CSP implementation, client-side security     |
| **mobile-security-coder**   | sonnet | frontend-mobile-security | Mobile security patterns, WebView security, biometric auth   |
| **test-automator**          | sonnet | unit-testing             | Comprehensive test suite creation (unit, integration, e2e)   |
| **tdd-orchestrator**        | sonnet | backend-development      | Test-Driven Development methodology guidance                 |
| **debugger**                | sonnet | debugging-toolkit        | Error resolution and test failure analysis                   |
| **error-detective**         | sonnet | error-debugging          | Log analysis and error pattern recognition                   |
| **legacy-modernizer**       | sonnet | framework-migration      | Legacy code refactoring and modernization                    |
| **payment-integration**     | sonnet | payment-processing       | Payment processor integration (Stripe, PayPal)               |
| **search-specialist**       | haiku  | content-marketing        | Advanced web research and information synthesis              |

### Data & AI (8 agents)

| Agent               | Model  | Plugin               | Primary Use Case                                         |
| ------------------- | ------ | -------------------- | -------------------------------------------------------- |
| **data-scientist**  | sonnet | machine-learning-ops | Data analysis, SQL queries, BigQuery operations          |
| **data-engineer**   | sonnet | data-engineering     | ETL pipelines, data warehouses, streaming architectures  |
| **ai-engineer**     | sonnet | llm-application-dev  | LLM applications, RAG systems, prompt pipelines          |
| **ml-engineer**     | sonnet | machine-learning-ops | ML pipelines, model serving, feature engineering         |
| **mlops-engineer**  | sonnet | machine-learning-ops | ML infrastructure, experiment tracking, model registries |
| **prompt-engineer** | sonnet | llm-application-dev  | LLM prompt optimization and engineering                  |

### Documentation & Technical Writing (6 agents)

| Agent                 | Model  | Plugin                    | Primary Use Case                                  |
| --------------------- | ------ | ------------------------- | ------------------------------------------------- |
| **docs-architect**    | sonnet | code-documentation        | Comprehensive technical documentation generation  |
| **api-documenter**    | sonnet | api-testing-observability | OpenAPI/Swagger specifications and developer docs |
| **reference-builder** | haiku  | documentation-generation  | Technical references and API documentation        |
| **tutorial-engineer** | sonnet | code-documentation        | Step-by-step tutorials and educational content    |
| **mermaid-expert**    | sonnet | documentation-generation  | Diagram creation (flowcharts, sequences, ERDs)    |

### Business & Operations (11 agents)

| Agent                | Model  | Plugin                    | Primary Use Case                                        |
| -------------------- | ------ | ------------------------- | ------------------------------------------------------- |
| **business-analyst** | sonnet | business-analytics        | Metrics analysis, reporting, KPI tracking               |
| **quant-analyst**    | sonnet | quantitative-trading      | Financial modeling, trading strategies, market analysis |
| **risk-manager**     | sonnet | quantitative-trading      | Portfolio risk monitoring and management                |
| **content-marketer** | sonnet | content-marketing         | Blog posts, social media, email campaigns               |
| **sales-automator**  | haiku  | customer-sales-automation | Cold emails, follow-ups, proposal generation            |
| **customer-support** | sonnet | customer-sales-automation | Support tickets, FAQ responses, customer communication  |
| **hr-pro**           | sonnet | hr-legal-compliance       | HR operations, policies, employee relations             |
| **legal-advisor**    | sonnet | hr-legal-compliance       | Privacy policies, terms of service, legal documentation |

### SEO & Content Optimization (10 agents)

| Agent                            | Model  | Plugin                     | Primary Use Case                                     |
| -------------------------------- | ------ | -------------------------- | ---------------------------------------------------- |
| **seo-content-writer**           | sonnet | seo-content-creation       | SEO-optimized content creation                       |
| **seo-content-planner**          | haiku  | seo-content-creation       | Content planning and topic clusters                  |
| **seo-content-auditor**          | sonnet | seo-content-creation       | Content quality analysis, E-E-A-T signals assessment |
| **seo-meta-optimizer**           | haiku  | seo-technical-optimization | Meta title and description optimization              |
| **seo-keyword-strategist**       | haiku  | seo-technical-optimization | Keyword analysis and semantic variations             |
| **seo-structure-architect**      | haiku  | seo-technical-optimization | Content structure and schema markup                  |
| **seo-snippet-hunter**           | haiku  | seo-technical-optimization | Featured snippet formatting                          |
| **seo-content-refresher**        | haiku  | seo-analysis-monitoring    | Content freshness analysis                           |
| **seo-cannibalization-detector** | haiku  | seo-analysis-monitoring    | Keyword overlap detection                            |
| **seo-authority-builder**        | sonnet | seo-analysis-monitoring    | E-E-A-T signal analysis                              |

---

## All 47 Skills Reference

Skills are modular knowledge packages that activate automatically when Claude detects matching patterns.

### Kubernetes Operations (4 skills)

| Skill                      | Activation Trigger                             | What It Provides                                                          |
| -------------------------- | ---------------------------------------------- | ------------------------------------------------------------------------- |
| **k8s-manifest-generator** | "Create Kubernetes deployment", "K8s manifest" | Production-ready manifests for Deployments, Services, ConfigMaps, Secrets |
| **helm-chart-scaffolding** | "Helm chart", "Package Kubernetes app"         | Chart design, organization, templating best practices                     |
| **gitops-workflow**        | "GitOps", "ArgoCD", "Flux"                     | Declarative deployment workflows and continuous delivery                  |
| **k8s-security-policies**  | "Kubernetes security", "NetworkPolicy", "RBAC" | Security policies, pod security, RBAC configuration                       |

### LLM Application Development (4 skills)

| Skill                           | Activation Trigger                                         | What It Provides                                       |
| ------------------------------- | ---------------------------------------------------------- | ------------------------------------------------------ |
| **langchain-architecture**      | "LangChain", "LLM application", "AI agent"                 | LangChain framework patterns, agents, memory, tools    |
| **prompt-engineering-patterns** | "Prompt engineering", "LLM optimization"                   | Advanced prompting techniques, reliability patterns    |
| **rag-implementation**          | "RAG", "Retrieval augmented generation", "Vector database" | RAG system design, vector search, semantic retrieval   |
| **llm-evaluation**              | "LLM evaluation", "AI metrics", "Model benchmarking"       | Evaluation strategies, automated metrics, benchmarking |

### Backend Development (3 skills)

| Skill                      | Activation Trigger                                    | What It Provides                                             |
| -------------------------- | ----------------------------------------------------- | ------------------------------------------------------------ |
| **api-design-principles**  | "API design", "REST API", "GraphQL API"               | API design best practices, intuitive interfaces, scalability |
| **architecture-patterns**  | "Clean architecture", "Hexagonal architecture", "DDD" | Architectural patterns, design principles, domain modeling   |
| **microservices-patterns** | "Microservices", "Service boundaries", "Event-driven" | Service decomposition, communication patterns, resilience    |

### Blockchain & Web3 (4 skills)

| Skill                       | Activation Trigger                             | What It Provides                                            |
| --------------------------- | ---------------------------------------------- | ----------------------------------------------------------- |
| **defi-protocol-templates** | "DeFi", "Staking", "AMM", "Lending protocol"   | DeFi protocol templates, governance, tokenomics             |
| **nft-standards**           | "NFT", "ERC-721", "ERC-1155"                   | NFT standards, metadata, marketplace integration            |
| **solidity-security**       | "Smart contract security", "Solidity audit"    | Security patterns, vulnerability prevention, best practices |
| **web3-testing**            | "Smart contract testing", "Hardhat", "Foundry" | Testing frameworks, unit tests, mainnet forking             |

### CI/CD Automation (4 skills)

| Skill                          | Activation Trigger                           | What It Provides                                       |
| ------------------------------ | -------------------------------------------- | ------------------------------------------------------ |
| **deployment-pipeline-design** | "CI/CD pipeline", "Deployment automation"    | Multi-stage pipelines, approval gates, security checks |
| **github-actions-templates**   | "GitHub Actions", "CI workflow"              | Production-ready workflow templates, matrix builds     |
| **gitlab-ci-patterns**         | "GitLab CI", "Pipeline configuration"        | GitLab CI/CD patterns, distributed runners             |
| **secrets-management**         | "Secrets management", "Vault", "AWS Secrets" | Secure secrets storage, rotation, access control       |

### Cloud Infrastructure (4 skills)

| Skill                        | Activation Trigger                              | What It Provides                                    |
| ---------------------------- | ----------------------------------------------- | --------------------------------------------------- |
| **terraform-module-library** | "Terraform", "IaC", "Infrastructure as code"    | Reusable modules for AWS, Azure, GCP                |
| **multi-cloud-architecture** | "Multi-cloud", "Avoid vendor lock-in"           | Cloud-agnostic design patterns                      |
| **hybrid-cloud-networking**  | "Hybrid cloud", "VPN", "Direct Connect"         | Secure connectivity, network architecture           |
| **cost-optimization**        | "Cloud cost optimization", "AWS cost reduction" | Rightsizing, tagging strategies, reserved instances |

### Framework Migration (4 skills)

| Skill                   | Activation Trigger                              | What It Provides                                      |
| ----------------------- | ----------------------------------------------- | ----------------------------------------------------- |
| **react-modernization** | "React upgrade", "Migrate to hooks", "React 19" | Hooks migration, concurrent features, modern patterns |
| **angular-migration**   | "Angular migration", "AngularJS to Angular"     | Hybrid mode strategies, incremental rewriting         |
| **database-migration**  | "Database migration", "Zero-downtime migration" | Migration strategies, data transformations, rollback  |
| **dependency-upgrade**  | "Dependency upgrade", "Major version upgrade"   | Compatibility analysis, breaking change handling      |

### Observability & Monitoring (4 skills)

| Skill                        | Activation Trigger                       | What It Provides                               |
| ---------------------------- | ---------------------------------------- | ---------------------------------------------- |
| **prometheus-configuration** | "Prometheus", "Metrics collection"       | Prometheus setup, exporters, alerting rules    |
| **grafana-dashboards**       | "Grafana dashboard", "Visualization"     | Production dashboard templates, best practices |
| **distributed-tracing**      | "Distributed tracing", "Jaeger", "Tempo" | Trace collection, correlation, analysis        |
| **slo-implementation**       | "SLO", "SLI", "Error budget"             | SLI/SLO definition, error budgets, alerting    |

### Payment Processing (4 skills)

| Skill                  | Activation Trigger                         | What It Provides                           |
| ---------------------- | ------------------------------------------ | ------------------------------------------ |
| **stripe-integration** | "Stripe", "Payment processing"             | Stripe checkout, subscriptions, webhooks   |
| **paypal-integration** | "PayPal", "Payment gateway"                | PayPal express checkout, subscriptions     |
| **pci-compliance**     | "PCI compliance", "Payment security"       | PCI DSS requirements, secure card handling |
| **billing-automation** | "Billing automation", "Recurring payments" | Automated billing, invoicing, dunning      |

### Python Development (5 skills)

| Skill                               | Activation Trigger                                  | What It Provides                                       |
| ----------------------------------- | --------------------------------------------------- | ------------------------------------------------------ |
| **async-python-patterns**           | "Python async", "asyncio", "Concurrent programming" | AsyncIO patterns, async/await best practices           |
| **python-testing-patterns**         | "pytest", "Python testing", "Mock testing"          | Pytest patterns, fixtures, mocking strategies          |
| **python-packaging**                | "Python package", "PyPI", "Distribution"            | Package structure, setup.py/pyproject.toml, publishing |
| **python-performance-optimization** | "Python optimization", "Performance profiling"      | cProfile usage, bottleneck identification              |
| **uv-package-manager**              | "uv", "Python package manager", "Fast dependencies" | uv usage, virtual environments, workflow optimization  |

### JavaScript/TypeScript (4 skills)

| Skill                           | Activation Trigger                         | What It Provides                                     |
| ------------------------------- | ------------------------------------------ | ---------------------------------------------------- |
| **typescript-advanced-types**   | "TypeScript generics", "Conditional types" | Advanced type system, mapped types, utilities        |
| **nodejs-backend-patterns**     | "Node.js backend", "Express", "Fastify"    | Backend service patterns, middleware, error handling |
| **javascript-testing-patterns** | "Jest", "Vitest", "Testing Library"        | Testing strategies, mocking, test organization       |
| **modern-javascript-patterns**  | "ES6+", "Modern JavaScript", "Async/await" | Modern syntax, functional patterns, best practices   |

### API Scaffolding (1 skill)

| Skill                 | Activation Trigger                   | What It Provides                                      |
| --------------------- | ------------------------------------ | ----------------------------------------------------- |
| **fastapi-templates** | "FastAPI", "Python API", "Async API" | FastAPI project templates, async patterns, validation |

### Machine Learning Operations (1 skill)

| Skill                    | Activation Trigger                         | What It Provides                                 |
| ------------------------ | ------------------------------------------ | ------------------------------------------------ |
| **ml-pipeline-workflow** | "MLOps", "ML pipeline", "Model deployment" | End-to-end ML workflows, feature stores, serving |

### Security Scanning (1 skill)

| Skill                  | Activation Trigger                             | What It Provides                                 |
| ---------------------- | ---------------------------------------------- | ------------------------------------------------ |
| **sast-configuration** | "SAST", "Static analysis", "Security scanning" | SAST tool configuration, vulnerability detection |

---

## All 44+ Commands Reference

Commands are slash commands for direct invocation of tools and workflows.

### Format

```bash
/plugin-name:command-name [arguments]
```

### Development & Features

```bash
/backend-development:feature-development [feature description]
/full-stack-orchestration:full-stack-feature [feature description]
/multi-platform-apps:multi-platform [platform requirements]
```

### Testing & Quality

```bash
/unit-testing:test-generate [file or module]
/tdd-workflows:tdd-cycle [feature description]
/tdd-workflows:tdd-red [test description]
/tdd-workflows:tdd-green
/tdd-workflows:tdd-refactor
/code-review-ai:ai-review
/comprehensive-review:full-review
/comprehensive-review:pr-enhance
```

### Debugging & Troubleshooting

```bash
/debugging-toolkit:smart-debug [issue description]
/incident-response:incident-response [incident details]
/incident-response:smart-fix [problem description]
/error-debugging:error-analysis [error details]
/error-debugging:error-trace [stack trace]
/error-diagnostics:smart-debug [diagnostic info]
/distributed-debugging:debug-trace [distributed system issue]
```

### Security

```bash
/security-scanning:security-hardening [--level comprehensive|standard|quick]
/security-scanning:security-sast
/security-scanning:security-dependencies
/security-compliance:compliance-check [SOC2|HIPAA|GDPR]
/frontend-mobile-security:xss-scan
```

### Infrastructure & Deployment

```bash
/observability-monitoring:monitor-setup [service name]
/observability-monitoring:slo-implement [SLO requirements]
/deployment-validation:config-validate
/cicd-automation:workflow-automate [workflow type]
```

### Data & ML

```bash
/machine-learning-ops:ml-pipeline [model description]
/data-engineering:data-pipeline [pipeline description]
/data-engineering:data-driven-feature [feature requirements]
```

### Documentation

```bash
/code-documentation:doc-generate [scope]
/code-documentation:code-explain [code reference]
/documentation-generation:doc-generate [doc type]
```

### Refactoring & Maintenance

```bash
/code-refactoring:refactor-clean [target]
/code-refactoring:tech-debt [assessment]
/codebase-cleanup:deps-audit
/codebase-cleanup:tech-debt
/framework-migration:legacy-modernize [target framework]
/framework-migration:code-migrate [migration plan]
/framework-migration:deps-upgrade [dependency]
```

### Database

```bash
/database-migrations:sql-migrations [migration description]
/database-migrations:migration-observability
/database-cloud-optimization:cost-optimize
```

### Git & PR Workflows

```bash
/git-pr-workflows:pr-enhance
/git-pr-workflows:onboard [team member]
/git-pr-workflows:git-workflow [workflow type]
```

### Project Scaffolding

```bash
/python-development:python-scaffold [project type]
/javascript-typescript:typescript-scaffold [project type]
/systems-programming:rust-project [project name]
```

### AI & LLM Development

```bash
/llm-application-dev:langchain-agent [agent description]
/llm-application-dev:ai-assistant [assistant requirements]
/llm-application-dev:prompt-optimize [prompt]
/agent-orchestration:multi-agent-optimize
/agent-orchestration:improve-agent [agent name]
```

### Testing & Performance

```bash
/performance-testing-review:ai-review
/application-performance:performance-optimization [target]
```

### Team Collaboration

```bash
/team-collaboration:issue [issue details]
/team-collaboration:standup-notes
```

### Accessibility

```bash
/accessibility-compliance:accessibility-audit
```

### API Development

```bash
/api-testing-observability:api-mock [API spec]
```

### Context Management

```bash
/context-management:context-save
/context-management:context-restore
```

---

## Multi-Agent Orchestration Patterns

### Pattern 1: Planning → Execution → Review

**Use When:** Building features with clear specifications

**Flow:**

```
Sonnet Agent (Planning)
  ↓
Haiku Agent (Execution)
  ↓
Sonnet Agent (Review)
```

**Example:**

```
backend-architect (Sonnet) → Design API architecture
  ↓
Generate API endpoints (Haiku) → Implement spec
  ↓
test-automator (Haiku) → Create tests
  ↓
code-reviewer (Sonnet) → Validate architecture
```

**Invocation:**

```bash
/backend-development:feature-development user authentication with OAuth2
```

### Pattern 2: Full-Stack Feature Development

**Use When:** Implementing end-to-end features requiring frontend, backend, testing, security, and deployment

**Agents Orchestrated (7+):**

1. backend-architect (Sonnet) - API design
2. database-architect (Sonnet) - Schema design
3. frontend-developer (Sonnet) - UI components
4. test-automator (Haiku) - Test generation
5. security-auditor (Sonnet) - Security review
6. deployment-engineer (Haiku) - CI/CD setup
7. observability-engineer (Haiku) - Monitoring

**Invocation:**

```bash
/full-stack-orchestration:full-stack-feature "user dashboard with real-time analytics"
```

**Natural Language Alternative:**

```
"Implement user dashboard with real-time analytics showing KPIs, charts, and activity feed"
```

### Pattern 3: Security Hardening

**Use When:** Performing comprehensive security assessment and remediation

**Agents Orchestrated:**

1. security-auditor (Sonnet) - Vulnerability scanning
2. backend-security-coder (Sonnet) - Backend fixes
3. frontend-security-coder (Sonnet) - Frontend fixes
4. mobile-security-coder (Sonnet) - Mobile fixes
5. test-automator (Haiku) - Security test generation

**Invocation:**

```bash
/security-scanning:security-hardening --level comprehensive
```

**Natural Language Alternative:**

```
"Perform comprehensive security audit implementing OWASP best practices"
```

### Pattern 4: ML Pipeline Development

**Use When:** Building machine learning features from data to production

**Agents Orchestrated:**

1. data-scientist (Sonnet) - Exploratory analysis
2. data-engineer (Sonnet) - ETL pipeline
3. ml-engineer (Sonnet) - Model training
4. mlops-engineer (Sonnet) - Deployment infrastructure
5. performance-engineer (Sonnet) - Optimization

**Invocation:**

```bash
/machine-learning-ops:ml-pipeline "customer churn prediction model"
```

### Pattern 5: Incident Response

**Use When:** Debugging production issues requiring rapid resolution

**Agents Orchestrated:**

1. incident-responder (Sonnet) - Triage and strategy
2. devops-troubleshooter (Haiku) - Execute fixes
3. debugger (Sonnet) - Deep analysis
4. error-detective (Haiku) - Log analysis
5. observability-engineer (Haiku) - Monitoring setup

**Invocation:**

```bash
/incident-response:smart-fix "memory leak in payment service"
```

---

## Practical Usage Examples

### Example 1: Building FastAPI Microservice

**Goal:** Create production-ready FastAPI project with async patterns, testing, and documentation

**Approach 1 - Direct Command:**

```bash
/python-development:python-scaffold fastapi-microservice
```

**What Happens:**

- Activates: `fastapi-templates` skill
- Agent: `fastapi-pro`
- Result: Complete project with:
  - Async endpoint patterns
  - Pydantic models
  - Database integration
  - Test suite
  - Docker configuration

**Approach 2 - Natural Language:**

```
"Create FastAPI microservice for user management with PostgreSQL, JWT auth, and comprehensive tests"
```

**Skills Activated:**

- `fastapi-templates`
- `async-python-patterns`
- `python-testing-patterns`

### Example 2: Kubernetes Deployment with Helm

**Goal:** Deploy application to Kubernetes with Helm chart and GitOps

**Command:**

```bash
"Create production Kubernetes deployment with Helm chart and ArgoCD GitOps workflow"
```

**Skills Activated:**

- `k8s-manifest-generator`
- `helm-chart-scaffolding`
- `gitops-workflow`
- `k8s-security-policies`

**Agent:** `kubernetes-architect`

**Deliverables:**

- Production-grade manifests
- Helm chart with templates
- ArgoCD application config
- NetworkPolicy and RBAC

### Example 3: React Component with Accessibility

**Goal:** Create accessible React component with full keyboard navigation

**Command:**

```bash
/frontend-mobile-development:component-scaffold UserProfile with WCAG 2.1 AA compliance
```

**Agent:** `frontend-developer`

**Additional Validation:**

```bash
/accessibility-compliance:accessibility-audit
```

**Agent:** `ui-visual-validator`

### Example 4: Database Migration Strategy

**Goal:** Migrate database with zero downtime

**Natural Language:**

```
"Design zero-downtime database migration strategy for adding user_preferences table"
```

**Agents Activated:**

1. `database-architect` - Migration strategy
2. `sql-pro` - SQL script generation
3. `database-admin` - Execution plan

**Skill Activated:** `database-migration`

**Command Alternative:**

```bash
/database-migrations:sql-migrations add user_preferences table
```

### Example 5: Security Audit + Remediation

**Goal:** Find and fix security vulnerabilities

**Command:**

```bash
/security-scanning:security-hardening --level comprehensive
```

**Workflow:**

1. SAST analysis
2. Dependency scanning
3. Code review for OWASP Top 10
4. Generate remediation plan
5. Implement fixes
6. Generate security tests

**Agents:**

- `security-auditor` (Sonnet) - Assessment
- `backend-security-coder` (Sonnet) - Backend fixes
- `frontend-security-coder` (Sonnet) - Frontend fixes
- `test-automator` (Haiku) - Security tests

### Example 6: TDD Workflow

**Goal:** Implement feature using Test-Driven Development

**Commands:**

```bash
# 1. Write failing test
/tdd-workflows:tdd-red "User can reset password via email"

# 2. Implement minimum code to pass
/tdd-workflows:tdd-green

# 3. Refactor with passing tests
/tdd-workflows:tdd-refactor
```

**Agent:** `tdd-orchestrator`

**Complete Cycle:**

```bash
/tdd-workflows:tdd-cycle "password reset functionality"
```

### Example 7: Multi-Platform App Development

**Goal:** Build app for web, iOS, and Android simultaneously

**Command:**

```bash
/multi-platform-apps:multi-platform "fitness tracking app with social features"
```

**Agents Orchestrated:**

- `backend-architect` - API design
- `frontend-developer` - React web app
- `mobile-developer` - React Native mobile
- `ios-developer` - iOS-specific features
- `ui-ux-designer` - Consistent design system

---

## Model Configuration Strategy

### Overview

The framework uses **hybrid model orchestration** for optimal performance and cost:

- **47 Haiku agents** - Fast execution for deterministic tasks
- **97 Sonnet agents** - Complex reasoning and architecture decisions

### Haiku Agent Use Cases

**When to Use Haiku (Fast Execution):**

- Generating code from well-defined specifications
- Creating tests following established patterns
- Writing documentation with clear templates
- Executing infrastructure operations
- Performing database query optimization
- Handling customer support responses
- Processing SEO optimization tasks
- Managing deployment pipelines

**Haiku Agents Include:**

- `reference-builder` - Technical documentation
- `search-specialist` - Web research
- `context-manager` - Context persistence
- `sales-automator` - Sales emails
- All 10 SEO agents except `seo-content-writer` and `seo-authority-builder`

### Sonnet Agent Use Cases

**When to Use Sonnet (Complex Reasoning):**

- Designing system architecture
- Making technology selection decisions
- Performing security audits
- Reviewing code for architectural patterns
- Creating complex AI/ML pipelines
- Providing language-specific expertise
- Orchestrating multi-agent workflows
- Handling business-critical legal/HR matters

**Sonnet Agents Include:**

- All architecture agents
- All programming language agents
- All security agents
- All quality assurance agents
- Complex infrastructure agents

### Orchestration Examples

**Example 1: Backend Feature**

```
backend-architect (Sonnet) → Plans API
  ↓
Generate endpoints (Haiku) → Implements spec
  ↓
test-automator (Haiku) → Creates tests
  ↓
code-reviewer (Sonnet) → Reviews architecture
```

**Example 2: Incident Response**

```
incident-responder (Sonnet) → Diagnoses issue
  ↓
devops-troubleshooter (Haiku) → Executes fixes
  ↓
deployment-engineer (Haiku) → Deploys hotfix
  ↓
observability-engineer (Haiku) → Sets up alerts
```

---

## Best Practices & Workflows

### When to Use Slash Commands vs Natural Language

**Use Slash Commands When:**

- You know exactly which workflow to run
- Structured, repeatable tasks
- Precise parameter control needed
- Discovering available functionality

**Use Natural Language When:**

- Exploratory work (unsure which tool)
- Complex reasoning required
- Contextual decision-making
- Ad-hoc, one-off tasks

### Plugin Selection Strategy

**Essential Plugins (Install First):**

```bash
/plugin install code-documentation
/plugin install debugging-toolkit
/plugin install git-pr-workflows
/plugin install code-review-ai
```

**For Backend Development:**

```bash
/plugin install backend-development
/plugin install python-development  # or javascript-typescript
/plugin install database-design
/plugin install unit-testing
/plugin install security-scanning
```

**For Frontend/Mobile:**

```bash
/plugin install frontend-mobile-development
/plugin install multi-platform-apps
/plugin install accessibility-compliance
```

**For Infrastructure:**

```bash
/plugin install cloud-infrastructure
/plugin install kubernetes-operations
/plugin install cicd-automation
/plugin install observability-monitoring
```

**For Full-Stack Teams:**

```bash
/plugin install full-stack-orchestration
/plugin install backend-development
/plugin install frontend-mobile-development
/plugin install unit-testing
/plugin install code-review-ai
/plugin install security-scanning
```

### Workflow Composition

Compose multiple plugins for complex scenarios:

```bash
# 1. Develop feature
/backend-development:feature-development payment processing

# 2. Generate tests
/unit-testing:test-generate

# 3. Security scan
/security-scanning:security-hardening

# 4. Code review
/code-review-ai:ai-review

# 5. Setup CI/CD
/cicd-automation:workflow-automate

# 6. Add monitoring
/observability-monitoring:monitor-setup
```

### Progressive Skill Activation

Skills activate automatically based on request patterns:

```
User: "Build FastAPI app with async patterns and testing"
  → Activates: fastapi-templates + async-python-patterns + python-testing-patterns

User: "Deploy to Kubernetes with Helm and GitOps"
  → Activates: k8s-manifest-generator + helm-chart-scaffolding + gitops-workflow

User: "Implement RAG system for document Q&A"
  → Activates: rag-implementation + prompt-engineering-patterns
```

### Context Management Best Practices

1. **Install plugins incrementally** - Start with essentials, add as needed
2. **Use specific commands** - More precise than generic natural language
3. **Leverage skills** - They auto-activate with relevant keywords
4. **Compose workflows** - Chain commands for complex tasks
5. **Review orchestration** - Understand which agents are being invoked

---

## Quick Reference

### Installation Quick Start

```bash
# Add marketplace (one-time)
/plugin marketplace add wshobson/agents

# Browse plugins
/plugin

# Install essentials
/plugin install code-documentation
/plugin install debugging-toolkit
/plugin install backend-development
/plugin install unit-testing
/plugin install code-review-ai
```

### Common Command Patterns

```bash
# Development
/backend-development:feature-development [description]
/full-stack-orchestration:full-stack-feature [description]

# Testing
/unit-testing:test-generate [target]
/tdd-workflows:tdd-cycle [feature]

# Security
/security-scanning:security-hardening
/security-scanning:security-sast

# Debugging
/debugging-toolkit:smart-debug [issue]
/incident-response:smart-fix [problem]

# Documentation
/code-documentation:doc-generate [scope]

# Infrastructure
/observability-monitoring:monitor-setup [service]
/cicd-automation:workflow-automate [type]
```

### Agent Invocation Patterns

```
# Natural language
"Use backend-architect to design the payment API"
"Have security-auditor perform OWASP assessment"
"Get kubernetes-architect to create production deployment"

# Via commands
/backend-development:feature-development payment processing
/security-scanning:security-hardening --level comprehensive
```

### Skill Activation Keywords

| Keyword                  | Skills Activated                                                                       |
| ------------------------ | -------------------------------------------------------------------------------------- |
| "FastAPI"                | fastapi-templates, async-python-patterns                                               |
| "Kubernetes", "K8s"      | k8s-manifest-generator, helm-chart-scaffolding, gitops-workflow, k8s-security-policies |
| "RAG", "Vector database" | rag-implementation, prompt-engineering-patterns                                        |
| "Terraform", "IaC"       | terraform-module-library, multi-cloud-architecture                                     |
| "CI/CD pipeline"         | deployment-pipeline-design, github-actions-templates                                   |
| "DeFi", "Smart contract" | defi-protocol-templates, solidity-security, web3-testing                               |

### Model Selection Quick Reference

| Task Type           | Model        | Example Agents                                         |
| ------------------- | ------------ | ------------------------------------------------------ |
| Architecture Design | Sonnet       | backend-architect, cloud-architect, database-architect |
| Code Implementation | Haiku/Sonnet | Depends on complexity                                  |
| Testing             | Haiku        | test-automator, debugger                               |
| Security Audit      | Sonnet       | security-auditor, code-reviewer                        |
| Documentation       | Haiku/Sonnet | Depends on depth                                       |
| Infrastructure      | Haiku        | deployment-engineer, database-optimizer                |

---

## Conclusion

This framework provides a comprehensive, production-ready ecosystem for AI-assisted software development. By understanding:

- **What plugins exist** (63 focused plugins)
- **Which agents to use** (85 specialized agents)
- **How skills activate** (47 progressive disclosure packages)
- **When to use commands** (44+ slash commands)
- **How to orchestrate** (5 core patterns)

Any Claude Code instance can effectively leverage the wshobson agents framework to deliver high-quality software across all domains.

**Remember:** Install only what you need, compose workflows from multiple plugins, and leverage skills for specialized knowledge.

---

**Framework Repository:** https://github.com/wshobson/agents
**License:** MIT
**Author:** Seth Hobson (@wshobson)
**Support:** https://github.com/wshobson/agents/issues
