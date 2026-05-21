# claude-template

My personal scaffold for [Claude Code](https://claude.com/claude-code) — agents, commands, skills, hooks, and rules that I copy into new coding projects.

This is a living template. I keep refining it as I learn what does and doesn't work; expect it to drift.

## What's inside

| Path | Purpose | Type |
|---|---|---|
| `CLAUDE.md` | Global behavioral guidelines (think-before-coding, surgical changes, simplicity, orchestration). Lives at project root. | Drop-in |
| `agents/` | Specialized subagents (`backend-dev`, `frontend-dev`) with system prompts and trigger examples. | Drop-in |
| `commands/` | Slash commands: `/genesis`, `/spec`, `/review-pr`, `/sync-knowledge`. | Drop-in |
| `skills/` | Reusable skills (`consult-ai`, `context7-mcp`, `graphify`, `karpathy-guidelines`, `obsidian-*`, `orchestrate`). | Drop-in |
| `hooks/` | `session-start.sh` and `session-end.sh` lifecycle hooks. | Drop-in |
| `rules/` | Per-project context: `stack.md`, `architecture.md`, `conventions.md`, `commands.md`. | **Template — edit per project** |
| `statusline-command.sh` | Custom status line script. | Drop-in |

**Drop-in** = use as-is. **Template** = placeholder content; fill in per-project before relying on it.

## Usage

Bootstrap into a new project by copying the pieces you want:

```bash
# From any project root
PROJECT_ROOT=$(pwd)
TEMPLATE=~/sandbox/claude-template   # or wherever you cloned it

mkdir -p "$PROJECT_ROOT/.claude"
cp -r "$TEMPLATE"/{agents,commands,skills,hooks,rules} "$PROJECT_ROOT/.claude/"
cp "$TEMPLATE/CLAUDE.md" "$PROJECT_ROOT/CLAUDE.md"
cp "$TEMPLATE/statusline-command.sh" "$PROJECT_ROOT/.claude/"
```

Then:
1. Fill in `.claude/rules/*.md` with the actual stack, architecture, conventions, and commands for the project.
2. Trim anything you don't need (e.g. delete `skills/obsidian-*` if the project isn't tied to the Obsidian vault).
3. Run `/genesis` inside Claude Code to let it audit the project and finish populating the rules.

Each project owns its copy after that — updates here don't flow back automatically. To pull in improvements later, diff the relevant file against this repo and merge by hand.

## Updating the template

When something works well in a real project, I backport it here:

```bash
cd ~/sandbox/claude-template
# copy the improved file back, commit, push
```

Conversely, when something here turns out to be wrong, I delete it. The template is supposed to shrink as often as it grows.

## Philosophy

The guidelines in `CLAUDE.md` are the load-bearing part — they bias the model toward asking before assuming, making surgical edits, and avoiding speculative complexity. Everything else (agents, commands, skills) is supporting infrastructure.

If you're forking this for your own use: keep `CLAUDE.md`, throw out anything that doesn't match how you work, and treat `rules/` as the per-project escape hatch.
