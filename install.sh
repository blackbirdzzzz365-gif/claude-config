#!/bin/bash
set -e
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "🚀 Setting up Claude Code — $(hostname)"
echo ""

# 1. Settings.json — merge hoặc copy tùy tình huống
SETTINGS="$CLAUDE_DIR/settings.json"
TEMPLATE="$REPO_DIR/global/settings.template.json"

if [ ! -f "$SETTINGS" ]; then
  # Máy mới: chưa có settings.json → copy template
  cp "$TEMPLATE" "$SETTINGS"
  echo "✅ settings.json installed (from template)"

elif command -v jq &> /dev/null; then
  # Máy đã có settings.json + có jq → merge permissions, giữ nguyên mọi thứ khác
  BACKUP="$SETTINGS.bak.$(date +%Y%m%d_%H%M%S)"
  cp "$SETTINGS" "$BACKUP"

  jq -s '
    .[0] as $existing |
    .[1] as $template |
    $existing |
    .permissions.allow = (
      ($existing.permissions.allow // []) +
      ($template.permissions.allow // [])
      | unique
    )
  ' "$SETTINGS" "$TEMPLATE" > "$SETTINGS.tmp" && mv "$SETTINGS.tmp" "$SETTINGS"

  ADDED=$(jq -s '
    (.[1].permissions.allow // []) - (.[0].permissions.allow // []) | .[]
  ' "$BACKUP" "$SETTINGS" 2>/dev/null || echo "")

  if [ -n "$ADDED" ]; then
    echo "✅ settings.json merged — permissions mới được thêm:"
    echo "$ADDED" | sed 's/^/   + /'
  else
    echo "✅ settings.json OK — không có permissions mới cần thêm"
  fi
  echo "   Backup: $BACKUP"

else
  # Máy đã có settings.json nhưng không có jq → bỏ qua, không đụng vào
  echo "⚠️  settings.json đã tồn tại — bỏ qua (jq chưa cài)"
  echo "   Cài jq để auto-merge: brew install jq"
  echo "   Sau đó chạy lại ./install.sh"
fi

# 2. Copy skills vào ~/.claude/commands/p/
# Dùng subdir "p" để gọi bằng /p/<skill> — gõ /p rồi autocomplete thấy tất cả PM skills
# Claude Code không hỗ trợ symlink plugins, phải copy trực tiếp
COMMANDS_DIR="$CLAUDE_DIR/commands/p"
SKILLS_DIR="$REPO_DIR/global/plugins/team-skills/skills"
mkdir -p "$COMMANDS_DIR"

COPIED=0
NEW=0
for skill_dir in "$SKILLS_DIR"/*/; do
  skill_name=$(basename "$skill_dir")
  [[ "$skill_name" == _* ]] && continue  # bỏ qua thư mục _lab, _draft, v.v.
  if [ -f "$skill_dir/SKILL.md" ]; then
    dest="$COMMANDS_DIR/$skill_name.md"
    [ ! -f "$dest" ] && NEW=$((NEW + 1))
    cp "$skill_dir/SKILL.md" "$dest"
    COPIED=$((COPIED + 1))
  fi
done

# Xóa skill đã bị remove khỏi repo
for existing in "$COMMANDS_DIR"/*.md; do
  skill_name=$(basename "$existing" .md)
  if [ ! -d "$SKILLS_DIR/$skill_name" ]; then
    rm "$existing"
    echo "   🗑  removed: $skill_name (not in repo)"
  fi
done

echo "✅ $COPIED skills synced → $COMMANDS_DIR ($NEW new)"
echo "   Gọi bằng: /p/<skill-name>"

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
