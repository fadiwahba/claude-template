---
description: Sync important learnings from the current session into the project's KNOWLEDGE_BASE.md
argument-hint: [optional focus area or topic hint]
---

Review the current conversation and update the project's `KNOWLEDGE_BASE.md` with any durable learnings that belong in persistent project memory.

## Step 1 — Locate KNOWLEDGE_BASE.md

Check if a `KNOWLEDGE_BASE.md` exists in the current project root (or at the path referenced in `CLAUDE.md`).

- **If not found:** check for a `KNOWLEDGE_BASE.md` as a fallback (legacy name). If neither exists, inform the user and stop.
- **If found:** read it in full before proceeding.

## Step 2 — Scan the session for candidates

Review the entire conversation and identify content that meets ALL of these criteria:

**Must be:**
- Durable — still true in future sessions (not ephemeral task state)
- Non-derivable — cannot be recovered by reading the code or running `git log`
- Actionable — changes how you or the user would approach future work

**Typical high-value candidates:**
- Gotchas and non-obvious constraints discovered during debugging or testing
- API behaviours that contradicted documentation or expectations
- Architecture decisions with reasoning that isn't in the code
- Confirmed results from experiments/backtests (promoted configs, ruled-out approaches)
- Workflow conventions established or changed this session

**Exclude anything that is:**
- Already in KNOWLEDGE_BASE.md (no duplicates)
- Covered by CLAUDE.md or committed docs
- Ephemeral (task status, in-progress work, current conversation context)
- A general programming concept (not project-specific)
- A test result that isn't clearly better than existing alternatives (e.g. "this config got 5% return, which is good but not clearly better than the 4.5% from the previous config")
- A code-level detail that can be easily found by reading the code (e.g. "the `fetchData` function uses the `dataService` module and returns an array of objects with `date`, `open`, `close` fields")
- Code patterns or file paths derivable from the codebase

## Step 3 — Apply the slim test

Before adding anything, ask: *"If a future session reads this, will it meaningfully change behaviour?"*

- Yes → include it
- Maybe → exclude it (when in doubt, leave it out)
- No → exclude it

**KNOWLEDGE_BASE.md must stay slim.** Every line added has a cost (future context load). Prefer updating an existing section over adding a new one. Prefer one precise sentence over three vague ones.

## Step 4 — Propose changes

Present proposed additions/updates to the user as a clear diff-style summary:

```
PROPOSED KNOWLEDGE_BASE.md CHANGES
─────────────────────────
Section: <section name or "New section: X">

  ADD: <the exact text to add, as it would appear in the file>

Reason: <one sentence on why this earns its place>
─────────────────────────
```

List all candidates. Then ask:

> "Does this look right? I'll update KNOWLEDGE_BASE.md once you confirm — or tell me which items to skip."

## Step 5 — Write confirmed changes

Once the user confirms (or adjusts), update `KNOWLEDGE_BASE.md` with only the approved additions. Prefer appending to relevant existing sections over creating new sections.

## Rules

- **Never remove existing content** unless the user explicitly asks.
- **Never add more than ~10 lines** per session without strong justification.
- **One idea per bullet** — no compound sentences that hide two learnings.
- **Propose first, write second** — always get confirmation before touching the file.
- **Never write to the Claude Code auto-memory store** (`~/.claude/projects/.../memory/`) — always write to the project's `KNOWLEDGE_BASE.md`.
- If `$ARGUMENTS` is provided, use it as a hint for which area of the session to focus on (e.g. `/sync-knowledge backtest` focuses on backtest-related learnings only).
