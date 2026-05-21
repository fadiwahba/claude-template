# Consultation Prompt Template

This file is loaded by `consult-ai` and substituted with the topic + context before being sent to the external agent.

## Required placeholders

- `{{TOPIC}}` — the question/topic (either user-supplied or inferred from chat)
- `{{CONTEXT}}` — the relevant slice of conversation context (may be empty if user supplied an explicit topic)

## TODO: write the template below

The template shapes what kind of response we get. Decide what frame you want:

- **Critique frame**: "Find flaws in this reasoning." → Adversarial, surfaces blind spots, can be noisy.
- **Alternative frame**: "Propose a different approach and contrast." → Best for design choices.
- **Validation frame**: "Tell me if this reasoning is sound, citing specifics." → Tie-breaker for shaky hypotheses.
- **Open frame**: "Here's the topic. What's your take?" → Most flexible, least targeted.

Constraints to bake in:
- Ask for a concise response (the external agent has no memory of our session — long answers waste tokens).
- Tell it to be direct about disagreement; sycophancy here is useless.
- Optionally: ask for a confidence level or a "what would change my mind" line.

---

You are being consulted as a second-opinion expert.
The primary assistant has been working on:

{{CONTEXT}}

Question: {{TOPIC}}

Do NOT just agree. Propose a DIFFERENT approach if you can find one, and contrast it with what's implied above. If the implied approach is genuinely best, say so plainly and explain why alternatives are worse.

Keep under 250 words. End with one line:
"What would change my mind: ..."
