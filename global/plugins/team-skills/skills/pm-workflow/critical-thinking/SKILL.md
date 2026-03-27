---
name: critical-thinking
description: >
  This skill should be used when the user asks to "pre-mortem", "devil's advocate",
  "phản biện", "challenge my plan", "stress test this idea", "tìm điểm yếu",
  "identify assumptions", "xác định assumptions", "prioritize assumptions",
  "assumption mapping", "what could go wrong", "điều gì có thể sai",
  "brutal review", "review khắt khe", "test this strategy", or wants to
  critically evaluate any plan, feature, strategy, or product decision before committing.
  Also use when the user wants to avoid groupthink or confirmation bias.
version: 0.1.0
argument-hint: <plan-strategy-or-decision>
allowed-tools: [Read]
---

# Critical Thinking

Stress-test plans, identify hidden assumptions, và challenge decisions trước khi team commit resources.

**Nguyên tắc cốt lõi:** Mục tiêu không phải là phá plan — là làm plan tốt hơn. Đưa ra critique có constructive alternative.

## Các chế độ

### Chế độ 1: Pre-mortem

Technique của Gary Klein. Research cho thấy pre-mortem tăng 30% khả năng phát hiện failure causes trước khi xảy ra.

Quy trình:
1. **Set up:** "Assume it's [6 months/1 year] from now. The project has completely failed. What happened?"
2. **Brainstorm failures** — liệt kê tất cả lý do có thể (minimum 10 items)
3. **Cluster and rank** — nhóm theo theme, rank theo probability × impact
4. **Top 3 deep dive** — phân tích từng failure: root cause, early warning signs, prevention
5. **Tripwires** — thiết kế early warning indicators để catch failure early

Output format:
```
PRE-MORTEM: [Tên project/feature]

Assumed failure date: [mốc thời gian]

TOP FAILURE CAUSES (ranked):
1. [Failure]: [Probability High/Med/Low] × [Impact High/Med/Low]
   Root cause: ...
   Early warning: ...
   Prevention: ...

2. [Failure]: ...

TRIPWIRES (monitor these weekly):
- [ ] [Metric/signal] — ngưỡng đáng lo ngại: [threshold]
- [ ] [Metric/signal] — ngưỡng đáng lo ngại: [threshold]

PLAN MODIFICATIONS:
- [Thay đổi gì trong plan để giảm risk]
```

Xem hướng dẫn chi tiết tại `references/pre-mortem-guide.md`.

### Chế độ 2: Devil's Advocate

Challenge toàn diện một quyết định hoặc strategy.

Quy trình:
1. **Understand the plan** — tóm tắt lại plan để confirm hiểu đúng
2. **Challenge từng assumption** — "Điều gì phải đúng để plan này work?"
3. **Steel-man the opposition** — Đưa ra strongest case AGAINST plan
4. **Second-order effects** — "Nếu X xảy ra, điều gì tiếp theo?"
5. **Blind spots** — Gì plan này KHÔNG xem xét?

Tone: Thẳng thắn nhưng constructive. Không brutal, không diplomatic. Honest.

Output format:
```
DEVIL'S ADVOCATE: [Quyết định/Plan]

HIDDEN ASSUMPTIONS (những gì phải đúng để plan work):
1. [Assumption] — Evidence: [Strong/Weak/Unknown]
2. [Assumption] — Evidence: [Strong/Weak/Unknown]

STRONGEST CASE AGAINST:
[2-3 đoạn văn, strongest objection]

SECOND-ORDER RISKS:
- Nếu [X], thì [Y] → dẫn đến [Z problem]
- Nếu [X], thì [Y] → dẫn đến [Z problem]

BLIND SPOTS:
- [Stakeholder/dimension bị bỏ qua]
- [Alternative solution chưa xem xét]

RECOMMENDATION:
[Proceed / Proceed with modifications / Pause and validate / Rethink]
[Specific modifications if proceeding]
```

### Chế độ 3: Assumption Mapping

Framework của David Bland, dùng để prioritize assumptions cần validate trước khi build.

Quy trình:
1. Liệt kê tất cả assumptions của plan (Value / Usability / Viability / Feasibility)
2. Plot lên 2x2 matrix: Important vs. Known/Unknown
3. Categorize:
   - **Tigers** — Important + Unknown: Test NGAY, đây là existential risks
   - **Elephants** — Unknown + bị ignore: Nguy hiểm vì không ai để ý
   - **Paper Tigers** — Important trông vậy nhưng thực ra known/low risk
   - **Dead Fish** — Unimportant + Unknown: Bỏ qua, không đáng test
4. Design experiments để validate Tigers trước khi invest thêm

Xem chi tiết tại `references/assumption-mapping.md`.

## Chọn chế độ nào?

| Tình huống | Chế độ phù hợp |
|-----------|----------------|
| Sắp launch feature / bắt đầu project | Pre-mortem |
| Đang xem xét strategy / pivot / lớn | Devil's Advocate |
| Bắt đầu build, chưa biết gì valid | Assumption Mapping |
| User muốn tất cả | Chạy Pre-mortem → Devil's Advocate → Assumption Mapping theo thứ tự |

Hỏi user muốn chế độ nào nếu không rõ.

## Quan trọng

Kết thúc mỗi critique bằng **constructive path forward**. Không bao giờ chỉ đưa ra vấn đề mà không có direction.
