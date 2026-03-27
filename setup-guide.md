# Hướng dẫn Setup Claude Code Team Configuration

## Dành cho Agent thực hiện

Đây là hướng dẫn đầy đủ để setup hệ thống Claude Code dùng chung cho team 6 người PM.
Đọc toàn bộ trước khi bắt đầu. Thực hiện theo đúng thứ tự.

---

## Context và Mục tiêu

### Team
- 6 thành viên PM, mỗi người có GitHub account riêng
- Cần dùng chung: skills, rules, knowledge base của Claude Code
- Không dùng chung: lịch sử trò chuyện (conversation history)
- Mỗi người tự auth MCP tools (Figma, BigQuery, Slack...) trên máy của họ

### Mục tiêu sau khi setup xong
- Máy mới bất kỳ: clone 1 repo + chạy 1 lệnh → Claude Code có đầy đủ skills của team
- Skill mới: thêm vào repo → `git pull` → cả team có ngay
- Tài sản (skills, knowledge) thuộc về team, không thuộc máy cá nhân

### Quyết định kiến trúc đã chốt
- GitHub Organization: Free plan ($0)
- Repo `claude-config`: Private, KHÔNG bật branch protection (dựa vào kỷ luật team)
- Không dùng Password Manager (mỗi người tự auth MCP qua browser)
- Không setup CI/CD pipeline

---

## Kiến trúc tổng thể

```
GitHub Organization (your-team-org)
├── claude-config    [PRIVATE]  ← Tài sản Claude Code của team
└── project-alpha    [PRIVATE]  ← App repos (thêm sau)

Trên mỗi máy local:
~/claude-config/                     ← Git clone từ GitHub
└── global/plugins/team-skills/      ← Nội dung thật của skills

~/.claude/                           ← Claude Code đọc từ đây
├── settings.json                    ← Copy từ settings.template.json
└── plugins/custom/
    └── team-skills → ~/claude-config/global/plugins/team-skills  (symlink)
```

### Tại sao dùng symlink
Symlink là "mũi tên" trỏ từ `~/.claude/plugins/custom/team-skills`
vào `~/claude-config/global/plugins/team-skills`.
Khi chạy `git pull`, files trong `~/claude-config/` thay đổi,
symlink vẫn trỏ đúng → Claude Code thấy nội dung mới ngay.
Không cần chạy lại install.sh sau mỗi lần pull.

---

## Phần 1: Setup GitHub Organization

### Bước 1.1 — Tạo Organization

1. Vào github.com
2. Nhấn dấu `+` góc trên phải → **New organization**
3. Chọn plan: **Free**
4. Điền:
   - Organization name: `tên-team` (ngắn, không dấu, không space)
   - Contact email: email của lead
5. Nhấn **Create organization**

### Bước 1.2 — Add Owner thứ 2

```
Org → Settings → Members → Invite member
→ Nhập account của lead thứ 2
→ Role: Owner
```

Lý do cần 2 Owner: nếu 1 người không available, người kia vẫn quản lý được org.

### Bước 1.3 — Invite 4 Members còn lại

```
Org → Settings → Members → Invite member
→ Invite từng account (4 người)
→ Role: Member (mặc định)
```

### Bước 1.4 — Tạo 2 Teams

```
Org → Teams → New team

Team 1:
  Name: team-all
  Visibility: Visible
  → Add tất cả 6 người vào team này

Team 2:
  Name: team-leads
  Visibility: Visible
  → Add 2 owners/leads vào team này
```

---

## Phần 2: Tạo repo `claude-config` trên GitHub

### Bước 2.1 — Tạo repo

```
Trong Org → Repositories → New repository
  Name:                  claude-config
  Visibility:            Private
  Initialize with README: ✅ (tick vào)
```

### Bước 2.2 — Cấp quyền cho Teams

```
Repo claude-config → Settings → Collaborators and teams
→ Add a team: team-all   → Role: Write
→ Add a team: team-leads → Role: Maintain
```

KHÔNG bật branch protection (đã quyết định dùng Phương án B: $0, kỷ luật team).

---

## Phần 3: Setup cấu trúc trên máy local

Thực hiện trên máy của người setup đầu tiên (thường là lead).

### Bước 3.1 — Tạo cấu trúc thư mục

```bash
mkdir -p ~/claude-config/global/plugins/team-skills/.claude-plugin
mkdir -p ~/claude-config/global/plugins/team-skills/skills/shared
mkdir -p ~/claude-config/global/plugins/team-skills/skills/pm-workflow
mkdir -p ~/claude-config/global/plugins/team-skills/skills/_lab
mkdir -p ~/claude-config/knowledge
mkdir -p ~/claude-config/project-templates/nextjs-app/.claude
mkdir -p ~/claude-config/project-templates/pm-project
```

