````skill
---
name: extend-agent
description: Extend this project's AI agentic capabilities by adding new skills, prompts, instructions, agents, or know-how entries. Use when the LLM discovers gaps in its own configuration or the user requests new capabilities.
user-invokable: true
disable-model-invocation: false
---

# Extend Agent — Self-Improve AI Capabilities

## When to Use

- You discovered a gap in your skills, prompts, or instructions
- The user asks you to "remember" or "learn" something for future sessions
- A new workflow pattern emerged that should be codified
- A library or framework has domain-specific patterns worth encoding
- After onboarding to a new area of the codebase with reusable insights

## What Can Be Extended

| Capability | Location | Format | Purpose |
|-----------|----------|--------|---------|
| Skills | `.github/skills/<name>/SKILL.md` | Skill template | Reusable multi-step workflows |
| Prompts | `.github/prompts/<name>.prompt.md` | Prompt template | Slash commands for common tasks |
| Instructions | `.github/instructions/<name>.instructions.md` | Instruction template | Auto-applied rules by file glob |
| Agents | `.github/agents/<name>.agent.md` | Agent template | Specialized personas |
| Know-how | `docs/know-how/<name>.md` | Know-how template | Lessons learned, gotchas |
| Rules | `AGENTS.md` | Markdown | Universal rules for all agents |

## Steps

1. **Identify the gap** — what capability is missing or incomplete?
2. **Choose the right type:**
   - **Skill** if it's a multi-step workflow (e.g., "add a JUCE module")
   - **Prompt** if it's a user-invokable slash command (e.g., `/build`)
   - **Instruction** if it's a rule that auto-applies to certain files (e.g., CMake conventions)
   - **Agent** if it's a specialized persona (e.g., audio DSP expert)
   - **Know-how** if it's a lesson learned (e.g., "CLAP needs recursive submodule init")
   - **AGENTS.md** if it's a universal rule that applies to all agents
3. **Create the file** using the appropriate template from existing examples
4. **Test it** — verify the new capability makes sense in context
5. **Update CHANGELOG.md** with what was added

## Rules

- Follow existing naming conventions (kebab-case filenames)
- Keep files focused — one capability per file
- Skills should have clear steps and "When to Use" sections
- Instructions must specify `applyTo` glob patterns
- Reference `docs/tech-stack.md` for version-specific info
- Don't duplicate — check existing skills/prompts first

````
