---
name: user-stories
description: >
  This skill should be used when the user asks to "write user stories", "tạo user stories",
  "break down epic", "phân rã epic thành stories", "viết acceptance criteria", "tạo AC",
  "write Given/When/Then", "viết job stories", or wants to convert product requirements
  into sprint-ready user stories with acceptance criteria. Also use when asked to check
  if existing stories meet INVEST criteria.
version: 0.1.0
argument-hint: <epic-or-feature-description>
allowed-tools: [Read]
---

# User Stories

Phân rã epic hoặc feature thành user stories sprint-ready, với acceptance criteria đầy đủ theo Gherkin format.

## Input nhận vào

Nhận một trong các dạng:
- Mô tả feature hoặc epic (text)
- PRD document (file path hoặc nội dung paste)
- Danh sách requirements chưa structured

## Quy trình

**Bước 1 — Đọc và hiểu context**
Xác định: primary user là ai? Epic này giải quyết vấn đề gì? Tech constraints có không?

**Bước 2 — Identify stories**
Phân tích input, xác định các user stories. Nguyên tắc:
- Mỗi story deliver value độc lập (theo INVEST: Independent, Valuable)
- Story size: vừa với 1-3 ngày dev work
- Không quá lớn (phải split tiếp) cũng không quá nhỏ (task, không phải story)

**Bước 3 — Viết story theo format chuẩn**

```
### US-[số]: [Tên ngắn gọn]

**As a** [user type]
**I want** [goal/action]
**So that** [benefit/outcome]

**Acceptance Criteria:**
- Given [precondition]
  When [action]
  Then [expected result]
- Given [precondition]
  When [action]
  Then [expected result]

**Out of scope:** [gì KHÔNG thuộc story này]

**Dependencies:** [US-? phải done trước] / None

**Notes:** [context kỹ thuật, design link, edge cases cần lưu ý]
```

**Bước 4 — INVEST check**
Với mỗi story, verify:
- **I**ndependent — có thể dev/test độc lập không?
- **N**egotiable — details có thể adjust không?
- **V**aluable — deliver value cho user không?
- **E**stimable — team estimate được không?
- **S**mall — vừa sprint không?
- **T**estable — viết test case được không?

Nếu story fail INVEST → flag và gợi ý cách fix (split, merge, clarify).

## Job Story format (alternative)

Dùng Job Story thay User Story khi focus vào context và motivation hơn là persona:

```
When [situation/context]
I want to [motivation/goal]
So I can [expected outcome]
```

Job Story tốt hơn khi:
- Persona không rõ ràng hoặc nhiều loại user cùng dùng feature
- Focus vào behavioral context hơn là user segment

## Output format

Trả về:
1. **Danh sách stories** đánh số US-01, US-02... theo thứ tự logic (không phải priority)
2. **Story map** ngắn nếu có nhiều stories — group theo user journey stage
3. **Recommended sprint breakdown** — gợi ý chia stories vào sprint nào (MVP first)
4. **Open questions** — những gì cần clarify trước khi dev bắt đầu

Xem template tại `templates/story-template.md`.

## Lưu ý quan trọng

Acceptance criteria phải testable — nếu QA không thể viết test case từ AC, AC đó quá vague.
Luôn có ít nhất 1 AC cho happy path, 1 cho error/edge case.
