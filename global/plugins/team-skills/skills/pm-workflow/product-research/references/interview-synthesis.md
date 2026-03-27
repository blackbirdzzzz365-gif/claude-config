# Interview Synthesis — Hướng dẫn chi tiết

Framework tổng hợp user interview từ raw transcript thành insights có thể action được.

---

## Quy trình 5 bước

### Bước 1: Prepare (trước khi đọc)

Xác định rõ research questions trước khi đọc materials:
- "Tại sao users bỏ giỏ hàng?"
- "Users dùng feature X như thế nào trong thực tế?"
- "Pain point lớn nhất trong luồng onboarding là gì?"

Nếu không có research questions → hỏi user trước khi tổng hợp.

### Bước 2: First pass — Collect raw observations

Đọc lần đầu, chỉ COLLECT, chưa interpret.

Ghi lại:
- Direct quotes (verbatim) — những gì user NÓI
- Observable behaviors — những gì user LÀM
- Emotional moments — chỗ user express frustration/delight/confusion

**Chưa cluster, chưa conclude. Chỉ thu thập.**

### Bước 3: Theme clustering (Affinity Mapping)

Group raw observations theo themes tự nhiên xuất hiện.

Common themes trong product research:
- **Pain Points** — khó khăn, friction, workarounds
- **Jobs to be Done** — underlying motivations
- **Current Workarounds** — cách họ đang tự giải quyết
- **Unmet Needs** — những gì họ muốn nhưng chưa có
- **Delighters** — những gì họ thích nhất
- **Confusions** — những gì không rõ hoặc unexpected

### Bước 4: Score và prioritize insights

Với mỗi insight, score:

**Frequency:** Bao nhiêu % participants đề cập
- High: > 60%
- Medium: 30-60%
- Low: < 30%

**Severity (với pain points):**
- 5 — Deal-breaker, user bỏ dùng hoặc không thể hoàn thành task
- 4 — Major friction, significantly impacts experience
- 3 — Moderate frustration, workaround exists
- 2 — Minor annoyance
- 1 — Edge case, rarely encountered

**Actionability:**
- High — Team có thể làm gì đó rõ ràng
- Medium — Cần thêm research hoặc validation
- Low — Out of control, external factor

### Bước 5: Synthesize và output

## Output format chuẩn

```markdown
# Research Synthesis — [Topic]
**Date:** [ngày] | **Participants:** [N] | **Method:** [Interview/Survey/Usability test]
**Research questions:** [liệt kê]

---

## TL;DR — Top 3 Insights
1. [Insight chính 1 — có số frequency]
2. [Insight chính 2]
3. [Insight chính 3]

---

## Pain Points

### [Pain Point Name]
**Frequency:** X/N (Y%) | **Severity:** [1-5] | **Actionability:** High/Med/Low

**Summary:** [1-2 câu mô tả pattern]

**Evidence (verbatim quotes):**
> "[Quote 1]" — [User type/context]
> "[Quote 2]" — [User type/context]

**Opportunity:** [Cách giải quyết tiềm năng]

---

## Jobs to Be Done

### [JTBD Statement]
When [situation], users want to [motivation], so they can [outcome].

**Frequency:** X/N | **How they do it now:** [current behavior]

---

## Unmet Needs

### [Need Name]
**Frequency:** X/N | **Currently addressed by:** [workaround or nothing]

**Quotes:**
> "[Quote]"

---

## Positive Signals (What's Working)

### [Positive Pattern]
**Frequency:** X/N
> "[Positive quote]"

---

## Recommended Actions (Prioritized)
1. **[Action]** — addresses [insight], estimated impact: High/Med/Low
2. **[Action]** — ...
3. **[Action]** — ...

## Further Research Needed
- [Question cần investigate thêm]
- [Hypothesis cần validate]

## Limitations & Caveats
- Sample size: [N] — [nhận xét về representativeness]
- Selection bias: [có không? Mô tả]
- Date of research: [quan trọng nếu market đã thay đổi]
```

---

## Interview best practices (cho lần sau)

**Câu hỏi tốt:**
- "Kể cho tôi nghe lần cuối cùng bạn [làm X]..."
- "Điều gì khiến bạn quyết định..."
- "Nếu không có [product/feature] này, bạn sẽ làm gì?"

**Câu hỏi tránh:**
- "Bạn có muốn feature X không?" — Leading question
- "Bạn có thích X không?" — Hypothetical, không reliable
- "Thường thì bạn..." — General, không cụ thể

**5 Whys technique:**
Khi user nói pain point, hỏi "Tại sao điều đó là vấn đề?" 5 lần để tìm root cause.