### Bước 3.2 — Tạo file: plugin.json

Path: `~/claude-config/global/plugins/team-skills/.claude-plugin/plugin.json`

```json
{
  "name": "team-skills",
  "description": "Shared skills for the team",
  "author": {
    "name": "Tên team của bạn"
  }
}
```

### Bước 3.3 — Tạo file: settings.template.json

Path: `~/claude-config/global/settings.template.json`

Đây là file settings SẠCH — không có path cứng, không có tên user.
`install.sh` sẽ copy file này thành `~/.claude/settings.json` trên mỗi máy.
Sau khi copy, Claude Code tiếp tục ghi thêm permissions khi user bấm "Allow".

```json
{
  "permissions": {
    "allow": [
      "Bash(git commit:*)",
      "Bash(git push:*)",
      "Bash(git add:*)",
      "Bash(git config:*)",
      "Bash(pnpm:*)",
      "Bash(npm:*)",
      "Bash(npx:*)",
      "Bash(docker:*)",
      "Bash(git --version)",
      "Bash(node --version)",
      "WebSearch"
    ]
  },
  "extraKnownMarketplaces": {
    "claude-plugins-official": {
      "source": {
        "source": "github",
        "repo": "anthropics/claude-plugins-official"
      }
    }
  },
  "effortLevel": "high"
}
```

Lưu ý về settings.template.json:
- KHÔNG dùng path như `Read(//Users/username/**)` — sẽ lỗi trên máy khác
- Permissions riêng của từng project đặt trong `<project>/.claude/settings.local.json`
- Cập nhật file này khi team cần thêm permission mới cho MỌI máy

### Bước 3.4 — Tạo file: team-conventions.md

Path: `~/claude-config/knowledge/team-conventions.md`

```markdown
# Team Conventions

## Auth MCP Tools — mỗi người tự làm trên máy của mình

Các tool sau cần auth lại trên TỪNG MÁY qua browser:
- **Figma**: Mở Claude Code → dùng tool Figma lần đầu → browser popup → login
- **BigQuery**: Dùng tool BigQuery → login Google account có quyền
- **Slack**: Login workspace
- **Google Calendar / Gmail**: Login Google account

Auth tokens được lưu LOCAL trên máy bạn.
Không share token. Không commit token.
Mỗi máy mới: auth 1 lần là đủ.

## Git branch naming
- `skill/ten-skill`      — thêm hoặc sửa skill
- `knowledge/mo-ta`      — cập nhật knowledge base
- `fix/mo-ta`            — sửa lỗi
- `feature/ten-feature`  — cho app repos

## Quy ước Pull Request
- Mọi thay đổi vào main qua Pull Request
- Assign ít nhất 1 người review và approve
- Không push trực tiếp vào main (kỷ luật team, không có enforcement)

## Cập nhật skills hàng ngày
```bash
cd ~/claude-config && git pull
```
```

### Bước 3.5 — Tạo file: .gitignore

Path: `~/claude-config/.gitignore`

```
# Secrets
.secrets
*.key
*.pem
*.token

# macOS
.DS_Store

# Temp
.tmp/
*.local
```

### Bước 3.6 — Tạo file: install.sh

Path: `~/claude-config/install.sh`

Script này chạy 1 lần trên mỗi máy mới. Làm 2 việc:
1. Copy settings.template.json thành ~/.claude/settings.json
2. Tạo symlink từ ~/.claude/plugins/custom/team-skills → ~/claude-config/global/plugins/team-skills

```bash
#!/bin/bash
set -e
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "🚀 Setting up Claude Code — $(hostname)"
echo ""

# 1. Copy settings template
cp "$REPO_DIR/global/settings.template.json" "$CLAUDE_DIR/settings.json"
echo "✅ settings.json installed"

# 2. Tạo symlink team-skills
mkdir -p "$CLAUDE_DIR/plugins/custom"
SYMLINK="$CLAUDE_DIR/plugins/custom/team-skills"
[ -L "$SYMLINK" ] && rm "$SYMLINK"
ln -sf "$REPO_DIR/global/plugins/team-skills" "$SYMLINK"
echo "✅ team-skills linked: $SYMLINK → $REPO_DIR/global/plugins/team-skills"

# 3. Nhắc auth MCP tools
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "⚠️  Bước cuối (làm thủ công): Auth MCP Tools"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Mở Claude Code, dùng từng tool lần đầu để kích hoạt auth:"
echo "  • Figma       → dùng tool Figma    → login browser"
echo "  • BigQuery    → dùng tool BigQuery → login Google"
echo "  • Slack       → dùng tool Slack    → login workspace"
echo "  • Calendar    → dùng tool Calendar → login Google"
echo ""
echo "Auth lưu local trên máy này. Không cần làm lại trừ khi đổi máy."
echo ""
echo "🎉 Done! Để update skills sau này: cd $REPO_DIR && git pull"
```

