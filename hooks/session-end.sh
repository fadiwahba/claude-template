#!/usr/bin/env bash
# Marks that a session closed without wiki sync.
# SessionStart hook reads this marker and injects a reminder into the next session.
set -euo pipefail
touch ~/.claude/wiki-sync-pending
