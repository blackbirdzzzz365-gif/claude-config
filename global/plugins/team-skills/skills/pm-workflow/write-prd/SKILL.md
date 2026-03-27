---
name: write-prd
description: >
  This skill should be used when the user asks to "write a PRD", "tạo PRD",
  "viết product requirement", "draft product spec", "write feature spec",
  "tạo product brief", "viết tài liệu yêu cầu sản phẩm", or wants to create
  any form of product requirements document. Also use when asked to create a
  one-page PRD, feature brief, or product specification for a specific feature.
version: 0.1.0
argument-hint: <feature-name-or-description>
allowed-tools: [Read, WebSearch]
---

# Write PRD

Tạo Product Requirements Document chất lượng cao, đúng format, đầy đủ thông tin để engineering và design có thể bắt đầu work.

## Trước khi bắt đầu — Thu thập context

Hỏi user các thông tin sau nếu chưa có (tối đa 5 câu hỏi, nhóm lại):

1. **Feature là gì?** — Mô tả ngắn về tính năng cần build
2. **Vấn đề đang giải quyết?** — Problem statement, ai bị ảnh hưởng, ảnh hưởng thế nào
3. **Target user segment?** — Primary user, secondary user (nếu có)
4. **Constraints?** — Deadline, tech constraint, out-of-scope
5. **Success trông như thế nào?** — Metric cụ thể nếu có

Nếu user cung cấp file transcript, feedback, hoặc Figma link → đọc trước khi hỏi.

## PRD Format chuẩn (8 sections)

Xem chi tiết hướng dẫn từng section tại `references/prd-sections-guide.md`.
Dùng template tại `templates/prd-full.md` làm starting point.

### Khi nào dùng One-page PRD

Dùng `templates/prd-one-page.md` thay vì full PRD khi:
- Feature nhỏ (< 1 sprint để build)
- Không có ambiguity lớn
- Team đã hiểu context đầy đủ

## Quy trình tạo PRD

**Bước 1 — Draft**
Tạo draft đầy đủ theo template. Điền [TBD] vào những chỗ chưa có thông tin — đừng bịa.

**Bước 2 — Flag open questions**
Tại cuối mỗi section, note những gì cần clarify thêm. Section "Open Questions" phải có ít nhất 3 câu hỏi cho features mới.

**Bước 3 — Self-review checklist**
Trước khi trả về cho user, check:
- [ ] Problem statement rõ ràng, không giả định solution
- [ ] User stories dùng format "As a [user], I want [goal] so that [benefit]"
- [ ] Success metrics có số cụ thể, có baseline và target
- [ ] Out-of-scope explicit (tránh scope creep)
- [ ] Không có claim về competitor data hay market size mà không source

## Quality markers

**PRD tốt có:**
- Problem statement tách biệt hoàn toàn với solution
- User stories viết từ góc nhìn user, không từ góc nhìn kỹ thuật
- Success metrics đo OUTCOME không đo OUTPUT ("user hoàn thành onboarding trong < 5 phút" ≠ "ship onboarding flow")
- Risks section thành thật, không né tránh

**PRD xấu có:**
- "Build [feature X]" trong problem statement (solution-first)
- Metrics là output: "deliver feature by Q3" không phải outcome
- Open questions trống hoặc chỉ có 1 câu
- Assumptions không được explicit

## Output format

Trả về PRD dưới dạng markdown.
Đầu file có metadata block:

```
---
Feature: [Tên feature]
Author: [Để trống — user điền]
Status: Draft
Last updated: [ngày hôm nay]
---
```

Hỏi user xem muốn full PRD hay one-page trước khi tạo.
