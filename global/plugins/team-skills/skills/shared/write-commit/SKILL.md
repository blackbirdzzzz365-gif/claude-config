---
name: write-commit
description: >
  This skill should be used when the user asks to "commit", "tạo commit",
  "viết commit message", "commit changes", "stage and commit", or wants to
  create a git commit with a well-structured message. Use when the user has
  made code changes and wants to commit them following team conventions.
version: 0.1.0
argument-hint: [message]
allowed-tools: [Bash, Read, Glob]
---

# Write Commit

Tạo git commit message chuẩn chỉnh theo Conventional Commits, phù hợp với quy ước team.

## Quy trình

1. Chạy `git status` để xem files đã thay đổi.
2. Chạy `git diff --staged` (hoặc `git diff` nếu chưa stage) để đọc nội dung thay đổi.
3. Xác định loại thay đổi:
   - `feat` — tính năng mới
   - `fix` — sửa bug
   - `docs` — cập nhật tài liệu
   - `refactor` — refactor code, không thêm feature/fix bug
   - `test` — thêm/sửa test
   - `chore` — maintenance (build, deps, config)
   - `skill` — thêm/sửa Claude Code skill
   - `knowledge` — cập nhật knowledge base
4. Viết commit message theo format dưới.
5. Stage files phù hợp và tạo commit.

## Format

```
<type>(<scope>): <subject>

[optional body]

[optional footer]
```

### Subject line rules
- Không quá 72 ký tự
- Dùng imperative mood: "add feature" không phải "added feature"
- Không kết thúc bằng dấu chấm
- Viết bằng tiếng Anh hoặc tiếng Việt tùy convention team

### Ví dụ tốt
```
feat(auth): add Google OAuth login flow

Replaces email/password with OAuth to reduce friction.
Closes #42.
```

```
skill(pm-workflow): add write-prd skill with PRD templates

Includes full 8-section PRD template and one-page variant.
References: prd-sections-guide.md
```

```
fix(onboarding): correct validation error on phone number field

Vietnamese phone numbers starting with 03x were rejected.
```

### Ví dụ xấu (tránh)
```
update stuff          ← quá vague
WIP                   ← không descriptive
fix bug               ← không nói bug nào
commit                ← vô nghĩa
```

## Khi không chắc scope

Dùng scope ngắn gọn là tên module/folder bị ảnh hưởng.
Nếu thay đổi nhiều nơi không liên quan → cân nhắc tách thành nhiều commits.

## Không commit file nhạy cảm

Kiểm tra trước khi stage:
- Không commit `.env`, `*.token`, `*.key`, `credentials.json`
- Nếu thấy file nhạy cảm trong git status → dừng lại và hỏi user
