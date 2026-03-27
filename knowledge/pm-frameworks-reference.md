# PM Frameworks Quick Reference

Cheat sheet các framework hay dùng nhất. Đọc nhanh trước khi gọi skill.

---

## Prioritization Frameworks

### RICE
```
Score = (Reach × Impact × Confidence) / Effort

Reach:      Số user bị ảnh hưởng trong 1 quý
Impact:     3=massive, 2=high, 1=medium, 0.5=low, 0.25=minimal
Confidence: 100%=high, 80%=medium, 50%=low
Effort:     Person-weeks để deliver
```
**Dùng khi:** Backlog lớn, cần so sánh nhiều features khác nhau.

### MoSCoW
```
Must have   — không có thì sản phẩm không hoạt động / không ra mắt được
Should have — quan trọng nhưng có workaround nếu thiếu
Could have  — nice-to-have, bỏ nếu time/resource eo hẹp
Won't have  — explicitly loại khỏi scope lần này
```
**Dùng khi:** Sprint planning, release scoping, stakeholder alignment.

### ICE
```
Score = Impact × Confidence × Ease (mỗi cái 1-10)
```
**Dùng khi:** Quick prioritization, ít data, cần tốc độ ra quyết định.

### Kano Model
```
Basic (Must-be)    — thiếu → khách không hài lòng; có → take for granted
Performance        — càng nhiều càng tốt (linear satisfaction)
Delight (Wow)      — không expect, nhưng có thì rất thích
Indifferent        — không ảnh hưởng satisfaction
Reverse            — có thì một số người không thích
```
**Dùng khi:** Feature roadmap, tránh over-invest vào wrong category.

---

## Research Frameworks

### Jobs-to-be-Done (JTBD)
```
Format: When [situation], I want to [motivation], so I can [expected outcome].

Functional job: task cụ thể muốn hoàn thành
Emotional job:  cảm xúc muốn có/tránh
Social job:     muốn người khác nhìn mình thế nào
```
**Dùng khi:** User interviews, persona building, feature ideation.

### Opportunity Solution Tree (Teresa Torres)
```
Outcome (business metric) → Opportunities (user needs/pain) → Solutions → Experiments
```
**Dùng khi:** Connect business goal với user problems, tránh solution bias.

### Customer Journey Map
```
Stages: Aware → Consider → Purchase → Onboard → Use → Renew/Expand → Refer

Mỗi stage ghi:
- Touchpoints: user tương tác với gì?
- Actions: họ làm gì?
- Thoughts: họ nghĩ gì?
- Emotions: cảm xúc (happy / neutral / frustrated)
- Pain points: friction points
- Opportunities: chỗ có thể improve
```

---

## Requirements Frameworks

### User Story (3 C's)
```
Card:         As a [user type], I want [goal] so that [benefit]
Conversation: Discussion về details giữa team
Confirmation: Acceptance criteria — Given/When/Then
```

### INVEST (criteria cho good user story)
```
Independent  — không phụ thuộc story khác
Negotiable   — details có thể thảo luận
Valuable     — deliver value cho user/business
Estimable    — team estimate được effort
Small        — vừa với 1 sprint
Testable     — có thể viết test case
```

### Acceptance Criteria (Gherkin)
```
Given [precondition/context]
When  [action/event]
Then  [expected outcome]
And   [additional condition] (optional)
```

---

## Metrics Frameworks

### North Star Framework (Amplitude)
```
North Star Metric
├── Input Metric 1 (driver)
├── Input Metric 2 (driver)
└── Input Metric 3 (driver)

Guardrail Metrics (không được phá khi optimize North Star)
Anti-metrics   (những gì KHÔNG dùng làm success measure)
```

### HEART (Google)
```
Happiness    — satisfaction, NPS, sentiment
Engagement   — interaction depth/frequency
Adoption     — new users, feature adoption
Retention    — returning users, churn
Task Success — completion rate, error rate, time-on-task
```
**Dùng khi:** Measure product quality holistically, UX-focused metrics.

### OKR (John Doerr)
```
Objective: Inspiring, qualitative, time-bound
Key Result: Measurable, specific, ambitious (70% = success)

Quy tắc:
- 3-5 Objectives per quarter
- 3-5 Key Results per Objective
- KR đo OUTCOME không đo OUTPUT (shipped ≠ KR)
- KR phải có số cụ thể
```

---

## Critical Thinking Frameworks

### Pre-mortem (Gary Klein)
```
Bước 1: Giả sử project đã fail hoàn toàn
Bước 2: Viết ra TẤT CẢ lý do tại sao nó fail
Bước 3: Nhóm theo theme, rank theo probability
Bước 4: Thiết kế mitigation cho top 3
Bước 5: Thêm early warning tripwires vào plan
```

### Assumption Mapping (David Bland)
```
Phân loại assumptions theo 2 trục:
- Trục X: Important → Unimportant
- Trục Y: Known → Unknown

Tigers:       Important + Unknown → Test ngay
Paper Tigers: Important + Known (known to be false risks)
Elephants:    Unknown + Important (bị ignore)
Dead Fish:    Unimportant + Unknown (bỏ qua)
```

### Risk Quadrant (4 types)
```
Value risk:       Liệu user có muốn không?
Usability risk:   Liệu user có biết dùng không?
Viability risk:   Liệu business model có work không?
Feasibility risk: Liệu tech team có build được không?
```

---

## GTM Frameworks

### Product Launch Checklist
```
T-6 weeks: Define launch goals + success metrics
T-4 weeks: Finalize positioning + messaging
T-3 weeks: Prepare sales/support enablement
T-2 weeks: Beta testing + feedback loop
T-1 week:  Press/analyst outreach (if applicable)
T-0:       Launch + monitor dashboards
T+1 week:  First retrospective
T+1 month: Full launch review vs. metrics
```

### Positioning Statement
```
For [target customer]
Who [statement of need/opportunity]
[Product name] is [product category]
That [key benefit / reason to buy]
Unlike [primary alternative]
Our product [primary differentiation]
```
