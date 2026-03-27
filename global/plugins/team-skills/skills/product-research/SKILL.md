---
name: product-research
description: >
  This skill should be used when the user asks to "synthesize user interviews",
  "tổng hợp interview", "analyze user feedback", "phân tích feedback", "research users",
  "tìm user insights", "competitive analysis", "phân tích competitor", "analyze reviews",
  "đọc app store reviews", "market sizing", "customer journey map", "tạo persona",
  "user persona", or wants to extract insights from any user research data.
  Also use when the user wants to understand what users really need, pain points,
  or Jobs-to-be-Done from raw research material.
version: 0.1.0
argument-hint: <research-data-or-topic>
allowed-tools: [Read, WebSearch, Glob]
---

# Product Research

Tổng hợp và phân tích research data để extract insights có thể action được.

## Các loại research task

### 1. Interview Synthesis

Input: transcript files, ghi chú phỏng vấn, survey responses.

Quy trình:
1. Đọc tất cả materials được cung cấp
2. Extract quotes theo từng theme (đừng interpret trước, thu thập raw quotes trước)
3. Cluster theo pattern: pain points, jobs-to-be-done, workarounds, delighters
4. Score mỗi insight theo frequency (bao nhiêu % user đề cập) và severity (1-5)
5. Output insights theo format chuẩn (xem `references/interview-synthesis.md`)

Format output insight:
```
**[Insight tên ngắn gọn]**
Frequency: X/Y người đề cập (Z%)
Severity: [1-5] — [Low/Medium/High/Critical]
Summary: [1-2 câu mô tả pattern]
Evidence (verbatim quotes):
  - "[Quote 1]" — [context ngắn]
  - "[Quote 2]" — [context ngắn]
Opportunity: [Có thể giải quyết thế nào?]
```

### 2. Competitive Analysis

Input: tên competitors, product category, hoặc URL cụ thể.

Quy trình:
1. Research từng competitor: pricing, features, positioning, target segment
2. Identify gaps: gì họ làm tốt, gì họ yếu, gì họ không làm
3. Output comparison table + narrative analysis

Xem framework chi tiết tại `references/competitive-analysis.md`.

### 3. Feedback Analysis (App Store, Surveys, Support Tickets)

Input: raw reviews, NPS comments, support ticket summaries.

Quy trình:
1. Phân loại: Bug reports / Feature requests / Praise / Confusion
2. Cluster theo theme
3. Sentiment scoring per theme
4. Prioritize: frequency × sentiment intensity

### 4. Customer Journey Mapping

Input: product description, target user, touchpoints hiện tại.

Output: Journey map đầy đủ theo stages (Aware → Consider → Purchase → Onboard → Use → Expand → Refer), với:
- Actions user làm ở mỗi stage
- Emotional state (happy/neutral/frustrated)
- Pain points
- Opportunities

### 5. User Persona Building

Input: interview data hoặc behavioral analytics.

Output: 2-4 personas, mỗi persona có:
- Name + demographic sketch
- Primary job-to-be-done
- Pain points (top 3)
- Goals (top 3)
- Quote đại diện (verbatim nếu có)
- Behavior patterns

## Quy tắc quan trọng

**Tách biệt observation và interpretation:**
- Observation: "7/10 user phải hỏi support để tìm được feature X"
- Interpretation: "Navigation của feature X không intuitive"
Luôn trình bày observation trước, interpretation sau và label rõ.

**Flag khi data không đủ:**
Nếu sample size < 5 interviews → note rõ "preliminary insights, cần thêm data".
Nếu research data một chiều (chỉ có user hài lòng) → flag selection bias.

**Không fabricate quotes:**
Chỉ dùng quotes từ materials user cung cấp. Nếu không có materials → note rõ và hỏi.

## Output chuẩn

Mỗi research output có:
1. **TL;DR** — 3-5 bullet points insights chính (cho người chỉ đọc 2 phút)
2. **Detailed findings** — breakdown đầy đủ theo theme
3. **Recommended actions** — 3-5 action items cụ thể, ranked theo impact
4. **Open questions** — gì cần research thêm để confirm

Tham khảo thêm tại `references/interview-synthesis.md` và `references/competitive-analysis.md`.
