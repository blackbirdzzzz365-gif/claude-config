---
name: stakeholder-update
description: >
  This skill should be used when the user asks to "write stakeholder update", "viết status update",
  "weekly update", "monthly report", "báo cáo tuần", "báo cáo tháng", "stakeholder map",
  "tạo stakeholder map", "go-to-market plan", "GTM plan", "kế hoạch launch", "product strategy",
  "chiến lược sản phẩm", "product vision", "value proposition", "competitive battlecard",
  "positioning statement", or wants to communicate product status/strategy to leadership
  or other stakeholders.
version: 0.1.0
argument-hint: <update-type-or-context>
allowed-tools: [Read, mcp__claude_ai_Slack__slack_send_message_draft]
---

# Stakeholder Update

Tạo communication đúng format, đúng audience, đúng level của detail — để stakeholders luôn aligned và confident.

## Các loại output

### 1. Weekly/Monthly Status Update (RAG)

**RAG = Red / Amber / Green** — phương pháp báo cáo rõ ràng nhất cho leadership.

Input cần: sprint goals, metrics hiện tại, blockers, next steps.

Xem template tại `templates/weekly-rag-update.md`.

Format chuẩn:
```
# [Product Name] — Status Update [W? / Tháng ?]
**Overall Status:** 🟢 On Track / 🟡 At Risk / 🔴 Off Track

## Highlights
- [Achievement 1 — có số cụ thể nếu được]
- [Achievement 2]

## Metrics vs. Target
| Metric | Target | Actual | Status |
|--------|--------|--------|--------|
| [KR 1] | [num]  | [num]  | 🟢/🟡/🔴 |

## Risks & Blockers
- 🔴 [Blocker cần giải quyết ngay]: [action needed từ ai]
- 🟡 [Risk đang theo dõi]: [mitigation]

## Next 2 Weeks
- [ ] [Action 1] — Owner: [ai]
- [ ] [Action 2] — Owner: [ai]

## Decisions Needed
- [Quyết định cần từ stakeholders, nếu có]
```

### 2. Go-to-Market Plan

Input: product/feature description, launch date, target segment, success metrics.

Xem template tại `templates/gtm-plan.md`.

Cấu trúc GTM plan:
1. Launch Overview (what, when, who)
2. Target Audience & Segments
3. Positioning & Key Messages
4. Launch Channels & Tactics (owned, earned, paid)
5. Enablement (sales, support, CS)
6. Success Metrics (leading + lagging)
7. Launch Timeline
8. Risk & Mitigation

### 3. Stakeholder Map

Input: project description, list stakeholders (hoặc Claude suy luận từ context).

Output: Power × Interest grid + communication plan:

```
STAKEHOLDER MAP: [Project]

HIGH POWER, HIGH INTEREST (Manage Closely):
- [Name/Role]: [What they care about] → [How to engage]

HIGH POWER, LOW INTEREST (Keep Satisfied):
- [Name/Role]: [Minimum viable update cadence]

LOW POWER, HIGH INTEREST (Keep Informed):
- [Name/Role]: [Channel + frequency]

LOW POWER, LOW INTEREST (Monitor):
- [Name/Role]: [Monitor only]

COMMUNICATION PLAN:
Weekly: [Who gets what]
Monthly: [Who gets what]
Milestone-based: [What triggers updates]
```

### 4. Product Strategy Document

Input: product context, market situation, OKRs.

Cấu trúc (9 sections của Product Strategy Canvas):
1. Vision — Sản phẩm sẽ trở thành gì trong 3-5 năm?
2. Target Customer — Ai là người quan trọng nhất?
3. Customer Problems — Top 3 unmet needs
4. Solution Approach — Cách tiếp cận tổng thể
5. Differentiation — Tại sao chúng ta thắng?
6. Business Model — Monetize thế nào?
7. Metrics — Đo success thế nào?
8. Constraints — Gì không thể làm?
9. Milestones — 3-month, 6-month, 1-year checkpoints

### 5. Value Proposition

Output dùng format Jobs-to-be-Done based:

```
For [target customer — specific segment]
Who struggle with [primary pain point / job not being done]
[Product name] is [category]
That helps them [primary outcome]
Unlike [current alternative]
We [key differentiator — specific and provable]
```

## Calibrate theo audience

**Leadership/Board:** TL;DR first, RAG status, 3 bullets, call to action.
**Cross-functional team:** Full context, dependencies, timeline.
**External stakeholders:** Simple language, no jargon, focus on business outcomes.
**Engineering/Design:** Detail-oriented, specific, technical context ok.

Hỏi user về audience trước khi viết nếu không rõ.
