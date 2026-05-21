---
name: consult-ai
description: "Use when the user wants a second opinion from another AI (Gemini CLI, Opencode) on a design choice, code review, debugging hypothesis, or technical question. Trigger on phrases like 'ask gemini', 'consult opencode', 'what does <agent> think', 'second opinion from <agent>'. Invokes the external agent in headless mode and returns its response."
trigger: /consult-ai
---

# /consult-ai

Consult an external AI agent (Gemini CLI, Opencode) in headless mode for a second opinion on the current topic. Returns the external agent's response inline so you can compare reasoning.

## Usage

```
/consult-ai <agent>                    # use current chat context as the topic
/consult-ai <agent> "<topic>"          # explicit topic / question
/consult-ai <agent> --model <model>    # override default model
/consult-ai <agent> --raw              # return raw output, no summarization
```

`<agent>` is one of: `gemini`, `opencode`.

## When to Use

- User asks for a "second opinion", "sanity check", or "what would <other AI> say".
- You're uncertain about a design trade-off and want a tie-breaker.
- A debugging hypothesis is shaky and a fresh perspective could help.
- Cross-checking factual claims about a library where Context7 isn't enough.

**Do NOT use** for tasks the current session can answer directly, or as a way to delegate work the user asked YOU to do.

## Pre-flight Checks

Before invoking, verify the agent is installed:

```bash
command -v gemini    # for agent=gemini
command -v opencode  # for agent=opencode
```

If missing, tell the user how to install (`brew install gemini-cli` / see opencode docs) and stop. Do not silently fall back to a different agent.

## Agent Adapters

Each agent has a different headless invocation. Always pass the prompt via stdin or `-p` — never embed user-controlled text directly in the shell command without quoting.

### Gemini CLI

```bash
gemini -y -m "${MODEL:-gemini-3.1-pro-preview}" -o text -p "$PROMPT" 2>/dev/null
```

- `-y` — auto-accept tool calls (YOLO; safe in headless one-shot)
- `-m` — model selector; default `gemini-3.1-pro-preview`
- `-o text` — plain text output (use `json` if you need structured)
- `-p` — non-interactive prompt mode
- `2>/dev/null` — suppress noisy auth/telemetry stderr; surface real errors by checking exit code

### Opencode

```bash
opencode run -m "${MODEL:-google/gemini-3.1-pro-preview}" "$PROMPT"
```

- `opencode run` is the headless command (NOT `--prompt`).
- `-m` takes a `provider/model` string. Useful alternatives:
  - `openrouter/anthropic/claude-opus-4.7` — for a non-Google opinion
  - `openrouter/anthropic/claude-sonnet-4.6` — cheaper/faster
- Opencode emits its TUI banner on stderr; capture stdout only.

## Building the Prompt

This is the heart of the skill. The prompt template determines whether the response is a useful second opinion or generic noise.

**TODO (user contribution):** Define the prompt template in `prompt-template.md` in this directory. See that file for the exact spec and trade-offs.

When invoking:

1. Determine `<topic>`:
   - If user supplied one explicitly, use it verbatim.
   - Otherwise, extract the **last meaningful technical exchange** from the current conversation (the question + your latest reasoning/proposal). Keep it under ~2000 tokens.
2. Load `prompt-template.md` and substitute `{{TOPIC}}` and `{{CONTEXT}}`.
3. Pipe to the agent adapter above.
4. Capture stdout. If exit code ≠ 0, surface stderr to the user; do not invent a response.

## Output Handling

- Default: present the external agent's response under a clearly-marked block:
  ```
  ━━━ Consulted: gemini (gemini-3.1-pro-preview) ━━━
  <response>
  ━━━ End consultation ━━━
  ```
- Then add ONE sentence with your own take: agree / disagree / partial agreement, with a reason.
- `--raw`: skip the framing and your take. Just print the response.

## Quick Reference

| Agent     | Headless flag        | Default model                       |
|-----------|----------------------|-------------------------------------|
| gemini    | `-p "<prompt>"`      | `gemini-3.1-pro-preview`            |
| opencode  | `run "<message>"`    | `google/gemini-3.1-pro-preview`     |

## Common Mistakes

- **Embedding the prompt unquoted in the shell** — use `"$PROMPT"` with proper escaping or pipe via stdin.
- **Falling back to a different agent silently** when the requested one is missing — tell the user, don't substitute.
- **Treating the response as authoritative** — it's a second opinion, not a verdict. Always add your own assessment.
- **Dumping the entire chat history as context** — extract only the relevant slice; long contexts cost money and dilute the question.
- **Forgetting `-y` on gemini** — without it, headless mode hangs on tool-approval prompts.
