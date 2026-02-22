# Autodocs

**AI-powered project documentation template** — drop it into any repo and your AI agents (VS Code Copilot, GitHub coding agent) automatically track history, enforce documentation, and build institutional knowledge.

## The Problem

AI coding agents are powerful, but they have no memory between sessions. Every new conversation starts from zero — the agent doesn't know what was built yesterday, what decisions were made, or what lessons were learned.

Manual documentation helps, but developers forget to update it. Knowledge lives in Slack threads, PR descriptions, and people's heads.

## The Solution

Autodocs gives your project:

- **Automatic documentation enforcement** — a Stop hook blocks the agent if code changes lack a CHANGELOG entry
- **Task tracking via GitHub Issues** — assignable to humans or Copilot coding agent
- **Universal history** — `CHANGELOG.md` is the bridge between local and remote AI agents
- **Growing knowledge base** — `docs/know-how/` captures lessons learned over time
- **Specialized AI agents** — planner, coder, reviewer with distinct roles and handoffs
- **Slash commands** — `/new-task`, `/done` for common workflows
- **Agent Skills** — portable skills (`learn`, `adr`, `onboard`) in `.github/skills/`
- **Issue templates** — structured task & bug templates with agent configuration fields

## Quick Start

### New project

```bash
npx degit joealmond/autodocs my-project
cd my-project
```

### Existing project

```bash
# Copy the AI layer
npx degit joealmond/autodocs/.github .github --force
npx degit joealmond/autodocs/templates templates --force
npx degit joealmond/autodocs/docs docs --force

# Copy root files
curl -sL https://raw.githubusercontent.com/joealmond/autodocs/main/AGENTS.md -o AGENTS.md
curl -sL https://raw.githubusercontent.com/joealmond/autodocs/main/CHANGELOG.md -o CHANGELOG.md

# Optional
curl -sL https://raw.githubusercontent.com/joealmond/autodocs/main/ROADMAP.md -o ROADMAP.md
```

## What You Get

```
.github/
  agents/           — 3 AI personas (planner, coder, reviewer)
  prompts/          — 2 slash commands (/new-task, /done)
  instructions/     — File-pattern rules (auto-applied by glob)
  hooks/            — Stop hook → checks docs are updated
  skills/           — 3 portable skills (learn, adr, onboard)
  ISSUE_TEMPLATE/   — Task & bug forms with agent config fields
docs/
  architecture/     — ADRs (Architecture Decision Records)
  know-how/         — Lessons learned (grows over time)
templates/          — tech-stack.md reference template
scripts/            — autodoc-check.sh
README-Autodocs.md  — This file (autodocs documentation)
AGENTS.md           — Universal rules for all AI agents
CHANGELOG.md        — Universal history bridge
ROADMAP.md          — Future ideas (non-actionable)
```

## How It Works

### Two modes of AI work

| Mode | Where | History | Task context |
|---|---|---|---|
| **Local** (VS Code) | Your machine | `CHANGELOG.md` on disk | User conversation + GitHub MCP |
| **Remote** (coding agent) | GitHub Actions sandbox | `CHANGELOG.md` in repo | Assigned Issue + GitHub MCP |

`CHANGELOG.md` is the **universal bridge** — committed to the repo, readable by all agents, always current.

### Agents

| Agent | Role | Tools |
|---|---|---|
| **Planner** | Breaks work into Issues, estimates, tracks progress | read-only |
| **Coder** | Implements features, fixes bugs, writes tests | full editing |
| **Reviewer** | Checks quality, security, documentation | read-only |

Agents hand off to each other: Planner → Coder → Reviewer → Coder (fix) → done.

### Slash Commands

| Command | What it does |
|---|---|
| `/new-task` | Draft a GitHub Issue with structured format |
| `/done` | Record completed work in CHANGELOG |

### Agent Skills

Portable skills in `.github/skills/` — auto-discovered by the agent based on task context.

| Skill | What it does |
|---|---|
| `learn` | Save a lesson to `docs/know-how/` |
| `adr` | Create an Architecture Decision Record |
| `onboard` | Gather full project context at session start |
### Stop Hook

When the Coder agent finishes, `autodoc-check.sh` runs automatically. If code files changed but `CHANGELOG.md` wasn't updated, the agent is asked to fix it before finishing.

## GitHub Issues + Copilot Coding Agent

Tasks live in GitHub Issues — not local files. Issue templates include fields for:

- **Agent** — which agent should handle it (coder/planner/reviewer)
- **MCP Servers** — which MCP servers the agent needs
- **Tools / Skills** — specific capabilities required
- **Agent Instructions** — extra context for the AI

To assign an issue to Copilot: open the Issue → assign `@copilot` → it creates a PR automatically.

## License

MIT
