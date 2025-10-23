# wshobson Agent Framework - Complete Reference Manual

> **AI-First Documentation for Claude Code Users**
> Version: 2025-01 | Updated for Sonnet 4.5 & Haiku 4.5
> Source: [wshobson/agents](https://github.com/wshobson/agents)

## Table of Contents

- [Executive Summary](#executive-summary)
- [Quick Start Guide](#quick-start-guide)
- [Framework Architecture](#framework-architecture)
- [Core Concepts](#core-concepts)
- [Complete Agent Catalog](#complete-agent-catalog)
- [Agent Skills Reference](#agent-skills-reference)
- [Plugin Reference](#plugin-reference)
- [Command Reference](#command-reference)
- [Multi-Agent Orchestration](#multi-agent-orchestration)
- [Best Practices](#best-practices)
- [Workflow Patterns](#workflow-patterns)
- [Model Configuration Strategy](#model-configuration-strategy)
- [Integration Guide](#integration-guide)
- [Troubleshooting](#troubleshooting)
- [Appendix](#appendix)

---

## Executive Summary

The wshobson agent framework is a **production-ready multi-agent orchestration system** for Claude Code that provides:

- **63 Focused Plugins** - Granular, single-purpose plugins optimized for minimal token usage and composability
- **85 Specialized Agents** - Domain experts with deep knowledge across architecture, languages, infrastructure, quality, data/AI, documentation, business operations, and SEO
- **47 Agent Skills** - Modular knowledge packages with progressive disclosure for specialized expertise
- **15 Workflow Orchestrators** - Multi-agent coordination systems for complex operations
- **44 Development Tools** - Optimized utilities including project scaffolding, security scanning, and test automation

### Key Differentiators

1. **Granular Design**: Average 3.4 components per plugin (follows Anthropic's 2-8 pattern)
2. **Token Efficiency**: Install only what you need; no unnecessary resources loaded
3. **Progressive Disclosure**: Skills load knowledge only when activated
4. **Hybrid Orchestration**: Strategic Haiku/Sonnet model assignment for optimal performance
5. **100% Agent Coverage**: All plugins include specialized agents

### Use Cases

- Full-stack feature development with multi-agent coordination
- Security hardening and compliance automation
- ML/AI pipeline development and deployment
- Infrastructure as code with Terraform and Kubernetes
- Test-driven development workflows
- Legacy code modernization and migration
- Production incident response and debugging
- SEO content creation and optimization

---

## Quick Start Guide

### Installation

#### Step 1: Add the Marketplace

```bash
/plugin marketplace add wshobson/agents
```

This makes all 63 plugins available but **does not load any agents or tools** into context.

#### Step 2: Install Essential Plugins

**For Full-Stack Development:**
```bash
/plugin install python-development          # Python with 5 specialized skills
/plugin install javascript-typescript       # JS/TS with 4 specialized skills
/plugin install backend-development         # Backend APIs with 3 architecture skills
/plugin install frontend-mobile-development # React/React Native components
/plugin install full-stack-orchestration   # Multi-agent workflows
```

**For Infrastructure & Operations:**
```bash
/plugin install kubernetes-operations       # K8s with 4 deployment skills
/plugin install cloud-infrastructure        # AWS/Azure/GCP with 4 cloud skills
/plugin install cicd-automation            # CI/CD pipelines with 4 skills
/plugin install observability-monitoring    # Metrics, logs, traces, SLOs
```

**For Security & Quality:**
```bash
/plugin install security-scanning           # SAST with security skill
/plugin install code-review-ai             # AI-powered code review
/plugin install unit-testing               # Automated test generation
/plugin install comprehensive-review        # Multi-perspective analysis
```

#### Step 3: Verify Installation

```bash
/plugin
```

This displays all installed plugins and available commands.

### First Workflow

Try a complete full-stack feature:

```bash
/full-stack-orchestration:full-stack-feature "user authentication with OAuth2"
```

This coordinates 7+ agents:
1. backend-architect (API design)
2. database-architect (schema design)
3. frontend-developer (UI components)
4. test-automator (comprehensive tests)
5. security-auditor (security review)
6. deployment-engineer (CI/CD)
7. observability-engineer (monitoring)

---

## Framework Architecture

### Design Philosophy

The wshobson framework follows four core principles:

#### 1. Single Responsibility Principle

- Each plugin does **one thing well** (Unix philosophy)
- Clear, focused purposes (describable in 5-10 words)
- Average 3.4 components per plugin
- No bloated plugins

#### 2. Composability Over Bundling

- Mix and match plugins based on needs
- Workflow orchestrators compose focused plugins
- No forced feature bundling
- Clear boundaries between plugins

#### 3. Context Efficiency

- Smaller tools = faster processing
- Better fit in LLM context windows
- More accurate, focused responses
- Install only what you need

#### 4. Maintainability

- Single-purpose = easier updates
- Clear boundaries = isolated changes
- Less duplication = simpler maintenance
- Isolated dependencies

### Repository Structure

```
wshobson/agents/
├── .claude-plugin/
│   └── marketplace.json          # 63 plugins catalog
├── plugins/                       # Isolated plugin directories
│   ├── python-development/
│   │   ├── agents/               # 3 Python experts
│   │   │   ├── python-pro.md
│   │   │   ├── django-pro.md
│   │   │   └── fastapi-pro.md
│   │   ├── commands/             # Project scaffolding
│   │   │   └── python-scaffold.md
│   │   └── skills/               # 5 specialized skills
│   │       ├── async-python-patterns/
│   │       ├── python-testing-patterns/
│   │       ├── python-packaging/
│   │       ├── python-performance-optimization/
│   │       └── uv-package-manager/
│   ├── backend-development/
│   │   ├── agents/
│   │   │   ├── backend-architect.md
│   │   │   ├── graphql-architect.md
│   │   │   └── tdd-orchestrator.md
│   │   ├── commands/
│   │   │   └── feature-development.md
│   │   └── skills/
│   │       ├── api-design-principles/
│   │       ├── architecture-patterns/
│   │       └── microservices-patterns/
│   └── ... (61 more plugins)
├── docs/
│   ├── architecture.md
│   ├── agents.md
│   ├── agent-skills.md
│   ├── plugins.md
│   └── usage.md
└── README.md
```

### Component Breakdown

**Framework Inventory:**
- 63 plugins organized in 23 categories
- 85 specialized agents (47 Haiku, 38 Sonnet)
- 47 agent skills with progressive disclosure
- 44 development tools and commands
- 15 workflow orchestrators

---

## Core Concepts

### 1. Plugins

**Definition**: Plugins are isolated, single-purpose packages that contain agents, commands, and skills.

**Characteristics:**
- **Granular**: Each plugin has one focused purpose
- **Composable**: Mix and match for complex workflows
- **Token-efficient**: Load only what you need
- **Isolated**: Clear boundaries, independent updates

**Example:**
```bash
# Install python development plugin
/plugin install python-development

# This loads:
# - 3 agents (python-pro, django-pro, fastapi-pro)
# - 1 command (python-scaffold)
# - 5 skills (async, testing, packaging, performance, uv)
# Total: ~300 tokens
```

### 2. Agents

**Definition**: Agents are specialized AI assistants with deep domain expertise.

**Types:**
- **Architecture Agents**: Design systems and make technology decisions
- **Language Agents**: Provide programming language expertise
- **Infrastructure Agents**: Handle deployment, operations, and cloud
- **Quality Agents**: Perform code review, testing, and security audits
- **Data/AI Agents**: Build ML pipelines and LLM applications
- **Business Agents**: Handle documentation, marketing, support

**Model Assignment:**
- **Haiku (47 agents)**: Fast execution, deterministic tasks
- **Sonnet (38 agents)**: Complex reasoning, architecture

**Invocation:**
```bash
# Natural language
"Use backend-architect to design the authentication API"

# Slash command
/backend-development:feature-development user authentication
```

### 3. Agent Skills

**Definition**: Skills are modular knowledge packages that extend agent capabilities with progressive disclosure.

**Architecture:**
```yaml
---
name: skill-name
description: What the skill does. Use when [activation trigger].
---

# Skill content with three tiers:
# 1. Metadata (frontmatter) - always loaded
# 2. Instructions - loaded when activated
# 3. Resources - loaded on demand
```

**Progressive Disclosure:**
1. **Metadata**: Name and activation criteria (~50 tokens)
2. **Instructions**: Core guidance and patterns (~500 tokens)
3. **Resources**: Examples and templates (~2000 tokens)

**Activation:**
```
User: "Set up Kubernetes deployment with Helm"
→ Activates: helm-chart-scaffolding, k8s-manifest-generator

User: "Build RAG system for document Q&A"
→ Activates: rag-implementation, prompt-engineering-patterns
```

### 4. Commands

**Definition**: Commands are tools and workflows accessible via slash commands.

**Format:**
```bash
/plugin-name:command-name [arguments]
```

**Categories:**
- **Scaffolding**: Project generation (python-scaffold, typescript-scaffold)
- **Testing**: Test generation (test-generate, tdd-cycle)
- **Security**: Security scanning (security-sast, security-hardening)
- **Workflows**: Multi-agent orchestration (full-stack-feature, ml-pipeline)
- **Utilities**: Code refactoring, documentation, debugging

**Example:**
```bash
# Python project scaffolding
/python-development:python-scaffold fastapi-microservice

# Security hardening
/security-scanning:security-hardening --level comprehensive

# Full-stack feature
/full-stack-orchestration:full-stack-feature "payment processing"
```

### 5. Workflow Orchestrators

**Definition**: Orchestrators coordinate multiple agents in predefined sequences for complex operations.

**Patterns:**
```
Planning (Sonnet) → Execution (Haiku) → Review (Sonnet)

Example: Full-Stack Feature
backend-architect (Sonnet) → design API
  ↓
database-architect (Sonnet) → design schema
  ↓
Generate code (Haiku) → implement spec
  ↓
test-automator (Haiku) → create tests
  ↓
security-auditor (Sonnet) → security review
  ↓
deployment-engineer (Haiku) → CI/CD setup
  ↓
observability-engineer (Haiku) → monitoring setup
```

**Available Orchestrators:**
- full-stack-feature
- ml-pipeline
- incident-response
- security-hardening
- legacy-modernize
- tdd-cycle
- multi-agent-optimize

---

## Complete Agent Catalog

### Architecture & System Design (7 agents)

#### Core Architecture

| Agent | Model | Plugin | Description | Use When |
|-------|-------|--------|-------------|----------|
| **backend-architect** | opus | backend-development | RESTful API design, microservice boundaries, database schemas | Designing backend APIs, service architectures, or data models |
| **frontend-developer** | sonnet | multi-platform-apps | React components, responsive layouts, client-side state management | Building UI components, implementing responsive designs |
| **graphql-architect** | opus | backend-development | GraphQL schemas, resolvers, federation architecture | Designing GraphQL APIs, implementing schema federation |
| **architect-reviewer** | opus | comprehensive-review | Architectural consistency analysis and pattern validation | Reviewing code for architectural patterns and consistency |
| **cloud-architect** | opus | cloud-infrastructure | AWS/Azure/GCP infrastructure design and cost optimization | Designing cloud infrastructure, optimizing costs |
| **hybrid-cloud-architect** | opus | cloud-infrastructure | Multi-cloud strategies across cloud and on-premises environments | Planning hybrid cloud architectures |
| **kubernetes-architect** | opus | kubernetes-operations | Cloud-native infrastructure with Kubernetes and GitOps | Designing K8s deployments, implementing GitOps |

#### UI/UX & Mobile

| Agent | Model | Plugin | Description | Use When |
|-------|-------|--------|-------------|----------|
| **ui-ux-designer** | sonnet | multi-platform-apps | Interface design, wireframes, design systems | Creating UI/UX designs, design systems |
| **ui-visual-validator** | sonnet | accessibility-compliance | Visual regression testing and UI verification | Validating UI changes, accessibility compliance |
| **mobile-developer** | sonnet | multi-platform-apps | React Native and Flutter application development | Building cross-platform mobile apps |
| **ios-developer** | sonnet | multi-platform-apps | Native iOS development with Swift/SwiftUI | Developing native iOS applications |
| **flutter-expert** | sonnet | multi-platform-apps | Advanced Flutter development with state management | Building Flutter apps with complex state |

### Programming Languages (20 agents)

#### Systems & Low-Level

| Agent | Model | Plugin | Description | Use When |
|-------|-------|--------|-------------|----------|
| **c-pro** | sonnet | systems-programming | System programming with memory management and OS interfaces | Writing C code, system-level programming |
| **cpp-pro** | sonnet | systems-programming | Modern C++ with RAII, smart pointers, STL algorithms | Writing modern C++ code |
| **rust-pro** | sonnet | systems-programming | Memory-safe systems programming with ownership patterns | Developing Rust applications |
| **golang-pro** | sonnet | systems-programming | Concurrent programming with goroutines and channels | Building Go services, concurrent systems |

#### Web & Application

| Agent | Model | Plugin | Description | Use When |
|-------|-------|--------|-------------|----------|
| **javascript-pro** | sonnet | javascript-typescript | Modern JavaScript with ES6+, async patterns, Node.js | Writing JavaScript code |
| **typescript-pro** | sonnet | javascript-typescript | Advanced TypeScript with type systems and generics | Developing TypeScript applications |
| **python-pro** | sonnet | python-development | Python development with advanced features and optimization | Writing Python code |
| **ruby-pro** | sonnet | web-scripting | Ruby with metaprogramming, Rails patterns, gem development | Developing Ruby applications |
| **php-pro** | sonnet | web-scripting | Modern PHP with frameworks and performance optimization | Writing PHP code |

#### Enterprise & JVM

| Agent | Model | Plugin | Description | Use When |
|-------|-------|--------|-------------|----------|
| **java-pro** | sonnet | jvm-languages | Modern Java with streams, concurrency, JVM optimization | Developing Java applications |
| **scala-pro** | sonnet | jvm-languages | Enterprise Scala with functional programming and distributed systems | Writing Scala code |
| **csharp-pro** | sonnet | jvm-languages | C# development with .NET frameworks and patterns | Developing C# applications |

#### Specialized Platforms

| Agent | Model | Plugin | Description | Use When |
|-------|-------|--------|-------------|----------|
| **elixir-pro** | sonnet | functional-programming | Elixir with OTP patterns and Phoenix frameworks | Building Elixir applications |
| **django-pro** | sonnet | api-scaffolding | Django development with ORM and async views | Creating Django projects |
| **fastapi-pro** | sonnet | api-scaffolding | FastAPI with async patterns and Pydantic | Building FastAPI applications |
| **unity-developer** | sonnet | game-development | Unity game development and optimization | Developing Unity games |
| **minecraft-bukkit-pro** | sonnet | game-development | Minecraft server plugin development | Creating Minecraft plugins |
| **sql-pro** | sonnet | database-design | Complex SQL queries and database optimization | Writing SQL queries, optimizing databases |
| **arm-cortex-expert** | sonnet | arm-cortex-microcontrollers | ARM Cortex-M firmware and peripheral driver development | Developing ARM Cortex firmware |

### Infrastructure & Operations (12 agents)

#### DevOps & Deployment

| Agent | Model | Plugin | Description | Use When |
|-------|-------|--------|-------------|----------|
| **devops-troubleshooter** | sonnet | incident-response | Production debugging, log analysis, deployment troubleshooting | Debugging production issues |
| **deployment-engineer** | sonnet | cloud-infrastructure | CI/CD pipelines, containerization, cloud deployments | Setting up CI/CD, deploying applications |
| **terraform-specialist** | sonnet | cloud-infrastructure | Infrastructure as Code with Terraform modules and state management | Writing Terraform configurations |
| **dx-optimizer** | sonnet | team-collaboration | Developer experience optimization and tooling improvements | Improving developer workflows |

#### Database Management

| Agent | Model | Plugin | Description | Use When |
|-------|-------|--------|-------------|----------|
| **database-optimizer** | sonnet | observability-monitoring | Query optimization, index design, migration strategies | Optimizing database performance |
| **database-admin** | sonnet | database-migrations | Database operations, backup, replication, monitoring | Managing database operations |
| **database-architect** | opus | database-design | Database design from scratch, technology selection, schema modeling | Designing database schemas |

#### Incident Response & Network

| Agent | Model | Plugin | Description | Use When |
|-------|-------|--------|-------------|----------|
| **incident-responder** | opus | incident-response | Production incident management and resolution | Handling production incidents |
| **network-engineer** | sonnet | observability-monitoring | Network debugging, load balancing, traffic analysis | Debugging network issues |

### Quality Assurance & Security (13 agents)

#### Code Quality & Review

| Agent | Model | Plugin | Description | Use When |
|-------|-------|--------|-------------|----------|
| **code-reviewer** | opus | comprehensive-review | Code review with security focus and production reliability | Reviewing code changes |
| **security-auditor** | opus | comprehensive-review | Vulnerability assessment and OWASP compliance | Performing security audits |
| **backend-security-coder** | opus | data-validation-suite | Secure backend coding practices, API security implementation | Implementing backend security |
| **frontend-security-coder** | opus | frontend-mobile-security | XSS prevention, CSP implementation, client-side security | Implementing frontend security |
| **mobile-security-coder** | opus | frontend-mobile-security | Mobile security patterns, WebView security, biometric auth | Securing mobile applications |

#### Testing & Debugging

| Agent | Model | Plugin | Description | Use When |
|-------|-------|--------|-------------|----------|
| **test-automator** | sonnet | codebase-cleanup | Comprehensive test suite creation (unit, integration, e2e) | Generating tests |
| **tdd-orchestrator** | sonnet | backend-development | Test-Driven Development methodology guidance | Following TDD practices |
| **debugger** | sonnet | error-debugging | Error resolution and test failure analysis | Debugging errors |
| **error-detective** | sonnet | error-debugging | Log analysis and error pattern recognition | Analyzing error logs |

#### Performance & Observability

| Agent | Model | Plugin | Description | Use When |
|-------|-------|--------|-------------|----------|
| **performance-engineer** | opus | observability-monitoring | Application profiling and optimization | Optimizing application performance |
| **observability-engineer** | opus | observability-monitoring | Production monitoring, distributed tracing, SLI/SLO management | Setting up observability |
| **search-specialist** | haiku | content-marketing | Advanced web research and information synthesis | Researching information |

### Data & AI (8 agents)

#### Data Engineering & Analytics

| Agent | Model | Plugin | Description | Use When |
|-------|-------|--------|-------------|----------|
| **data-scientist** | opus | machine-learning-ops | Data analysis, SQL queries, BigQuery operations | Analyzing data |
| **data-engineer** | sonnet | data-engineering | ETL pipelines, data warehouses, streaming architectures | Building data pipelines |

#### Machine Learning & AI

| Agent | Model | Plugin | Description | Use When |
|-------|-------|--------|-------------|----------|
| **ai-engineer** | opus | llm-application-dev | LLM applications, RAG systems, prompt pipelines | Building LLM applications |
| **ml-engineer** | opus | machine-learning-ops | ML pipelines, model serving, feature engineering | Developing ML pipelines |
| **mlops-engineer** | opus | machine-learning-ops | ML infrastructure, experiment tracking, model registries | Setting up MLOps infrastructure |
| **prompt-engineer** | opus | llm-application-dev | LLM prompt optimization and engineering | Optimizing LLM prompts |

### Documentation & Technical Writing (6 agents)

| Agent | Model | Plugin | Description | Use When |
|-------|-------|--------|-------------|----------|
| **docs-architect** | opus | code-documentation | Comprehensive technical documentation generation | Creating technical documentation |
| **api-documenter** | sonnet | api-testing-observability | OpenAPI/Swagger specifications and developer docs | Documenting APIs |
| **reference-builder** | haiku | documentation-generation | Technical references and API documentation | Building reference documentation |
| **tutorial-engineer** | sonnet | code-documentation | Step-by-step tutorials and educational content | Creating tutorials |
| **mermaid-expert** | sonnet | documentation-generation | Diagram creation (flowcharts, sequences, ERDs) | Creating diagrams |

### Business & Operations (11 agents)

#### Business Analysis & Finance

| Agent | Model | Plugin | Description | Use When |
|-------|-------|--------|-------------|----------|
| **business-analyst** | sonnet | business-analytics | Metrics analysis, reporting, KPI tracking | Analyzing business metrics |
| **quant-analyst** | opus | quantitative-trading | Financial modeling, trading strategies, market analysis | Building trading strategies |
| **risk-manager** | sonnet | quantitative-trading | Portfolio risk monitoring and management | Managing financial risk |

#### Marketing & Sales

| Agent | Model | Plugin | Description | Use When |
|-------|-------|--------|-------------|----------|
| **content-marketer** | sonnet | content-marketing | Blog posts, social media, email campaigns | Creating marketing content |
| **sales-automator** | haiku | customer-sales-automation | Cold emails, follow-ups, proposal generation | Automating sales workflows |

#### Support & Legal

| Agent | Model | Plugin | Description | Use When |
|-------|-------|--------|-------------|----------|
| **customer-support** | sonnet | customer-sales-automation | Support tickets, FAQ responses, customer communication | Handling customer support |
| **hr-pro** | opus | hr-legal-compliance | HR operations, policies, employee relations | Managing HR processes |
| **legal-advisor** | opus | hr-legal-compliance | Privacy policies, terms of service, legal documentation | Creating legal documents |

### SEO & Content Optimization (10 agents)

| Agent | Model | Plugin | Description | Use When |
|-------|-------|--------|-------------|----------|
| **seo-content-auditor** | sonnet | seo-content-creation | Content quality analysis, E-E-A-T signals assessment | Auditing SEO content |
| **seo-meta-optimizer** | haiku | seo-technical-optimization | Meta title and description optimization | Optimizing meta tags |
| **seo-keyword-strategist** | haiku | seo-technical-optimization | Keyword analysis and semantic variations | Developing keyword strategy |
| **seo-structure-architect** | haiku | seo-technical-optimization | Content structure and schema markup | Structuring content for SEO |
| **seo-snippet-hunter** | haiku | seo-technical-optimization | Featured snippet formatting | Optimizing for featured snippets |
| **seo-content-refresher** | haiku | seo-analysis-monitoring | Content freshness analysis | Refreshing existing content |
| **seo-cannibalization-detector** | haiku | seo-analysis-monitoring | Keyword overlap detection | Detecting content cannibalization |
| **seo-authority-builder** | sonnet | seo-analysis-monitoring | E-E-A-T signal analysis | Building content authority |
| **seo-content-writer** | sonnet | seo-content-creation | SEO-optimized content creation | Writing SEO content |
| **seo-content-planner** | haiku | seo-content-creation | Content planning and topic clusters | Planning content strategy |

### Specialized Domains (5 agents)

| Agent | Model | Plugin | Description | Use When |
|-------|-------|--------|-------------|----------|
| **blockchain-developer** | sonnet | blockchain-web3 | Web3 apps, smart contracts, DeFi protocols | Developing blockchain applications |
| **payment-integration** | sonnet | payment-processing | Payment processor integration (Stripe, PayPal) | Integrating payment systems |
| **legacy-modernizer** | sonnet | framework-migration | Legacy code refactoring and modernization | Modernizing legacy code |
| **context-manager** | haiku | agent-orchestration | Multi-agent context management | Managing multi-agent contexts |

---

## Agent Skills Reference

### Skills by Plugin

#### Kubernetes Operations (4 skills)

**k8s-manifest-generator**
- **Description**: Create production-ready Kubernetes manifests for Deployments, Services, ConfigMaps, and Secrets
- **Use When**: Setting up Kubernetes deployments, creating K8s resources
- **Activation Trigger**: "Kubernetes deployment", "K8s manifest", "create deployment"
- **Key Features**:
  - Deployment best practices
  - Resource limits and requests
  - Health checks (liveness/readiness)
  - ConfigMap and Secret management

**helm-chart-scaffolding**
- **Description**: Design, organize, and manage Helm charts for templating and packaging K8s applications
- **Use When**: Creating Helm charts, templating Kubernetes resources
- **Activation Trigger**: "Helm chart", "Helm template", "package Kubernetes"
- **Key Features**:
  - Chart structure and organization
  - Values.yaml configuration
  - Template helpers and functions
  - Chart dependencies

**gitops-workflow**
- **Description**: Implement GitOps workflows with ArgoCD and Flux for automated, declarative deployments
- **Use When**: Setting up GitOps, implementing continuous deployment
- **Activation Trigger**: "GitOps", "ArgoCD", "Flux", "declarative deployment"
- **Key Features**:
  - ArgoCD configuration
  - Flux setup and syncing
  - Git repository structure
  - Automated rollbacks

**k8s-security-policies**
- **Description**: Implement Kubernetes security policies including NetworkPolicy, PodSecurityPolicy, and RBAC
- **Use When**: Securing Kubernetes clusters, implementing security policies
- **Activation Trigger**: "K8s security", "NetworkPolicy", "RBAC", "PodSecurityPolicy"
- **Key Features**:
  - Network isolation
  - Pod security standards
  - Role-based access control
  - Security contexts

#### LLM Application Development (4 skills)

**langchain-architecture**
- **Description**: Design LLM applications using LangChain framework with agents, memory, and tool integration
- **Use When**: Building LangChain applications, implementing AI agents
- **Activation Trigger**: "LangChain", "LLM agent", "AI agent framework"
- **Key Features**:
  - Agent architectures
  - Memory systems
  - Tool integration
  - Chain composition

**prompt-engineering-patterns**
- **Description**: Master advanced prompt engineering techniques for LLM performance and reliability
- **Use When**: Optimizing LLM prompts, improving AI output quality
- **Activation Trigger**: "prompt engineering", "optimize prompt", "LLM prompt"
- **Key Features**:
  - Prompt templates
  - Few-shot learning
  - Chain-of-thought prompting
  - Prompt optimization

**rag-implementation**
- **Description**: Build Retrieval-Augmented Generation systems with vector databases and semantic search
- **Use When**: Building RAG systems, implementing document Q&A
- **Activation Trigger**: "RAG", "retrieval augmented", "vector database", "semantic search"
- **Key Features**:
  - Vector database setup
  - Document chunking strategies
  - Embedding generation
  - Retrieval optimization

**llm-evaluation**
- **Description**: Implement comprehensive evaluation strategies with automated metrics and benchmarking
- **Use When**: Evaluating LLM performance, testing AI applications
- **Activation Trigger**: "LLM evaluation", "AI testing", "benchmark LLM"
- **Key Features**:
  - Automated metrics
  - Human feedback loops
  - Benchmark datasets
  - Performance tracking

#### Backend Development (3 skills)

**api-design-principles**
- **Description**: Master REST and GraphQL API design for intuitive, scalable, and maintainable APIs
- **Use When**: Designing APIs, establishing API standards
- **Activation Trigger**: "API design", "REST API", "GraphQL schema"
- **Key Features**:
  - RESTful best practices
  - GraphQL schema design
  - API versioning
  - Error handling patterns

**architecture-patterns**
- **Description**: Implement Clean Architecture, Hexagonal Architecture, and Domain-Driven Design
- **Use When**: Architecting complex backend systems, refactoring for maintainability
- **Activation Trigger**: "clean architecture", "hexagonal architecture", "DDD", "domain-driven design"
- **Key Features**:
  - Layered architecture
  - Dependency injection
  - Domain modeling
  - Bounded contexts

**microservices-patterns**
- **Description**: Design microservices with service boundaries, event-driven communication, and resilience
- **Use When**: Building microservices, decomposing monoliths
- **Activation Trigger**: "microservices", "service boundaries", "event-driven"
- **Key Features**:
  - Service decomposition
  - Inter-service communication
  - Circuit breakers
  - Saga patterns

#### Blockchain & Web3 (4 skills)

**defi-protocol-templates**
- **Description**: Implement DeFi protocols with templates for staking, AMMs, governance, and lending
- **Use When**: Building DeFi protocols, implementing smart contracts
- **Activation Trigger**: "DeFi", "staking", "AMM", "liquidity pool", "governance"
- **Key Features**:
  - Staking mechanisms
  - Automated market makers
  - Governance voting
  - Lending protocols

**nft-standards**
- **Description**: Implement NFT standards (ERC-721, ERC-1155) with metadata and marketplace integration
- **Use When**: Creating NFT collections, implementing NFT functionality
- **Activation Trigger**: "NFT", "ERC-721", "ERC-1155", "token metadata"
- **Key Features**:
  - Token standards
  - Metadata management
  - Marketplace integration
  - Royalty mechanisms

**solidity-security**
- **Description**: Master smart contract security to prevent vulnerabilities and implement secure patterns
- **Use When**: Auditing smart contracts, implementing security best practices
- **Activation Trigger**: "smart contract security", "Solidity security", "audit contract"
- **Key Features**:
  - Common vulnerabilities (reentrancy, overflow)
  - Security patterns
  - Access control
  - Testing strategies

**web3-testing**
- **Description**: Test smart contracts using Hardhat and Foundry with unit tests and mainnet forking
- **Use When**: Testing smart contracts, setting up blockchain testing
- **Activation Trigger**: "smart contract testing", "Hardhat", "Foundry", "mainnet fork"
- **Key Features**:
  - Unit testing
  - Integration testing
  - Mainnet forking
  - Gas optimization testing

#### CI/CD Automation (4 skills)

**deployment-pipeline-design**
- **Description**: Design multi-stage CI/CD pipelines with approval gates and security checks
- **Use When**: Setting up CI/CD, designing deployment pipelines
- **Activation Trigger**: "CI/CD pipeline", "deployment pipeline", "continuous deployment"
- **Key Features**:
  - Multi-stage pipelines
  - Approval workflows
  - Security scanning
  - Rollback strategies

**github-actions-templates**
- **Description**: Create production-ready GitHub Actions workflows for testing, building, and deploying
- **Use When**: Setting up GitHub Actions, automating workflows
- **Activation Trigger**: "GitHub Actions", "workflow automation", "GHA"
- **Key Features**:
  - Workflow templates
  - Matrix builds
  - Secrets management
  - Deployment actions

**gitlab-ci-patterns**
- **Description**: Build GitLab CI/CD pipelines with multi-stage workflows and distributed runners
- **Use When**: Setting up GitLab CI, configuring pipelines
- **Activation Trigger**: "GitLab CI", ".gitlab-ci.yml", "GitLab pipeline"
- **Key Features**:
  - Pipeline configuration
  - Runner setup
  - Cache optimization
  - Deployment stages

**secrets-management**
- **Description**: Implement secure secrets management using Vault, AWS Secrets Manager, or native solutions
- **Use When**: Managing secrets, implementing secure credential storage
- **Activation Trigger**: "secrets management", "Vault", "AWS Secrets Manager", "credentials"
- **Key Features**:
  - HashiCorp Vault integration
  - Cloud secrets managers
  - Secret rotation
  - Access policies

#### Cloud Infrastructure (4 skills)

**terraform-module-library**
- **Description**: Build reusable Terraform modules for AWS, Azure, and GCP infrastructure
- **Use When**: Writing Terraform, creating reusable IaC modules
- **Activation Trigger**: "Terraform module", "IaC", "infrastructure as code"
- **Key Features**:
  - Module structure
  - Input variables
  - Output values
  - Module composition

**multi-cloud-architecture**
- **Description**: Design multi-cloud architectures avoiding vendor lock-in
- **Use When**: Planning multi-cloud strategy, designing cloud-agnostic systems
- **Activation Trigger**: "multi-cloud", "cloud agnostic", "vendor lock-in"
- **Key Features**:
  - Cloud abstraction patterns
  - Service mapping across clouds
  - Data synchronization
  - Disaster recovery

**hybrid-cloud-networking**
- **Description**: Configure secure connectivity between on-premises and cloud platforms
- **Use When**: Setting up hybrid cloud, connecting on-prem to cloud
- **Activation Trigger**: "hybrid cloud", "VPN", "Direct Connect", "ExpressRoute"
- **Key Features**:
  - VPN configurations
  - Direct Connect/ExpressRoute
  - Network topology
  - Security groups

**cost-optimization**
- **Description**: Optimize cloud costs through rightsizing, tagging, and reserved instances
- **Use When**: Reducing cloud costs, optimizing resource usage
- **Activation Trigger**: "cost optimization", "cloud costs", "rightsizing"
- **Key Features**:
  - Resource tagging
  - Rightsizing recommendations
  - Reserved instances
  - Cost allocation

#### Framework Migration (4 skills)

**react-modernization**
- **Description**: Upgrade React apps, migrate to hooks, and adopt concurrent features
- **Use When**: Modernizing React applications, upgrading React versions
- **Activation Trigger**: "React upgrade", "migrate to hooks", "React 18", "concurrent mode"
- **Key Features**:
  - Class to hooks migration
  - Concurrent features
  - Suspense and transitions
  - Migration strategies

**angular-migration**
- **Description**: Migrate from AngularJS to Angular using hybrid mode and incremental rewriting
- **Use When**: Migrating AngularJS applications to Angular
- **Activation Trigger**: "AngularJS migration", "Angular upgrade", "hybrid mode"
- **Key Features**:
  - Hybrid mode setup
  - Incremental migration
  - Component migration
  - Service updates

**database-migration**
- **Description**: Execute database migrations with zero-downtime strategies and transformations
- **Use When**: Migrating databases, performing schema changes
- **Activation Trigger**: "database migration", "zero downtime", "schema change"
- **Key Features**:
  - Migration planning
  - Zero-downtime strategies
  - Data transformations
  - Rollback procedures

**dependency-upgrade**
- **Description**: Manage major dependency upgrades with compatibility analysis and testing
- **Use When**: Upgrading dependencies, managing breaking changes
- **Activation Trigger**: "dependency upgrade", "breaking changes", "major version"
- **Key Features**:
  - Compatibility analysis
  - Breaking change detection
  - Upgrade strategies
  - Testing approaches

#### Observability & Monitoring (4 skills)

**prometheus-configuration**
- **Description**: Set up Prometheus for comprehensive metric collection and monitoring
- **Use When**: Setting up Prometheus, configuring monitoring
- **Activation Trigger**: "Prometheus", "metric collection", "monitoring setup"
- **Key Features**:
  - Prometheus configuration
  - Service discovery
  - Alerting rules
  - Recording rules

**grafana-dashboards**
- **Description**: Create production Grafana dashboards for real-time system visualization
- **Use When**: Creating monitoring dashboards, visualizing metrics
- **Activation Trigger**: "Grafana", "dashboard", "visualization"
- **Key Features**:
  - Dashboard design
  - Panel configuration
  - Template variables
  - Alerting integration

**distributed-tracing**
- **Description**: Implement distributed tracing with Jaeger and Tempo to track requests
- **Use When**: Implementing tracing, debugging distributed systems
- **Activation Trigger**: "distributed tracing", "Jaeger", "Tempo", "trace requests"
- **Key Features**:
  - Tracing setup
  - Span instrumentation
  - Context propagation
  - Trace analysis

**slo-implementation**
- **Description**: Define SLIs and SLOs with error budgets and alerting
- **Use When**: Setting up SLO monitoring, defining reliability targets
- **Activation Trigger**: "SLO", "SLI", "error budget", "reliability"
- **Key Features**:
  - SLI definition
  - SLO targets
  - Error budget calculation
  - Alert policies

#### Payment Processing (4 skills)

**stripe-integration**
- **Description**: Implement Stripe payment processing for checkout, subscriptions, and webhooks
- **Use When**: Integrating Stripe, implementing payment processing
- **Activation Trigger**: "Stripe", "payment processing", "checkout", "subscription"
- **Key Features**:
  - Checkout integration
  - Subscription management
  - Webhook handling
  - Payment intents

**paypal-integration**
- **Description**: Integrate PayPal payment processing with express checkout and subscriptions
- **Use When**: Integrating PayPal, implementing alternative payment methods
- **Activation Trigger**: "PayPal", "express checkout", "PayPal subscription"
- **Key Features**:
  - Express checkout
  - Subscription billing
  - IPN handling
  - Refunds and disputes

**pci-compliance**
- **Description**: Implement PCI DSS compliance for secure payment card data handling
- **Use When**: Implementing payment security, achieving PCI compliance
- **Activation Trigger**: "PCI DSS", "payment security", "card data"
- **Key Features**:
  - PCI requirements
  - Tokenization
  - Secure transmission
  - Audit logging

**billing-automation**
- **Description**: Build automated billing systems for recurring payments and invoicing
- **Use When**: Building billing systems, automating invoicing
- **Activation Trigger**: "billing automation", "invoicing", "recurring payments"
- **Key Features**:
  - Invoice generation
  - Payment scheduling
  - Dunning management
  - Proration logic

#### Python Development (5 skills)

**async-python-patterns**
- **Description**: Master Python asyncio, concurrent programming, and async/await patterns
- **Use When**: Implementing async Python, building high-performance applications
- **Activation Trigger**: "Python async", "asyncio", "concurrent", "async/await"
- **Key Features**:
  - Async/await syntax
  - Event loops
  - Concurrent tasks
  - Async context managers

**python-testing-patterns**
- **Description**: Implement comprehensive testing with pytest, fixtures, and mocking
- **Use When**: Writing Python tests, setting up test infrastructure
- **Activation Trigger**: "pytest", "Python testing", "fixtures", "mocking"
- **Key Features**:
  - Pytest configuration
  - Fixture patterns
  - Mocking strategies
  - Test organization

**python-packaging**
- **Description**: Create distributable Python packages with proper structure and PyPI publishing
- **Use When**: Creating Python packages, publishing to PyPI
- **Activation Trigger**: "Python package", "PyPI", "setup.py", "pyproject.toml"
- **Key Features**:
  - Package structure
  - pyproject.toml configuration
  - PyPI publishing
  - Version management

**python-performance-optimization**
- **Description**: Profile and optimize Python code using cProfile and performance best practices
- **Use When**: Optimizing Python code, debugging performance issues
- **Activation Trigger**: "Python performance", "profiling", "optimization", "cProfile"
- **Key Features**:
  - Profiling tools
  - Performance patterns
  - Memory optimization
  - Cython integration

**uv-package-manager**
- **Description**: Master the uv package manager for fast dependency management and virtual environments
- **Use When**: Using uv for Python projects, managing dependencies
- **Activation Trigger**: "uv", "Python package manager", "fast dependencies"
- **Key Features**:
  - uv installation
  - Dependency resolution
  - Virtual environments
  - Lockfile management

#### JavaScript/TypeScript (4 skills)

**typescript-advanced-types**
- **Description**: Master TypeScript's advanced type system including generics and conditional types
- **Use When**: Working with complex TypeScript types, type utilities
- **Activation Trigger**: "TypeScript types", "generics", "conditional types", "type utilities"
- **Key Features**:
  - Generics and constraints
  - Conditional types
  - Mapped types
  - Template literal types

**nodejs-backend-patterns**
- **Description**: Build production-ready Node.js services with Express/Fastify and best practices
- **Use When**: Building Node.js backends, creating APIs
- **Activation Trigger**: "Node.js backend", "Express", "Fastify", "Node API"
- **Key Features**:
  - Express/Fastify patterns
  - Middleware architecture
  - Error handling
  - Authentication

**javascript-testing-patterns**
- **Description**: Implement comprehensive testing with Jest, Vitest, and Testing Library
- **Use When**: Testing JavaScript/TypeScript, setting up test infrastructure
- **Activation Trigger**: "Jest", "Vitest", "Testing Library", "JavaScript testing"
- **Key Features**:
  - Jest configuration
  - Testing Library patterns
  - Mocking strategies
  - Snapshot testing

**modern-javascript-patterns**
- **Description**: Master ES6+ features including async/await, destructuring, and functional programming
- **Use When**: Writing modern JavaScript, refactoring legacy code
- **Activation Trigger**: "ES6+", "modern JavaScript", "async/await", "destructuring"
- **Key Features**:
  - ES6+ syntax
  - Functional programming
  - Module systems
  - Async patterns

#### API Scaffolding (1 skill)

**fastapi-templates**
- **Description**: Create production-ready FastAPI projects with async patterns and error handling
- **Use When**: Creating FastAPI projects, setting up API structure
- **Activation Trigger**: "FastAPI project", "FastAPI template", "API scaffolding"
- **Key Features**:
  - Project structure
  - Async endpoints
  - Error handling
  - API documentation

#### Machine Learning Operations (1 skill)

**ml-pipeline-workflow**
- **Description**: Build end-to-end MLOps pipelines from data preparation through deployment
- **Use When**: Building ML pipelines, setting up MLOps
- **Activation Trigger**: "ML pipeline", "MLOps", "model deployment"
- **Key Features**:
  - Data preprocessing
  - Model training
  - Model serving
  - Monitoring and retraining

#### Security Scanning (1 skill)

**sast-configuration**
- **Description**: Configure Static Application Security Testing tools for vulnerability detection
- **Use When**: Setting up SAST, configuring security scanning
- **Activation Trigger**: "SAST", "static analysis", "security scanning"
- **Key Features**:
  - Tool configuration
  - Rule customization
  - False positive management
  - CI/CD integration

---

## Plugin Reference

### Quick Reference Table

| Category | Plugin Count | Notable Plugins |
|----------|-------------|-----------------|
| Development | 4 | debugging-toolkit, backend-development, frontend-mobile-development |
| Documentation | 2 | code-documentation, documentation-generation |
| Workflows | 3 | git-pr-workflows, full-stack-orchestration, tdd-workflows |
| Testing | 2 | unit-testing, tdd-workflows |
| Quality | 3 | code-review-ai, comprehensive-review, performance-testing-review |
| AI & ML | 4 | llm-application-dev, agent-orchestration, machine-learning-ops |
| Data | 2 | data-engineering, data-validation-suite |
| Database | 2 | database-design, database-migrations |
| Operations | 4 | incident-response, error-diagnostics, distributed-debugging |
| Performance | 2 | application-performance, database-cloud-optimization |
| Infrastructure | 5 | kubernetes-operations, cloud-infrastructure, cicd-automation |
| Security | 4 | security-scanning, security-compliance, backend-api-security |
| Languages | 7 | python-development, javascript-typescript, systems-programming |
| Blockchain | 1 | blockchain-web3 |
| Finance | 1 | quantitative-trading |
| Payments | 1 | payment-processing |
| Gaming | 1 | game-development |
| Marketing | 4 | seo-content-creation, seo-technical-optimization |
| Business | 3 | business-analytics, hr-legal-compliance |

### Detailed Plugin Catalog

#### Development (4 plugins)

**debugging-toolkit**
- **Purpose**: Interactive debugging and DX optimization
- **Components**:
  - Agents: debugger, dx-optimizer
  - Commands: smart-debug
- **Use Cases**: Smart debugging, error analysis, developer experience improvements
- **Install**: `/plugin install debugging-toolkit`

**backend-development**
- **Purpose**: Backend API design with GraphQL and TDD
- **Components**:
  - Agents: backend-architect, graphql-architect, tdd-orchestrator
  - Commands: feature-development
  - Skills: api-design-principles, architecture-patterns, microservices-patterns
- **Use Cases**: API design, microservices architecture, test-driven development
- **Install**: `/plugin install backend-development`

**frontend-mobile-development**
- **Purpose**: Frontend UI and mobile development
- **Components**:
  - Agents: frontend-developer, mobile-developer
  - Commands: component-scaffold
- **Use Cases**: React components, React Native apps, UI development
- **Install**: `/plugin install frontend-mobile-development`

**multi-platform-apps**
- **Purpose**: Cross-platform app coordination (web/iOS/Android)
- **Components**:
  - Agents: frontend-developer, mobile-developer, ios-developer, flutter-expert, ui-ux-designer
  - Commands: multi-platform
- **Use Cases**: Cross-platform development, multi-platform coordination
- **Install**: `/plugin install multi-platform-apps`

#### Documentation (2 plugins)

**code-documentation**
- **Purpose**: Documentation generation and code explanation
- **Components**:
  - Agents: docs-architect, tutorial-engineer, code-reviewer
  - Commands: doc-generate, code-explain
- **Use Cases**: Technical documentation, code explanation, tutorial creation
- **Install**: `/plugin install code-documentation`

**documentation-generation**
- **Purpose**: OpenAPI specs, Mermaid diagrams, tutorials
- **Components**:
  - Agents: reference-builder, mermaid-expert
  - Commands: doc-generate
- **Use Cases**: API documentation, diagram generation, reference documentation
- **Install**: `/plugin install documentation-generation`

#### Workflows (3 plugins)

**git-pr-workflows**
- **Purpose**: Git automation and PR enhancement
- **Components**:
  - Commands: pr-enhance, onboard, git-workflow
- **Use Cases**: Pull request enhancement, team onboarding, git automation
- **Install**: `/plugin install git-pr-workflows`

**full-stack-orchestration**
- **Purpose**: End-to-end feature orchestration
- **Components**:
  - Commands: full-stack-feature
- **Use Cases**: Complete feature development, multi-agent coordination
- **Install**: `/plugin install full-stack-orchestration`

**tdd-workflows**
- **Purpose**: Test-driven development methodology
- **Components**:
  - Commands: tdd-cycle, tdd-red, tdd-green, tdd-refactor
- **Use Cases**: TDD workflows, red-green-refactor cycles
- **Install**: `/plugin install tdd-workflows`

#### Infrastructure (5 plugins)

**kubernetes-operations**
- **Purpose**: K8s manifests and GitOps workflows
- **Components**:
  - Agents: kubernetes-architect
  - Commands: k8s-deploy
  - Skills: k8s-manifest-generator, helm-chart-scaffolding, gitops-workflow, k8s-security-policies
- **Use Cases**: Kubernetes deployments, Helm charts, GitOps
- **Install**: `/plugin install kubernetes-operations`

**cloud-infrastructure**
- **Purpose**: AWS/Azure/GCP cloud architecture
- **Components**:
  - Agents: cloud-architect, deployment-engineer, terraform-specialist, network-engineer, hybrid-cloud-architect
  - Skills: terraform-module-library, multi-cloud-architecture, hybrid-cloud-networking, cost-optimization
- **Use Cases**: Cloud architecture, infrastructure as code, cost optimization
- **Install**: `/plugin install cloud-infrastructure`

**cicd-automation**
- **Purpose**: CI/CD pipeline configuration
- **Components**:
  - Agents: deployment-engineer, terraform-specialist, devops-troubleshooter, kubernetes-architect
  - Commands: workflow-automate
  - Skills: deployment-pipeline-design, github-actions-templates, gitlab-ci-patterns, secrets-management
- **Use Cases**: CI/CD pipelines, deployment automation
- **Install**: `/plugin install cicd-automation`

**deployment-strategies**
- **Purpose**: Deployment patterns and rollback automation
- **Components**:
  - Agents: deployment-engineer
- **Use Cases**: Blue-green deployment, canary releases, rollback strategies
- **Install**: `/plugin install deployment-strategies`

**deployment-validation**
- **Purpose**: Pre-deployment checks and validation
- **Components**:
  - Commands: config-validate
- **Use Cases**: Configuration validation, pre-deployment checks
- **Install**: `/plugin install deployment-validation`

#### Security (4 plugins)

**security-scanning**
- **Purpose**: SAST analysis and vulnerability scanning
- **Components**:
  - Agents: security-auditor
  - Commands: security-hardening, security-sast, security-dependencies
  - Skills: sast-configuration
- **Use Cases**: Security audits, vulnerability scanning, OWASP compliance
- **Install**: `/plugin install security-scanning`

**security-compliance**
- **Purpose**: SOC2/HIPAA/GDPR compliance
- **Components**:
  - Commands: compliance-check
- **Use Cases**: Compliance audits, regulatory requirements
- **Install**: `/plugin install security-compliance`

**backend-api-security**
- **Purpose**: API security and authentication
- **Components**:
  - Agents: backend-security-coder, backend-architect
- **Use Cases**: API security, authentication, authorization
- **Install**: `/plugin install backend-api-security`

**frontend-mobile-security**
- **Purpose**: XSS/CSRF prevention and mobile security
- **Components**:
  - Agents: frontend-security-coder, mobile-security-coder
  - Commands: xss-scan
- **Use Cases**: Frontend security, mobile app security, XSS prevention
- **Install**: `/plugin install frontend-mobile-security`

#### Languages (7 plugins)

**python-development**
- **Purpose**: Python 3.12+ with Django/FastAPI
- **Components**:
  - Agents: python-pro, django-pro, fastapi-pro
  - Commands: python-scaffold
  - Skills: async-python-patterns, python-testing-patterns, python-packaging, python-performance-optimization, uv-package-manager
- **Use Cases**: Python development, FastAPI projects, Django applications
- **Install**: `/plugin install python-development`

**javascript-typescript**
- **Purpose**: JavaScript/TypeScript with Node.js
- **Components**:
  - Agents: javascript-pro, typescript-pro
  - Commands: typescript-scaffold
  - Skills: typescript-advanced-types, nodejs-backend-patterns, javascript-testing-patterns, modern-javascript-patterns
- **Use Cases**: TypeScript development, Node.js backends, JavaScript applications
- **Install**: `/plugin install javascript-typescript`

**systems-programming**
- **Purpose**: Rust, Go, C, C++ for systems development
- **Components**:
  - Agents: rust-pro, golang-pro, c-pro, cpp-pro
  - Commands: rust-project
- **Use Cases**: Systems programming, low-level development
- **Install**: `/plugin install systems-programming`

**jvm-languages**
- **Purpose**: Java, Scala, C# with enterprise patterns
- **Components**:
  - Agents: java-pro, scala-pro, csharp-pro
- **Use Cases**: Enterprise Java, Scala applications, C# development
- **Install**: `/plugin install jvm-languages`

**web-scripting**
- **Purpose**: PHP and Ruby for web applications
- **Components**:
  - Agents: php-pro, ruby-pro
- **Use Cases**: PHP development, Ruby on Rails
- **Install**: `/plugin install web-scripting`

**functional-programming**
- **Purpose**: Elixir with OTP and Phoenix
- **Components**:
  - Agents: elixir-pro
- **Use Cases**: Elixir development, Phoenix applications
- **Install**: `/plugin install functional-programming`

**arm-cortex-microcontrollers**
- **Purpose**: ARM Cortex-M firmware and drivers
- **Components**:
  - Agents: arm-cortex-expert
- **Use Cases**: Embedded systems, firmware development
- **Install**: `/plugin install arm-cortex-microcontrollers`

#### AI & ML (4 plugins)

**llm-application-dev**
- **Purpose**: LLM apps and prompt engineering
- **Components**:
  - Agents: ai-engineer, prompt-engineer
  - Commands: langchain-agent, ai-assistant, prompt-optimize
  - Skills: langchain-architecture, prompt-engineering-patterns, rag-implementation, llm-evaluation
- **Use Cases**: LLM applications, RAG systems, prompt optimization
- **Install**: `/plugin install llm-application-dev`

**machine-learning-ops**
- **Purpose**: ML training pipelines and MLOps
- **Components**:
  - Agents: ml-engineer, mlops-engineer, data-scientist
  - Commands: ml-pipeline
  - Skills: ml-pipeline-workflow
- **Use Cases**: ML pipelines, model deployment, experiment tracking
- **Install**: `/plugin install machine-learning-ops`

**agent-orchestration**
- **Purpose**: Multi-agent system optimization
- **Components**:
  - Agents: context-manager
  - Commands: multi-agent-optimize, improve-agent
- **Use Cases**: Multi-agent coordination, agent optimization
- **Install**: `/plugin install agent-orchestration`

**context-management**
- **Purpose**: Context persistence and restoration
- **Components**:
  - Agents: context-manager
  - Commands: context-save, context-restore
- **Use Cases**: Session continuity, context preservation
- **Install**: `/plugin install context-management`

---

## Command Reference

### Development Commands

| Command | Description | Example |
|---------|-------------|---------|
| `/backend-development:feature-development` | End-to-end backend feature development | `/backend-development:feature-development user authentication` |
| `/full-stack-orchestration:full-stack-feature` | Complete full-stack feature implementation | `/full-stack-orchestration:full-stack-feature "payment processing"` |
| `/multi-platform-apps:multi-platform` | Cross-platform app development coordination | `/multi-platform-apps:multi-platform "todo app"` |
| `/python-development:python-scaffold` | FastAPI/Django project setup | `/python-development:python-scaffold fastapi-microservice` |
| `/javascript-typescript:typescript-scaffold` | Next.js/React + Vite setup | `/javascript-typescript:typescript-scaffold nextjs-app` |
| `/systems-programming:rust-project` | Rust project scaffolding | `/systems-programming:rust-project cli-tool` |

### Testing Commands

| Command | Description | Example |
|---------|-------------|---------|
| `/unit-testing:test-generate` | Generate comprehensive unit tests | `/unit-testing:test-generate src/api/users.py` |
| `/tdd-workflows:tdd-cycle` | Complete TDD red-green-refactor cycle | `/tdd-workflows:tdd-cycle "user registration"` |
| `/tdd-workflows:tdd-red` | Write failing tests first | `/tdd-workflows:tdd-red "password validation"` |
| `/tdd-workflows:tdd-green` | Implement code to pass tests | `/tdd-workflows:tdd-green` |
| `/tdd-workflows:tdd-refactor` | Refactor with passing tests | `/tdd-workflows:tdd-refactor` |

### Security Commands

| Command | Description | Example |
|---------|-------------|---------|
| `/security-scanning:security-hardening` | Comprehensive security hardening | `/security-scanning:security-hardening --level comprehensive` |
| `/security-scanning:security-sast` | Static application security testing | `/security-scanning:security-sast` |
| `/security-scanning:security-dependencies` | Dependency vulnerability scanning | `/security-scanning:security-dependencies` |
| `/security-compliance:compliance-check` | SOC2/HIPAA/GDPR compliance | `/security-compliance:compliance-check SOC2` |
| `/frontend-mobile-security:xss-scan` | XSS vulnerability scanning | `/frontend-mobile-security:xss-scan` |

### Infrastructure Commands

| Command | Description | Example |
|---------|-------------|---------|
| `/kubernetes-operations:k8s-deploy` | Kubernetes deployment automation | `/kubernetes-operations:k8s-deploy production` |
| `/cicd-automation:workflow-automate` | CI/CD pipeline automation | `/cicd-automation:workflow-automate` |
| `/observability-monitoring:monitor-setup` | Setup monitoring infrastructure | `/observability-monitoring:monitor-setup` |
| `/observability-monitoring:slo-implement` | Implement SLO/SLI metrics | `/observability-monitoring:slo-implement 99.9` |
| `/deployment-validation:config-validate` | Pre-deployment validation | `/deployment-validation:config-validate` |

### Code Quality Commands

| Command | Description | Example |
|---------|-------------|---------|
| `/code-review-ai:ai-review` | AI-powered code review | `/code-review-ai:ai-review` |
| `/comprehensive-review:full-review` | Multi-perspective analysis | `/comprehensive-review:full-review` |
| `/comprehensive-review:pr-enhance` | Enhance pull requests | `/comprehensive-review:pr-enhance` |
| `/code-refactoring:refactor-clean` | Code cleanup and refactoring | `/code-refactoring:refactor-clean` |
| `/code-refactoring:tech-debt` | Technical debt management | `/code-refactoring:tech-debt` |

### Debugging Commands

| Command | Description | Example |
|---------|-------------|---------|
| `/debugging-toolkit:smart-debug` | Interactive smart debugging | `/debugging-toolkit:smart-debug "memory leak"` |
| `/incident-response:incident-response` | Production incident management | `/incident-response:incident-response "API timeout"` |
| `/incident-response:smart-fix` | Automated incident resolution | `/incident-response:smart-fix "database connection"` |
| `/error-debugging:error-analysis` | Deep error analysis | `/error-debugging:error-analysis` |
| `/error-debugging:error-trace` | Stack trace debugging | `/error-debugging:error-trace` |
| `/distributed-debugging:debug-trace` | Distributed system tracing | `/distributed-debugging:debug-trace` |

### Documentation Commands

| Command | Description | Example |
|---------|-------------|---------|
| `/code-documentation:doc-generate` | Generate comprehensive documentation | `/code-documentation:doc-generate` |
| `/code-documentation:code-explain` | Explain code functionality | `/code-documentation:code-explain src/api/` |
| `/documentation-generation:doc-generate` | OpenAPI specs, diagrams, tutorials | `/documentation-generation:doc-generate` |

### Data & ML Commands

| Command | Description | Example |
|---------|-------------|---------|
| `/machine-learning-ops:ml-pipeline` | ML training pipeline orchestration | `/machine-learning-ops:ml-pipeline "churn prediction"` |
| `/data-engineering:data-pipeline` | ETL/ELT pipeline construction | `/data-engineering:data-pipeline "user analytics"` |
| `/data-engineering:data-driven-feature` | Data-driven feature development | `/data-engineering:data-driven-feature "recommendations"` |
| `/llm-application-dev:langchain-agent` | LangChain agent development | `/llm-application-dev:langchain-agent "research assistant"` |
| `/llm-application-dev:ai-assistant` | AI assistant implementation | `/llm-application-dev:ai-assistant "customer support"` |
| `/llm-application-dev:prompt-optimize` | Prompt engineering optimization | `/llm-application-dev:prompt-optimize` |

### Migration & Maintenance Commands

| Command | Description | Example |
|---------|-------------|---------|
| `/framework-migration:legacy-modernize` | Legacy code modernization | `/framework-migration:legacy-modernize` |
| `/framework-migration:code-migrate` | Framework migration | `/framework-migration:code-migrate "React 18"` |
| `/framework-migration:deps-upgrade` | Dependency upgrades | `/framework-migration:deps-upgrade` |
| `/codebase-cleanup:deps-audit` | Dependency auditing | `/codebase-cleanup:deps-audit` |
| `/codebase-cleanup:tech-debt` | Technical debt reduction | `/codebase-cleanup:tech-debt` |

### Git & PR Commands

| Command | Description | Example |
|---------|-------------|---------|
| `/git-pr-workflows:pr-enhance` | Enhance pull request quality | `/git-pr-workflows:pr-enhance` |
| `/git-pr-workflows:onboard` | Team onboarding automation | `/git-pr-workflows:onboard` |
| `/git-pr-workflows:git-workflow` | Git workflow automation | `/git-pr-workflows:git-workflow` |

### Database Commands

| Command | Description | Example |
|---------|-------------|---------|
| `/database-migrations:sql-migrations` | SQL migration automation | `/database-migrations:sql-migrations` |
| `/database-migrations:migration-observability` | Migration monitoring | `/database-migrations:migration-observability` |
| `/database-cloud-optimization:cost-optimize` | Database and cloud optimization | `/database-cloud-optimization:cost-optimize` |

### Miscellaneous Commands

| Command | Description | Example |
|---------|-------------|---------|
| `/agent-orchestration:multi-agent-optimize` | Multi-agent optimization | `/agent-orchestration:multi-agent-optimize` |
| `/agent-orchestration:improve-agent` | Agent improvement workflows | `/agent-orchestration:improve-agent` |
| `/context-management:context-save` | Save conversation context | `/context-management:context-save` |
| `/context-management:context-restore` | Restore previous context | `/context-management:context-restore` |
| `/api-testing-observability:api-mock` | API mocking and testing | `/api-testing-observability:api-mock` |
| `/accessibility-compliance:accessibility-audit` | WCAG compliance auditing | `/accessibility-compliance:accessibility-audit` |
| `/performance-testing-review:ai-review` | Performance analysis | `/performance-testing-review:ai-review` |
| `/application-performance:performance-optimization` | App optimization | `/application-performance:performance-optimization` |

---

## Multi-Agent Orchestration

### Orchestration Patterns

#### Pattern 1: Planning → Execution → Review

**Model Assignment: Sonnet → Haiku → Sonnet**

```
Sonnet Agent (Planning)
  ↓
Haiku Agent (Execution)
  ↓
Sonnet Agent (Review)
```

**Example: API Development**
```
backend-architect (Sonnet)
  → Design API architecture, endpoints, data models
  ↓
Generate API code (Haiku)
  → Implement endpoints following spec
  ↓
test-automator (Haiku)
  → Generate comprehensive tests
  ↓
code-reviewer (Sonnet)
  → Architectural review, security audit
```

**Command:**
```bash
/backend-development:feature-development "user authentication API"
```

#### Pattern 2: Full-Stack Feature Development

**Multi-Agent Workflow**

```
1. backend-architect (Sonnet)
   → API design, service boundaries

2. database-architect (Sonnet)
   → Schema design, migrations

3. frontend-developer (Sonnet)
   → UI components, state management

4. Generate implementations (Haiku)
   → Backend code, frontend code

5. test-automator (Haiku)
   → Unit tests, integration tests, E2E tests

6. security-auditor (Sonnet)
   → Security review, vulnerability assessment

7. deployment-engineer (Haiku)
   → CI/CD pipeline, deployment configs

8. observability-engineer (Haiku)
   → Monitoring, logging, alerting
```

**Command:**
```bash
/full-stack-orchestration:full-stack-feature "user dashboard with real-time analytics"
```

**What Happens:**
1. Database schema with migrations
2. Backend API (REST/GraphQL)
3. Frontend components with state management
4. Comprehensive test suite
5. Security audit and hardening
6. CI/CD pipeline with feature flags
7. Observability configuration

#### Pattern 3: Security Hardening

**Multi-Agent Workflow**

```
1. security-auditor (Sonnet)
   → Comprehensive security assessment
   → Identify vulnerabilities (OWASP Top 10)

2. backend-security-coder (Opus)
   → Implement API security
   → Authentication, authorization, input validation

3. frontend-security-coder (Opus)
   → XSS prevention, CSP headers
   → Secure client-side storage

4. mobile-security-coder (Opus)
   → Mobile-specific security patterns
   → Certificate pinning, biometric auth

5. test-automator (Haiku)
   → Security test suite
   → Penetration testing automation
```

**Command:**
```bash
/security-scanning:security-hardening --level comprehensive
```

#### Pattern 4: ML Pipeline Development

**Multi-Agent Workflow**

```
1. data-scientist (Opus)
   → Exploratory data analysis
   → Feature engineering
   → Model selection

2. data-engineer (Sonnet)
   → Data pipeline architecture
   → ETL/ELT implementation
   → Data quality checks

3. ml-engineer (Opus)
   → Model training pipeline
   → Hyperparameter tuning
   → Model evaluation

4. mlops-engineer (Opus)
   → Model registry setup
   → Experiment tracking
   → A/B testing infrastructure

5. performance-engineer (Opus)
   → Model optimization
   → Inference optimization
   → Resource allocation
```

**Command:**
```bash
/machine-learning-ops:ml-pipeline "customer churn prediction"
```

#### Pattern 5: Incident Response

**Multi-Agent Workflow**

```
1. incident-responder (Opus)
   → Incident triage
   → Impact assessment
   → Resolution strategy

2. devops-troubleshooter (Sonnet)
   → Log analysis
   → System diagnostics
   → Root cause identification

3. debugger (Sonnet)
   → Code-level debugging
   → Error resolution

4. deployment-engineer (Haiku)
   → Hotfix deployment
   → Rollback if needed

5. observability-engineer (Haiku)
   → Alert refinement
   → Monitoring improvements
   → Runbook creation
```

**Command:**
```bash
/incident-response:smart-fix "production memory leak in payment service"
```

### Workflow Composition

**Chaining Multiple Plugins**

```bash
# 1. Feature Development
/backend-development:feature-development "payment processing"

# 2. Security Hardening
/security-scanning:security-hardening

# 3. Test Generation
/unit-testing:test-generate

# 4. Code Review
/code-review-ai:ai-review

# 5. CI/CD Setup
/cicd-automation:workflow-automate

# 6. Monitoring Setup
/observability-monitoring:monitor-setup
```

### Natural Language Orchestration

Claude Code can also reason about agent coordination through natural language:

```
"Build a payment processing API with:
- Stripe integration
- PCI-DSS compliance
- Comprehensive security audit
- Full test coverage
- CI/CD pipeline
- Production monitoring"

Claude will automatically:
1. Use backend-architect to design API
2. Activate stripe-integration and pci-compliance skills
3. Invoke security-auditor for compliance
4. Use test-automator for test generation
5. Configure CI/CD with deployment-engineer
6. Set up monitoring with observability-engineer
```

---

## Best Practices

### Plugin Selection

#### Start Small, Scale Up

```bash
# Day 1: Essential plugins
/plugin install python-development
/plugin install unit-testing
/plugin install code-review-ai

# Week 1: Add infrastructure
/plugin install cloud-infrastructure
/plugin install cicd-automation

# Month 1: Advanced workflows
/plugin install full-stack-orchestration
/plugin install security-scanning
```

#### Install by Project Type

**Backend API Project:**
```bash
/plugin install backend-development
/plugin install python-development
/plugin install database-design
/plugin install api-testing-observability
/plugin install security-scanning
```

**Full-Stack Application:**
```bash
/plugin install full-stack-orchestration
/plugin install backend-development
/plugin install frontend-mobile-development
/plugin install database-design
/plugin install unit-testing
/plugin install cicd-automation
```

**ML/AI Project:**
```bash
/plugin install llm-application-dev
/plugin install machine-learning-ops
/plugin install python-development
/plugin install data-engineering
/plugin install observability-monitoring
```

**Infrastructure Project:**
```bash
/plugin install cloud-infrastructure
/plugin install kubernetes-operations
/plugin install cicd-automation
/plugin install observability-monitoring
/plugin install security-compliance
```

### Agent Invocation

#### Use Slash Commands for Structured Workflows

```bash
# Prefer this
/backend-development:feature-development user authentication

# Over this
"Build a user authentication feature"
```

**Why:**
- Direct invocation (no reasoning overhead)
- Structured arguments
- Predictable workflow
- Composable with other commands

#### Use Natural Language for Complex Reasoning

```
# When Claude needs to coordinate multiple agents
"Design a microservices architecture for an e-commerce platform with:
- User service (authentication, profiles)
- Product service (catalog, inventory)
- Order service (cart, checkout, payments)
- Review service (ratings, comments)

Ensure proper service boundaries, event-driven communication,
and resilience patterns."
```

**Why:**
- Claude reasons about agent selection
- Adapts to context and requirements
- Handles ambiguity and edge cases

### Agent Skills

#### Explicit Activation

```
# Clearly mention skill triggers in your request
"Create Kubernetes deployment with Helm chart and GitOps workflow"

→ Activates: helm-chart-scaffolding, gitops-workflow
```

#### Progressive Disclosure

```
# Start with high-level request
"Set up FastAPI project"
→ Activates: fastapi-templates skill (basic structure)

# Dive deeper as needed
"Add async database patterns with SQLAlchemy"
→ Activates: async-python-patterns skill (advanced patterns)
```

### Model Selection

#### Let the Framework Handle It

The framework automatically assigns agents to optimal models:

- **Haiku**: Fast execution tasks (testing, scaffolding, deployment)
- **Sonnet**: Complex reasoning (architecture, security, ML)

**Don't override unless you have specific requirements.**

#### Hybrid Orchestration

Leverage the Sonnet → Haiku → Sonnet pattern:

```bash
# Planning with Sonnet
/backend-development:feature-development "payment API"
→ backend-architect (Sonnet) designs architecture

# Execution with Haiku
→ Generate code (Haiku) implements design
→ test-automator (Haiku) creates tests

# Review with Sonnet
→ code-reviewer (Sonnet) validates architecture
```

### Workflow Optimization

#### Batch Operations

```bash
# Instead of sequential commands
/unit-testing:test-generate src/api/users.py
/unit-testing:test-generate src/api/products.py
/unit-testing:test-generate src/api/orders.py

# Use a single orchestrated command
/unit-testing:test-generate src/api/
```

#### Use Orchestrators for Complex Workflows

```bash
# Instead of manual coordination
/backend-development:feature-development
/security-scanning:security-sast
/unit-testing:test-generate
/code-review-ai:ai-review

# Use orchestrator
/full-stack-orchestration:full-stack-feature
```

### Context Management

#### Save Context for Long Sessions

```bash
# Before context limit
/context-management:context-save "payment-api-development"

# In new session
/context-management:context-restore "payment-api-development"
```

#### Use Memory for Project Knowledge

Store project-specific information:
- Architecture decisions
- API conventions
- Security requirements
- Deployment procedures

### Testing Strategy

#### Always Generate Tests

```bash
# After feature development
/backend-development:feature-development user-authentication
→ Automatically generates tests via test-automator

# Or explicitly
/unit-testing:test-generate
```

#### Use TDD Workflows

```bash
# Start with failing tests
/tdd-workflows:tdd-red "user can reset password"

# Implement to pass
/tdd-workflows:tdd-green

# Refactor
/tdd-workflows:tdd-refactor
```

### Security Practices

#### Security-First Development

```bash
# Include security in every feature
/full-stack-orchestration:full-stack-feature "user profile"
→ Automatically includes security-auditor

# Or run dedicated security scan
/security-scanning:security-hardening
```

#### Regular Dependency Audits

```bash
# Schedule regular audits
/codebase-cleanup:deps-audit

# Check for vulnerabilities
/security-scanning:security-dependencies
```

### Documentation Habits

#### Document as You Build

```bash
# Generate docs alongside code
/code-documentation:doc-generate

# Create API specifications
/documentation-generation:doc-generate
```

#### Explain Complex Code

```bash
# Get explanations for understanding
/code-documentation:code-explain src/api/payment_processor.py
```

---

## Workflow Patterns

### Pattern: Test-Driven Development

**Workflow:**

```bash
# 1. Write failing test
/tdd-workflows:tdd-red "user registration validates email format"

# 2. Implement minimal code to pass
/tdd-workflows:tdd-green

# 3. Refactor while maintaining tests
/tdd-workflows:tdd-refactor

# 4. Repeat for next feature
/tdd-workflows:tdd-cycle "user can upload profile picture"
```

**Benefits:**
- Ensures test coverage
- Guides implementation
- Prevents over-engineering
- Facilitates refactoring

### Pattern: Feature Flag Deployment

**Workflow:**

```bash
# 1. Develop feature with flag
/backend-development:feature-development "new recommendation algorithm"
# Include feature flag in implementation

# 2. Deploy behind flag
/cicd-automation:workflow-automate
# CI/CD includes feature flag config

# 3. Monitor rollout
/observability-monitoring:monitor-setup
# Track metrics for flagged feature

# 4. Gradual rollout
# Increase flag percentage based on metrics
```

### Pattern: Microservices Development

**Workflow:**

```bash
# 1. Design service boundaries
"Design microservices architecture for e-commerce with proper boundaries"
→ backend-architect with microservices-patterns skill

# 2. Implement services
/backend-development:feature-development "user service"
/backend-development:feature-development "product service"
/backend-development:feature-development "order service"

# 3. Set up inter-service communication
"Implement event-driven communication between services"
→ Activates microservices-patterns skill

# 4. Deploy with orchestration
/kubernetes-operations:k8s-deploy
```

### Pattern: Database Migration

**Workflow:**

```bash
# 1. Design schema changes
"Design database migration to add user preferences table"
→ database-architect

# 2. Generate migration
/database-migrations:sql-migrations

# 3. Test migration
"Create test plan for zero-downtime migration"
→ database-migration skill

# 4. Execute with monitoring
/database-migrations:migration-observability

# 5. Validate
"Verify data integrity after migration"
```

### Pattern: Legacy Modernization

**Workflow:**

```bash
# 1. Analyze legacy code
/framework-migration:legacy-modernize
→ Analyzes codebase, identifies modernization opportunities

# 2. Plan migration strategy
"Create incremental migration plan from AngularJS to React"
→ Activates angular-migration and react-modernization skills

# 3. Implement hybrid mode
"Set up hybrid AngularJS/React architecture"

# 4. Migrate incrementally
/framework-migration:code-migrate "user profile component"
/framework-migration:code-migrate "dashboard component"

# 5. Update dependencies
/framework-migration:deps-upgrade
```

### Pattern: Production Incident Response

**Workflow:**

```bash
# 1. Incident triage
/incident-response:incident-response "API latency spike"
→ incident-responder analyzes logs, metrics

# 2. Root cause analysis
/incident-response:smart-fix
→ devops-troubleshooter identifies root cause

# 3. Implement fix
/debugging-toolkit:smart-debug
→ debugger implements solution

# 4. Deploy hotfix
/cicd-automation:workflow-automate
→ deployment-engineer deploys fix

# 5. Improve monitoring
/observability-monitoring:monitor-setup
→ observability-engineer adds alerts

# 6. Create runbook
/code-documentation:doc-generate
→ docs-architect documents incident + resolution
```

### Pattern: ML Model Deployment

**Workflow:**

```bash
# 1. Develop ML pipeline
/machine-learning-ops:ml-pipeline "churn prediction"
→ data-scientist, ml-engineer develop model

# 2. Set up MLOps infrastructure
"Configure experiment tracking and model registry"
→ mlops-engineer

# 3. Optimize model
/application-performance:performance-optimization
→ performance-engineer optimizes inference

# 4. Create API endpoint
/backend-development:feature-development "model serving API"

# 5. Deploy with monitoring
/cicd-automation:workflow-automate
/observability-monitoring:monitor-setup

# 6. Set up retraining pipeline
"Implement automated model retraining based on drift detection"
```

---

## Model Configuration Strategy

### Overview

The wshobson framework uses a **two-tier model architecture** for optimal performance and cost efficiency:

| Model | Agent Count | Use Case |
|-------|-------------|----------|
| **Haiku 4.5** | 47 agents | Fast execution, deterministic tasks, high throughput |
| **Sonnet 4.5** | 38 agents | Complex reasoning, architecture, strategic decisions |

### Model Selection Criteria

#### Haiku - Fast Execution & Deterministic Tasks

**Use Haiku when:**
- Generating code from well-defined specifications
- Creating tests following established patterns
- Writing documentation with clear templates
- Executing infrastructure operations (deployments, configs)
- Performing database query optimization
- Handling customer support responses
- Processing SEO optimization tasks
- Managing deployment pipelines
- Scaffolding projects from templates

**Examples:**
- test-automator: Generate pytest tests
- deployment-engineer: Deploy to Kubernetes
- sql-pro: Optimize database queries
- reference-builder: Generate API docs
- seo-meta-optimizer: Optimize meta tags

#### Sonnet - Complex Reasoning & Architecture

**Use Sonnet when:**
- Designing system architecture
- Making technology selection decisions
- Performing security audits
- Reviewing code for architectural patterns
- Creating complex AI/ML pipelines
- Providing language-specific expertise
- Orchestrating multi-agent workflows
- Handling business-critical legal/HR matters
- Making strategic infrastructure decisions

**Examples:**
- backend-architect: Design API architecture
- security-auditor: Comprehensive security audit
- code-reviewer: Architectural code review
- data-scientist: Exploratory data analysis
- ai-engineer: LLM application architecture

### Hybrid Orchestration Patterns

#### Pattern 1: Planning → Execution → Review

```
Sonnet (Strategic Planning)
  → Designs architecture, makes key decisions

Haiku (Fast Execution)
  → Implements according to spec
  → Generates tests
  → Creates documentation

Sonnet (Quality Review)
  → Validates architecture
  → Checks for edge cases
  → Ensures best practices
```

**Example: API Development**
```
backend-architect (Sonnet)
  → Design RESTful API architecture
  → Define endpoints, data models, authentication
  ↓
Generate API code (Haiku)
  → Implement FastAPI endpoints
  → Create Pydantic models
  → Set up error handling
  ↓
test-automator (Haiku)
  → Generate unit tests
  → Create integration tests
  → Add API documentation tests
  ↓
code-reviewer (Sonnet)
  → Review architectural consistency
  → Check security best practices
  → Validate error handling
```

#### Pattern 2: Reasoning → Action (Incident Response)

```
Sonnet (Root Cause Analysis)
  → Analyzes logs and metrics
  → Identifies root cause
  → Develops resolution strategy

Haiku (Execute Fixes)
  → Implements fixes
  → Deploys hotfixes
  → Updates configurations
  → Sets up monitoring
```

**Example: Production Incident**
```
incident-responder (Opus)
  → Analyze incident: Database connection pool exhaustion
  → Strategy: Increase pool size, add connection timeout, improve query efficiency
  ↓
devops-troubleshooter (Sonnet)
  → Identify problematic queries
  → Review connection management
  ↓
Apply fixes (Haiku)
  → Update connection pool configuration
  → Add connection timeouts
  → Optimize slow queries
  ↓
deployment-engineer (Haiku)
  → Deploy configuration changes
  → Roll out query optimizations
  ↓
Setup monitoring (Haiku)
  → Add connection pool metrics
  → Create alerts for pool exhaustion
  → Set up query performance tracking
```

#### Pattern 3: Complex → Simple (Database Design)

```
Sonnet (Strategic Design)
  → Schema design
  → Technology selection
  → Normalization decisions

Haiku (Tactical Implementation)
  → Generate migration scripts
  → Execute migrations
  → Optimize queries
  → Set up indexes
```

**Example: Database Architecture**
```
database-architect (Opus)
  → Design schema for multi-tenant SaaS
  → Choose between shared DB vs. isolated DBs
  → Model relationships and constraints
  → Plan sharding strategy
  ↓
sql-pro (Haiku)
  → Generate CREATE TABLE statements
  → Write migration scripts
  → Add indexes for common queries
  ↓
database-admin (Haiku)
  → Execute migrations
  → Set up replication
  → Configure backups
  ↓
database-optimizer (Haiku)
  → Analyze query performance
  → Add missing indexes
  → Optimize slow queries
```

#### Pattern 4: Multi-Agent Full-Stack

```
Multiple Sonnet Agents (Design Phase)
  → backend-architect: API design
  → database-architect: Schema design
  → frontend-developer: Component architecture
  → security-auditor: Security requirements

Multiple Haiku Agents (Implementation Phase)
  → Generate backend code
  → Generate frontend code
  → Create database migrations
  → Generate comprehensive tests
  → Set up CI/CD
  → Configure monitoring

Sonnet Agents (Review Phase)
  → code-reviewer: Architectural review
  → security-auditor: Security validation
```

### Cost Optimization

#### Maximize Haiku Usage

```bash
# Use Haiku-heavy workflows for cost efficiency
/unit-testing:test-generate           # Haiku: test-automator
/python-development:python-scaffold   # Haiku: code generation
/cicd-automation:workflow-automate    # Haiku: deployment-engineer
/observability-monitoring:monitor-setup # Haiku: infrastructure setup
```

#### Reserve Sonnet for Strategic Decisions

```bash
# Use Sonnet when architecture matters
/backend-development:feature-development  # Sonnet: backend-architect
/comprehensive-review:full-review        # Sonnet: code-reviewer
/security-scanning:security-hardening    # Sonnet: security-auditor
```

### Performance Optimization

#### Batch Haiku Operations

```bash
# Run multiple fast operations in sequence
/unit-testing:test-generate src/
/cicd-automation:workflow-automate
/observability-monitoring:monitor-setup

# All use Haiku for fast execution
```

#### Parallel Sonnet Reasoning

```bash
# In full-stack-orchestration, Sonnet agents work in parallel:
- backend-architect designs API
- database-architect designs schema
- frontend-developer designs components
↓ (parallel)
Combined into comprehensive implementation plan
```

---

## Integration Guide

### IDE Integration

#### VS Code Setup

1. **Install Claude Code Extension**
2. **Configure Plugin Marketplace**
   ```json
   {
     "claude.plugins.marketplaces": [
       "wshobson/agents"
     ]
   }
   ```

3. **Install Essential Plugins**
   ```bash
   /plugin install python-development
   /plugin install backend-development
   /plugin install unit-testing
   ```

### CI/CD Integration

#### GitHub Actions

```yaml
name: Claude Code Review

on:
  pull_request:
    branches: [main, develop]

jobs:
  claude-review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Install Claude Code
        run: |
          # Install Claude Code CLI

      - name: Add Plugin Marketplace
        run: |
          claude plugin marketplace add wshobson/agents

      - name: Install Plugins
        run: |
          claude plugin install code-review-ai
          claude plugin install security-scanning
          claude plugin install unit-testing

      - name: Run Code Review
        run: |
          claude /code-review-ai:ai-review

      - name: Run Security Scan
        run: |
          claude /security-scanning:security-sast

      - name: Generate Tests
        run: |
          claude /unit-testing:test-generate
```

#### GitLab CI

```yaml
claude_review:
  stage: test
  image: claude-code:latest
  script:
    - claude plugin marketplace add wshobson/agents
    - claude plugin install code-review-ai
    - claude plugin install security-scanning
    - claude /code-review-ai:ai-review
    - claude /security-scanning:security-sast
  only:
    - merge_requests
```

### Project Configuration

#### Create `.claude/` Directory

```bash
mkdir -p .claude
```

#### Configure Installed Plugins

**.claude/config.json**
```json
{
  "plugins": [
    "python-development",
    "backend-development",
    "unit-testing",
    "code-review-ai",
    "security-scanning",
    "cloud-infrastructure",
    "cicd-automation"
  ],
  "default_model": "sonnet",
  "auto_install_dependencies": true
}
```

#### Project-Specific Commands

**.claude/commands/**
```
.claude/commands/
├── test.sh          # Custom test command
├── deploy.sh        # Custom deploy command
└── review.sh        # Custom review workflow
```

**test.sh**
```bash
#!/bin/bash
/unit-testing:test-generate
/code-review-ai:ai-review
```

### Team Workflows

#### Onboarding New Team Members

```bash
# Use git-pr-workflows for onboarding
/git-pr-workflows:onboard

# Generates:
# - Team documentation
# - Development setup guide
# - Git workflow guidelines
# - PR templates
# - Code review checklist
```

#### Standardize Development Process

1. **Create team plugin bundle**
   ```bash
   # Install core plugins for all team members
   /plugin install backend-development
   /plugin install frontend-mobile-development
   /plugin install unit-testing
   /plugin install code-review-ai
   /plugin install git-pr-workflows
   ```

2. **Share configuration**
   ```bash
   # Commit .claude/config.json to repository
   git add .claude/config.json
   git commit -m "Add Claude Code configuration"
   ```

3. **Document workflows**
   ```bash
   # Generate team documentation
   /code-documentation:doc-generate
   ```

---

## Troubleshooting

### Common Issues

#### Plugin Installation Fails

**Problem:** `/plugin install python-development` returns error

**Solutions:**
1. Verify marketplace is added:
   ```bash
   /plugin marketplace add wshobson/agents
   ```

2. Check plugin name spelling:
   ```bash
   /plugin  # List available plugins
   ```

3. Update marketplace:
   ```bash
   /plugin marketplace update wshobson/agents
   ```

#### Agent Not Activating

**Problem:** Agent not responding to natural language

**Solutions:**
1. Use explicit slash command:
   ```bash
   /backend-development:feature-development "authentication"
   ```

2. Use agent name in request:
   ```
   "Use backend-architect to design authentication API"
   ```

3. Verify plugin is installed:
   ```bash
   /plugin  # Check installed plugins
   ```

#### Skill Not Loading

**Problem:** Skill activation triggers not working

**Solutions:**
1. Use explicit keywords:
   ```
   # Instead of: "Set up K8s"
   "Create Kubernetes deployment with Helm chart"
   # Triggers: helm-chart-scaffolding skill
   ```

2. Check skill availability:
   ```bash
   /plugin install kubernetes-operations  # Includes K8s skills
   ```

3. Activate skill manually:
   ```
   "Activate helm-chart-scaffolding skill and create chart"
   ```

#### Command Not Found

**Problem:** `/plugin-name:command-name` not recognized

**Solutions:**
1. List available commands:
   ```bash
   /plugin
   ```

2. Verify plugin is installed:
   ```bash
   /plugin install plugin-name
   ```

3. Check command name:
   ```bash
   # Correct: /backend-development:feature-development
   # Incorrect: /backend-development:feature-dev
   ```

### Performance Issues

#### Slow Response Times

**Problem:** Agent responses are slow

**Solutions:**
1. Use Haiku-optimized commands for fast operations:
   ```bash
   /unit-testing:test-generate  # Uses Haiku
   ```

2. Avoid loading unnecessary plugins:
   ```bash
   /plugin uninstall unused-plugin
   ```

3. Use focused commands instead of broad requests:
   ```bash
   # Faster
   /backend-development:feature-development "user login"

   # Slower
   "Build a complete authentication system with OAuth2, JWT, MFA, password reset, email verification, and social login"
   ```

#### Context Window Overflow

**Problem:** "Context window exceeded" error

**Solutions:**
1. Save and restore context:
   ```bash
   /context-management:context-save "current-work"
   # Start new session
   /context-management:context-restore "current-work"
   ```

2. Uninstall unused plugins:
   ```bash
   /plugin uninstall rarely-used-plugin
   ```

3. Break large tasks into smaller workflows:
   ```bash
   # Instead of one massive command
   /full-stack-orchestration:full-stack-feature "entire application"

   # Break into phases
   /backend-development:feature-development "API layer"
   /frontend-mobile-development:component-scaffold "UI layer"
   /unit-testing:test-generate
   ```

### Quality Issues

#### Generated Code Doesn't Meet Standards

**Problem:** Code doesn't follow project conventions

**Solutions:**
1. Provide explicit guidelines:
   ```
   "Generate FastAPI endpoint following these conventions:
   - Use Pydantic v2 models
   - Include type hints
   - Add docstrings
   - Follow PEP 8
   - Use async/await"
   ```

2. Use code review workflow:
   ```bash
   /code-review-ai:ai-review
   # Get feedback, then refine
   ```

3. Activate relevant skills:
   ```
   "Use python-testing-patterns skill to generate pytest tests with fixtures"
   ```

#### Security Vulnerabilities

**Problem:** Generated code has security issues

**Solutions:**
1. Always run security scan:
   ```bash
   /security-scanning:security-hardening
   ```

2. Use security-focused agents:
   ```bash
   /backend-api-security:  # For backend security
   /frontend-mobile-security:xss-scan  # For frontend security
   ```

3. Include security in orchestration:
   ```bash
   /full-stack-orchestration:full-stack-feature "payment processing"
   # Automatically includes security-auditor
   ```

### Getting Help

#### Documentation Resources

1. **Framework Documentation**
   - README.md: Overview and quick start
   - docs/architecture.md: Design principles
   - docs/agents.md: Agent reference
   - docs/agent-skills.md: Skills reference
   - docs/plugins.md: Plugin catalog
   - docs/usage.md: Usage guide

2. **This Manual**
   - Complete reference for all components
   - Integration guide
   - Best practices
   - Workflow patterns

3. **Agent-Specific Help**
   ```
   "Explain how to use backend-architect agent"
   "Show examples of using kubernetes-operations plugin"
   ```

#### Community Support

1. **GitHub Repository**
   - Issues: Report bugs, request features
   - Discussions: Ask questions, share workflows
   - Pull Requests: Contribute improvements

2. **Claude Code Documentation**
   - [Claude Code Overview](https://docs.claude.com/en/docs/claude-code/overview)
   - [Plugins Guide](https://docs.claude.com/en/docs/claude-code/plugins)
   - [Subagents Guide](https://docs.claude.com/en/docs/claude-code/sub-agents)
   - [Agent Skills Guide](https://docs.claude.com/en/docs/agents-and-tools/agent-skills/overview)

---

## Appendix

### A. Complete Plugin Inventory

**Total: 63 plugins across 23 categories**

1. accessibility-compliance
2. agent-orchestration
3. api-scaffolding
4. api-testing-observability
5. application-performance
6. arm-cortex-microcontrollers
7. backend-api-security
8. backend-development
9. blockchain-web3
10. business-analytics
11. cicd-automation
12. cloud-infrastructure
13. codebase-cleanup
14. code-documentation
15. code-refactoring
16. code-review-ai
17. comprehensive-review
18. content-marketing
19. context-management
20. customer-sales-automation
21. database-cloud-optimization
22. database-design
23. database-migrations
24. data-engineering
25. data-validation-suite
26. debugging-toolkit
27. dependency-management
28. deployment-strategies
29. deployment-validation
30. distributed-debugging
31. documentation-generation
32. error-debugging
33. error-diagnostics
34. framework-migration
35. frontend-mobile-development
36. frontend-mobile-security
37. full-stack-orchestration
38. functional-programming
39. game-development
40. git-pr-workflows
41. hr-legal-compliance
42. incident-response
43. javascript-typescript
44. jvm-languages
45. kubernetes-operations
46. llm-application-dev
47. machine-learning-ops
48. multi-platform-apps
49. observability-monitoring
50. payment-processing
51. performance-testing-review
52. python-development
53. quantitative-trading
54. security-compliance
55. security-scanning
56. seo-analysis-monitoring
57. seo-content-creation
58. seo-technical-optimization
59. shell-scripting
60. systems-programming
61. tdd-workflows
62. team-collaboration
63. unit-testing
64. web-scripting

### B. Agent Index (85 agents)

See [Complete Agent Catalog](#complete-agent-catalog) for full details.

### C. Skills Index (47 skills)

See [Agent Skills Reference](#agent-skills-reference) for full details.

### D. Command Index (44+ commands)

See [Command Reference](#command-reference) for full details.

### E. Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `/plugin` | List plugins and commands |
| `/plugin install <name>` | Install plugin |
| `/plugin uninstall <name>` | Uninstall plugin |
| `/plugin marketplace add wshobson/agents` | Add marketplace |

### F. Glossary

**Agent**: Specialized AI assistant with domain expertise

**Skill**: Modular knowledge package with progressive disclosure

**Plugin**: Isolated package containing agents, commands, and skills

**Command**: Tool or workflow accessible via slash command (/)

**Orchestrator**: Multi-agent coordination system

**Progressive Disclosure**: Three-tier architecture (metadata → instructions → resources)

**Haiku**: Fast execution model for deterministic tasks

**Sonnet**: Complex reasoning model for architecture and strategy

**Hybrid Orchestration**: Combining Haiku and Sonnet models for optimal performance

### G. Version History

- **2025-01**: Complete reference manual created
- **2024-12**: Framework updated for Sonnet 4.5 & Haiku 4.5
- **2024-11**: Added 47 agent skills with progressive disclosure
- **2024-10**: Expanded to 63 plugins and 85 agents
- **2024-09**: Initial release with 50 plugins

### H. License

MIT License - see wshobson/agents repository for details.

---

## Quick Links

- [GitHub Repository](https://github.com/wshobson/agents)
- [Claude Code Documentation](https://docs.claude.com/en/docs/claude-code/overview)
- [Agent Skills Specification](https://github.com/anthropics/skills/blob/main/agent_skills_spec.md)

---

**Last Updated**: 2025-01-23
**Framework Version**: Latest
**Documentation Version**: 1.0.0
