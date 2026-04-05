#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "$0")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"

target_root="${1:-${CLAUDE_SKILLS_HOME:-$HOME/.claude/skills}}"
target_dir="$target_root/figure-plot"

mkdir -p "$target_root"
rm -rf "$target_dir"
mkdir -p "$target_dir"

if command -v rsync >/dev/null 2>&1; then
  rsync -a \
    --exclude '.git/' \
    --exclude '__pycache__/' \
    "$repo_root/" "$target_dir/"
else
  cp -R "$repo_root/." "$target_dir/"
  rm -rf "$target_dir/.git"
  find "$target_dir" -name '__pycache__' -type d -prune -exec rm -rf {} +
fi

echo "[figure-plot] installed to: $target_dir"
