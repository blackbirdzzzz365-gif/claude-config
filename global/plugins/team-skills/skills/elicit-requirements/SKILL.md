---
name: elicit-requirements
description: >
  This skill should be used when the user asks to "elicit requirements", "làm rõ yêu cầu",
  "hỏi stakeholder", "interview stakeholder", "requirements gathering", "thu thập yêu cầu",
  "discovery session", "kickoff meeting", "hỏi gì để hiểu nhu cầu", "clarify requirements",
  "đặt câu hỏi làm rõ", "5 whys", "JTBD interview", "jobs to be done",
  "funnel questions", "context-free questions", "elicitation workshop",
  "tìm root cause từ business", "stakeholder interview guide",
  or wants to systematically uncover, clarify, and document what stakeholders actually need
  before writing PRD or user stories.
version: 0.1.0
argument-hint: <topic-or-problem-statement> [optional]
allowed-tools: [Read, Write, Glob, Grep]
---

# Elicit Requirements

Dẫn dắt quá trình khám phá và làm rõ nhu cầu thật sự của stakeholder — bước TRƯỚC khi viết PRD hay user stories.

**Triết lý:** Stakeholder không phải lúc nào cũng biết rõ mình cần gì. Nhiệm vụ của BA là đặt đúng câu hỏi, đúng thứ tự, để đào sâu từ symptom → root cause → real need → actionable requirement.

## Bước 0 — Xác định context

Đọc các file sau nếu tồn tại (dùng Glob + Read):
1. `.phase.json` — lấy phase hiện tại
2. `docs/CONTEXT.md` — tổng quan project
3. `docs/ARCHITECTURE.md` — tech constraints
4. `knowledge/product-context.md` — product context của team

Nếu không có context file nào → vẫn tiếp tục, nhưng note rằng output cần validate thêm.

## Bước 1 — Chọn chế độ elicitation

Hỏi user: "Bạn đang ở giai đoạn nào?" rồi chọn chế độ phù hợp:

| Tình huống | Chế độ |
|-----------|--------|
| Mới bắt đầu, chưa biết gì nhiều | **Discovery (Context-Free)** |
| Có problem statement, cần đào sâu root cause | **Root Cause (5 Whys + Fishbone)** |
| Cần hiểu user motivation & switching behavior | **JTBD Interview** |
| Có draft requirements, cần validate & làm rõ | **Clarification (Funnel + Laddering)** |
| Workshop nhiều stakeholders | **Workshop Facilitation** |

Nếu user đã cung cấp đủ context → tự chọn chế độ phù hợp nhất, không cần hỏi.

---

## Chế độ 1: Discovery (Context-Free Questions)

Dùng khi biết rất ít về problem space. Dựa trên framework Gause & Weinberg.

**Quy trình:**

1. **Meta-questions** — hiểu bức tranh lớn trước:
   - "Ai là người dùng chính? Ai bị ảnh hưởng gián tiếp?"
   - "Thành công trông như thế nào? Đo bằng gì?"
   - "Giải quyết vấn đề này đáng giá bao nhiêu cho tổ chức?"
   - "Có constraints nào (budget, timeline, tech, compliance) cần biết trước?"
   - "Ai khác nên được hỏi ý kiến?"
   - "Đã có giải pháp nào được thử chưa? Kết quả ra sao?"

2. **Day-in-the-Life walkthrough:**
   - "Walk qua một ngày làm việc điển hình — bắt đầu từ đâu?"
   - "Trigger nào khiến bạn phải làm [task]?"
   - "Cần thông tin gì? Lấy từ đâu?"
   - "Output là gì? Ai dùng output đó?"
   - "Đâu là điểm frustrating nhất trong quy trình?"

3. **Boundary probe:**
   - "Gì nằm TRONG scope? Gì CHẮC CHẮN ngoài scope?"
   - "Nếu chỉ được giải quyết 1 thứ duy nhất, đó là gì?"
   - "Có hệ thống nào hiện tại phải tích hợp không?"

