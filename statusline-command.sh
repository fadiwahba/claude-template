#!/usr/bin/env bash
input=$(cat)

user=$(whoami)
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
model=$(echo "$input" | jq -r '.model.display_name')
remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')

# Git branch (skip optional locks to avoid conflicts with Claude's own git operations)
branch=""
if git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
  branch=$(git -C "$cwd" -c core.useBuiltinFSMonitor=false symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
fi

# Shorten cwd: replace $HOME with ~
home="$HOME"
short_cwd="${cwd/#$home/\~}"

# Build branch segment
branch_segment=""
if [ -n "$branch" ]; then
  branch_segment=$(printf '\033[33m(%s)\033[0m ' "$branch")
fi

# Build context segment
ctx_segment=""
if [ -n "$remaining" ]; then
  ctx_segment=$(printf ' \033[36mctx:%s%%\033[0m' "$remaining")
fi

# Build model segment
model_segment=$(printf ' \033[35m[%s]\033[0m' "$model")

# Session name (provided directly by Claude Code when a custom title is set)
session_segment=""
session_name=$(echo "$input" | jq -r '.session_name // empty' 2>/dev/null)
if [ -n "$session_name" ]; then
  session_segment=$(printf ' \033[95m[%s]\033[0m' "$session_name")
fi

printf '\033[32m%s\033[0m in \033[34m%s\033[0m %s%s%s%s' \
  "$user" "$short_cwd" "$branch_segment" "$model_segment" "$session_segment" "$ctx_segment"
