# PRD Sections — Hướng dẫn chi tiết

Hướng dẫn viết từng section của PRD. Đọc khi cần chi tiết hơn những gì có trong SKILL.md.

---

## Section 1: Problem Statement

**Mục đích:** Mô tả vấn đề cần giải quyết, không phải solution.

**Bao gồm:**
- Vấn đề cụ thể là gì?
- Ai bị ảnh hưởng? (user segment)
- Ảnh hưởng thế nào? (impact to user, impact to business)
- Tại sao cần giải quyết bây giờ? (urgency/opportunity)
- Evidence: data, quotes, research backing up this problem

**Dấu hiệu của Problem Statement tốt:**
- Đọc xong người ta hiểu WHY trước khi biết WHAT
- Không mention solution (dù chỉ gợi ý)
- Có số hoặc evidence thực

**Ví dụ xấu:**
> "Users cần một feature để upload nhiều ảnh cùng lúc."
(Đây là solution, không phải problem)

**Ví dụ tốt:**
> "63% user bỏ giỏ hàng khi upload hình sản phẩm vì phải lặp lại thao tác upload từng file một. Mỗi tháng team support nhận ~200 tickets liên quan đến quá trình này. Session recording cho thấy trung bình user phải upload 4.2 ảnh/sản phẩm."

---

## Section 2: Goals & Non-goals

**Goals — Bao gồm:**
- Business goals (KR nào của OKR nào)
- User goals (user muốn achieve gì)
- Product goals (cải thiện gì cho sản phẩm)

**Non-goals — Explicit về những gì KHÔNG làm trong version này:**
Non-goals quan trọng không kém goals. Giúp tránh scope creep và misalignment.

**Ví dụ:**
```
Goals:
- Giảm cart abandonment rate từ 63% xuống dưới 40% (OKR Q3 KR2)
- User upload 5+ ảnh trong < 2 phút

Non-goals (v1):
- Không support video upload
- Không edit/crop ảnh trong app
- Không auto-compress ảnh (sẽ xem xét v2)
```

---

## Section 3: User Stories / Use Cases

Viết theo format: "As a [user], I want [goal] so that [benefit]"

Bao gồm:
- Happy path (main flow)
- Edge cases quan trọng
- Error states

Phân loại theo priority: P0 (must have), P1 (should have), P2 (nice to have).

---

## Section 4: Functional Requirements

Danh sách requirements chi tiết, grouped theo feature area.

**Format:**
```
FR-01: [Requirement]
       Priority: P0/P1/P2
       Notes: [context, edge cases, constraints]
```

**Tips:**
- Dùng "The system SHALL..." cho must-have
- Dùng "The system SHOULD..." cho nice-to-have
- Tránh viết requirement mà không test được

---

## Section 5: Success Metrics

**Bắt buộc có:**
- Primary metric (1 metric chính đo success)
- Secondary metrics (2-4 metrics hỗ trợ)
- Guardrail metrics (không được phá)
- Baseline (giá trị hiện tại)
- Target (mục tiêu sau launch)
- Measurement method (đo bằng cách nào, tool nào)
- Timeframe (đo trong bao lâu để kết luận)

**Ví dụ:**
```
Primary: Cart abandonment rate
Baseline: 63% | Target: < 40% | Measured by: BigQuery funnel | Timeframe: 30 ngày post-launch

Secondary:
- Upload completion time: baseline 4.5 min → target < 2 min
- Upload error rate: baseline 12% → target < 3%

Guardrail:
- Overall conversion rate: không giảm quá 2%
- Page load time: không tăng quá 500ms
```

---

## Section 6: Risks & Mitigations

Liệt kê risks thực sự — không phải danh sách "để đó cho có".

**Categories:**
- Technical risks (infra, performance, security)
- User behavior risks (adoption, confusion)
- Business risks (compliance, revenue impact)
- Dependency risks (third-party, other teams)

**Format:**
```
Risk: [Mô tả risk]
Probability: High/Medium/Low
Impact: High/Medium/Low
Mitigation: [Kế hoạch giảm thiểu]
Owner: [Ai chịu trách nhiệm theo dõi]
```

---

## Section 7: Out of Scope

Explicit list những gì KHÔNG thuộc PRD này, kèm lý do (deferred, won't do, separate PRD).

**Ví dụ:**
- Video upload: Deferred to v2, requires separate infra work
- Bulk edit: Won't do — complexity không justify user value
- Mobile-specific gestures: Separate PRD — mobile team owns

---

## Section 8: Open Questions

Danh sách câu hỏi chưa có đáp án. Mỗi câu hỏi có owner và deadline trả lời.

**Ví dụ:**
```
Q: Limit số ảnh tối đa per product là bao nhiêu? → Owner: Engineering | By: [ngày]
Q: Có cần hỗ trợ WebP format không? → Owner: Design | By: [ngày]
Q: Ảnh được lưu ở đâu (S3 hay CDN)? → Owner: Backend | By: [ngày]
```

**PRD không có open questions = PRD chưa honest.**
Features mới luôn có unknowns. Ít nhất 3-5 câu.

---

## Metadata block (đầu file)

```yaml
---
Feature: [Tên feature]
Author: [Tên PM]
Status: Draft | In Review | Approved | Deprecated
Version: 1.0
Last updated: [YYYY-MM-DD]
Reviewers: [Engineering lead, Design lead, ...]
Related docs: [Figma link, Research doc link, Jira epic]
---
```