**Output:**

```
DISCOVERY SUMMARY: [Topic]
Date: [YYYY-MM-DD]
Stakeholder(s): [Tên, vai trò]

PROBLEM LANDSCAPE:
- Primary problem: ...
- Who's affected: ...
- Current state: ...
- Desired state: ...
- Success metric: ...

CONSTRAINTS:
- Budget: ...
- Timeline: ...
- Technical: ...
- Compliance/Legal: ...

KEY QUOTES:
- "[Verbatim quote]" — [Context]
- "[Verbatim quote]" — [Context]

OPEN QUESTIONS (cần follow-up):
1. [Question] — Hỏi ai: [Role]
2. [Question] — Hỏi ai: [Role]

NEXT STEP: [Chế độ nào tiếp theo: Root Cause / JTBD / Clarification]
```

---

## Chế độ 2: Root Cause (5 Whys + Fishbone)

Dùng khi có problem statement nhưng cần đào sâu nguyên nhân gốc.

**Quy trình:**

1. **State the problem** rõ ràng — 1 câu, quan sát được, đo được
2. **5 Whys chain:**
   ```
   Problem: [Observable symptom]
   Why 1: Tại sao [problem] xảy ra? → [Answer 1]
   Why 2: Tại sao [answer 1]?        → [Answer 2]
   Why 3: Tại sao [answer 2]?        → [Answer 3]
   Why 4: Tại sao [answer 3]?        → [Answer 4]
   Why 5: Tại sao [answer 4]?        → [Root cause]
   ```
   Lưu ý: Dừng khi đến nguyên nhân có thể action được. Có thể < 5 hoặc > 5.

3. **Branch out** — Nếu Why 2 có nhiều hơn 1 answer → fork thành multiple chains
4. **Fishbone categories** — nhóm root causes theo: People, Process, Technology, Policy, Data, External
5. **Validate** — với mỗi root cause hỏi: "Nếu fix cái này, problem có biến mất không?"

**Output:**

```
ROOT CAUSE ANALYSIS: [Problem statement]

5-WHYS CHAIN:
[Chain diagram như trên, có thể nhiều nhánh]

FISHBONE SUMMARY:
| Category   | Root Causes Found        | Fixable? |
|------------|--------------------------|----------|
| People     | ...                      | Yes/No   |
| Process    | ...                      | Yes/No   |
| Technology | ...                      | Yes/No   |
| Policy     | ...                      | Yes/No   |

PRIMARY ROOT CAUSE: [Root cause có impact cao nhất]
CONTRIBUTING FACTORS: [Các yếu tố phụ]

RECOMMENDED REQUIREMENTS:
1. [Requirement từ root cause] — Priority: Must/Should/Could
2. [Requirement từ root cause] — Priority: Must/Should/Could

VALIDATION NEEDED:
- [ ] [Check gì để confirm root cause đúng]
```

Xem thêm ví dụ tại `references/root-cause-elicitation.md`.

---

## Chế độ 3: JTBD Interview

Dùng khi cần hiểu user motivation, switching behavior, và "job" thực sự.

Dựa trên Switch Interview framework (Bob Moesta / Chris Spiek).

**Quy trình — 4 Forces of Progress:**

1. **Push (bất mãn hiện tại):**
   - "Điều gì khiến cách làm hiện tại không chấp nhận được?"
   - "Tình huống cụ thể nào khiến bạn nghĩ 'phải có cách khác'?"
   - "Vấn đề này xảy ra bao lâu rồi? Tần suất?"

2. **Pull (hấp lực giải pháp mới):**
   - "Bạn hình dung giải pháp lý tưởng trông như thế nào?"
   - "Điều gì hấp dẫn nhất ở [giải pháp mới]?"
   - "Bạn kỳ vọng cuộc sống/công việc thay đổi thế nào sau khi có giải pháp?"

