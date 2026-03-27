---
name: manage-skill
description: >
  This skill should be used when the user asks to "tạo skill mới", "create new skill",
  "update skill", "sửa skill", "thêm skill vào team", "add skill to repo",
  "cập nhật skill", "improve skill", "đóng gói thành skill", "make this a skill",
  "push skill lên repo", "sync skill lên team", "update skills", "lấy skills mới nhất",
  "lấy knowledge mới nhất", "cập nhật knowledge", "thêm knowledge", "update knowledge",
  "cài đặt claude config", "setup claude", or wants to create, modify, or sync any
  Claude Code skill or knowledge file for the team repository.
version: 0.3.0
argument-hint: <skill-name|knowledge-name> [create|update|pull|push]
allowed-tools: [Read, Write, Edit, Glob, Grep, Bash]
---

# Manage Skill & Knowledge

Quản lý skills và knowledge files trong team repo — bao gồm lấy về, tạo mới, cập nhật, và đẩy lên cho cả team.

## Bước 0 — Tìm REPO_ROOT

```bash
REPO_ROOT=$(cd "$(dirname "$(readlink ~/.claude/commands/p/manage-skill.md 2>/dev/null || echo ~/.claude/commands/p/manage-skill.md)")/../../.." 2>/dev/null && pwd)
```

Nếu không resolve được, thử:
```bash
ls ~/claude-project/claude-config/team.sh   # hoặc hỏi user path của team.sh
```

Khi đã có REPO_ROOT:
```bash
TEAM_SH="$REPO_ROOT/team.sh"
SKILLS_DIR="$REPO_ROOT/global/plugins/team-skills/skills"
KNOWLEDGE_DIR="$REPO_ROOT/knowledge"
```

---

## 1. Lấy skills / knowledge mới nhất về

**Khi user nói:** "update skills", "lấy skills mới nhất", "lấy knowledge mới nhất", "sync về máy"

```bash
bash "$TEAM_SH" update
```

Lệnh này:
1. `git pull origin main` — lấy tất cả thay đổi từ team
2. Copy mọi `SKILL.md` vào `~/.claude/commands/p/<skill-name>.md`
3. Skill có hiệu lực ngay — không cần restart Claude Code

Kiểm tra skills đang có:
```bash
ls ~/.claude/commands/p/
```

Dùng skill trong Claude Code: `/p/<skill-name>`

---

## 2. Upload skill mới lên team

**Khi user nói:** "tạo skill mới", "đóng gói thành skill", "thêm skill vào team", "push skill lên"

### Bước 2.1 — Hỏi thông tin (nếu chưa rõ)

Hỏi gộp 1 lần:
1. Tên skill (kebab-case, động từ đầu: `write-prd`, `analyze-metrics`)
2. Skill làm gì? (1-2 câu)
3. User sẽ nói gì để kích hoạt? (ít nhất 5 cụm, đặt trong ngoặc kép)

### Bước 2.2 — Tạo file SKILL.md

Path: `$SKILLS_DIR/<skill-name>/SKILL.md`

```markdown
---
name: <skill-name>
description: >
  This skill should be used when the user asks to "<trigger 1>", "<trigger 2>",
  "<trigger 3>", "<trigger 4>", "<trigger 5>", or wants to [mô tả ngắn].
version: 0.1.0
argument-hint: <input> [optional]
allowed-tools: [Read, Write, Edit, Bash, Glob, Grep]
---

# <Tên Skill>

<Mô tả 2-3 câu.>

## Quy trình

[Các bước — dùng imperative, không dùng "you should"]

## Output format

[Output trả về trông như thế nào]

## Lưu ý

[Edge cases, constraints]
```

Quy tắc:
- Dưới 300 dòng — nội dung dài đẩy vào `references/<topic>.md`
- `allowed-tools` chỉ list tools thực sự dùng
- Thêm `templates/<name>.md` nếu có boilerplate output

### Bước 2.3 — Đẩy lên team

```bash
bash "$TEAM_SH" sync
```

Script sẽ hỏi mô tả commit và xác nhận trước khi push.
Sau khi push, mọi người trong team chạy `./team.sh update` là có ngay.

---

## 3. Cập nhật skill có sẵn

**Khi user nói:** "sửa skill", "cập nhật skill", "update skill X"

### Bước 3.1 — Đọc skill hiện tại

```bash
cat "$SKILLS_DIR/<skill-name>/SKILL.md"
```

Hoặc dùng Read tool với path: `global/plugins/team-skills/skills/<skill-name>/SKILL.md`

### Bước 3.2 — Sửa file

Chỉ sửa phần cần thay đổi. Bump version:
- Minor change: `0.1.0` → `0.2.0`
- Major rewrite: `0.2.0` → `1.0.0`

### Bước 3.3 — Đẩy lên team

```bash
bash "$TEAM_SH" sync
```

---

## 4. Tạo / cập nhật knowledge file

**Khi user nói:** "thêm knowledge", "cập nhật knowledge", "lưu context này vào team", "thêm vào knowledge base"

Knowledge files sống tại: `$KNOWLEDGE_DIR/`

Files hiện có:
```
knowledge/
├── team-conventions.md      ← Quy ước team, git branches, PR process
├── product-context.md       ← Context sản phẩm, goals, users
└── pm-frameworks-reference.md ← Frameworks PM hay dùng
```

### Tạo knowledge file mới

1. Xác định file phù hợp nhất — ưu tiên thêm vào file có sẵn thay vì tạo mới
2. Nếu cần file mới: đặt tên dạng `<topic>.md`, viết nội dung rõ ràng
3. Đẩy lên:

```bash
bash "$TEAM_SH" sync
```

### Cập nhật knowledge file có sẵn

Đọc file trước, chỉ sửa phần cần thiết, sau đó sync.

Knowledge files được Claude đọc mỗi conversation nếu được reference trong CLAUDE.md của project.

---

## Lưu ý quan trọng

- **Skill có hiệu lực ngay** trên máy bạn sau khi tạo (được copy vào `~/.claude/commands/p/`)
- **Cả team nhận được** sau khi merge + `./team.sh update`
- `./team.sh sync` push thẳng vào `main` — dùng cho thay đổi đã test kỹ
- Muốn test trước khi share: tạo trong `skills/_lab/<skill-name>/` → test vài ngày → move ra ngoài
