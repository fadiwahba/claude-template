---
name: orchestrate
description: "Reinforces agent orchestration and tooling defaults from CLAUDE.md. Use when Claude appears to be working sequentially instead of in parallel, choosing wrong models, skipping MCP tools, or not reporting agent status. Trigger: /orchestrate"
trigger: /orchestrate
---

# /orchestrate

Re-anchor to the orchestration and tooling rules. Run this when you notice drift: sequential work that could be parallel, wrong model selection, missing MCP tools, or silent agent progress.

## What to do when invoked

1. **Audit the current task** against the rules below.
2. **State out loud** what you will change or confirm you are already compliant.
3. **Adjust your approach** before proceeding — do not just acknowledge and continue as before.

---

## Agent Orchestration Rules

- **Spawn sub-agents** for independent parallel tasks. Use `@~/.claude/agents/` for coding contexts.
- **You are the single point of contact.** Summarise each agent's scope, progress, and output. User never speaks directly to sub-agents.
- **Report proactively** at start, completion, and on any blocker. Never go silent mid-task.
- **Default: spawn agents with `run_in_background: true`.** Main session stays free for conversation immediately. Only fall back to foreground (blocking) dispatch when the current skill explicitly requires merging agent output before it can proceed (e.g. graphify's merge step).
- **Model selection by complexity:**
  - Haiku → simple tasks: documentation, linting, straightforward refactors
  - Sonnet → complex logic, architecture, multi-step reasoning
  - Re-evaluate if a task grows beyond initial scope.
- **Context hygiene:** Pass only relevant files/APIs to each agent. No logs, build artifacts, or unrelated modules.
- **Agent scope clarity:** Define discrete, independent boundaries upfront. Pre-seed each agent with its relevant `KNOWLEDGE_BASE.md` subset.

---

## Tooling Defaults

| Situation | Default |
|---|---|
| Multi-step non-trivial task | Sequential Thinking MCP — plan before coding |
| API/library usage | Context7 for official docs before implementing |
| UI/browser-facing changes | Validate with Playwright; report what was tested |
| Parallel independent tasks | Dispatch sub-agents |
| Required tool unavailable | State it explicitly; use the closest fallback |
| Completing a feature or spec | Run `/sync-knowledge` to update project memory |

---

## Self-check before responding

Ask yourself:
- Can any part of this task run in parallel? → spawn agents with `run_in_background: true` (default)
- Does the current skill explicitly need agent output before proceeding? → foreground dispatch only in that case
- Am I about to use an API/library from memory? → use Context7 first
- Is this multi-step and non-trivial? → use Sequential Thinking MCP
- Did I assign the right model to each agent?
- Will I report back at each milestone, or just at the end?
