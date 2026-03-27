#!/bin/bash
set -e
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "🚀 Setting up Claude Code — $(hostname)"
echo ""

# 1. Copy settings template
if [ -f "$CLAUDE_DIR/settings.json" ]; then
  echo "⚠️  settings.json đã tồn tại — backup thành settings.json.bak"
  cp "$CLAUDE_DIR/settings.json" "$CLAUDE_DIR/settings.json.bak"
fi
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
