---
name: adr
description: Create an Architecture Decision Record (ADR) to document a significant technical decision. Use when choosing between technologies, changing system architecture, or making a design decision that affects the project long-term. Creates a structured entry in docs/architecture/.
---

# ADR — Architecture Decision Record

## When to Use

- Choosing between technologies or approaches
- Changing system architecture or data models
- Making a design decision that will be hard to reverse
- Any decision where "why did we do this?" will matter later

## Steps

1. Ask the user: "What decision are you making, and what alternatives did you consider?"
2. Determine the next ADR number by checking existing files in `docs/architecture/`
3. Create a file named `ADR-NNN-kebab-case-title.md` in `docs/architecture/`
4. Use the [template](./template.md) format
5. Set status to **Proposed** (the user or reviewer changes it to **Accepted**)

## Rules

- One decision per ADR — don't bundle multiple choices
- Always document alternatives considered and why they were rejected
- Include both positive and negative consequences
- Never delete an ADR — mark old ones as **Deprecated** or **Superseded** with a link to the replacement
