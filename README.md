# claude-config

Shared Claude Code skills, knowledge base, và config cho PM team.

## Setup máy mới (15 phút)

### Bước 1: Clone repo
```bash
git clone https://github.com/TÊN-ORG/claude-config.git ~/claude-config
cd ~/claude-config
chmod +x install.sh update.sh
./install.sh
```

### Bước 2: Auth MCP Tools
Mở Claude Code và dùng từng tool lần đầu để kích hoạt:
- Figma, BigQuery, Slack, Google Calendar

Auth lưu local. Mỗi máy mới làm 1 lần.

## Cập nhật skills hàng ngày
```bash
cd ~/claude-config && git pull
```
Symlink tự áp dụng, không cần chạy install.sh lại.

## Thêm skill mới
Xem [CONTRIBUTING.md](./CONTRIBUTING.md)

## Cấu trúc
```
global/
└── plugins/team-skills/skills/
    ├── shared/        Skills dùng cho mọi project (commit, review PR...)
    ├── pm-workflow/   Skills riêng PM team
    └── _lab/          Thử nghiệm cá nhân, chưa chính thức

knowledge/             Context sản phẩm, quy ước team, PM framework reference
project-templates/     CLAUDE.md template cho project mới
```

## PM Skills có sẵn

| Trigger | Skill | Mô tả |
|---------|-------|--------|
| `/write-prd` | write-prd | Tạo PRD đầy đủ 8 sections |
| `/user-stories` | user-stories | Viết user stories + acceptance criteria |
| `/research-users` | product-research | Tổng hợp interview, competitive analysis |
| `/analyze-metrics` | product-analyst | Metrics framework, SQL, A/B test |
| `/pre-mortem` | critical-thinking | Pre-mortem, devil's advocate, assumption mapping |
| `/prioritize` | prioritize | RICE/MoSCoW/Kano scoring |
| `/meeting-notes` | meeting-notes | Tổng hợp meeting → decisions + action items |
| `/stakeholder-update` | stakeholder-update | Weekly RAG update, GTM plan |

## Khi gặp vấn đề

### Symlink bị mất
```bash
cd ~/claude-config && ./install.sh
```

### Skills không hiện trong Claude Code
1. Kiểm tra symlink: `ls -la ~/.claude/plugins/custom/`
2. Nếu không có → chạy `./install.sh`
3. Restart Claude Code
