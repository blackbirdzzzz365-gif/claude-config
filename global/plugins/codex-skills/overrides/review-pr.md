---
name: review-pr
description: >
  This skill should be used when the user asks to "review PR", "review pull request",
  "xem PR", "check PR", "đánh giá PR", "review code changes", or wants feedback on
  a pull request before merging. Use when reviewing skill files, knowledge base updates,
  or any code/config changes in the team repo.
---

# Review Pull Request

Review PR theo mindset tìm bug, regression, và rủi ro trước; summary chỉ là phần phụ.

## Quy trình

1. Đọc mục tiêu thay đổi từ PR description hoặc diff.
2. Xem các file thay đổi và xác định risk chính.
3. Ưu tiên tìm behavioral regressions, edge cases, missing validation, missing tests.
4. Trả findings theo severity, có file path và line tham chiếu khi có thể.

## Checklist cho Codex Skill PR

### Frontmatter

- [ ] `name` đúng format kebab-case, không trùng skill khác
- [ ] `description` nói rõ khi nào skill nên được dùng, có trigger phrases cụ thể
- [ ] Chỉ giữ metadata cần thiết, tránh frontmatter cũ chỉ dùng cho Claude slash commands

### SKILL.md Body

- [ ] Workflow rõ ràng, có thể action ngay
- [ ] Nội dung gọn, không phình quá mức
- [ ] References/templates được nhắc đúng lúc, không copy trùng lặp
- [ ] Không hardcode local paths trừ khi path đó là chuẩn của repo hoặc Codex home

### Skill Resources

- [ ] `references/` chỉ chứa material cần tra cứu khi cần
- [ ] `templates/` hoặc `assets/` có ích thật sự, không phải file thừa
- [ ] Nếu skill được sync từ nguồn Claude, override Codex chỉ xuất hiện khi thực sự cần khác biệt

### Knowledge / Repo Changes

- [ ] Nội dung knowledge chính xác, còn hiệu lực
- [ ] Không lộ secrets hoặc dữ liệu nhạy cảm
- [ ] Scripts sync không ghi đè skill người dùng ngoài phạm vi repo quản lý

## Format feedback

```markdown
## Findings
- [high] [file:line] Vấn đề và tác động
- [medium] [file:line] Vấn đề và tác động

## Open Questions
- Điều gì chưa chắc chắn hoặc cần confirm

## Summary
- Đánh giá ngắn gọn về trạng thái PR
```

Nếu không có findings, nói rõ điều đó và nêu residual risk hoặc test gap còn lại.
