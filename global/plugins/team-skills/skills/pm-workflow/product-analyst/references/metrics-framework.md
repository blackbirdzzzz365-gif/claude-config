# Metrics Framework — Hướng dẫn chi tiết

Xây dựng metrics framework đúng methodology, tránh những sai lầm phổ biến nhất.

---

## North Star Metric Framework

### Chọn North Star Metric đúng

Checklist cho North Star Metric tốt:
- [ ] Đo VALUE user nhận được, không chỉ đo activity
- [ ] Tương quan với long-term retention và revenue
- [ ] Team có thể influence được (không phải external factor)
- [ ] Leading indicator, không lagging
- [ ] Một con số duy nhất (không phải formula phức tạp)

**Ví dụ North Star theo business model:**

| Business Model | North Star Metric |
|---------------|-------------------|
| Marketplace | GMV (Gross Merchandise Value) |
| SaaS B2B | Weekly Active Teams |
| Consumer Social | Messages Sent (DAU × session frequency) |
| E-commerce | Orders per Active Buyer per Month |
| Fintech lending | Loan Volume của Healthy Borrowers |
| EdTech | Lessons Completed per Week |

### Input Metrics (Drivers)

Phân tích: North Star = f(Input 1, Input 2, Input 3...)

Ví dụ cho "Weekly Active Teams":
- Input 1: New team signups per week (acquisition)
- Input 2: Activation rate (% teams dùng core feature trong 7 ngày)
- Input 3: Week-4 retention rate
- Input 4: Expansion (% teams add thêm seats)

Mỗi squad/team nên own 1-2 input metrics, không phải North Star trực tiếp.

### Guardrail Metrics

Những metric KHÔNG được phá khi optimize North Star.

Ví dụ:
- Nếu optimize DAU → Guardrail: Session quality (không spam notifications)
- Nếu optimize revenue → Guardrail: Churn rate (không extract value ngắn hạn)
- Nếu optimize growth → Guardrail: Support ticket volume per user

### Anti-Metrics

Metrics team KHÔNG dùng để measure success (vì perverse incentives).

Ví dụ:
- Pageviews (user bị confused navigate nhiều page → high pageviews ≠ good)
- Time on site (có thể chỉ là user bị stuck)
- Features shipped (output không phải outcome)

---

## HEART Framework (Google)

Dùng để measure holistic product quality:

| Dimension | Đo gì | Ví dụ metric |
|-----------|--------|--------------|
| **H**appiness | Satisfaction, NPS | CSAT score, NPS, app store rating |
| **E**ngagement | Depth/frequency | DAU/MAU ratio, actions per session |
| **A**doption | New users, new features | Activation rate, feature adoption % |
| **R**etention | Return users | D7/D30 retention, churn rate |
| **T**ask Success | Completion, efficiency | Task completion rate, time-on-task, error rate |

---

## OKR Writing Guide

### Objective criteria:
- Inspiring và ambitious (bộ nhớ dễ nhớ sau 6 tháng)
- Qualitative (không có số)
- Time-bound (gắn với quarter/year)
- Within team's control

**Bad Objective:** "Improve product metrics in Q3"
**Good Objective:** "Make onboarding so good that users feel setup in minutes, not hours"

### Key Result criteria:
- Measurable (có số cụ thể)
- Outcome-based (không phải output)
- Has baseline và target
- Team can measure without ambiguity

**Bad KR:** "Launch new onboarding flow" (output)
**Good KR:** "Reduce time-to-first-value from 15 min to 5 min for 80% of new users"

**Bad KR:** "Increase engagement" (vague)
**Good KR:** "Grow D30 retention from 34% to 45% (Q3 cohorts)"

### Health check:
- 70% attainment = success (không phải 100%)
- Nếu team consistently hits 100% → KRs quá conservative
- Nếu team consistently misses 50% → KRs không realistic hoặc không trong control

---

## A/B Test Design

### Sample Size Calculation

Trước khi chạy test, tính:
```
Required sample size phụ thuộc vào:
- Baseline conversion rate (p)
- Minimum detectable effect (MDE) — e.g., muốn detect 10% lift
- Statistical power (thường 0.8)
- Significance level (thường p < 0.05 = 95% confidence)
```

Rule of thumb: Để detect 10% lift trên baseline 5% conversion rate với 95% confidence → cần ~10,000 users per variant.

Tools: [statsig.com/calculator](https://statsig.com/calculator), Google Optimize, hay Optimizely's calculator.

### Test Duration

- Tối thiểu: 1 tuần (capture full business cycle)
- Khuyến nghị: 2-4 tuần (reduce weekday/weekend bias)
- Không kết thúc sớm dù đã significant (peeking problem)

### Common A/B Test Pitfalls

**Network effects:** Nếu users tương tác với nhau, control và treatment contaminate nhau. → Dùng cluster-based randomization.

**Novelty effect:** Treatment tốt hơn chỉ vì users tò mò. → Phân tích first-week vs. later cohorts riêng.

**Multiple testing problem:** Nếu test nhiều metrics → tăng false positive rate. → Xác định primary metric TRƯỚC khi chạy test, không "data fish" sau.

**SRM (Sample Ratio Mismatch):** Control:Treatment không đúng tỉ lệ dự kiến → tracking bug. → Check ngay ngày đầu sau khi launch.

---

## Funnel Analysis

### Identify drop-off points

```
Step 1: [Event A]    → 100%
Step 2: [Event B]    → 78%  (drop: -22%)
Step 3: [Event C]    → 45%  (drop: -33%) ← Biggest drop
Step 4: [Event D]    → 38%  (drop: -7%)
Step 5: [Event E]    → 31%  (drop: -7%)
```

### Diagnosis questions cho mỗi drop-off:

1. Drop xảy ra tập trung ở segment nào? (new vs. returning, mobile vs. desktop, traffic source)
2. Có correlated với specific event (deploy, campaign, external factor)?
3. Session recordings/heatmaps cho thấy gì ở step này?
4. User research đã capture pain point ở step này chưa?
