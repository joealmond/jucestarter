# GitHub Issues + Copilot Coding Agent Workflow

> How to use GitHub Issues for task tracking and the Copilot coding agent for automated implementation.

*Last updated: 2026-02-21*

## Creating Issues

Use the Issue templates (New Issue → pick "Task" or "Bug Report"). Only the description is required — everything else is optional.

### Tips for Copilot-assignable Issues

Write issues like clear prompts:
- Be specific about **which files** to modify
- Include **acceptance criteria** as a checklist
- Mention **tests to run** if applicable
- Add agent instructions for constraints (e.g., "don't modify the public API")

## Assigning to Copilot

1. Open the Issue on GitHub
2. In the Assignees sidebar, assign `@copilot`
3. Copilot reacts with 👀, then creates a `copilot/` branch and opens a PR
4. Track progress via the session logs (PR → "View session")

## What Copilot Can Do

- Read your repo code and docs
- Write code, create/edit files
- Run terminal commands (tests, linters, builds)
- Use MCP servers (GitHub, Sentry, Notion, Azure, etc.)
- Run headless browsers (Playwright)
- Use Docker containers
- Access package registries (npm, pip, etc.)

## What Copilot Can't Do

- Access arbitrary websites (firewall blocks by default)
- Run on macOS (Ubuntu or Windows only)
- Use OAuth-authenticated remote MCP servers
- Use MCP resources/prompts (only tools)

## Custom Agents

Files in `.github/agents/*.agent.md` are available both in VS Code and on GitHub. When assigning an Issue to Copilot, you can select which agent to use.

## MCP Servers

Configured in repo Settings → Copilot → Coding agent (not in files). The GitHub MCP server is built-in with read-only repo access. See `coding-agent-sandbox.md` for full details.

## Labels We Use

| Label | Meaning |
|---|---|
| `task` | Feature or improvement |
| `bug` | Something broken |
| `priority:high/medium/low` | Urgency |
| `size:XS/S/M/L/XL` | Effort estimate |
