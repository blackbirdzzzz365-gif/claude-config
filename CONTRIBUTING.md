# Hướng dẫn đóng góp

## Nguyên tắc

- Mọi thay đổi vào `main` phải qua Pull Request
- PR cần ít nhất 1 người review và approve
- Không push trực tiếp vào `main`

---

## Quy trình thêm skill mới

### Bước 1: Tạo branch

```bash
git checkout -b skill/ten-skill-moi
```

### Bước 2: Test trong `_lab/` trước

```bash
mkdir -p global/plugins/team-skills/skills/_lab/ten-skill-moi
# Tạo SKILL.md trong folder đó
# Dùng thử trên máy cá nhân vài ngày
```

### Bước 3: Khi ổn, chuyển ra ngoài `_lab/`

```bash
mv global/plugins/team-skills/skills/_lab/ten-skill-moi \
   global/plugins/team-skills/skills/ten-skill-moi
```

### Bước 4: Push và tạo PR

```bash
git add .
git commit -m "skill: add ten-skill-moi"
git push origin skill/ten-skill-moi
# Tạo PR trên GitHub → assign reviewer → merge
```

### Sau khi merge

Cả team chạy để có skill mới:

```bash
cd ~/claude-config && git pull
```

---

## Cấu trúc Skills

Skills nằm flat trong `global/plugins/team-skills/skills/`:

```
skills/
├── _lab/               # Thử nghiệm cá nhân — KHÔNG tự deploy
├── write-prd/          # Skills đã review, sẵn sàng dùng
├── user-stories/
├── product-research/
└── ...
```

> Chỉ thư mục `_lab/` bị exclude khi deploy. Mọi folder khác sẽ được copy vào `~/.claude/commands/p/`.

---

## Convention đặt tên

- Tên folder skill: `kebab-case` (ví dụ: `write-prd`, `review-pr`)
- Tên file: `SKILL.md` (uppercase)
- Tên branch: `skill/`, `knowledge/`, `fix/`, `feature/`

---

## Cấu trúc SKILL.md chuẩn

```
ten-skill/
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
