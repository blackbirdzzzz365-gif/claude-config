# Customization Guide

## Customize Architecture Team Members

File: `.architecture/members.yml`

### Member YAML Structure

```yaml
- id: unique_id           # lowercase với underscores
  name: "Full Name"
  title: "Role Title"
  specialties:            # 3-5 main expertise areas
    - "Specialty 1"
  disciplines:            # 3-5 professional disciplines
    - "Discipline 1"
  skillsets:              # 3-5 specific skills
    - "Skill 1"
  domains:                # 3-5 application domains
    - "Domain 1"
  perspective: "One sentence describing their unique viewpoint in reviews"
```

### Technology Stack Specialists

**TypeScript/JavaScript:**
```yaml
- id: typescript_expert
  name: "Alex Rivera"
  title: "TypeScript Expert"
  specialties: ["Modern TypeScript", "Frontend architecture", "Build tools"]
  disciplines: ["Type safety", "Performance", "DX"]
  skillsets: ["TypeScript 5+", "Generics", "Module systems"]
  domains: ["Web apps", "Node.js backends", "Monorepos"]
  perspective: "Focuses on type-safe code and modern JS/TS patterns"
```

**React/Next.js:**
```yaml
- id: react_specialist
  name: "Emma Rodriguez"
  title: "React Specialist"
  specialties: ["React patterns", "Component architecture", "State management"]
  disciplines: ["Hooks", "Performance", "Accessibility"]
  skillsets: ["React 18+", "Context/Zustand/Redux", "Testing Library"]
  domains: ["SPAs", "Component libraries", "SSR apps"]
  perspective: "Focuses on modern React patterns and component reusability"
```

**Python/FastAPI:**
```yaml
- id: python_expert
  name: "Dr. Sarah Chen"
  title: "Python Expert"
  specialties: ["Python best practices", "Async architecture", "Type hints"]
  disciplines: ["Pythonic code", "Testing patterns", "Performance"]
  skillsets: ["Python 3.12+", "FastAPI", "Pydantic", "async/await"]
  domains: ["Backend services", "Data processing", "REST APIs"]
  perspective: "Advocates for clean, Pythonic solutions following PEP guidelines"
```

**Go:**
```yaml
- id: go_expert
  name: "Dmitri Ivanov"
  title: "Go Expert"
  specialties: ["Idiomatic Go", "Concurrency patterns", "Service architecture"]
  disciplines: ["Simplicity", "Composition", "Clear error handling"]
  skillsets: ["Goroutines/channels", "Standard library", "Performance profiling"]
  domains: ["Microservices", "Cloud-native", "CLI tools"]
  perspective: "Advocates for Go's simplicity philosophy and effective concurrency"
```

**Ruby/Rails:**
```yaml
- id: ruby_expert
  name: "Marcus Johnson"
  title: "Ruby Expert"
  specialties: ["Ruby idioms", "Rails patterns", "Metaprogramming"]
  disciplines: ["Convention over configuration", "DRY", "Expressive code"]
  skillsets: ["Ruby 3.x", "Rails 7+", "Active Record", "RSpec"]
  domains: ["Web apps", "API services", "Background jobs"]
  perspective: "Emphasizes Ruby's elegance and Rails conventions"
```

**Java/Spring:**
```yaml
- id: java_expert
  name: "Jennifer Park"
  title: "Java Expert"
  specialties: ["Enterprise Java", "Spring ecosystem", "JVM optimization"]
  disciplines: ["SOLID principles", "Clean architecture", "Design patterns"]
  skillsets: ["Java 21+", "Spring Boot", "Reactive programming"]
  domains: ["Enterprise apps", "Distributed systems", "Cloud services"]
  perspective: "Focuses on maintainable enterprise patterns and modern Java"
```

### Core Members — Luôn giữ

```
- Systems Architect      ← Overall architecture coherence
- Domain Expert          ← Business domain representation
- Security Specialist    ← Security analysis
- Performance Specialist ← Scalability
- Maintainability Expert ← Code quality, tech debt
- Pragmatic Enforcer     ← YAGNI (nếu enable pragmatic mode)
```

**Thêm specialists, không replace core members.**

## Customize Architectural Principles

File: `.architecture/principles.md`

Append framework-specific principles sau các core principles:

**Format:**
```markdown
## N. [Principle Name]

[Mô tả ngắn tại sao principle này quan trọng.]

**In Practice:**
- [Specific application 1]
- [Specific application 2]

**Anti-patterns to Avoid:**
- [Anti-pattern 1]
```

**React principles:** Component composition, hooks, unidirectional data flow
**Rails principles:** Convention over configuration, fat models/skinny controllers
**Django principles:** Explicit over implicit, reusable apps, use built-ins
**FastAPI principles:** Dependency injection, Pydantic models, async by default

## Update CLAUDE.md Integration

Nếu project có `CLAUDE.md`, append:

```markdown
## AI Software Architect Framework

Project này dùng AI Software Architect framework.

### Available Commands
- "Create ADR for [decision]"
- "Start architecture review for version X.Y.Z"
- "Ask [specialist] to review [target]"
- "What's our architecture status?"

### Documentation
- ADRs: `.architecture/decisions/adrs/`
- Reviews: `.architecture/reviews/`
- Principles: `.architecture/principles.md`
- Team: `.architecture/members.yml`
```

## Configuration Options

File: `.architecture/config.yml`

### Pragmatic Mode

```yaml
pragmatic_mode:
  enabled: true
  intensity: balanced   # strict | balanced | lenient
  applies_to:
    - reviews
    - adrs
    - implementation
  exemptions:
    - security
    - compliance
    - accessibility
    - data_loss_prevention
```

- **strict** (ratio <1.0): MVP, tight timeline — challenge mọi abstraction
- **balanced** (ratio <1.5): Normal development — allow abstractions với clear benefit
- **lenient** (ratio <2.0): Platform building — allow strategic complexity

### Implementation Methodology

```yaml
implementation:
  enabled: true
  methodology: TDD      # TDD | BDD | DDD | Test-Last
  influences:
    - "Kent Beck - TDD by Example"
  languages:
    python:
      style_guide: "Ruff"
      test_framework: "pytest"
    typescript:
      style_guide: "ESLint + Prettier"
      test_framework: "Vitest"
```

## Customization Checklist

- [ ] Thêm technology-specific members vào `members.yml`
- [ ] Thêm framework principles vào `principles.md`
- [ ] Update `config.yml` (pragmatic mode, methodology)
- [ ] Append vào `CLAUDE.md` nếu tồn tại
- [ ] Chạy initial system analysis
- [ ] Verify: "What's our architecture status?"
