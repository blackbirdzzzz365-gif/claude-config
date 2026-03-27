#!/bin/bash
# ──────────────────────────────────────────────
#  team.sh — Claude Config Team Manager
#  Dùng: ./team.sh <setup|update|sync>
# ──────────────────────────────────────────────
set -e
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

# ── Colors ────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; BOLD='\033[1m'; RESET='\033[0m'

info()    { echo -e "${BLUE}ℹ${RESET}  $1"; }
success() { echo -e "${GREEN}✅${RESET} $1"; }
warn()    { echo -e "${YELLOW}⚠️ ${RESET}  $1"; }
error()   { echo -e "${RED}❌${RESET} $1"; exit 1; }
header()  { echo -e "\n${BOLD}$1${RESET}"; echo "────────────────────────────────"; }

# ══════════════════════════════════════════════
#  SETUP — Cài đặt lần đầu trên máy mới
# ══════════════════════════════════════════════
cmd_setup() {
  header "🚀 Setup Claude Config — $(hostname)"

  # 1. Settings.json
  SETTINGS="$CLAUDE_DIR/settings.json"
  TEMPLATE="$REPO_DIR/global/settings.template.json"

  if [ ! -f "$SETTINGS" ]; then
    cp "$TEMPLATE" "$SETTINGS"
    success "settings.json installed (from template)"
  elif command -v jq &>/dev/null; then
    BACKUP="$SETTINGS.bak.$(date +%Y%m%d_%H%M%S)"
    cp "$SETTINGS" "$BACKUP"
    jq -s '
      .[0] as $existing | .[1] as $template |
      $existing |
      .permissions.allow = (
        ($existing.permissions.allow // []) +
        ($template.permissions.allow // []) | unique
      )
    ' "$SETTINGS" "$TEMPLATE" > "$SETTINGS.tmp" && mv "$SETTINGS.tmp" "$SETTINGS"
    success "settings.json merged (quyền cũ được giữ nguyên)"
    info "Backup: $BACKUP"
  else
    warn "settings.json giữ nguyên (cài jq để auto-merge: brew install jq)"
  fi

  # 2. Symlink
  mkdir -p "$CLAUDE_DIR/plugins/custom"
  SYMLINK="$CLAUDE_DIR/plugins/custom/team-skills"
  if [ -d "$SYMLINK" ] && [ ! -L "$SYMLINK" ]; then
    error "Conflict: $SYMLINK là thư mục thật. Backup thủ công rồi chạy lại:\n   mv $SYMLINK $SYMLINK.bak"
  fi
  [ -L "$SYMLINK" ] && rm "$SYMLINK"
  ln -sf "$REPO_DIR/global/plugins/team-skills" "$SYMLINK"
  success "Team skills linked → $REPO_DIR/global/plugins/team-skills"

  # 3. Xong
  echo ""
  echo -e "${BOLD}🎉 Setup xong!${RESET}"
  echo ""
  echo "Bước tiếp theo — Auth MCP tools (làm thủ công 1 lần):"
  echo "  Mở Claude Code → dùng tool Figma / BigQuery / Slack lần đầu → login browser"
  echo ""
  echo "Để cập nhật skills sau này:"
  echo -e "  ${BOLD}./team.sh update${RESET}"
}

# ══════════════════════════════════════════════
#  UPDATE — Lấy skills mới nhất về
# ══════════════════════════════════════════════
cmd_update() {
  header "⬇️  Update — Lấy skills mới nhất từ team"

  cd "$REPO_DIR"

  # Kiểm tra có thay đổi local chưa commit không
  if ! git diff --quiet || ! git diff --cached --quiet; then
    warn "Bạn có thay đổi chưa commit trên máy này:"
    git status --short
    echo ""
    read -r -p "Tiếp tục update (có thể gây conflict)? [y/N] " confirm
    [[ "$confirm" =~ ^[Yy]$ ]] || { info "Đã hủy."; exit 0; }
  fi

  git pull origin main
  echo ""
  success "Skills đã được cập nhật!"
  info "Symlink tự áp dụng — không cần restart Claude Code"
}

# ══════════════════════════════════════════════
#  SYNC — Đẩy skill/knowledge mới lên team
# ══════════════════════════════════════════════
cmd_sync() {
  header "⬆️  Sync — Đẩy thay đổi của bạn lên team"

  cd "$REPO_DIR"

  # Kiểm tra có gì thay đổi không
  CHANGED=$(git status --short)
  if [ -z "$CHANGED" ]; then
    info "Không có gì thay đổi so với repo."
    exit 0
  fi

  echo "Những thay đổi sẽ được đưa lên:"
  git status --short
  echo ""

  # Hỏi mô tả
  read -r -p "Mô tả ngắn thay đổi này là gì? (VD: thêm skill write-prd, cập nhật team conventions): " description
  [ -z "$description" ] && error "Cần có mô tả để commit."

  # Xác nhận
  echo ""
  warn "Sẽ commit và push thẳng lên main. Team sẽ nhận được khi chạy update."
  read -r -p "Xác nhận? [y/N] " confirm
  [[ "$confirm" =~ ^[Yy]$ ]] || { info "Đã hủy."; exit 0; }

  # Commit và push
  git add .
  git commit -m "$description"
  git push origin main

  echo ""
  success "Đã đẩy lên team!"
  info "Thành viên khác chạy './team.sh update' để nhận thay đổi này"
}

# ══════════════════════════════════════════════
#  HELP
# ══════════════════════════════════════════════
cmd_help() {
  echo ""
  echo -e "${BOLD}team.sh — Claude Config Team Manager${RESET}"
  echo ""
  echo "Cách dùng:"
  echo -e "  ${BOLD}./team.sh setup${RESET}    Cài đặt lần đầu trên máy mới"
  echo -e "  ${BOLD}./team.sh update${RESET}   Lấy skills & knowledge mới nhất từ team về"
  echo -e "  ${BOLD}./team.sh sync${RESET}     Đẩy skill/knowledge bạn vừa tạo/sửa lên team"
  echo ""
  echo "Sau khi setup, bạn cũng có thể nói với Claude Code:"
  echo "  • \"update skills\"           → Claude chạy ./team.sh update"
  echo "  • \"sync skill mới lên team\" → Claude chạy ./team.sh sync"
  echo ""
}

# ══════════════════════════════════════════════
#  ROUTER
# ══════════════════════════════════════════════
case "${1:-help}" in
  setup)  cmd_setup  ;;
  update) cmd_update ;;
  sync)   cmd_sync   ;;
  help|*) cmd_help   ;;
esac
