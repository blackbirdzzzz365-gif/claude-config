# SQL Patterns — BigQuery Reference

Common query patterns cho PM analytics. Tất cả examples dùng BigQuery syntax.

---

## Pattern 1: DAU / MAU / WAU

```sql
-- Daily Active Users (định nghĩa: user thực hiện ít nhất 1 action)
SELECT
  DATE(event_timestamp) AS date,
  COUNT(DISTINCT user_id) AS dau
FROM `project.dataset.events`
WHERE DATE(event_timestamp) BETWEEN DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)
  AND CURRENT_DATE()
  AND event_name NOT IN ('page_view')  -- Exclude passive events
GROUP BY 1
ORDER BY 1;

-- DAU/MAU Ratio (stickiness)
WITH dau AS (
  SELECT DATE(event_timestamp) AS date, COUNT(DISTINCT user_id) AS count
  FROM `project.dataset.events`
  WHERE DATE(event_timestamp) >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)
  GROUP BY 1
),
mau AS (
  SELECT COUNT(DISTINCT user_id) AS count
  FROM `project.dataset.events`
  WHERE DATE(event_timestamp) >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)
)
SELECT
  dau.date,
  dau.count AS dau,
  mau.count AS mau,
  ROUND(dau.count / mau.count * 100, 1) AS dau_mau_ratio
FROM dau, mau
ORDER BY 1;
```

---

## Pattern 2: Retention Analysis (Cohort)

```sql
-- Week-N Retention by signup cohort
WITH cohorts AS (
  SELECT
    user_id,
    DATE_TRUNC(DATE(created_at), WEEK) AS cohort_week
  FROM `project.dataset.users`
  WHERE DATE(created_at) >= DATE_SUB(CURRENT_DATE(), INTERVAL 90 DAY)
),
activity AS (
  SELECT
    user_id,
    DATE_TRUNC(DATE(event_timestamp), WEEK) AS activity_week
  FROM `project.dataset.events`
  WHERE event_name = 'core_action'  -- Thay bằng core event của sản phẩm
  GROUP BY 1, 2
)
SELECT
  c.cohort_week,
  COUNT(DISTINCT c.user_id) AS cohort_size,
  DATE_DIFF(a.activity_week, c.cohort_week, WEEK) AS week_number,
  COUNT(DISTINCT a.user_id) AS retained_users,
  ROUND(COUNT(DISTINCT a.user_id) / COUNT(DISTINCT c.user_id) * 100, 1) AS retention_rate
FROM cohorts c
LEFT JOIN activity a ON c.user_id = a.user_id
GROUP BY 1, 2, 3
ORDER BY 1, 3;
```

---

## Pattern 3: Conversion Funnel

```sql
-- Funnel: Signup → Onboarding complete → First core action → D7 active
WITH funnel_steps AS (
  SELECT
    user_id,
    MAX(CASE WHEN event_name = 'signup_completed' THEN 1 ELSE 0 END) AS step1,
    MAX(CASE WHEN event_name = 'onboarding_completed' THEN 1 ELSE 0 END) AS step2,
    MAX(CASE WHEN event_name = 'core_action' THEN 1 ELSE 0 END) AS step3,
    MAX(CASE
      WHEN event_name = 'core_action'
        AND DATE_DIFF(DATE(event_timestamp), DATE(MIN(event_timestamp) OVER (PARTITION BY user_id)), DAY) <= 7
      THEN 1 ELSE 0 END) AS step4
  FROM `project.dataset.events`
  WHERE DATE(event_timestamp) >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)
  GROUP BY 1
)
SELECT
  COUNT(*) AS total_users,
  SUM(step1) AS completed_step1,
  SUM(step2) AS completed_step2,
  ROUND(SUM(step2) / SUM(step1) * 100, 1) AS step1_to_step2,
  SUM(step3) AS completed_step3,
  ROUND(SUM(step3) / SUM(step2) * 100, 1) AS step2_to_step3,
  SUM(step4) AS completed_step4,
  ROUND(SUM(step4) / SUM(step1) * 100, 1) AS overall_conversion
FROM funnel_steps;
```

---

## Pattern 4: Feature Adoption

```sql
-- % users dùng feature X trong 30 ngày, grouped by user segment
SELECT
  u.segment,  -- hoặc plan, country, signup_source...
  COUNT(DISTINCT u.user_id) AS total_users,
  COUNT(DISTINCT e.user_id) AS feature_users,
  ROUND(COUNT(DISTINCT e.user_id) / COUNT(DISTINCT u.user_id) * 100, 1) AS adoption_rate
FROM `project.dataset.users` u
LEFT JOIN (
  SELECT DISTINCT user_id
  FROM `project.dataset.events`
  WHERE event_name = 'feature_x_used'
    AND DATE(event_timestamp) >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)
) e ON u.user_id = e.user_id
WHERE DATE(u.created_at) <= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)  -- Exclude new users
GROUP BY 1
ORDER BY total_users DESC;
```

---

## Pattern 5: A/B Test Results

```sql
-- So sánh conversion rate giữa control và treatment
SELECT
  experiment_variant,
  COUNT(DISTINCT user_id) AS users,
  SUM(converted) AS conversions,
  ROUND(SUM(converted) / COUNT(DISTINCT user_id) * 100, 2) AS conversion_rate,
  -- Confidence interval (simplified)
  ROUND(1.96 * SQRT(SUM(converted) / COUNT(DISTINCT user_id)
    * (1 - SUM(converted) / COUNT(DISTINCT user_id))
    / COUNT(DISTINCT user_id)) * 100, 2) AS margin_of_error
FROM (
  SELECT
    user_id,
    experiment_variant,
    MAX(CASE WHEN event_name = 'purchase_completed' THEN 1 ELSE 0 END) AS converted
  FROM `project.dataset.experiment_events`
  WHERE experiment_id = 'exp_001'  -- Thay bằng experiment ID thực
    AND DATE(event_timestamp) BETWEEN '2024-01-01' AND '2024-01-14'
  GROUP BY 1, 2
)
GROUP BY 1
ORDER BY 1;
```

---

## Pattern 6: Revenue Analysis

```sql
-- Monthly Recurring Revenue trend
SELECT
  DATE_TRUNC(DATE(paid_at), MONTH) AS month,
  SUM(amount_usd) AS mrr,
  COUNT(DISTINCT user_id) AS paying_users,
  ROUND(SUM(amount_usd) / COUNT(DISTINCT user_id), 2) AS arpu
FROM `project.dataset.transactions`
WHERE status = 'completed'
  AND DATE(paid_at) >= DATE_SUB(CURRENT_DATE(), INTERVAL 12 MONTH)
GROUP BY 1
ORDER BY 1;
```

---

## Tips viết SQL cho BigQuery

**Performance:**
- Filter trên `DATE()` column thay vì apply function lên timestamp column
- Dùng `DATE_SUB(CURRENT_DATE(), INTERVAL N DAY)` thay vì hardcode dates
- Cluster tables by commonly filtered columns (date, user_id)

**Readability:**
- Dùng CTEs (`WITH ... AS`) thay vì nested subqueries
- Comment mỗi CTE làm gì
- Đặt tên columns rõ nghĩa trong SELECT

**Accuracy:**
- Always check: có duplicate rows không? → Dùng `COUNT(DISTINCT user_id)`
- Timezone: BigQuery lưu UTC → convert về VN time: `DATETIME(event_timestamp, 'Asia/Ho_Chi_Minh')`
- NULL handling: `COALESCE(value, 0)` khi cần
