# Installation Procedures — Chi tiết

## 1. Prerequisites Verification

```bash
# Check framework được clone chưa
if [ ! -d ".architecture/.architecture" ]; then
  echo "❌ Framework chưa clone:"
  echo "   git clone https://github.com/codenamev/ai-software-architect .architecture/.architecture"
  exit 1
fi

# Verify đang ở project root
if [ -f "package.json" ] || [ -f "requirements.txt" ] || [ -f "go.mod" ] || [ -f "Gemfile" ] || [ -f "Cargo.toml" ]; then
  echo "✅ Đang ở project root"
else
  echo "⚠️  Không tìm thấy project markers — có đang ở project root không?"
fi
```

## 2. Framework Installation

### Copy Framework Files

```bash
cp -r .architecture/.architecture/.architecture/* .architecture/
[ $? -eq 0 ] && echo "✅ Framework files copied" || { echo "❌ Copy failed"; exit 1; }
```

### Remove Clone Directory

```bash
rm -rf .architecture/.architecture
echo "✅ Clone directory removed"
```

### Create Directory Structure

```bash
mkdir -p .architecture/decisions/adrs
mkdir -p .architecture/reviews
mkdir -p .architecture/recalibration
mkdir -p .architecture/comparisons
mkdir -p .architecture/agent_docs
echo "✅ Directory structure created"
```

### Initialize Config

```bash
if [ -f ".architecture/templates/config.yml" ]; then
  cp .architecture/templates/config.yml .architecture/config.yml
  echo "✅ Config initialized"
fi
```

### Verify Installation

```bash
test -d .architecture/decisions/adrs && \
test -d .architecture/reviews && \
test -f .architecture/members.yml && \
test -f .architecture/principles.md && \
echo "✅ Installation verified" || echo "❌ Installation incomplete"
```

## 3. Cleanup Procedures

### Remove Framework Docs

```bash
rm -f .architecture/README.md
rm -f .architecture/USAGE*.md
rm -f .architecture/INSTALL.md
echo "✅ Framework docs removed"
```

### Remove Template Git Repository — CRITICAL SAFEGUARDS

**⚠️ Đọc kỹ trước khi xóa `.git/` directory.**

```bash
#!/bin/bash
set -e

# 1. Verify project root
if [ ! -f "package.json" ] && [ ! -f ".git/config" ] && [ ! -f "Gemfile" ]; then
  echo "❌ Không phải project root — DỪNG LẠI"
  exit 1
fi

# 2. Check target tồn tại
if [ ! -d ".architecture/.git" ]; then
  echo "✅ Không có .git cần xóa"
  exit 0
fi

# 3. Verify đây là template repo (không phải project repo)
if ! grep -q "ai-software-architect" .architecture/.git/config 2>/dev/null; then
  echo "❌ .architecture/.git KHÔNG phải template repo — DỪNG LẠI"
  echo "   User confirmation required"
  exit 1
fi

# 4. Dùng absolute path (KHÔNG dùng relative path với rm -rf)
ABS_PATH="$(pwd)/.architecture/.git"
if [[ "$ABS_PATH" != *"/.architecture/.git" ]]; then
  echo "❌ Path không đúng pattern — DỪNG LẠI"
  exit 1
fi

# 5. Execute removal
echo "Removing: $ABS_PATH"
rm -rf "$ABS_PATH"

[ ! -d ".architecture/.git" ] && echo "✅ Template .git removed" || echo "❌ Removal failed"
```

**Quy tắc bắt buộc:**
- KHÔNG dùng wildcard với rm -rf
- LUÔN dùng absolute path
- STOP và hỏi user nếu bất kỳ check nào fail
- Nếu xóa nhầm project `.git` → recover từ backup ngay

## 4. Troubleshooting

| Lỗi | Nguyên nhân | Giải pháp |
|-----|-------------|-----------|
| Framework not found | Chưa clone | `git clone ...` |
| Permission denied | Thiếu quyền | `chmod -R u+rw .architecture/` |
| Directory already exists | Đã install một phần | Check `ls -la .architecture/` |
| .git removal verification failed | Safety check detect unexpected repo | Tự verify `.architecture/.git/config` chứa template URL |

### Verification Commands

```bash
# Check required files/dirs
test -d .architecture/decisions/adrs && echo "✅ ADRs" || echo "❌ Missing ADRs"
test -d .architecture/reviews       && echo "✅ Reviews" || echo "❌ Missing reviews"
test -f .architecture/members.yml   && echo "✅ Members" || echo "❌ Missing members"
test -f .architecture/principles.md && echo "✅ Principles" || echo "❌ Missing principles"

# Check leftover framework files (không nên tồn tại sau cleanup)
test -f .architecture/README.md         && echo "⚠️  Framework README still present"
test -d .architecture/.git              && echo "⚠️  Template .git still present"
test -d .architecture/.architecture     && echo "⚠️  Clone directory still present"
```

### Recovery

Nếu install fail giữa chừng:
1. `rm -rf .architecture/` (nếu chưa có gì quan trọng trong đó)
2. Re-clone: `git clone https://github.com/codenamev/ai-software-architect .architecture/.architecture`
3. Bắt đầu lại từ Step 1
