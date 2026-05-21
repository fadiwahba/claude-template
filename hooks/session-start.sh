#!/usr/bin/env bash
# Injects orchestration rules on fresh startup and after compaction.
# Also injects wiki orientation on startup, and a sync reminder if a
# previous session ended without running wiki-sync.

set -euo pipefail

SOURCE=$(cat | jq -r '.source // ""' 2>/dev/null)

if [[ "$SOURCE" != "startup" && "$SOURCE" != "compact" ]]; then
  exit 0
fi

ORCHESTRATION="## Orchestration Rules

**Agent dispatch default: \`run_in_background: true\`** — main session stays free for conversation immediately.
Only use foreground (blocking) dispatch when the active skill explicitly needs agent output before proceeding.

- Spawn sub-agents for every independent parallel task
- You are the single point of contact — summarise scope, progress, and output for each agent
- Model: Haiku for simple tasks (docs, linting, refactors) · Sonnet for complex logic / architecture
- Context hygiene: pass only relevant files/APIs — no logs, build artefacts, or unrelated modules
- Report at start, completion, and on any blocker — never go silent mid-task

**Self-check before acting on any non-trivial task:**
- Can any part run in parallel? → spawn agents with \`run_in_background: true\`
- Does the active skill need agent output to proceed? → foreground only in that case
- About to use an API/library from memory? → use Context7 first
- Multi-step and non-trivial? → use Sequential Thinking MCP first"

WIKI_ORIENTATION="## Knowledge Base (Obsidian Wiki)
Vault: ~/Library/Mobile Documents/iCloud~md~obsidian/Documents
- Start here for project context: wiki/syntheses/active_projects.md
- Atomic notes: wiki/concepts/ and wiki/entities/
- Human-owned (read only): Projects/, Cerebro/, raw/, My Journal/
Read wiki/syntheses/active_projects.md when the user's request relates to an active project."

CONTEXT="$ORCHESTRATION

$WIKI_ORIENTATION"

# If a previous session ended without wiki-sync, inject a reminder and clear the marker.
if [[ -f ~/.claude/wiki-sync-pending ]]; then
  CONTEXT="$CONTEXT

## Wiki Sync Pending
A previous session closed without writing learnings to the wiki.
Early in this session, offer to run /obsidian-ingest (raw inbox) then /obsidian-wiki-sync (session learnings) to capture anything worth preserving."
  rm -f ~/.claude/wiki-sync-pending
fi

jq -n --arg ctx "$CONTEXT" \
  '{hookSpecificOutput: {hookEventName: "SessionStart", additionalContext: $ctx}}'
