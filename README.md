# claude-config

Shared Claude Code skills, knowledge base, và config cho PM team tại [ts-evo-pm](https://github.com/ts-evo-pm).

## Setup máy mới (15 phút)

### Bước 1: Clone repo

```bash
git clone https://github.com/ts-evo-pm/claude-config.git ~/claude-config
cd ~/claude-config
chmod +x install.sh team.sh
./install.sh
```

### Bước 2: Auth MCP Tools
Mở Claude Code và dùng từng tool lần đầu để kích hoạt:
- **Figma** → dùng tool Figma → login browser
- **BigQuery** → dùng tool BigQuery → login Google
- **Slack** → dùng tool Slack → login workspace
- **Google Calendar** → login Google

Auth lưu local trên máy này. Mỗi máy mới làm 1 lần.

---

## Cập nhật skills

```bash
cd ~/claude-config && git pull
```

Skills tự đồng bộ. Không cần restart Claude Code.

Để sync sang Codex:

```bash
cd ~/claude-config && ./scripts/sync-codex-skills.sh
```

Skills sẽ được cài vào `~/.codex/skills/` và dùng được trong các chat Codex mới.

---

## Thêm skill mới

Xem [CONTRIBUTING.md](./CONTRIBUTING.md)

---

## Cấu trúc

```
claude-config/
├── install.sh                  # Setup lần đầu (copy skills + merge settings)
├── team.sh                     # CLI tool: setup / update / sync
│
├── global/
│   ├── settings.template.json  # Permissions mặc định cho máy mới
│   └── plugins/team-skills/
│       └── skills/             # Tất cả PM skills
│           ├── _lab/           # Thử nghiệm cá nhân (không deploy)
│           ├── write-prd/
│           ├── user-stories/
│           └── ...
│
├── knowledge/                  # Context sản phẩm, quy ước team, PM frameworks
└── project-templates/          # CLAUDE.md template cho project mới
    ├── pm-project/
    └── nextjs-app/
```

---

## PM Skills có sẵn

Gọi bằng `/p/<skill-name>` trong Claude Code (gõ `/p` rồi Tab để autocomplete).

| Trigger | Mô tả |
|---------|-------|
| `/p/write-prd` | Tạo PRD đầy đủ 8 sections hoặc one-page brief |
| `/p/user-stories` | Viết user stories + acceptance criteria |
| `/p/product-research` | Tổng hợp interview, competitive analysis |
| `/p/product-analyst` | Metrics framework, SQL queries, A/B test |
| `/p/critical-thinking` | Pre-mortem, devil's advocate, assumption mapping |
| `/p/prioritize` | RICE / MoSCoW / Kano scoring |
| `/p/meeting-notes` | Tổng hợp meeting → decisions + action items |
| `/p/stakeholder-update` | Weekly RAG update, GTM plan, stakeholder map |
| `/p/review-pr` | Review Pull Request |
| `/p/write-commit` | Tạo git commit message chuẩn |
| `/p/manage-skill` | Tạo hoặc cập nhật skill mới |
| `/p/implement-system-design` | Biến architecture doc thành implementation slices + contracts |

Trong Codex, gọi bằng cách nhắc trực tiếp tên skill hoặc intent tương ứng, ví dụ:
- `dùng skill write-prd để draft PRD cho feature onboarding`
- `review-pr giúp mình review diff này`
- `prioritize backlog này theo RICE`

---

## Khi gặp vấn đề

### Skills không hiện trong Claude Code

```bash
# Kiểm tra skills đã được copy chưa
ls ~/.claude/commands/p/

# Nếu thiếu → sync lại
cd ~/claude-config && ./install.sh
```

### Settings không áp dụng

Kiểm tra `~/.claude/settings.json` đã có permissions từ template chưa:
```bash
cat ~/.claude/settings.json | grep defaultMode
```

### Cần sync lại toàn bộ

```bash
cd ~/claude-config && git pull && ./install.sh
```
