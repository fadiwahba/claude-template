---
name: obsidian-raw-ingest
description: Process files from the Obsidian raw/ inbox into atomic wiki notes. Expands raw captures into full notes in wiki/concepts/ or wiki/entities/. Tracks processed files in a manifest — never deletes originals. Invoke on demand with /obsidian-ingest or chained automatically before /obsidian-wiki-sync.
trigger: /obsidian-ingest
---

# Obsidian Raw Ingest

Process all files waiting in the `raw/` inbox and synthesise them into the wiki.

**Vault**: `/Users/fady/Library/Mobile Documents/iCloud~md~obsidian/Documents`

## Territory Rules (Non-Negotiable)

| Zone | Permission |
|---|---|
| `wiki/` (all subdirs) | Read + Write |
| `log.md` | Append only |
| `raw/.ingested` | Read + Write (manifest file — tracks processed filenames) |
| `raw/` files | Read only — never delete or move |
| `Projects/`, `Cerebro/`, `My Journal/`, `index.md` | Read only — never write or delete |

## Step 1 — Scan raw/ against the manifest

Read `raw/.ingested` if it exists — this is a plain-text list of already-processed filenames, one per line.

List all `.md` files directly in `raw/` (not subdirectories). Cross-reference against the manifest:
- **Already listed in manifest** → skip silently
- **Not in manifest** → queue for processing

If all files are already in the manifest, report "Inbox up to date — nothing new to ingest" and stop.

For each queued file: read the full content, then read any related `Projects/` or `Cerebro/` files needed for context before classifying.

## Step 2 — Classify and route

| Content type | Target folder |
|---|---|
| Mental model, technique, algorithm, general learning | `wiki/concepts/` |
| Project-specific decision, spec update, architecture | `wiki/entities/` |
| External reference, documentation, tool discovery | `wiki/sources/` |

## Step 3 — Write atomic note

One raw file → one wiki note (split into multiple only if the file clearly contains distinct, unrelated insights). Format:

```markdown
# [Descriptive Title]

**Type**: concept | entity | source
**Project**: [project name or "general"]
**Ingested**: [YYYY-MM-DD]
**Linked to**: [[Cerebro/X]] | [[Projects/Y]] | [[wiki/concepts/Z]]
**Source**: [[raw/filename|Original Capture]]

---

[Expand the raw capture into a complete, useful note.
Add context, mental models, and links.
Do not copy raw text verbatim — synthesise it.]

[If it is a decision: include the WHY, not just the what.]
[If it is a gotcha: what failed → why → the fix.]
```

**Check first**: if a note already exists for this topic, append or update it — never duplicate.

Name files descriptively: `Tradify v2 ATR Stop Loss.md`, not `2026-05-21-note.md`.

## Step 4 — Mark as processed in manifest

After the wiki note write is confirmed: append the raw filename (just the filename, not the path) to `raw/.ingested`, one filename per line.

```
01_personal_background.md
test_async.md
```

If the write fails for any reason, do not append to the manifest — the file will be retried on the next run.

Never delete or move raw files. They are permanent source captures.

## Step 5 — Log

Append to `log.md`:

```markdown
## [YYYY-MM-DD] - Obsidian Raw Ingest
- **Trigger**: /obsidian-ingest | PreCompact chain
- **Files processed**: [raw filenames]
- **Notes created**: [wiki filenames]
- **Notes updated**: [wiki filenames or "none"]
- **Inbox status**: empty | [N files remaining if any failed]
```

## Completion

Report: files processed, notes created/updated, inbox status, any failures.