3. **Anxiety (lo ngại về cái mới):**
   - "Điều gì khiến bạn do dự khi chuyển sang cách mới?"
   - "Rủi ro lớn nhất nếu giải pháp mới không hoạt động?"
   - "Cần gì để bạn cảm thấy an tâm khi thử?"

4. **Habit (quán tính cái cũ):**
   - "Bạn đã quen với workflow hiện tại bao lâu?"
   - "Có phần nào của cách cũ mà bạn vẫn thích?"
   - "Ai khác sẽ bị ảnh hưởng nếu bạn thay đổi cách làm?"

5. **Timeline** — tái hiện hành trình:
   - "Lần đầu nghĩ đến việc thay đổi là khi nào?"
   - "Bạn đã thử tìm giải pháp nào trước đó?"
   - "Điều gì trigger bạn bắt đầu tìm kiếm nghiêm túc?"

**Output:**

```
JTBD ANALYSIS: [Product/Feature area]

JOB STATEMENT:
"When [situation], I want to [motivation], so I can [expected outcome]."

4 FORCES MAP:
┌─────────────────────────────────────────┐
│  PUSH (away from current)    │ PULL (toward new)           │
│  • [Pain 1]                  │ • [Attraction 1]            │
│  • [Pain 2]                  │ • [Attraction 2]            │
├──────────────────────────────┼─────────────────────────────┤
│  HABIT (stay with current)   │ ANXIETY (about new)         │
│  • [Inertia 1]               │ • [Fear 1]                  │
│  • [Inertia 2]               │ • [Fear 2]                  │
└──────────────────────────────┴─────────────────────────────┘

Switching likelihood: [High/Medium/Low]
Key insight: [1 câu — điều bất ngờ nhất]

REQUIREMENTS IMPLICATIONS:
- Must address: [Push factor] → Requirement: ...
- Must deliver: [Pull factor] → Requirement: ...
- Must reduce: [Anxiety factor] → Requirement: ...
- Must ease transition from: [Habit factor] → Requirement: ...
```

---

## Chế độ 4: Clarification (Funnel + Laddering)

Dùng khi ĐÃ CÓ draft requirements nhưng cần validate và làm rõ.

**Quy trình:**

1. **Đọc requirement hiện có** — tìm vague terms, assumptions ngầm, thiếu sót
2. **Funnel down** mỗi requirement mơ hồ:
   - Open: "Khi bạn nói [X], ý bạn là gì cụ thể?"
   - Probe: "Cho tôi ví dụ cụ thể khi [X] xảy ra?"
   - Closed: "Vậy requirement là [restate cụ thể] — đúng không?"

3. **Ladder up** khi requirement là solution thay vì need:
   - "Tại sao [solution] này quan trọng?" (→ tìm underlying need)
   - "[Need] đó sẽ giúp bạn đạt được gì?" (→ tìm business goal)

4. **Ladder down** khi requirement quá abstract:
   - "Điều đó trông như thế nào trong thực tế?"
   - "Cho tôi scenario cụ thể?"
   - "Ai làm gì, ở đâu, khi nào?"

5. **Edge cases:**
   - "Chuyện gì xảy ra khi [unusual condition]?"
   - "Worst case scenario là gì?"
   - "Bao nhiêu user/transaction cùng lúc?"

6. **Completeness check** — INVEST + BABOK checklist:
   - Functional vs Non-functional đủ chưa?
   - Acceptance criteria rõ không?
   - Dependencies đã map chưa?

**Output:**

```
REQUIREMENT CLARIFICATION: [Feature/Epic]

VAGUE TERMS RESOLVED:
| Original Term     | Clarified Meaning                    | Confirmed By |
|-------------------|--------------------------------------|--------------|
| "nhanh"           | Response < 200ms at P95              | [Name]       |
| "dễ dùng"         | Max 3 clicks to complete task        | [Name]       |

REQUIREMENTS REFINED:
1. [REQ-01] [Requirement rõ ràng, testable]
   - Type: Functional / Non-functional
   - Priority: Must / Should / Could
   - Acceptance criteria: Given... When... Then...

GAPS FOUND:
- [ ] [Missing requirement area]
- [ ] [Assumption chưa validate]

DEPENDENCIES:
- [REQ-01] depends on [system/team/data]
```

