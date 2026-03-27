# Pre-mortem Guide — Hướng dẫn chi tiết

Technique của Gary Klein (1989). Research cho thấy pre-mortem tăng 30% khả năng identify failure causes trước khi project thực sự fail.

---

## Tại sao pre-mortem work?

**Prospective hindsight:** Khi người ta tưởng tượng một event đã xảy ra (thay vì sẽ xảy ra), họ generate nhiều lý do chính xác hơn 30%.

**Psychological safety:** Nhóm được phép nói "điều này sẽ fail" — tránh hiệu ứng groupthink và sunk cost fallacy.

**Concrete future:** Nói về failure như fact đã xảy ra → tư duy cụ thể hơn là risk abstract.

---

## Setup

**Khi nào dùng:**
- Trước khi start major project hoặc sprint
- Trước khi launch feature quan trọng
- Trước khi present strategy lên leadership
- Bất kỳ lúc nào team cảm thấy "có gì đó không ổn nhưng không nói được"

**Thời gian:** 45-90 phút (workshop) hoặc 15-20 phút (solo với Claude)

---

## Quy trình chi tiết

### Phase 1: Set the scenario (5 phút)

Đọc to (hoặc viết ra):

> "Hãy tưởng tượng: Hôm nay là [ngày cụ thể, 3-6 tháng nữa]. Project/feature [tên] đã **hoàn toàn thất bại**. Không phải thất bại một phần — thất bại hoàn toàn. Chúng ta đang ngồi đây để tìm hiểu tại sao."

**Quan trọng:** "Hoàn toàn thất bại" — không phải "có vấn đề nhỏ". Extreme scenario khai thác tư duy tốt hơn.

### Phase 2: Independent brainstorm (10 phút)

Mỗi người viết riêng (hoặc Claude generate độc lập):

**Minimum 10 failure causes.** Categories để cover:
- **Execution failures:** Timeline trễ, quality kém, scope creep
- **Team failures:** Miscommunication, key person leave, wrong priorities
- **User failures:** Wrong assumption about users, adoption thấp, wrong segment
- **Market failures:** Competitor move, market shift, macro changes
- **Technical failures:** Performance issues, security breach, integration break
- **Business failures:** Budget cut, strategy pivot, stakeholder conflict
- **Assumption failures:** Data was wrong, research was biased, hypothesis invalid

### Phase 3: Share và cluster (10 phút)

Round-robin share. Group theo theme. Rank bằng dot-voting (mỗi người 3 votes cho failure họ sợ nhất).

### Phase 4: Deep dive top 3 (20 phút)

Với mỗi failure trong top 3, phân tích:

```
Failure: [Mô tả]

Root cause analysis (5 Whys):
  Tại sao [failure] xảy ra?
  → [Reason 1]
  Tại sao [Reason 1]?
  → [Reason 2]
  Tại sao [Reason 2]?
  → [Root cause]

Early warning signals (tripwires):
  - [Signal 1] — detectable at: [week/milestone]
  - [Signal 2] — detectable at: [week/milestone]

Prevention / Mitigation:
  - [Action 1] — Owner: [ai] — By: [when]
  - [Action 2] — Owner: [ai] — By: [when]
```

### Phase 5: Plan modifications (10 phút)

**Hỏi:** "Dựa trên những gì vừa identify, chúng ta sẽ thay đổi gì trong plan?"

Không phải mọi risk cần mitigation. Focus vào:
- Catastrophic failures (impact cao)
- Early risks (xảy ra sớm, block toàn bộ)
- Assumptions chưa validated

---

## Solo pre-mortem với Claude

Cung cấp cho Claude:
1. Mô tả project/feature (1-2 đoạn)
2. Timeline
3. Resources và constraints
4. Assumptions team đang làm

Claude sẽ generate:
- 15+ failure causes (diverse, không chỉ obvious ones)
- Rank theo probability × impact
- Deep dive 3 highest-risk failures
- Tripwires để monitor
- Specific plan modifications

---

## Common failure categories PM hay miss

**The dog that didn't bark (absence of evidence ≠ evidence of absence):**
- User research không capture silent majority
- No complaints ≠ happy users (churn silently)
- Test passed ≠ production will work

**Second-order effects:**
- Feature thành công → cần scale → infra không ready
- Feature viral → support ticket tăng 10x → team burnout
- New metric improved → gaming the metric → other metrics hurt

**Dependency failures:**
- API partner thay đổi terms
- Third-party service down vào đúng launch day
- Upstream team delayed → domino effect

**Organizational failures:**
- Key person leave sau khi launch
- Leadership change priorities mid-project
- Budget cut → team size giảm

---

## Sau pre-mortem

**Không cần lo mọi risk** — selective action.

Filter bằng:
- High probability AND high impact → Must address before launch
- Low probability AND high impact → Define contingency plan
- High probability AND low impact → Monitor only
- Low probability AND low impact → Ignore

Document outcomes vào project doc. Review tripwires weekly trong first month post-launch.
