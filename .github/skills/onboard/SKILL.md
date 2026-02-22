---
name: onboard
description: Gather project context at the start of a new session. Reads CHANGELOG, ROADMAP, know-how, tech-stack, and architecture docs to understand the project state before doing any work. Use at the beginning of every session or when switching to an unfamiliar area of the codebase.
user-invokable: true
disable-model-invocation: false
---

# Onboard — Gather Project Context

AI agents have no memory between sessions. This skill reads the key project files and builds a mental model of where things stand — so you can act on the user's intent instead of guessing.

## Steps

1. Read `CHANGELOG.md` — what happened recently, what was already tried
2. Read `ROADMAP.md` (if it exists) — future direction, so your work aligns
3. Read `docs/tech-stack.md` (if it exists) — installed versions and doc links
4. Scan `docs/know-how/` — list available entries, read any relevant to the current task
5. Scan `docs/architecture/` — list ADRs, read any relevant to the current task
6. Check GitHub Issues (if GitHub MCP is available) — open issues, recent PRs

## Output

Summarize what you found in this format:

```markdown
## Project State

**Recent changes:** [1-2 sentence summary from CHANGELOG]
**Direction:** [key point from ROADMAP]
**Tech stack:** [key technologies and versions]
**Known gotchas:** [relevant know-how entries]
**Open work:** [relevant open issues]
```

## When to Use

- Start of a new chat session
- Before working on an unfamiliar part of the codebase
- When the user asks "what's the status?" or "what happened recently?"
- When you're unsure about project conventions or past decisions
