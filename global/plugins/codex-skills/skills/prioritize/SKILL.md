---
name: prioritize
description: >
  This skill should be used when the user asks to "prioritize features", "ưu tiên tính năng",
  "RICE scoring", "MoSCoW", "rank backlog", "sắp xếp backlog", "tạo roadmap",
  "transform roadmap", "feature roadmap", "outcome roadmap", "triage feature requests",
  "phân loại feature requests", "Kano analysis", "ICE scoring", "which feature first",
  "nên làm gì trước", or wants help deciding what to build next and in what order.
---


# Prioritize Features

Ưu tiên backlog và transform feature list thành roadmap có lý luận rõ ràng.

## Trước khi bắt đầu

Hỏi:
1. **Input là gì?** — Danh sách features? Backlog từ tool? Brainstorm list?
2. **Context quyết định?** — Sprint planning? Quarterly roadmap? Quick triage?
3. **Framework ưu tiên?** — Nếu không biết, hỏi để recommend (xem bên dưới)
4. **Criteria đặc biệt?** — Constraint nào (deadline, tech debt, compliance)?

## Chọn framework

| Tình huống | Framework phù hợp |
|-----------|-------------------|
| Backlog lớn, nhiều stakeholders, cần justify | RICE |
| Sprint planning, cần consensus nhanh | MoSCoW |
| Early stage, ít data, cần speed | ICE |
| Muốn hiểu user satisfaction impact | Kano |
| Có data về user needs từ research | Opportunity Score |

Xem chi tiết tất cả framework tại `references/prioritization-frameworks.md`.

## RICE Scoring

```
Score = (Reach × Impact × Confidence) / Effort

Reach:      Số user bị ảnh hưởng trong 1 quý (số thực)
Impact:     3=massive, 2=high, 1=medium, 0.5=low, 0.25=minimal
Confidence: 100%=high data, 80%=some data, 50%=gut feeling
Effort:     Person-weeks (1 tuần = 1, 1 tháng ≈ 4)
```

Output RICE table:
```
| Feature | Reach | Impact | Confidence | Effort | RICE Score | Rank |
|---------|-------|--------|------------|--------|------------|------|
| ...     |       |        |            |        |            |      |
```

Sau table: narrative giải thích top 3 choices và trade-offs.

## MoSCoW Sorting

Phân loại mỗi item:
- **Must** — product không hoạt động hoặc không thể ship thiếu cái này
- **Should** — quan trọng, có workaround nhưng UX kém
- **Could** — nice-to-have, bỏ nếu time eo hẹp
- **Won't** — explicitly loại khỏi scope lần này (ghi rõ lý do)

**Quan trọng:** Phần Must không quá 60% total effort. Nếu quá → scope quá lớn, cần cut.

## Outcome Roadmap

Khi user muốn transform feature list → strategic roadmap:

1. **Group features theo outcome/theme** thay vì feature type
2. **Gán mỗi group vào horizon:**
   - Now (current quarter): Committed, detailed
   - Next (next quarter): Probable, directional
   - Later (beyond): Exploratory, placeholder
3. **Label bằng outcome** không phải tên feature:
   - BAD: "Redesign onboarding screen"
   - GOOD: "Reduce time-to-first-value from 15 min to 5 min"

Template roadmap:
```
## [Product Name] — Q[?] Roadmap

**North Star:** [metric]

### Now (Q?)
**Theme: [Outcome]**
- [Feature] → contributes to [outcome] by [mechanism]
- [Feature] → ...

**Theme: [Outcome]**
- ...

### Next (Q?)
**Theme: [Outcome]** — [Confidence level: High/Med/Low]
- [Feature direction — not committed yet]

### Later
- [Area of exploration — no features committed]
```

## Feature Request Triage

Khi nhận được feature requests (từ sales, users, stakeholders):

1. **Categorize:** Bug fix / Enhancement / New feature / Infrastructure
2. **Strategic fit check:** Does this serve current OKR?
3. **Group by theme:** Thường 5-10 requests là cùng 1 underlying need
4. **Score nhanh bằng ICE:** Impact × Confidence × Ease (1-10 mỗi cái)
5. **Recommend:** Add to backlog / Add to roadmap / Reject (with rationale)

## Output format chuẩn

Mọi output prioritization đều có:
1. **Scoring/ranking table** (tùy framework)
2. **Top 3 recommendations** với rationale
3. **Trade-offs** — cái gì bị sacrifice khi chọn top 3
4. **Assumptions** — scoring dựa trên data nào, gì là gut feeling

Luôn label rõ confidence level của từng score. Không bịa số.
