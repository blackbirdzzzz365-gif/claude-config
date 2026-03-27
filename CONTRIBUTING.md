# Hướng dẫn đóng góp

## Nguyên tắc
- Mọi thay đổi vào `main` phải qua Pull Request
- PR cần ít nhất 1 người review và approve
- Không push trực tiếp vào `main`

## Quy trình thêm skill mới

### Bước 1: Tạo branch
```bash
git checkout -b skill/ten-skill-moi
```

### Bước 2: Test trong _lab/ trước
```bash
mkdir -p global/plugins/team-skills/skills/_lab/ten-skill-moi
# Tạo SKILL.md trong folder đó
# Dùng thử trên máy cá nhân vài ngày
```

### Bước 3: Khi ổn, chuyển ra ngoài
```bash
# Skills dùng cho mọi project:
mv global/plugins/team-skills/skills/_lab/ten-skill-moi \
   global/plugins/team-skills/skills/shared/ten-skill-moi

# Hoặc skills riêng PM:
mv global/plugins/team-skills/skills/_lab/ten-skill-moi \
   global/plugins/team-skills/skills/pm-workflow/ten-skill-moi
```

### Bước 4: Push và tạo PR
```bash
git push origin skill/ten-skill-moi
# Tạo PR trên GitHub → assign reviewer → merge
```

### Sau khi merge
Cả team chạy để có skill mới:
```bash
cd ~/claude-config && git pull
```

## Convention đặt tên
- Tên folder skill: `kebab-case` (ví dụ: `write-prd`, `review-pr`)
- Tên file: `SKILL.md` (uppercase)
- Tên branch: `skill/`, `knowledge/`, `fix/`, `feature/`

## Phân loại skills
- `skills/shared/`      — Skills dùng cho mọi project (commit, review PR...)
- `skills/pm-workflow/` — Skills riêng cho PM (viết PRD, ghi chú họp...)
- `skills/_lab/`        — Thử nghiệm cá nhân, chưa chính thức

## Cấu trúc SKILL.md chuẩn

```
skill-name/
├── SKILL.md                    # Core (< 300 dòng)
├── references/                 # Chi tiết — Claude load khi cần
│   └── topic-detail.md
└── templates/                  # Boilerplate sẵn để copy
    └── template-name.md
```

### Frontmatter bắt buộc
```yaml
---
name: ten-skill
description: >
  This skill should be used when the user asks to "...", "...",
  or wants to do [...]. Mô tả cụ thể trigger phrases.
version: 0.1.0
argument-hint: <input> [optional]
---
```

### Quy tắc viết body
- Dùng imperative form: "Parse the file." — KHÔNG dùng "You should parse..."
- SKILL.md giữ ngắn (< 300 dòng), chi tiết đưa vào `references/`
- Luôn reference các file trong `references/` và `templates/`
