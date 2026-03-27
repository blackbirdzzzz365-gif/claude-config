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

# 2. Tạo symlink team-skills
mkdir -p "$CLAUDE_DIR/plugins/custom"
SYMLINK="$CLAUDE_DIR/plugins/custom/team-skills"
[ -L "$SYMLINK" ] && rm "$SYMLINK"
ln -sf "$REPO_DIR/global/plugins/team-skills" "$SYMLINK"
echo "✅ team-skills linked: $SYMLINK"
echo "   → $REPO_DIR/global/plugins/team-skills"

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
