---
name: obsidian-wiki-sync
description: Extract learnings, decisions, gotchas, and patterns from the current session and write atomic notes to the Obsidian wiki. Runs automatically before compaction via PreCompact hook. Invoke on demand with /obsidian-wiki-sync.
trigger: /obsidian-wiki-sync
---

# Obsidian Wiki Sync

Persist this session's knowledge into the Obsidian vault at:
**`/Users/fady/Library/Mobile Documents/iCloud~md~obsidian/Documents`**

## Territory Rules (Non-Negotiable)

| Zone | Permission |
|---|---|
| `wiki/` (all subdirs) | Read + Write |
| `log.md` | Append only |
| `Projects/`, `Cerebro/`, `raw/`, `My Journal/`, `index.md` | Read only — never write or delete |

## Step 1 — Scan the session

Review the full conversation. Extract only items that would change future behaviour. Classify each:

| Type | What qualifies | Target folder |
|---|---|---|
| **Concept** | Mental model, pattern, algorithm, technique | `wiki/concepts/` |
| **Entity** | Project-specific decision, architecture, spec update | `wiki/entities/` |
| **Gotcha** | Something that failed, a footgun, a surprising constraint | `wiki/concepts/` — prefix title: `Gotcha — ` |
| **Source** | External reference, documentation link, tool discovery | `wiki/sources/` |

**Skip**: conversational filler, things already in the wiki, anything derivable from reading the code.

**Check before creating**: if a note already exists for this topic, update or append — never duplicate.

## Step 2 — Write atomic notes

One insight = one file. Format:

```markdown
# [Descriptive Title]

**Type**: concept | entity | gotcha | source
**Project**: [project name or "general"]
**Session**: [YYYY-MM-DD]
**Linked to**: [[Cerebro/X]] | [[Projects/Y]] | [[wiki/concepts/Z]]

---

[2–8 lines of dense, actionable content. No padding or preamble.]

[Gotcha: what failed → why → the fix.]
[Decision: what was decided → WHY — the reasoning is the value, not the outcome.]
[Pattern: the rule → when it applies → the counter-case to watch for.]
```

Name files descriptively using content, not dates:
- `Tradify v2 LISTEN NOTIFY Command Dispatch.md`
- `Gotcha — Obsidian Wikilink Path Resolution.md`

## Step 3 — Regenerate active_projects.md

Read these source files:
- `Projects/Tradify v2.md`
- `Projects/Lotto Oracle.md`
- `Cerebro/Trading.md`
- All files in `wiki/entities/` and `wiki/concepts/`

Overwrite `wiki/syntheses/active_projects.md` with a compact dashboard (max 50 lines):

```markdown
# Active Projects Dashboard
_AI-generated — do not edit manually. Updated: [YYYY-MM-DD]_

## [Project Name]
**Status**: not started | in progress | blocked | shipped
**Current phase**: [phase name from spec]
**Blocking**: [open question or hard dependency, or "none"]
**Key constraints**: [top 3 non-negotiable rules]
**Recent decisions**: [1–2 lines from latest session]
**Wiki nodes**: [[wiki/entities/...]] [[wiki/concepts/...]]

---
## Open Questions Across Projects
- [unresolved decisions surfaced in recent sessions]

---
## Wiki Index
- [all current wiki notes, one line each]
```

## Step 4 — Log

Append to `log.md`:

```markdown
## [YYYY-MM-DD] - Obsidian Wiki Sync
- **Trigger**: PreCompact | /obsidian-wiki-sync
- **Notes written**: [filenames]
- **Notes updated**: [filenames or "none"]
- **active_projects.md**: regenerated
- **Session topics**: [3–5 word summary]
```

## Completion

Report: notes written, notes updated, active_projects.md regenerated, any topics skipped and why.
