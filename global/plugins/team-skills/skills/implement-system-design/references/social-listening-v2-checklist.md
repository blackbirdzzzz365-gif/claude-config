# social-listening-v2 Implementation Checklist

Áp dụng khi implement từ:
- `docs/design-system.md`
- `docs/design-system-review.md`

## Bản chất của doc

Đây không phải UI design system. Đây là system design cho một AI-assisted Facebook social listening product với:
- approval-gated write actions
- browser automation / browser agents
- execution state
- context memory
- analytics, lead tracking, notifications

## Những gaps quan trọng nhất từ review

1. `JOIN_GROUP` đang bị lệch boundary. Nếu action thay đổi Facebook state, nó phải qua write-action gate.
2. Approval boolean từ frontend là quá yếu. Cần approval artifact từ backend.
3. `PlanStep` chưa có contract đủ chặt cho review UI, executor, retry, audit.
4. Chưa có model bền vững cho execution như `plan_runs`, `plan_step_runs`, `execution_events`.
5. `ProductContext` đang quá rộng; cần thêm `GroupContext`, `ThreadContext`, `LeadContext`.
6. `group_intelligence` quan trọng nhưng chưa có owner/lifecycle rõ.
7. Data model thiếu entity first-class cho comments, groups, content variants, approval grants, notifications.
8. Privacy policy và schema đang conflict ở phần lưu tên người dùng.
9. Redis Pub/Sub không đủ cho business-critical workflow events.
10. Account health phải là subsystem riêng, không chỉ là runtime reaction khi đang chạy plan.

## Thứ tự implementation khuyến nghị

### Slice 1 — Approval + write boundary

Thêm:
- `approval_grants`
- backend-issued approval token/artifact
- shared write-action boundary cho post/comment/follow-up/join-group

Hoàn thành slice này trước khi đụng sâu vào engagement flows.

### Slice 2 — Execution contracts

Thêm:
- `PlanStep`
- `PlanRun`
- `PlanStepRun`
- `ExecutionCheckpoint`
- `ExecutionEvent`

Mục tiêu: review screen, executor, notifications, retry/resume cùng nói chung một contract.

### Slice 3 — Context ownership

Tách:
- `ProductContext`
- `GroupContext`
- `ThreadContext`
- `LeadContext`

Mỗi context phải có producer và lifecycle rõ ràng.

### Slice 4 — Durable events

Tách:
- durable workflow events
- client-facing notifications

Ưu tiên outbox + queue/stream semantics cho event nghiệp vụ.

### Slice 5 — Browser runtime abstraction

Không nhúng thẳng domain logic vào script selectors.

Tạo lớp trung gian:
- `BrowserSession`
- `BrowserTaskRunner`
- `BrowserTaskResult`
- `SessionHealth`

Mục tiêu: có thể đổi từ Playwright script sang agent/browser runtime mà không đổi business layer.

### Slice 6 — Account health subsystem

Theo dõi:
- CAPTCHA frequency
- rate-limit responses
- action blocked signals
- cooldown recommendations
- account risk state

## Migration path từ repo hiện tại

Repo hiện tại đang có các script:
- `fb_login.py`
- `fb_search.py`
- `fb_crawler.py`
- `fb_join_groups.py`

Không nên bọc nguyên xi các script này thành services rồi dừng lại. Hướng tốt hơn:

1. Giữ script login/session như deterministic primitives
2. Trích xuất browser/session abstraction
3. Chuyển search/crawl/extract/join thành task contracts
4. Bổ sung status/result codes rõ ràng: `OK`, `CAPTCHA_DETECTED`, `SESSION_EXPIRED`, `APPROVAL_REQUIRED`, `BLOCKED`
5. Chỉ sau đó mới bọc thành APIs/jobs/services

## Definition of done cho một slice

- Có contract/schema rõ
- Có persistent record cho state quan trọng
- Có audit trail
- Có explicit failure modes
- Có test cho recovery hoặc retry
