---
name: manage-skill
description: >
  This skill should be used when the user asks to "tạo skill mới", "create new skill",
  "update skill", "sửa skill", "thêm skill vào team", "add skill to repo",
  "cập nhật skill", "improve skill", "đóng gói thành skill", "make this a skill",
  "push skill lên repo", "sync skill lên team", "update skills", "lấy skills mới nhất",
  "cài đặt claude config", "setup claude", or wants to create, modify, or sync any
  Claude Code skill or knowledge file for the team repository.
version: 0.2.0
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

## Bước 1 — Tìm REPO_ROOT và team.sh

```bash
TEAM_SH="$(readlink ~/.claude/plugins/custom/team-skills)/../../../team.sh"
REPO_ROOT="$(readlink ~/.claude/plugins/custom/team-skills)/../../.."
```

Hoặc resolve bằng:
```bash
SYMLINK_TARGET=$(readlink ~/.claude/plugins/custom/team-skills)
REPO_ROOT=$(cd "$SYMLINK_TARGET/../../.." && pwd)
TEAM_SH="$REPO_ROOT/team.sh"
```

Nếu không tìm được → hỏi user path của `claude-config/`.

## Bước 1b — Các tác vụ nhanh (không cần tạo skill)

**Khi user nói "update skills" / "lấy skills mới nhất":**
```bash
bash "$TEAM_SH" update
```
Xong. Không cần làm thêm gì.

**Khi user nói "sync lên team" / "đẩy thay đổi":**
```bash
bash "$TEAM_SH" sync
```
Script sẽ hỏi mô tả và xác nhận trước khi push. Không cần làm thêm gì.

**Khi user nói "setup" / "cài đặt":**
```bash
bash "$TEAM_SH" setup
```

---

## Bước 2 — Tạo branch (chỉ khi tạo/sửa skill)

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

## Bước 4 — Commit và sync

```bash
git -C "$REPO_ROOT" add global/plugins/team-skills/skills/<category>/<skill-name>/
git -C "$REPO_ROOT" commit -m "skill(<skill-name>): <mô tả ngắn thay đổi>"
```

Sau đó dùng team.sh để push:
```bash
bash "$TEAM_SH" sync
```

Hoặc push trực tiếp nếu đã có branch:
```bash
git -C "$REPO_ROOT" push origin skill/<tên-skill>
gh pr create --repo evo-pm-vn-ai/claude-config \
  --title "skill(<tên-skill>): <mô tả>" \
  --body "Skill mới: <tên>. Trigger: '<phrase>'. Test OK trên local."
```

## Bước 5 — Báo cáo kết quả

```
✅ Skill "<tên>" đã được tạo/cập nhật

Branch:  skill/<tên-skill>
PR:      <link PR>
Files:   <danh sách files>

Test ngay: mở conversation mới → nói "<trigger phrase>"
Cả team nhận: ./team.sh update
```

## Lưu ý quan trọng

Skill mới **có hiệu lực ngay** trên máy tạo ra nó nhờ symlink.
Chỉ sau khi merge + `./team.sh update` thì cả team mới có.

Test trong `_lab/` trước nếu chưa chắc — chuyển ra `shared/` hoặc `pm-workflow/` khi ổn.
