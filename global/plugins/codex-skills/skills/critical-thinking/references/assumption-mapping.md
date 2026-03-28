# Assumption Mapping — Hướng dẫn chi tiết

Framework của David Bland & Alex Osterwalder (Inspired by "Testing Business Ideas", 2019).
Dùng để identify và prioritize assumptions cần validate trước khi invest vào building.

---

## Tại sao cần Assumption Mapping?

**The Build Trap:** PM thường biết product phải làm gì nhưng không biết nó có value không.
Teams build features dựa trên assumptions chưa validated → waste engineering effort.

**Lean Validation:** Test assumptions nhanh và rẻ (interviews, prototypes, smoke tests) thay vì build full feature rồi mới biết wrong.

---

## 4 loại assumption (Risk categories)

### Value Risk
*Liệu users có muốn điều này không?*
- Có problem này thực sự xảy ra không?
- Users có willing to pay/switch/adopt không?
- Solution có giải quyết đúng problem không?

### Usability Risk
*Liệu users có biết cách dùng không?*
- UI/UX có intuitive không?
- Users có discover được feature không?
- Onboarding có đủ để users self-serve không?

### Feasibility Risk
*Liệu team có build được không?*
- Tech có thể làm được trong timeline không?
- Team có skill cần thiết không?
- Third-party dependencies có reliable không?

### Viability Risk
*Liệu business có sustainable không?*
- Revenue/cost model có work không?
- Có compliance/regulatory issues không?
- Có đủ market size không?
- Channel có scalable không?

---

## 2x2 Matrix

```
HIGH
IMPORTANCE
    │  TIGERS              │  ELEPHANTS
    │  (Critical + Unknown) │  (Unknown but ignored)
    │  → Test NGAY         │  → Bring into light
    │                      │
────┼──────────────────────┼──────────────────────
    │  PAPER TIGERS        │  DEAD FISH
    │  (Looks risky,       │  (Unimportant + Unknown)
    │   but manageable)    │  → Ignore
    │                      │
LOW                         HIGH
IMPORTANCE                 UNKNOWNNESS
```

### Tigers (Most dangerous)
- Assumption quan trọng nhất
- Chưa biết là đúng hay sai
- **Action: Design experiment để test NGAY ASAP**

### Elephants
- Unknown nhưng không ai đề cập
- Nguy hiểm vì bị ignore, không phải vì low risk
- **Action: Discuss explicitly, then decide priority**

### Paper Tigers
- Team nghĩ là risky nhưng thực ra known/manageable
- Tốn thời gian lo lắng không cần thiết
- **Action: Articulate why risk is actually low, move on**

### Dead Fish
- Unknown nhưng không đáng test
- **Action: Consciously ignore, document why**

---

## Quy trình với Claude

### Bước 1: Dump tất cả assumptions

Cung cấp cho Claude:
- Mô tả feature/product/strategy
- Target user
- Business model

Claude generate danh sách assumptions comprehensive nhất có thể, chia theo 4 risk categories.

### Bước 2: Plot lên matrix

Với mỗi assumption, Claude (hoặc team) đánh giá:
- **Importance (1-5):** Nếu assumption sai, project có fail không?
- **Unknownness (1-5):** Team có evidence để support assumption chưa? Hay chỉ là gut feeling?

### Bước 3: Design experiments cho Tigers

Với mỗi Tiger assumption, chọn experiment nhanh nhất và rẻ nhất:

| Assumption | Experiment Type | Cost | Time | Confidence |
|-----------|-----------------|------|------|------------|
| Users sẽ pay $X | Pricing page (smoke test) | Low | 1 week | Medium |
| Users có problem Y | 5 user interviews | Low | 1 week | Medium |
| Feature có thể build | Tech spike | Medium | 1 week | High |

**Experiment types theo budget:**

| Budget | Method |
|--------|--------|
| Rất thấp | Interview (5 users), Survey, Fake door test |
| Thấp | Landing page + waitlist, Paper prototype, Wizard of Oz |
| Trung bình | Clickable prototype (Figma), Concierge MVP |
| Cao | MVP, A/B test, Pilot |

---

## Experiment Design (RITE method)

Với mỗi experiment, xác định:

```
Hypothesis: We believe [assumption]
We'll know we're right when [measurable outcome]
We'll test by [experiment method]
With [N users/data points]
Over [time period]

Success criteria:
- Strong evidence: [định nghĩa rõ ràng]
- Weak evidence: [định nghĩa]
- Evidence against: [định nghĩa]

Decision rule: If [condition], we [proceed/pivot/stop]
```

---

## Common mistakes

**Treating everything as a Tiger:**
Không phải assumption nào cũng cần test. Test mất thời gian và attention. Prioritize mercilessly.

**Testing the wrong things:**
Test solution (does this UX work?) trước khi validate problem (do users have this problem?). Test problem first.

**Setting weak success criteria:**
"Users liked it" → không đủ. "5/5 users completed task without assistance" → testable.

**Not learning from failed experiments:**
Failed = didn't prove hypothesis. Update understanding, redesign experiment, or kill assumption.
