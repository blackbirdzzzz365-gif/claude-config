---
name: manage-skill
description: >
  This skill should be used when the user asks to "tạo skill mới", "create new skill",
  "update skill", "sửa skill", "thêm skill vào codex", "add skill to codex",
  "cập nhật skill", "đóng gói thành skill", "make this a skill", "sync codex skills",
  "cài codex skill", "lấy skills mới nhất", or wants to create, modify, or sync any
  Codex skill or shared knowledge file in this repository.
---

# Manage Skill & Knowledge

Quản lý bộ skill Codex trong repo này và đồng bộ sang `~/.codex/skills`.

## Đường dẫn chính

- Claude source skills: `global/plugins/team-skills/skills`
- Codex skills: `global/plugins/codex-skills/skills`
- Codex overrides: `global/plugins/codex-skills/overrides`
- Knowledge base: `knowledge`
- Installed Codex skills: `~/.codex/skills`
- Sync script: `scripts/sync-codex-skills.sh`

## 1. Lấy skill Codex mới nhất

Khi user muốn sync hoặc refresh skills:

1. Pull repo nếu cần.
2. Chạy `./scripts/sync-codex-skills.sh`.
3. Kiểm tra skill đã có trong `~/.codex/skills/<skill-name>`.

Skill mới sẽ sẵn sàng cho các chat Codex mới sau khi sync xong.

## 2. Tạo skill mới

Khi user muốn tạo skill mới:

1. Chọn tên kebab-case, ưu tiên verb-first như `write-prd`, `review-pr`.
2. Tạo thư mục `global/plugins/codex-skills/skills/<skill-name>/`.
3. Tạo `SKILL.md` với frontmatter tối thiểu:

```markdown
---
name: <skill-name>
description: >
  This skill should be used when the user asks to "<trigger 1>", "<trigger 2>",
  "<trigger 3>", or wants to [mô tả ngắn].
---
```

4. Viết body ngắn, procedural, chỉ giữ workflow cốt lõi.
5. Nếu skill có references hoặc templates, ưu tiên đặt ở repo và link/sync qua script thay vì copy tay nhiều lần.
6. Chạy `./scripts/sync-codex-skills.sh`.

## 3. Cập nhật skill có sẵn

Khi user muốn sửa skill:

1. Đọc `global/plugins/codex-skills/skills/<skill-name>/SKILL.md`.
2. Nếu skill này được mirror từ Claude source, sửa source trước ở `global/plugins/team-skills/skills/<skill-name>/SKILL.md`.
3. Nếu Codex cần behavior riêng, tạo hoặc sửa override tại `global/plugins/codex-skills/overrides/<skill-name>.md`.
4. Chạy lại `./scripts/sync-codex-skills.sh`.

## 4. Cập nhật knowledge

Knowledge dùng chung vẫn nằm trong `knowledge/`.

1. Chọn file phù hợp nhất, ưu tiên update file sẵn có.
2. Chỉ thêm thông tin thực sự reusable.
3. Nếu knowledge ảnh hưởng tới workflow skill, cập nhật skill tương ứng để nhắc đọc đúng file.

## Lưu ý

- Codex chỉ cần `name` và `description` trong frontmatter.
- Không nhét hướng dẫn dài vào `SKILL.md`; chuyển nội dung chi tiết sang `references/` hoặc `templates/`.
- Nếu user muốn skill dùng được ngay trong chat hiện tại, cần nói rõ rằng phiên hiện tại có thể chưa refresh danh sách skill; các chat mới sẽ nhận bộ skill sau khi sync.
