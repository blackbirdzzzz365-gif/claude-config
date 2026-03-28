---
name: arch-review
description: >
  This skill should be used when the user asks to "architecture review", "review kiến trúc",
  "full arch review", "đánh giá kiến trúc", "multi-perspective review", "review hệ thống",
  "comprehensive architecture review", "full system review", "review toàn bộ kiến trúc",
  "kiểm tra kiến trúc", "arch review version X", or wants a complete assessment
  from multiple specialist perspectives. Do NOT use for single-specialist reviews
  or status checks.
version: 0.1.0
argument-hint: [version|feature|component]
allowed-tools: Read, Write, Glob, Grep, Bash(git:*)
---

# Architecture Review

Conduct comprehensive multi-perspective architecture reviews với toàn bộ architecture team members.

## Process Overview

1. **Determine Scope** — version, feature, hoặc component cần review
2. **Load Team** — đọc members từ `.architecture/members.yml`, check pragmatic mode
3. **Analyze System** — examine architecture dùng Read, Glob, Grep, git
4. **Individual Reviews** — mỗi member review từ specialized perspective
5. **Collaborative Discussion** — synthesize findings, establish priorities
6. **Create Document** — generate review dùng template
7. **Report Results** — summary findings và next steps

**Process guide:** [references/review-process.md](references/review-process.md)
**Pragmatic mode:** [references/pragmatic-integration.md](references/pragmatic-integration.md)
**Template:** [assets/review-template.md](assets/review-template.md)

## Quy trình

### 1. Xác định Scope

Xác định review target và tạo filename:
- **Version**: "version 2.1.0" → `2-1-0.md`
- **Feature**: "feature auth flow" → `feature-auth-flow.md`
- **Component**: "component BrowserAgent" → `component-browser-agent.md`

Apply filename sanitization: remove path traversal (`..`, `/`), convert to lowercase kebab-case.

### 2. Load Config & Team

```bash
cat .architecture/config.yml    # Check pragmatic_mode.enabled
cat .architecture/members.yml   # Load all members
```

Include Pragmatic Enforcer nếu pragmatic mode enabled.

### 3. Analyze Target

Tùy loại review — xem [references/review-process.md § Analysis Guidelines](references/review-process.md):

- **Version review**: overall architectural health, patterns, tech debt, ADR alignment
- **Feature review**: implementation, integration, security impact, performance impact
- **Component review**: structure, boundaries, dependencies, cohesion

Dùng:
- `Read` — code, configs, docs
- `Glob` — tìm files theo pattern
- `Grep` — search specific patterns
- `Bash(git:*)` — git history, recent changes

### 4. Individual Member Reviews

Mỗi member viết review bao gồm:
- Perspective statement
- Key observations (3-5)
- Strengths (3-5)
- Concerns với impact và recommendation (3-7)
- Prioritized recommendations với effort estimates (3-7)

Format chi tiết: [references/review-process.md § Individual Member Review Format](references/review-process.md)

Nếu pragmatic mode enabled: thêm Pragmatic Enforcer analysis sau mỗi member.

### 5. Collaborative Discussion

Synthesize findings:
- Identify common concerns
- Discuss disagreements
- Establish consensus
- Prioritize: **Critical** (0-2 tuần) | **Important** (2-8 tuần) | **Nice-to-Have** (2-6 tháng)

Format: [references/review-process.md § Collaborative Discussion](references/review-process.md)

### 6. Tạo Review Document

Load template:
```bash
cat .architecture/skills/arch-review/assets/review-template.md
```

Include:
- Executive summary + overall assessment (Strong | Adequate | Needs Improvement)
- Individual member reviews
- Collaborative discussion
- Consolidated findings (strengths, improvements, tech debt, risks)
- Recommendations (immediate, short-term, long-term)
- Success metrics + follow-up plan

Save to `.architecture/reviews/[filename].md`

### 7. Report kết quả

```
Architecture Review Complete: [Target]

Location: .architecture/reviews/[filename].md
Overall Assessment: [Strong | Adequate | Needs Improvement]

Top 3 Priorities:
1. [Priority 1]
2. [Priority 2]
3. [Priority 3]

Immediate Actions:
- [Action 1]
- [Action 2]

Next Steps:
- "Start architecture recalibration for [target]"
- Create ADRs cho key decisions
```

## Related Skills

- **Trước**: setup-architect, list-members
- **Song song**: create-adr (document decisions found during review)
- **Sau**: architecture-recalibration

## Lưu ý

- `.architecture/members.yml` phải tồn tại — nếu không, hướng dẫn chạy `setup-architect` trước
- Mỗi concern phải có recommendation cụ thể và actionable
- Balance positive và negative — nhận ra điều đang hoạt động tốt
- Recommendations phải có effort estimate (S/M/L) và priority (H/M/L)
