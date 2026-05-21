Provide a code review for pull request $ARGUMENTS, in learning mode.

Do NOT post any GitHub comments. Instead, present every finding directly in the conversation as a structured learning document — following the format defined in LEARNINGS/how-to-read-and-debug-code.md.

Make a todo list first, then follow these steps precisely.

---

## Step 1 — Eligibility check (Haiku agent)

Use a Haiku agent to check if the pull request is:
(a) closed, (b) a draft, (c) an automated/trivial PR that doesn't need review, or (d) already reviewed by Claude Code (look for "🤖 Generated with [Claude Code]" in comments/reviews).

If any of these are true, stop and tell the user why.

---

## Step 2 — Find relevant CLAUDE.md files (Haiku agent)

Use a Haiku agent to:
1. Run `gh pr diff <number> --name-only` to get modified files
2. Run `find . -name "CLAUDE.md"` to list all CLAUDE.md files
3. Return only the file paths of the root CLAUDE.md + any CLAUDE.md files in the directories of modified files (no file contents needed)

---

## Step 3 — Summarise the PR (Haiku agent)

Use a Haiku agent to run `gh pr view <number>` and `gh pr diff <number>` and return:
- PR title and description (Jira story intent)
- List of modified files
- A 3–5 sentence plain-English summary of what the change does

---

## Step 4 — Five parallel code review agents (Sonnet)

Launch 5 parallel Sonnet agents. Each agent should return a list of issues with file:line references and the reason each was flagged.

a. **Agent 1 – CLAUDE.md compliance**: Audit the diff against the CLAUDE.md files. Note: CLAUDE.md is guidance for Claude writing code; not every instruction applies during a code review.
b. **Agent 2 – Bug scan**: Shallow scan of the diff for obvious, large bugs. No extra context beyond the diff. Ignore nitpicks, linter/compiler-catchable issues, and false positives.
c. **Agent 3 – Git history context**: Run `git log` and `git blame` on modified files to identify bugs that only make sense in light of the commit history (e.g., a fix that reverts a previous fix).
d. **Agent 4 – Prior PR comments**: Find prior PRs that touched these files, read their review comments, and flag anything that also applies to this PR.
e. **Agent 5 – Code comment compliance**: Read the full modified files and check that the changes comply with any inline comments, TODOs, or JSDoc guidance in those files.

---

## Step 5 — Score every issue (parallel Haiku agents)

For each issue from Step 4, launch a parallel Haiku agent to score it 0–100. Give this rubric verbatim to each agent:

- 0: Not confident at all. False positive, or a pre-existing issue.
- 25: Somewhat confident. Might be real, might be a false positive. Unverified. Stylistic issues not explicitly in CLAUDE.md score here.
- 50: Moderately confident. Real issue, but a nitpick or infrequent in practice.
- 75: Highly confident. Double-checked. Very likely a real issue hit in practice. Important. Directly mentioned in CLAUDE.md.
- 100: Absolutely certain. Confirmed. Happens frequently. Evidence is direct.

For CLAUDE.md issues, the agent must verify the exact rule is stated in the relevant CLAUDE.md.

---

## Step 6 — Filter

Discard any issue with a score below 80. If no issues remain, tell the user no issues were found and stop.

---

## Step 7 — Re-check eligibility (Haiku agent)

Re-run the eligibility check from Step 1. If the PR is no longer eligible, stop.

---

## Step 8 — Present findings in learning mode AND persist to disk

Do NOT post a GitHub comment.

First, extract the Jira ID from the PR title (e.g. `IMH-3217` from `IMH-3217 (Fix): ...`). If no Jira ID is found, use `NO-JIRA`. Also capture the PR number from the argument. Construct the output filename as:

```
LEARNINGS/code_reviews/<JIRA-ID>_PR<pr-number>_code-review.md
```

Example: `LEARNINGS/code_reviews/IMH-3217_PR2329_code-review.md`

Ensure the directory exists (`mkdir -p LEARNINGS/code_reviews`) then write the full learning document to that file using the Write tool. After writing, print a confirmation line: `Saved to LEARNINGS/code_reviews/<filename>`.

Then also present the output in the conversation, using the structure below. Model it on LEARNINGS/how-to-read-and-debug-code.md: use ASCII diagrams, concrete file paths, layer labels, and plain-English explanations. The reader is new to this codebase and is learning how to review and debug code.

### Output structure (one section per finding)

For the whole PR first, output:

```
─────────────────────────────────────────────
PR OVERVIEW
─────────────────────────────────────────────
Jira / story intent:   <one line>
What the PR does:      <2–3 sentences>
Files changed:
  <file>   → <layer label: UI Component / Business Logic / Test / CI / etc.>
  <file>   → <layer label>
  ...
─────────────────────────────────────────────
```

Then for each finding, output:

```
═══════════════════════════════════════════════
ISSUE #N — <short title>
Confidence: <score>/100
═══════════════════════════════════════════════

## What is this about?
<2–3 sentences explaining the concept or the layer where the bug lives, in plain English. Assume the reader hasn't seen this code before.>

## File map
<List the files involved in this issue and label their role>

  <file A>   → <role>
    └─ <file B>   → <role>
         └─ <file C>   → <role>

## Execution path (how data flows here)
<ASCII sequence diagram showing the relevant code path — from user action or data entry point, down to where the bug manifests. Use the style from LEARNINGS/how-to-read-and-debug-code.md>

## Where the bug lives
File: <exact file path>
Lines: <L start–end>

<Paste the relevant code snippet (≤20 lines) from the file>

## Why this is a bug
<Step-by-step explanation of what goes wrong, using concrete examples. E.g. "If the user sets medium to 'Phone' but leaves adviceGiver empty, then...". Show the before/after behaviour.>

## How it relates to other files
<Explain how this file interacts with the files above/below it in the file map. What does each file expect? Where does the contract break?>

## Recommended fix
<A concrete code snippet showing the corrected code, with a brief explanation of WHY this fix works — not just what it changes.>
```

---

## Step 9 — PR comment draft

After all findings are presented, output a ready-to-copy block the user can paste manually as a GitHub PR comment. Also append this same block to the bottom of the saved file so the file is fully self-contained.

```
─────────────────────────────────────────────
READY TO COPY — paste this as your PR comment
─────────────────────────────────────────────

### Code review

Found N issues:

1. <brief description> — `<file path>` L<start>–L<end>
2. <brief description> — `<file path>` L<start>–L<end>
...

<sub>Reviewed with Claude Code</sub>

─────────────────────────────────────────────
```

---

## False positive examples (for Steps 4 and 5)

- Pre-existing issues not introduced by this PR
- Things a linter, compiler, or type-checker would catch automatically (assume CI handles these)
- Nitpicks a senior engineer wouldn't flag in a review
- CLAUDE.md issues that are explicitly silenced in the code (e.g., eslint-disable comment)
- Intentional behaviour changes directly related to the PR's stated goal
- Real issues on lines the PR did not modify

## General notes

- Do not attempt to build or type-check the app.
- Use `gh` for all GitHub interactions.
- When referencing code, always use the format `file:line` or a GitHub permalink with the full 40-character SHA.
- Read LEARNINGS/how-to-read-and-debug-code.md before writing any output in Step 8, to align the style precisely.
