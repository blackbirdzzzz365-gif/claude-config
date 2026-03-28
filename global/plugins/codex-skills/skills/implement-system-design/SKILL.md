---
name: implement-system-design
description: >
  This skill should be used when the user asks to "implement system design",
  "triển khai design system", "dịch architecture thành code", "build from architecture doc",
  "contract-first implementation", "refactor script crawler", "migrate script-based crawler",
  "triển khai social listening architecture", "thiết kế implementation slices",
  or wants to turn a system design document into implementation-ready contracts,
  schemas, services, browser tasks, and delivery slices.
---


# Implement System Design

Biến tài liệu kiến trúc thành implementation slices có thể ship, ưu tiên contract-first thay vì service-first.

## Bắt đầu đúng cách

1. Đọc design doc chính trước.
2. Nếu có critique/review doc, dùng nó để tìm gaps cần fix trước khi code.
3. Tóm tắt 4 thứ trước khi implement:
   - safety invariants
   - core contracts
   - domain entities
   - execution model

Nếu đang làm dự án social-listening-v2, đọc thêm:
- `references/social-listening-v2-checklist.md`
- `references/browser-runtime-notes.md`

## Cách chia việc

Triển khai theo vertical slice. Không dựng tất cả service trước rồi mới nối lại.

Mỗi slice nên đi theo thứ tự:
1. Domain contract
2. Persistence model
3. Service/API boundary
4. Browser/runtime behavior nếu có
5. Observability + audit
6. Tests + recovery behavior

Ưu tiên làm các slice unblock toàn hệ thống:
- approval boundary
- execution state
- context ownership
- write-action routing
- durable events

## Non-negotiables

- Mọi action làm thay đổi state Facebook phải đi qua cùng approval + audit boundary
- Không dùng boolean kiểu `human_approved: true` làm safety contract cuối cùng
- Không để execution state chỉ sống trong memory queue hoặc log text
- Không nhét entity thật vào JSON blob nếu nó cần query, analytics, retry, hoặc timeline
- Tách durable workflow events khỏi transient UI notifications
- Context phải có scope rõ ràng: product, group, thread, lead

## Browser layer strategy

Không hardcode một browser runtime như đáp án cuối cùng. Anti-detection thay đổi nhanh và cần swap được runtime.

- Dùng abstraction như `BrowserSession`, `BrowserTaskRunner`, `SessionStore`
- Giữ auth state theo file `storage_state`, không commit vào repo
- Route task:
  - deterministic: login, restore session, known URL navigation, session checks
  - dynamic: search, crawl, extract, join group, modal handling under changing DOM
- Nếu dùng browser agent, define task contract + output schema trước khi code

Đọc `references/browser-runtime-notes.md` trước khi chốt runtime.

## Output cần có cho mỗi task implement

```markdown
IMPLEMENTATION SLICE: [name]

Goal:
[what user story / risk this slice unlocks]

Contracts:
- [schema / API / event / browser task]

Files to add or change:
- ...

Tests:
- [happy path]
- [failure / retry / recovery]
- [approval / audit constraint]

Open questions:
- ...
```

## Checklist trước khi merge

- Domain table hay record mới đã có owner rõ ràng
- Write actions không bypass approval gate
- Pause/resume/retry có durable state record
- Failure modes có explicit event/log, không fail silent
- Browser tasks có timeout, retry rule, và status rõ ràng
- Security/privacy policy khớp với data model