### Bước 3.7 — Tạo file: update.sh

Path: `~/claude-config/update.sh`

```bash
#!/bin/bash
cd "$(dirname "$0")"
git pull
echo "✅ Config updated. Symlinks apply automatically."
```

### Bước 3.8 — Tạo file: CONTRIBUTING.md

Path: `~/claude-config/CONTRIBUTING.md`

```markdown
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
```

### Bước 3.9 — Tạo file: README.md

Path: `~/claude-config/README.md`
(Ghi đè file README.md mặc định GitHub tạo khi push)

```markdown
# claude-config

Shared Claude Code skills, knowledge base, và config cho team.

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
    ├── shared/        Skills dùng cho mọi project
    ├── pm-workflow/   Skills riêng PM team
    └── _lab/          Thử nghiệm cá nhân

knowledge/             Context dự án, quy ước team
project-templates/     CLAUDE.md template cho project mới
```

## Khi gặp vấn đề

### Symlink bị mất
```bash
cd ~/claude-config && ./install.sh
```

### Skills không hiện trong Claude Code
1. Kiểm tra symlink: `ls -la ~/.claude/plugins/custom/`
2. Nếu không có → chạy `./install.sh`
3. Restart Claude Code
```

---

## Phần 4: Chạy install.sh và test

### Bước 4.1 — Cấp quyền và chạy

```bash
chmod +x ~/claude-config/install.sh ~/claude-config/update.sh
~/claude-config/install.sh
```

Output mong đợi:
```
🚀 Setting up Claude Code — [tên máy]

✅ settings.json installed
✅ team-skills linked: /Users/[username]/.claude/plugins/custom/team-skills → /Users/[username]/claude-config/global/plugins/team-skills

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚠️  Bước cuối (làm thủ công): Auth MCP Tools
...
🎉 Done!
```

### Bước 4.2 — Verify symlink

```bash
ls -la ~/.claude/plugins/custom/
```

Output mong đợi:
```
team-skills -> /Users/[username]/claude-config/global/plugins/team-skills
```

Nếu thấy mũi tên `->` là đúng.

---

## Phần 5: Push lên GitHub

### Bước 5.1 — Init git và push

```bash
cd ~/claude-config

git init
git branch -M main

# Kiểm tra file sẽ commit — đảm bảo không có file nhạy cảm
git status

git add .
git commit -m "init: team claude-config setup"

# Thay TÊN-ORG bằng tên organization thật
git remote add origin https://github.com/TÊN-ORG/claude-config.git
git push -u origin main
```

### Bước 5.2 — Verify trên GitHub

Vào `https://github.com/TÊN-ORG/claude-config` và kiểm tra:
- Thấy đủ các files: README.md, install.sh, update.sh, CONTRIBUTING.md, .gitignore
- Thấy folder: global/, knowledge/, project-templates/
- KHÔNG thấy: .secrets, file có chứa credentials

---

## Phần 6: Onboard từng thành viên

Gửi cho mỗi thành viên đúng 3 lệnh này:

```bash
git clone https://github.com/TÊN-ORG/claude-config.git ~/claude-config
cd ~/claude-config && chmod +x install.sh update.sh && ./install.sh
```

Sau đó mỗi người:
1. Mở VS Code + Claude Code extension
2. Dùng tool Figma/BigQuery/Slack lần đầu → browser popup → login
3. Từ hôm sau: `cd ~/claude-config && git pull` mỗi buổi sáng

---

## Cấu trúc file cuối cùng

```
~/claude-config/                         ← Git repo, sync lên GitHub
├── .gitignore
├── README.md
├── CONTRIBUTING.md
├── install.sh                           ← Chạy 1 lần trên máy mới
├── update.sh                            ← Chạy hàng ngày để sync
├── global/
│   ├── settings.template.json           ← Settings sạch, không path cứng
│   └── plugins/
│       └── team-skills/
│           ├── .claude-plugin/
│           │   └── plugin.json          ← Khai báo plugin
│           └── skills/
│               ├── shared/              ← Skills dùng cho mọi project
│               ├── pm-workflow/         ← Skills riêng PM team
│               └── _lab/               ← Thử nghiệm cá nhân
├── knowledge/
│   └── team-conventions.md             ← Quy ước team + hướng dẫn auth MCP
└── project-templates/
    ├── nextjs-app/
    │   ├── CLAUDE.md                    ← Template cho Next.js project
    │   └── .claude/settings.local.json
    └── pm-project/
        └── CLAUDE.md                    ← Template cho PM project
```

