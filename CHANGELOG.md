# Changelog

All notable changes to this project will be documented in this file.

## [1.0.0] — 2026-02-22

### Added

**Core**
- `AGENTS.md` — universal rules for all AI agents (single source of truth)
- `CHANGELOG.md` — universal history bridge between local and remote agents
- `ROADMAP.md` — non-actionable future ideas
- `README-Autodocs.md` — full autodocs documentation (overview, quick start, how it works)

**Agents**
- `.github/agents/planner.agent.md` — project planner (read-only, creates Issues)
- `.github/agents/coder.agent.md` — implementation agent (full tools, library-aware)
- `.github/agents/reviewer.agent.md` — code reviewer (read-only, quality checklists)

**Skills**
- `.github/skills/learn/` — save lessons to `docs/know-how/` (includes template)
- `.github/skills/adr/` — create Architecture Decision Records (includes template)
- `.github/skills/onboard/` — gather full project context at session start

**Prompts**
- `.github/prompts/new-task.prompt.md` — `/new-task` slash command (draft GitHub Issue)
- `.github/prompts/done.prompt.md` — `/done` slash command (record work in CHANGELOG)

**Instructions**
- `.github/instructions/changelog.instructions.md` — auto-applied CHANGELOG formatting rules
- `.github/instructions/docs.instructions.md` — auto-applied documentation standards

**Automation**
- `.github/hooks/stop.json` — Stop hook enforcing CHANGELOG updates
- `scripts/autodoc-check.sh` — doc enforcement script used by Stop hook

**Templates**
- `.github/ISSUE_TEMPLATE/task.yml` — structured task template with agent config fields
- `.github/ISSUE_TEMPLATE/bug.yml` — bug report template with agent config
- `templates/tech-stack.md` — tech stack reference template (versions + doc links)

**Knowledge Base**
- `docs/know-how/README.md` — knowledge base guide
- `docs/know-how/coding-agent-sandbox.md` — Copilot sandbox capabilities
- `docs/know-how/github-issues-workflow.md` — GitHub Issues + Copilot workflow
- `docs/know-how/working-with-libraries.md` — version mismatch prevention
- `docs/know-how/instruction-files.md` — how instruction files work (vs Agent Skills)
- `docs/architecture/` — ADR folder (empty, ready for use)
