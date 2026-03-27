---
name: review-pr
description: >
  This skill should be used when the user asks to "review PR", "review pull request",
  "xem PR", "check PR", "đánh giá PR", "review code changes", or wants feedback on
  a pull request before merging. Use when reviewing skill files, knowledge base updates,
  or any code/config changes in the team repo.
version: 0.1.0
argument-hint: <pr-url-or-branch>
allowed-tools: [Bash, Read, Glob, Grep]
---

# Review Pull Request

Review PR theo checklist chuẩn, đưa ra nhận xét actionable.

## Quy trình

1. Đọc PR description để hiểu mục đích thay đổi.
2. Xem diff (`git diff main...branch` hoặc đọc files thay đổi).
3. Chạy qua checklist dưới theo loại thay đổi.
4. Đưa ra feedback theo 3 cấp độ:
   - **Blocker** — phải fix trước khi merge
   - **Suggestion** — nên fix nhưng không bắt buộc
   - **Nit** — minor, tùy reviewer và author

## Checklist cho Skill PR

### Frontmatter
- [ ] `name` đúng format kebab-case, không trùng tên skill đã có
- [ ] `description` dùng third-person, có ít nhất 3 trigger phrases cụ thể
- [ ] `version` có và đúng format semantic (0.1.0)
- [ ] `argument-hint` có nếu là slash command

### SKILL.md Body
- [ ] Không dùng "you should", "you need" → phải dùng imperative
- [ ] Độ dài hợp lý (< 300 dòng cho core skill)
- [ ] Có reference đến files trong `references/` và `templates/` (nếu có)
- [ ] Instructions rõ ràng, actionable — không vague

### Cấu trúc thư mục
- [ ] Đúng thư mục (shared/ hay pm-workflow/ hay _lab/)
- [ ] References và templates đặt đúng chỗ
- [ ] Không có file không cần thiết

### Content chất lượng
- [ ] Skill làm đúng 1 việc, không scope creep
- [ ] Examples có trong skill hoặc references
- [ ] Không hardcode path cụ thể của máy ai đó

## Checklist cho Knowledge PR

- [ ] `product-context.md` — thông tin chính xác, cập nhật ngày tháng
- [ ] Không có thông tin nhạy cảm (API key, password, internal metrics không muốn share)
- [ ] Markdown format hợp lệ

## Format feedback

```markdown
## PR Review: [tên PR]

### Blockers (phải fix)
- [file:line] Vấn đề: ... | Gợi ý: ...

### Suggestions (nên fix)
- [file:line] Vấn đề: ... | Gợi ý: ...

### Nits (tùy)
- [file:line] ...

### Tổng kết
[Approve / Request changes / Comment]
Lý do ngắn gọn.
```
