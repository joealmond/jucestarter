# Copilot Coding Agent — Sandbox Capabilities

> What the GitHub Copilot coding agent can (and can't) do in its sandbox environment.

*Last updated: 2026-02-21*

## Environment

The coding agent runs in an **ephemeral GitHub Actions runner** (Ubuntu x64 or Windows 64-bit). You customize it via `.github/workflows/copilot-setup-steps.yml`.

## Capabilities

| Capability | Available? | Details |
|---|---|---|
| **MCP Servers** | Yes | Configure in repo Settings → Copilot → Coding agent. Supports local (stdio), HTTP, and SSE servers. |
| **GitHub MCP** | Built-in | Read-only access to current repo by default. Expand with a PAT for cross-repo access. |
| **Internet** | Limited | Firewall on by default. Allowlists package registries, container registries, OS repos, certificate authorities. |
| **Playwright** | Yes | Firewall allowlist includes browser download hosts. Install via `copilot-setup-steps.yml`. |
| **Headless browser** | Yes | Headless Chromium via Playwright works. No display server — no visual browser. |
| **Terminal / Bash** | Yes | Full bash — run tests, linters, builds, arbitrary commands. |
| **Docker** | Yes | Can run containers (e.g. Notion MCP uses `docker run`). |
| **Secrets** | Yes | Via `copilot` environment in repo Settings. Prefix with `COPILOT_MCP_`. |
| **Custom runners** | Yes | Larger GitHub-hosted or self-hosted (ARC). |

## Key Limitations

- **Firewall does NOT apply to MCP servers** — they bypass it
- **No OAuth-authenticated remote MCPs** yet
- **No macOS runners** — Ubuntu or Windows only
- **Only MCP tools** supported — not MCP resources or prompts
- Arbitrary websites blocked unless allowlisted or firewall disabled

## Configuring MCP Servers

MCP is configured as JSON in repo settings (Settings → Copilot → Coding agent), not in files:

```json
{
  "mcpServers": {
    "sentry": {
      "type": "local",
      "command": "npx",
      "args": ["@sentry/mcp-server@latest"],
      "tools": ["get_issue_details", "get_issue_summary"],
      "env": {
        "SENTRY_ACCESS_TOKEN": "COPILOT_MCP_SENTRY_ACCESS_TOKEN"
      }
    }
  }
}
```

Secrets referenced in `env` must be added to the `copilot` environment (Settings → Environments → copilot) with names prefixed `COPILOT_MCP_`.

## Firewall — Adding Domains to the Allowlist

By default, the firewall blocks outbound traffic except to known package registries and GitHub hosts. To allow additional domains:

1. Go to **Settings → Copilot → Coding agent**
2. Click **Custom allowlist**
3. Add entries — two formats supported:
   - **Domain**: `packages.contoso.corp` — allows traffic to this domain and all subdomains
   - **URL**: `https://api.example.com/v1/` — allows only this scheme, host, and path (+ descendant paths)
4. Click **Add Rule**, then **Save changes**

Example entries:
```
api.mycompany.com              → allows api.mycompany.com + *.api.mycompany.com
https://registry.npmjs.org/    → allows only HTTPS to this specific path
```

### Disabling the Firewall Entirely

Settings → Copilot → Coding agent → toggle **Enable firewall** off.

> **Warning:** Disabling the firewall allows Copilot to connect to any host, increasing exfiltration risk.

### Recommended Allowlist

Enabled by default. Covers:
- OS package repos (Debian, Ubuntu, Red Hat)
- Container registries (Docker Hub, ACR, ECR)
- Language package registries (npm, PyPI, crates.io, Maven, etc.)
- Certificate authorities
- Playwright browser download hosts

You can disable the recommended allowlist separately while keeping your custom allowlist.

## Setup Steps Example

```yaml
# .github/workflows/copilot-setup-steps.yml
name: "Copilot Setup Steps"
on:
  workflow_dispatch:
  push:
    paths:
      - .github/workflows/copilot-setup-steps.yml

jobs:
  copilot-setup-steps:
    runs-on: ubuntu-latest
    permissions:
      contents: read
    steps:
      - uses: actions/checkout@v5
      - uses: actions/setup-node@v4
        with:
          node-version: "20"
          cache: "npm"
      - run: npm ci
```

## References

- [Customizing the development environment](https://docs.github.com/en/copilot/customizing-copilot/customizing-the-development-environment-for-copilot-coding-agent)
- [Extending coding agent with MCP](https://docs.github.com/en/copilot/customizing-copilot/extending-copilot-coding-agent-with-mcp)
- [Customizing the firewall](https://docs.github.com/en/copilot/customizing-copilot/customizing-or-disabling-the-firewall-for-copilot-coding-agent)
