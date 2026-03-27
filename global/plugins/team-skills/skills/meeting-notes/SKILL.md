---
name: meeting-notes
description: >
  This skill should be used when the user asks to "summarize meeting", "tổng hợp meeting",
  "ghi chú cuộc họp", "meeting notes", "extract action items", "lấy action items",
  "meeting recap", "tóm tắt họp", "write meeting summary", "họp xong cần ghi lại gì",
  or provides raw meeting notes, transcript, or recording summary that needs to be
  structured into decisions, action items, and follow-ups.
version: 0.1.0
argument-hint: [meeting-notes-or-transcript]
allowed-tools: [Read]
---

# Meeting Notes

Chuyển ghi chú thô hoặc transcript thành structured summary với decisions, action items, và follow-ups rõ ràng.

## Input nhận vào

- Raw notes (bullets, stream of consciousness)
- Meeting transcript (từ Zoom, Google Meet, Slack)
- Voice memo được transcribe
- Chỉ mô tả meeting bằng miệng (kém nhất — hỏi thêm thông tin)

## Quy trình

**Bước 1 — Xác định metadata**
Nếu không có trong input, hỏi:
- Tên/mục đích meeting
- Participants (ai + role)
- Ngày, thời lượng

**Bước 2 — Extract 4 loại thông tin**

1. **Decisions** — những gì đã được QUYẾT ĐỊNH (không phải thảo luận)
   - Format: "[Ai] quyết định [gì] vì [lý do ngắn]"
   - Chỉ mark là Decision khi có sự đồng thuận rõ ràng

2. **Action Items** — task cụ thể cần làm
   - Mỗi action item phải có: Owner + Task + Deadline
   - Format: "[ ] [Owner]: [Task] — Due: [ngày]"

3. **Open Questions** — câu hỏi chưa có đáp án
   - Format: "[Câu hỏi] — Owner to answer: [ai] — By: [khi nào]"

4. **Context/Background** — thông tin cần nhớ nhưng không phải decision hay action
   - Ngắn gọn, chỉ những gì ảnh hưởng đến work tiếp theo

**Bước 3 — Tạo structured output**

## Output format chuẩn

```markdown
# [Meeting Name]
**Date:** [ngày] | **Duration:** [X phút] | **Facilitator:** [tên]
**Participants:** [danh sách tên + role ngắn]

---

## TL;DR (30 giây)
[2-3 bullet points — most important takeaways cho người không tham dự]

---

## Decisions Made
- [Ai] quyết định [gì]: [rationale ngắn]
- ...

## Action Items
- [ ] **[Owner]**: [Task cụ thể] — Due: [ngày/deadline]
- [ ] **[Owner]**: [Task cụ thể] — Due: [ngày/deadline]
- [ ] **[Owner]**: [Task cụ thể] — Due: [ngày/deadline]

## Open Questions
- [Câu hỏi]? → [Owner tìm đáp án] by [ngày]
- ...

## Context & Notes
[Background information cần lưu lại, không phải decision/action]

---
**Next meeting:** [ngày/thời điểm nếu có]
**Notes by:** [để trống — user điền hoặc ghi "Claude"]
```

## Gửi qua Slack sau khi tổng hợp

Nếu user muốn share lên Slack channel, tạo thêm Slack-friendly format:
```
📋 *Meeting Recap — [Tên]*

*Decisions:*
• ...

*Action Items:*
• @[owner]: [task] (due [ngày])

*Questions:*
• ...

Full notes: [link Notion/Confluence nếu có]
```

## Lưu ý

Phân biệt rõ **Decision** vs **Discussion**: "Team đồng ý sẽ thảo luận thêm về X" KHÔNG phải là Decision.
Nếu không chắc chắn ai là owner của action item → label là "TBD" và note cần assign.