---

## Sau khi setup xong: Workflow hàng ngày

### Mỗi buổi sáng
```bash
cd ~/claude-config && git pull    # Lấy skills mới nhất
```

### Khi bắt đầu project mới
```bash
# Copy template vào project mới
cp ~/claude-config/project-templates/nextjs-app/CLAUDE.md ~/my-new-project/
cp -r ~/claude-config/project-templates/nextjs-app/.claude ~/my-new-project/
# Mở CLAUDE.md → điền tên project → bắt đầu làm việc
```

### Khi muốn thêm skill mới
```bash
cd ~/claude-config
git checkout -b skill/ten-skill-moi
# Tạo SKILL.md trong skills/_lab/ten-skill-moi/
# Test vài ngày → chuyển sang skills/shared/ hoặc pm-workflow/
git push origin skill/ten-skill-moi
# Tạo PR trên GitHub → review → merge
```

### Khi có thành viên mới
```bash
# Invite vào GitHub Org + team-all
# Gửi cho họ 3 lệnh clone + install
```

### Khi thành viên rời team
```bash
# Org Settings → Members → Remove
# Mất quyền tất cả repos ngay lập tức
# Tài sản (skills, knowledge) vẫn ở lại trong Org
```

---

## Checklist tổng kết

### GitHub Setup
- [ ] Tạo GitHub Organization (Free plan)
- [ ] Add Owner thứ 2
- [ ] Invite 4 Members còn lại
- [ ] Tạo team `team-all` (6 người)
- [ ] Tạo team `team-leads` (2-3 người)
- [ ] Tạo repo `claude-config` (Private)
- [ ] Cấp quyền: team-all → Write, team-leads → Maintain

### Local Setup (máy lead)
- [ ] Tạo cấu trúc thư mục `~/claude-config/`
- [ ] Tạo `plugin.json`
- [ ] Tạo `settings.template.json` (không có path cứng)
- [ ] Tạo `team-conventions.md`
- [ ] Tạo `.gitignore`
- [ ] Tạo `install.sh`
- [ ] Tạo `update.sh`
- [ ] Tạo `CONTRIBUTING.md`
- [ ] Tạo `README.md`
- [ ] Chạy `./install.sh` → verify symlink
- [ ] `git init` + `commit` + `push` lên GitHub

### Onboarding Team
- [ ] Mỗi thành viên: `git clone` + `./install.sh`
- [ ] Mỗi thành viên: auth MCP tools (Figma, BigQuery, Slack...)
- [ ] Test: mở Claude Code → kiểm tra skills của team hiện ra

---

## Ghi chú kỹ thuật cho Agent

### Về settings.json
File `~/.claude/settings.json` được Claude Code tự tạo khi cài lần đầu
và tự ghi thêm permissions khi user bấm "Allow always".
`settings.template.json` trong repo là file BẠN TỰ VIẾT — là bản sạch
để làm starting point cho máy mới. Không có cơ chế auto-sync giữa
settings.json local và template.

### Về symlink
Symlink không thay đổi khi `git pull`.
Git pull chỉ thay đổi FILES bên trong `~/claude-config/global/plugins/team-skills/`.
Symlink vẫn trỏ đúng vào folder đó → Claude Code thấy nội dung mới ngay.
Chỉ cần chạy `install.sh` lại khi: máy mới, symlink bị mất, folder bị di chuyển.

### Về CODEOWNERS
Không setup CODEOWNERS vì dùng Free plan + Private repo.
CODEOWNERS chỉ có tác dụng enforcement khi có branch protection (cần Team plan).
Khi team muốn nâng cấp: Team plan ($4/user/tháng) → bật branch protection
→ thêm `.github/CODEOWNERS` vào repo `claude-config`.

### Về MCP Auth
Mỗi MCP tool (Figma, BigQuery, Slack...) dùng OAuth qua browser.
Token gắn với browser session trên máy đó.
Không thể share hoặc script hóa bước này.
Được ghi lại trong `~/.claude/mcp-needs-auth-cache.json` (local only).

### Về project-templates
`project-templates/` KHÔNG phải tính năng của Claude Code.
Đây là thư mục bạn tự tổ chức để tái sử dụng CLAUDE.md.
Khi tạo project mới: copy template ra → điền thông tin → CLAUDE.md sống riêng,
không còn liên kết với template.
CLAUDE.md trong project luôn được Claude Code đọc mỗi conversation.
Skills (SKILL.md) chỉ được load khi trigger → không tốn token thường xuyên.
