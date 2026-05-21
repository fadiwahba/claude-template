---
description: Write a detailed implementation spec for a feature
argument-hint: <feature description>
---

Write a detailed implementation spec for the following feature: $ARGUMENTS

Save it to `_specs/<YYYY-MM-DD_HH-MM-AM/PM>_<feature-slug>/spec.md` (create directory if needed).
The timestamp uses the current local date/time, e.g. `_specs/2026-03-16_09-30-AM_trail-monitor-v2/spec.md`.

## Spec structure

Use this structure:

```
# <Feature Name> — Implementation Spec

**Feature:** <feature-slug>
**Created:** <today's date>
**Status:** planned
**Priority:** <high|medium|low>

---

## What
One paragraph: what this feature does, from the user/operator perspective.

---

## Why
- Business motivation (what problem it solves)
- Any quantitative evidence (test results, metrics, user feedback)
- What happens if we don't build it

---

## How

### Architecture
- Diagram or bullet list of components and their interactions
- Key design decisions and rationale (why this approach, not others)
- Data flow: input → processing → output

### Key design decisions
Numbered list of non-obvious decisions with the reasoning for each.

---

## Database Changes (if any)
SQL migration statements + description of each column.

---

## API / Interface Changes (if any)
- Endpoint changes, new payload fields, webhook format changes
- Breaking vs non-breaking

---

## Implementation Logic (if non-trivial)
Pseudocode or TypeScript sketch of the core algorithm.
Keep it concise — enough to guide implementation, not a full implementation.

---

## Implementation Tasks

### Phase 1 — <phase name>
- [ ] Task description (specific, actionable)
- [ ] ...

### Phase 2 — <phase name>
- [ ] Task description
- [ ] ...

---

## Testing Strategy
1. Unit tests — what to mock, what to assert
2. Integration tests — end-to-end scenario
3. Regression — what must not break

---

## References
- Links to relevant docs, prior research, related files in the repo
```

## Process

1. First check if a relevant spec already exists under `_specs/`. If so, read it and ask if this should update the existing spec or create a new one. When creating, always generate a fresh timestamp for the directory name.
2. If the feature description is ambiguous, ask one clarifying question before writing.
3. Write the spec following the structure above, scaled to the feature's complexity — a small feature needs 1-2 sentences per section, a large infrastructure feature needs full detail.
4. After writing, confirm the file path to the user.

## Post-Implementation: Update KNOWLEDGE_BASE.md

When the feature is complete and all tasks are checked off, update `KNOWLEDGE_BASE.md` with any durable, non-derivable learnings from the implementation. Use `/sync-knowledge` or manually add entries that meet ALL of these criteria:
- **Durable** — still true in future sessions (not ephemeral task state)
- **Non-derivable** — cannot be recovered by reading the code or `git log`
- **Actionable** — changes how future work is approached

Typical candidates: architecture changes, new services/processes, gotchas discovered during implementation, API constraints, promoted configs. Update the spec status to `complete` after syncing.