---

## Chế độ 5: Workshop Facilitation

Dùng khi cần dẫn dắt session với nhiều stakeholders cùng lúc.

**Quy trình:**

1. **Prep agenda** — tạo workshop plan:
   - Mục tiêu workshop (max 3)
   - Attendees + vai trò
   - Timebox cho từng activity
   - Materials cần chuẩn bị

2. **Warm-up** (5 phút):
   - Mỗi người trả lời: "1 điều bạn muốn workshop này đạt được?"

3. **Diverge** (15-20 phút) — thu thập ý kiến, tránh groupthink:
   - Silent brainstorm: mỗi người viết trên sticky notes (hoặc doc riêng)
   - Round-robin share: mỗi người trình bày, không debate

4. **Cluster** (10 phút):
   - Nhóm ý kiến theo theme
   - Label mỗi cluster

5. **Converge** (15-20 phút):
   - Dot voting: mỗi người 3 votes
   - Discuss top-voted items
   - Decision: Keep / Park / Investigate

6. **Close** (5 phút):
   - Recap decisions
   - Assign action items + owners + deadlines

**Output:**

```
WORKSHOP SUMMARY: [Topic]
Date: [YYYY-MM-DD] | Duration: [X min]
Attendees: [Names + roles]
Facilitator: [Name]

OBJECTIVE: [What we set out to achieve]

THEMES IDENTIFIED:
1. [Theme] — [X] votes — Decision: [Keep/Park/Investigate]
2. [Theme] — [X] votes — Decision: [Keep/Park/Investigate]

KEY DECISIONS:
- [Decision 1] — Rationale: ...
- [Decision 2] — Rationale: ...

PARKED ITEMS (revisit later):
- [Item] — Owner: [Name] — Deadline: [Date]

ACTION ITEMS:
- [ ] [Action] — Owner: [Name] — Due: [Date]
- [ ] [Action] — Owner: [Name] — Due: [Date]

REQUIREMENTS EXTRACTED:
1. [REQ] — Source: [Theme/Discussion]
2. [REQ] — Source: [Theme/Discussion]
```

---

## Khi user paste raw text / transcript

Nếu user không chọn chế độ mà paste trực tiếp nội dung (meeting notes, chat log, email thread):

1. Đọc toàn bộ nội dung
2. Tự phân loại: đây là discovery data, problem statement, hay draft requirements?
3. Chọn chế độ phù hợp nhất
4. Extract insights theo format của chế độ đó
5. Luôn kết thúc bằng **Open Questions** — những gì cần hỏi thêm

---

## Anti-patterns — TRÁNH

- **Leading questions:** "Bạn có đồng ý rằng X tốt hơn không?" → Hỏi open: "Bạn nghĩ gì về X?"
- **Giả định answer:** "Vậy là bạn cần feature Y" → Hỏi confirm: "Tôi hiểu là bạn cần Y — đúng không?"
- **Nhảy vào solution:** "Chúng ta nên build API" → Quay lại: "Vấn đề thực sự cần giải quyết là gì?"
- **Hỏi quá nhiều cùng lúc:** Max 2 câu hỏi mỗi turn. Đợi trả lời rồi hỏi tiếp.
- **Bỏ qua silence:** Im lặng = đang suy nghĩ. Đợi 5 giây trước khi hỏi tiếp.

---

## Flow tổng thể

```
Discovery (Context-Free) → hiểu bức tranh lớn
        ↓
Root Cause (5 Whys) → đào sâu problem
        ↓
JTBD Interview → hiểu user motivation
        ↓
Clarification (Funnel) → refine thành requirements cụ thể
        ↓
→ Sẵn sàng cho /p:write-prd hoặc /p:user-stories
```

Mỗi chế độ có thể dùng độc lập hoặc theo flow trên.
