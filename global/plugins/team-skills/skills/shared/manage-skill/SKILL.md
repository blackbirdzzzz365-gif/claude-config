---
name: manage-skill
description: >
  This skill should be used when the user asks to "tạo skill mới", "create new skill",
  "update skill", "sửa skill", "thêm skill vào team", "add skill to repo",
  "cập nhật skill", "improve skill", "đóng gói thành skill", "make this a skill",
  "push skill lên repo", or wants to create or modify any Claude Code skill
  for the team repository. Also use when the user has just described a workflow
  they want to automate and wants to turn it into a reusable skill.
version: 0.1.0
argument-hint: <skill-name> [create|update]
allowed-tools: [Read, Write, Edit, Glob, Grep, Bash]
---

# Manage Skill

Tạo mới hoặc cập nhật skill cho team repo, bao gồm toàn bộ git workflow từ branch đến PR.

## Bước 0 — Xác định yêu cầu

Hỏi user (gộp thành 1 câu hỏi nếu chưa rõ):

**Tạo mới:** Cần biết:
1. Tên skill (kebab-case, ngắn gọn, động từ-đầu: `write-prd`, `analyze-metrics`)
2. Skill làm gì? (1-2 câu mô tả)
3. Trigger phrases — user sẽ nói gì để kích hoạt? (ít nhất 5 cụm)
4. Category: `shared/` (mọi người dùng) hay `pm-workflow/` (riêng PM)?
5. Cần references/ hay templates/ không?

**Cập nhật:** Cần biết:
1. Tên skill cần sửa (hoặc path)
2. Sửa gì cụ thể?

## Bước 1 — Đọc context repo

Xác định repo root:

```bash
git -C "$(dirname "$(find ~/.claude/plugins/custom/team-skills -name 'plugin.json' 2>/dev/null | head -1)")" rev-parse --show-toplevel 2>/dev/null || echo "NOT_FOUND"
```

Nếu không tìm được → hỏi user path của `claude-config/`.

Lưu path vào `REPO_ROOT`.

## Bước 2 — Tạo branch

```bash
git -C "$REPO_ROOT" checkout main
git -C "$REPO_ROOT" pull origin main
git -C "$REPO_ROOT" checkout -b skill/<tên-skill>
```

Dùng đúng tên branch convention: `skill/kebab-case-name`.

## Bước 3 — Tạo/sửa files

### Khi TẠO MỚI

Tạo cấu trúc thư mục:

```
skills/<category>/<skill-name>/
├── SKILL.md              ← bắt buộc
├── references/           ← thêm nếu có nội dung chi tiết > 100 dòng
│   └── <topic>.md
└── templates/            ← thêm nếu có boilerplate output
    └── <template>.md
```

**Viết SKILL.md theo chuẩn:**

```markdown
---
name: <skill-name>
description: >
  This skill should be used when the user asks to "<trigger 1>", "<trigger 2>",
  "<trigger 3>", "<trigger 4>", "<trigger 5>", or wants to [mô tả ngắn gọn].
version: 0.1.0
argument-hint: <input> [optional]
allowed-tools: [Read, Write, Edit, Bash, Glob, Grep]
---

# <Tên Skill>

<Mô tả 2-3 câu skill làm gì và khi nào dùng.>

## Quy trình

[Các bước cụ thể, dùng imperative — KHÔNG dùng "you should", "you need"]

## Output format

[Mô tả output trả về trông như thế nào]

## Lưu ý

[Edge cases, constraints, common mistakes]
```

**Quy tắc viết SKILL.md:**
- Dùng imperative: "Read the file." không phải "You should read the file."
- SKILL.md giữ dưới 300 dòng — nội dung dài đẩy vào `references/`
- Description phải có ít nhất 5 trigger phrases cụ thể, đặt trong ngoặc kép
- `allowed-tools` chỉ list tools skill thực sự cần dùng

### Khi CẬP NHẬT

Đọc file hiện tại trước:

```bash
cat "$REPO_ROOT/global/plugins/team-skills/skills/<category>/<skill-name>/SKILL.md"
```

Chỉ sửa phần cần thay đổi — không rewrite toàn bộ file nếu không cần thiết.
Bump version: `0.1.0` → `0.2.0` (minor change) hoặc `1.0.0` (major rewrite).

## Bước 4 — Commit

```bash
git -C "$REPO_ROOT" add global/plugins/team-skills/skills/<category>/<skill-name>/
git -C "$REPO_ROOT" commit -m "skill(<skill-name>): <mô tả ngắn thay đổi>"
```

Commit message format:
- Tạo mới: `skill(ten-skill): add skill for <mục đích>`
- Cập nhật: `skill(ten-skill): <cụ thể sửa gì>`

## Bước 5 — Push và tạo PR

```bash
git -C "$REPO_ROOT" push origin skill/<tên-skill>
gh pr create \
  --repo evo-pm-vn-ai/claude-config \
  --title "skill(<tên-skill>): <mô tả>" \
  --body "$(cat <<'EOF'
## Skill mới/cập nhật: <tên-skill>

**Category:** shared / pm-workflow

**Trigger phrases:**
- "<phrase 1>"
- "<phrase 2>"

**Test:** Đã test trên máy local — [mô tả kết quả]

**Files thay đổi:**
- SKILL.md
- references/<file> (nếu có)
- templates/<file> (nếu có)
EOF
)"
```

## Bước 6 — Báo cáo kết quả

Sau khi tạo PR, trả về:

```
✅ Skill "<tên>" đã được tạo/cập nhật

Branch:  skill/<tên-skill>
PR:      <link PR>
Files:   <danh sách files đã tạo/sửa>

Để test ngay: mở conversation mới trong Claude Code và nói "<trigger phrase>"
Sau khi PR được merge: cả team chạy `git pull` để có skill mới
```

## Lưu ý quan trọng

Skill mới **có hiệu lực ngay** trên máy tạo ra nó nhờ symlink — không cần đợi merge.
Chỉ sau khi merge + `git pull` thì cả team mới có.

Nếu user muốn test trên `_lab/` trước khi đưa vào `shared/` hoặc `pm-workflow/` → tạo branch và file trong `skills/_lab/<tên>/` trước, note lại để chuyển sau.
