# Prioritization Frameworks — Reference đầy đủ

9 frameworks phổ biến nhất, khi nào dùng cái nào, và cách apply.

---

## 1. RICE

**Dùng khi:** Backlog lớn, nhiều stakeholders, cần justify decisions với số liệu.

```
Score = (Reach × Impact × Confidence) / Effort
```

| Field | Definition | Scale |
|-------|-----------|-------|
| Reach | # users bị ảnh hưởng trong 1 quarter | Số thực (e.g., 1,000) |
| Impact | Mức ảnh hưởng per user | 3=massive, 2=high, 1=medium, 0.5=low, 0.25=minimal |
| Confidence | Mức chắc chắn của estimates | 100%=high, 80%=medium, 50%=low |
| Effort | Person-months để deliver | Số thực (e.g., 2 = 2 person-months) |

**Pitfalls:**
- Reach bias: features với large but shallow reach score cao hơn small but deep reach
- Don't game numbers — nếu mọi thứ đều "3" impact, framework vô nghĩa
- Effort estimate bias: engineers thường under-estimate

---

## 2. MoSCoW

**Dùng khi:** Sprint planning, release scoping, stakeholder alignment, cần consensus nhanh.

| Category | Nghĩa | % Effort |
|---------|-------|---------|
| **Must** | Non-negotiable — thiếu là fail hoặc không ship được | ≤ 60% |
| **Should** | Important, có workaround nhưng UX kém | 20-30% |
| **Could** | Nice-to-have, bỏ nếu time eo hẹp | 10-15% |
| **Won't** | Explicitly excluded — ghi rõ lý do | 0% (this sprint) |

**Rule:** Nếu Must > 60% total effort → scope quá lớn, cần cut Must hoặc extend timeline.

**Pitfalls:**
- "Must" inflation: stakeholders muốn mọi thứ là Must
- Won't cần ghi rõ "won't do THIS sprint" vs. "won't do ever"

---

## 3. ICE

**Dùng khi:** Early stage, ít data, cần tốc độ ra quyết định, quick triage.

```
Score = Impact × Confidence × Ease
```

Mỗi cái: 1-10 (10 là tốt nhất)

| Field | 1 (Low) | 5 (Medium) | 10 (High) |
|-------|---------|-----------|-----------|
| Impact | Minimal effect | Moderate effect | Game-changing |
| Confidence | Wild guess | Some data | Strong evidence |
| Ease | 3+ months, complex | 2-4 weeks, moderate | < 1 week, trivial |

**Pitfalls:**
- Ease bias: quick wins score cao nhưng long-term value thấp
- ICE là opinionated — standardize scales trước khi compare

---

## 4. Kano Model

**Dùng khi:** Feature roadmap, tránh over-invest vào wrong category, UX research.

| Category | Behavior | Strategy |
|---------|---------|---------|
| **Basic** (Must-be) | Absent = dissatisfied; Present = neutral | Just do it, don't gold-plate |
| **Performance** | More = more satisfied (linear) | Invest proportionally |
| **Delight** (Wow) | Unexpected; present = delighted | Prioritize for differentiation |
| **Indifferent** | Present or absent = neutral | Don't invest |
| **Reverse** | Present = some users dislike | Avoid or make optional |

**How to classify:** Survey users với 2 questions per feature:
- Functional: "Nếu tính năng này CÓ, bạn cảm thấy thế nào?"
- Dysfunctional: "Nếu tính năng này KHÔNG CÓ, bạn cảm thấy thế nào?"

Cross-reference answers → Kano category.

---

## 5. Opportunity Scoring (Ulwick)

**Dùng khi:** Có data từ user research, muốn find underserved needs.

```
Opportunity Score = Importance + max(Importance - Satisfaction, 0)
```

Cao (8-10): Underserved — users cần nhiều nhưng chưa được serve tốt → High opportunity
Trung bình (5-7): Competitive — nhiều competitors đang serve → Cần differentiation
Thấp (< 5): Overserved — users không cần nhiều và đã satisfied → Don't invest

**How to get data:** Survey users:
- "Mức độ quan trọng của [outcome] với bạn?" (1-10)
- "Bạn hài lòng như thế nào với solution hiện tại?" (1-10)

---

## 6. Value vs. Complexity Matrix

**Dùng khi:** Quick team alignment, visual prioritization workshop.

```
         HIGH VALUE
              │
  Quick Wins  │  Major Projects
  (Do now)    │  (Plan carefully)
              │
──────────────┼──────────────────
              │
  Fill-ins    │  Thankless Tasks
  (If time)   │  (Avoid/delegate)
              │
         LOW VALUE
    LOW COMPLEXITY ─── HIGH COMPLEXITY
```

Đặt mỗi feature lên matrix dựa trên team consensus.

---

## 7. Story Mapping (Jeff Patton)

**Dùng khi:** Organize user stories theo user journey, plan releases.

```
User Activities (horizontal):
[Log in] → [Search] → [Add to cart] → [Checkout] → [Track order]

User Tasks (vertical under each activity):
[Email login]    [Filter results]   [Select qty]    [Enter address]
[SSO login]      [Sort results]     [Save for later] [Payment]
[Reset password] [View history]     [Compare items] [Order confirmation]

Release slices (horizontal cuts):
─── MVP ────────────────────────────────────────────────────────
─── v1.1 ───────────────────────────────────────────────────────
─── v2.0 ───────────────────────────────────────────────────────
```

---

## 8. Impact Mapping

**Dùng khi:** Strategic planning, connect business goals với product decisions.

```
WHY (Goal) → WHO (Actors) → HOW (Impacts) → WHAT (Deliverables)

Ví dụ:
Increase revenue 20% (Q3)
├── New users
│   ├── Discover product faster
│   │   ├── SEO optimization
│   │   └── Referral program
│   └── Convert trial to paid
│       └── Improved onboarding
└── Existing users
    ├── Upgrade to higher plan
    │   └── Usage-based pricing nudges
    └── Refer new users
        └── Referral incentive program
```

---

## 9. Buy-a-Feature

**Dùng khi:** Stakeholder workshops, align cross-functional teams, executive buy-in.

**Setup:**
- Price mỗi feature theo relative effort (đơn giản = $100, phức tạp = $500)
- Cho mỗi stakeholder một budget ($1,000)
- Họ "mua" features họ muốn nhất
- Aggregate spending → prioritization

Outcome: Transparent, gamified, giảm political arguments.

---

## Chọn framework theo context

| Tình huống | Framework |
|-----------|-----------|
| Nhiều features, ít data | ICE |
| Nhiều data, nhiều stakeholders | RICE |
| Sprint scoping | MoSCoW |
| User research driven | Opportunity Scoring hoặc Kano |
| Strategic planning | Impact Mapping |
| Cross-team alignment | Story Mapping hoặc Buy-a-Feature |
| Quick visual sorting | Value vs. Complexity |

Không có framework "tốt nhất" — chọn cái team sẽ actually use consistently.
