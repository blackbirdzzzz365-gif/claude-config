---
name: product-analyst
description: >
  This skill should be used when the user asks to "write SQL", "viết query",
  "query BigQuery", "analyze metrics", "phân tích metrics", "define north star metric",
  "define OKR", "plan OKRs", "analyze A/B test", "phân tích A/B test",
  "calculate sample size", "cohort analysis", "phân tích cohort", "retention analysis",
  "setup metrics dashboard", "define success metrics", "tạo metrics framework",
  or any task involving data analysis, metric definition, or experiment design.
---


# Product Analyst

Phân tích metrics, viết SQL, thiết kế experiment, và xây dựng metrics framework cho sản phẩm.

## Các loại analysis task

### 1. SQL Query (BigQuery)

Trước khi viết query:
1. Hỏi: table nào cần query? Hoặc dùng BigQuery tool để list tables nếu user có quyền
2. Xem table schema (`get_table_info`) để hiểu columns
3. Clarify: time range, granularity (daily/weekly/monthly), filters cần thiết

Output query chuẩn:
```sql
-- [Mô tả query làm gì]
-- Author: [để trống]
-- Date: [ngày tạo]
-- Tables: [table names]

WITH base AS (
  SELECT ...
  FROM `project.dataset.table`
  WHERE DATE(created_at) BETWEEN DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)
    AND CURRENT_DATE()
),
...
SELECT ...
FROM base
```

Xem SQL patterns phổ biến tại `references/sql-patterns.md`.

### 2. North Star Metric & Metrics Framework

Input: mô tả sản phẩm, business model, OKR hiện tại.

Quy trình:
1. Identify North Star Metric — đo VALUE user nhận được, không chỉ đo engagement
2. Define Input Metrics (3-5 drivers của North Star)
3. Define Guardrail Metrics (không được phá khi optimize North Star)
4. Define Anti-metrics (những gì KHÔNG đo, để tránh perverse incentives)

Xem framework chi tiết tại `references/metrics-framework.md`.

### 3. A/B Test Analysis

Input: test results (control vs. treatment metrics).

Quy trình:
1. Check sample size — đủ statistical power chưa? (power ≥ 0.8, p < 0.05)
2. Check test duration — ít nhất 1 business cycle (thường 1-2 tuần)
3. Check for novelty effect — early vs. late cohort behavior
4. Primary metric + guardrail metrics — treatment có phá guardrail không?
5. Recommendation: Ship / Extend test / Kill

Output format:
```
Test: [tên]
Duration: [X ngày]
Sample: Control [N], Treatment [N]

Primary metric:    [metric] — Control: X%, Treatment: Y%, Lift: Z% (p=[value])
Guardrail metrics: [metric] — [OK / ⚠️ BROKEN]

Statistical significance: [Yes / No / Borderline]
Practical significance:   [ý nghĩa business của lift này]

Recommendation: [Ship / Extend / Kill]
Rationale: [2-3 câu]
```

### 4. OKR Writing

Input: business context, team focus area, quarter.

Quy trình:
1. Draft Objective — inspiring, qualitative, time-bound, team có thể influence
2. Draft 3-5 Key Results per Objective:
   - Đo OUTCOME không đo OUTPUT
   - Có số cụ thể (baseline → target)
   - Ambitious nhưng achievable (70% hit rate = healthy)
3. Check: KR có measure input hay output của Objective không? (phải là outcome)
4. Check: Team có đủ data để track KR này không?

### 5. Cohort & Retention Analysis

Input: cohort data hoặc request để tạo query.

Phân tích:
- Week 1, Week 4, Week 12 retention
- Cohort comparison (mới vs. cũ, before/after feature launch)
- Leading indicators của churn (early warning signals)
- Feature adoption by cohort

## Lưu ý quan trọng

**Kiểm tra trước khi claim:**
Mọi số liệu đưa ra phải từ data thực (query results) hoặc được label rõ là "giả định / ước tính".
Không bao giờ fabricate conversion rates, retention rates, hay market size.

**Flag data quality issues:**
Nếu thấy anomalies trong data (spike đột biến, gap dữ liệu, tracking inconsistency) → flag ngay.

**Context quan trọng hơn số:**
Luôn pair metric với narrative: "Retention tháng 3 giảm 8% — trùng với thời điểm competitor launch campaign X".

Tham khảo thêm tại `references/metrics-framework.md` và `references/sql-patterns.md`.
