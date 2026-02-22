````prompt
---
name: extend-agent
description: "Extend AI capabilities — add skills, prompts, instructions, or know-how"
agent: coder
tools: ['read', 'editFiles', 'search']
---

Help the user extend this project's AI agentic capabilities.

## Steps

1. Ask the user: "What capability should be added or improved?"
2. Determine the right type:
   - **Skill** → `.github/skills/<name>/SKILL.md` (multi-step workflow)
   - **Prompt** → `.github/prompts/<name>.prompt.md` (slash command)
   - **Instruction** → `.github/instructions/<name>.instructions.md` (auto-apply rules)
   - **Agent** → `.github/agents/<name>.agent.md` (specialized persona)
   - **Know-how** → `docs/know-how/<name>.md` (lesson learned)
3. Check existing files in the target directory to avoid duplicates
4. Read an existing file of the same type as a template reference
5. Create the new file following the established format
6. Update `CHANGELOG.md`
7. If the new capability reveals a gap in `AGENTS.md`, suggest updating it

## Rules

- One capability per file — keep focused
- Use kebab-case filenames
- Skills need: name, description, when-to-use, steps, rules
- Prompts need: name, description, agent, tools, steps
- Instructions need: name, description, applyTo glob, rules

````
