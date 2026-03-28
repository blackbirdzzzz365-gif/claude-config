#!/bin/bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
CLAUDE_SKILLS_DIR="$REPO_DIR/global/plugins/team-skills/skills"
CODEX_SKILLS_DIR="$REPO_DIR/global/plugins/codex-skills/skills"
OVERRIDES_DIR="$REPO_DIR/global/plugins/codex-skills/overrides"
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
INSTALLED_SKILLS_DIR="$CODEX_HOME/skills"

mkdir -p "$CODEX_SKILLS_DIR" "$INSTALLED_SKILLS_DIR"

render_skill() {
  local source_file="$1"
  local target_file="$2"

  awk '
    BEGIN {
      in_frontmatter = 0
      in_description = 0
      body = ""
      description = ""
    }
    NR == 1 && $0 == "---" {
      in_frontmatter = 1
      next
    }
    in_frontmatter {
      if ($0 == "---") {
        in_frontmatter = 0
        next
      }

      if ($0 ~ /^name:[[:space:]]*/) {
        name = $0
        sub(/^name:[[:space:]]*/, "", name)
        next
      }

      if ($0 ~ /^description:[[:space:]]*/) {
        description = $0
        sub(/^description:[[:space:]]*/, "", description)
        in_description = 1
        next
      }

      if (in_description) {
        if ($0 ~ /^[[:space:]]+/) {
          description = description ORS $0
          next
        }
        in_description = 0
      }

      next
    }
    {
      body = body $0 ORS
    }
    END {
      print "---"
      print "name: " name
      print "description: " description
      print "---"
      print ""
      printf "%s", body
    }
  ' "$source_file" > "$target_file"
}

sync_optional_dir() {
  local skill_name="$1"
  local dir_name="$2"
  local target_dir="$CODEX_SKILLS_DIR/$skill_name/$dir_name"
  local source_dir="$CLAUDE_SKILLS_DIR/$skill_name/$dir_name"

  if [ -L "$target_dir" ]; then
    rm "$target_dir"
  fi
  rm -rf "$target_dir"
  if [ -d "$CLAUDE_SKILLS_DIR/$skill_name/$dir_name" ]; then
    mkdir -p "$target_dir"
    cp -R "$source_dir/." "$target_dir/"
  fi
}

for source_skill_dir in "$CLAUDE_SKILLS_DIR"/*; do
  [ -d "$source_skill_dir" ] || continue

  skill_name="$(basename "$source_skill_dir")"
  [[ "$skill_name" == _* ]] && continue
  [ -f "$source_skill_dir/SKILL.md" ] || continue

  target_skill_dir="$CODEX_SKILLS_DIR/$skill_name"
  mkdir -p "$target_skill_dir"

  if [ -f "$OVERRIDES_DIR/$skill_name.md" ]; then
    cp "$OVERRIDES_DIR/$skill_name.md" "$target_skill_dir/SKILL.md"
  else
    render_skill "$source_skill_dir/SKILL.md" "$target_skill_dir/SKILL.md"
  fi

  sync_optional_dir "$skill_name" references
  sync_optional_dir "$skill_name" templates
done

for existing_dir in "$CODEX_SKILLS_DIR"/*; do
  [ -e "$existing_dir" ] || continue
  skill_name="$(basename "$existing_dir")"
  if [ ! -d "$CLAUDE_SKILLS_DIR/$skill_name" ]; then
    rm -rf "$existing_dir"
  fi
done

for skill_dir in "$CODEX_SKILLS_DIR"/*; do
  [ -d "$skill_dir" ] || continue
  skill_name="$(basename "$skill_dir")"
  install_path="$INSTALLED_SKILLS_DIR/$skill_name"

  if [ -e "$install_path" ] && [ ! -L "$install_path" ]; then
    echo "skip $skill_name: $install_path already exists and is not a symlink"
    continue
  fi

  ln -sfn "$skill_dir" "$install_path"
done
