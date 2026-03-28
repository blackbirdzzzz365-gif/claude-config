---
name: setup-architect
description: >
  This skill should be used when the user asks to "setup architecture framework",
  "cài AI Software Architect", "khởi tạo kiến trúc", "setup .architecture",
  "initialize architecture framework", "install software architect",
  "setup architect framework", "cài framework kiến trúc cho project",
  or wants to set up the AI Software Architect framework in a project for the first time.
  Do NOT use for checking status, creating ADRs, or when framework is already set up.
version: 0.1.0
argument-hint: [project-path]
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# Setup AI Software Architect Framework

Cài đặt và customize AI Software Architect framework cho một project mới — bao gồm phân tích tech stack, cài cấu trúc thư mục, customize team members và principles, và tạo initial system analysis.

## Overview

1. Verify prerequisites (framework đã clone chưa, đang ở project root)
2. Phân tích project (languages, frameworks, structure)
3. Cài framework files và directory structure
4. Customize team members theo tech stack detect được
5. Customize architectural principles
6. Tạo initial system analysis
7. Report kết quả

**Chi tiết từng bước:** [references/installation-procedures.md](references/installation-procedures.md)
**Customization guide:** [references/customization-guide.md](references/customization-guide.md)

## Quy trình

### 1. Verify Prerequisites

```bash
# Framework phải được clone vào .architecture/.architecture/
if [ ! -d ".architecture/.architecture" ]; then
  echo "Framework chưa được clone. Chạy:"
  echo "git clone https://github.com/codenamev/ai-software-architect .architecture/.architecture"
fi
```

Nếu thiếu: hướng dẫn user clone trước, dừng lại.

### 2. Phân tích Project

Dùng `Glob` và `Grep` để detect:
- **Languages**: TypeScript, Python, Ruby, Java, Go, Rust
- **Frameworks**: React, Vue, Next.js, Django, Rails, FastAPI, Spring
- **Infrastructure**: CI/CD, package managers, test setup
- **Structure**: directory layout, architecture patterns

### 3. Cài Framework

Xem [references/installation-procedures.md](references/installation-procedures.md) cho chi tiết từng bước:
- Copy framework files → `.architecture/`
- Remove clone directory
- Tạo directory structure (`decisions/adrs/`, `reviews/`, `recalibration/`, `comparisons/`)
- Initialize config từ template

**Quan trọng:** Luôn theo safety procedures khi xóa `.git/` directory.

### 4. Customize Architecture Team

Thêm technology-specific members vào `.architecture/members.yml` — xem [references/customization-guide.md § Customize Team Members](references/customization-guide.md) và [assets/member-template.yml](assets/member-template.yml).

Tech specialists cần thêm theo stack:
- **TypeScript/React**: JavaScript Expert + React Specialist
- **Python/FastAPI**: Python Expert + FastAPI Specialist
- **Go**: Go Expert + Microservices Architect
- **Java/Spring**: Java Expert + Spring Boot Specialist

**Giữ nguyên core members:** Systems Architect, Domain Expert, Security, Performance, Maintainability.

### 5. Customize Architectural Principles

Thêm framework-specific principles vào `.architecture/principles.md`. Xem [references/customization-guide.md § Customize Principles](references/customization-guide.md).

### 6. Update CLAUDE.md (nếu có)

Nếu project có `CLAUDE.md`, append framework usage section. Template ở [references/customization-guide.md § Update CLAUDE.md](references/customization-guide.md).

### 7. Cleanup

Xóa framework development files (README, USAGE*.md, INSTALL.md). Xóa template `.git/` với **critical safety checks** — xem [references/installation-procedures.md § Cleanup](references/installation-procedures.md).

### 8. Tạo Initial System Analysis

Generate comprehensive initial analysis document — mỗi member analyze system từ perspective của họ. Template: [assets/initial-analysis-template.md](assets/initial-analysis-template.md).

Lưu vào `.architecture/reviews/initial-system-analysis.md`.

### 9. Report kết quả

```
AI Software Architect Framework Setup Complete

Customizations:
- Added [N] technology specialists: [list]
- Customized principles for: [frameworks]

Initial Analysis Highlights:
- Overall assessment: [assessment]
- Top concern: [concern]
- Critical recommendation: [recommendation]

Location: .architecture/reviews/initial-system-analysis.md

Next Steps:
- Review initial analysis
- "List architecture members" để xem team
- "Create ADR for [decision]" để bắt đầu document
```

## Error Handling

**Framework chưa clone:**
```
Cần clone framework trước:
git clone https://github.com/codenamev/ai-software-architect .architecture/.architecture
Sau đó chạy lại setup.
```

**Đã setup rồi:**
```
Framework đã được setup.
Để verify: "What's our architecture status?"
Để reconfigure: sửa .architecture/members.yml và .architecture/principles.md
```

**Không xác định được project type:**
Hỏi user: primary language, framework, project purpose — customize accordingly.

## Lưu ý

- Customize dựa trên project **thực tế**, không thêm mọi possible option
- Safety checks khi cleanup là **non-negotiable** — không bao giờ skip
- Initial analysis nên focused và actionable, không cần exhaustive
