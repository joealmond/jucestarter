# Project Rules

> These rules apply to ALL AI agents working on this project.

## Why Context Matters

AI agents have no memory between sessions. Without context, every conversation starts from zero — leading to repeated mistakes, contradictory decisions, and wasted effort.

Before working on any task, **gather context first** so you can serve the user's intent meaningfully:

1. `CHANGELOG.md` — what happened recently, what was already tried
2. `docs/know-how/` — past lessons that prevent re-learning the hard way
3. `docs/architecture/` — design constraints that shouldn't be violated
4. `docs/tech-stack.md` — installed versions and doc links, so you don't guess APIs
5. `ROADMAP.md` — future direction, so your work aligns with it
6. GitHub Issues — the current task backlog and priorities

**Never assume library APIs.** Your training data may be outdated. Always check the official docs for the installed version — see `docs/tech-stack.md` for links. When unsure about anything, ask the user rather than guessing.

This context is what makes the difference between a useful response and a generic one.

## Where Things Live

| What | Where | Why |
|------|-------|-----|
| Rules | `AGENTS.md` | The single rulebook — read it before doing anything |
| Tasks | GitHub Issues | Single source of truth, assignable to humans or Copilot |
| History | `CHANGELOG.md` | Universal bridge — readable by all agents, local and remote |
| Knowledge | `docs/know-how/` | Prevents repeating mistakes across sessions |
| Architecture | `docs/architecture/` | Design constraints that outlive any single task |
| Tech Stack | `docs/tech-stack.md` | Installed versions + doc links — prevents version mismatch bugs |
| Future | `ROADMAP.md` | Non-actionable ideas — so agents don't work against the vision |

## This Is a JUCE Audio Plugin (Pamplejuce Template)

This project is a **C++23 JUCE audio plugin** based on the [Pamplejuce](https://melatonin.dev/manuals/pamplejuce/) template. Key facts:

- **Framework:** JUCE (develop branch, git submodule)
- **Build system:** CMake 3.25+ with modular helpers in `cmake/` (submodule: `sudara/cmake-includes`)
- **Plugin formats:** VST3, AU, AUv3, CLAP, Standalone
- **Source:** `source/PluginProcessor.cpp` (audio/DSP) + `source/PluginEditor.cpp` (GUI)
- **Testing:** Catch2 (via CPM) + pluginval in CI
- **CI/CD:** GitHub Actions — builds on macOS, Windows, Linux with sccache
- **Submodules:** JUCE, cmake-includes, clap-juce-extensions, melatonin_inspector
- **Init:** `git submodule update --init --recursive` (recursive is required for CLAP)

Read `docs/tech-stack.md` for full details, build commands, and doc links.
Read `docs/know-how/pamplejuce-build-system.md` and `docs/know-how/juce-plugin-architecture.md` for critical patterns.

## Project Structure

```
.github/
  agents/           — AI personas (planner, coder, reviewer, audio-dev)
  prompts/          — Slash commands (/new-task, /done, /build, /extend-agent)
  instructions/     — File-pattern rules (auto-applied by glob: changelog, docs, cmake, juce-cpp)
  hooks/            — Lifecycle automation (stop → check docs)
  skills/           — Portable skills (learn, adr, onboard, build, add-dsp, add-parameter, extend-agent)
  ISSUE_TEMPLATE/   — GitHub Issue templates (task, bug)
source/             — Plugin source code (PluginProcessor + PluginEditor)
JUCE/               — JUCE framework (git submodule, develop branch)
modules/            — External modules (clap-juce-extensions, melatonin_inspector)
cmake/              — CMake helpers (git submodule: sudara/cmake-includes)
tests/              — Catch2 tests
benchmarks/         — Catch2 benchmarks
packaging/          — Installers, code signing, icons
docs/
  architecture/     — ADRs (Architecture Decision Records)
  know-how/         — Learned knowledge (grows over time)
  tech-stack.md     — Installed versions + doc links + build commands
CHANGELOG.md        — Universal history bridge (repo root)
AGENTS.md           — All project rules (this file)
VERSION             — Semver version (read by CMake)
```

## Core Workflow

1. **Before coding**, read `CHANGELOG.md` for recent history and `ROADMAP.md` for direction.
2. **After coding**, update `CHANGELOG.md` with what changed.
3. **Tasks live in GitHub Issues** — not local files. Issues are the single source of truth.

## History Bridge (Local ↔ GitHub)

Both local VS Code agents and GitHub's sandboxed coding agent need full project history.

- **`CHANGELOG.md`** is committed to the repo — every agent can read it. This is the universal history.
- **Local agents** (VS Code): read `CHANGELOG.md` for history. Use the GitHub MCP server to browse Issues + PRs when you need task context.
- **GitHub coding agent** (sandboxed): reads `CHANGELOG.md` in the repo for history. The Issue assigned to you IS your task context. Use the GitHub MCP server (enabled by default) to browse related Issues + PRs.
- **When in doubt**, read `CHANGELOG.md` first — it has the full story.

## Documentation Rules

- Every code change MUST have a matching CHANGELOG entry.
- Architecture decisions go in `docs/architecture/` using the ADR template.
- Lessons learned go in `docs/know-how/` as short, focused files.
- Keep docs concise. One idea per file. No walls of text.

## Code Standards

- Follow existing patterns in the codebase.
- Prefer explicit over clever.
- Handle errors gracefully.
- No hardcoded secrets.

## Technology & External Libraries

AI training data goes stale. Library APIs change between versions. **Never assume — verify.**

- **Check docs online** before using any non-trivial library API. Fetch the official docs for the installed version — don't rely on memory or training data.
- **Ask, don't guess.** If unsure about user intent, requirements, or a technical decision — ask a clarifying question. A wrong assumption costs more than a quick question.
- **Read `docs/tech-stack.md`** (if it exists) for installed versions and doc links before writing code.
- **Don't add dependencies** without checking: bundle size impact, version compatibility with existing stack, and whether a simpler solution exists.
- **Record quirks.** When you discover a version-specific gotcha or workaround, add a know-how entry in `docs/know-how/` so future sessions don't repeat the discovery.
- **Pin for a reason.** If a dependency must be pinned to a specific version, document why in `docs/tech-stack.md`.

## File Naming

- ADRs: `ADR-NNN-title.md` (e.g., `ADR-001-use-convex.md`)
- Know-how: `topic-name.md` (e.g., `tanstack-ssr-gotchas.md`)

## What NOT To Do

- Don't guess architecture — read existing docs first.
- Don't assume library APIs — check the official docs for the installed version.
- Don't add dependencies without checking bundle size and compatibility.
- Don't create giant files — split at 200 lines.
- Don't skip tests when they exist.
- Don't duplicate task tracking — use GitHub Issues, not local files.
- Don't allocate or lock inside `processBlock()` — it's a real-time audio thread.
- Don't change parameter IDs after release — it breaks user presets.

## Self-Improvement — Extend Your Own Capabilities

**When you discover gaps in your skills, prompts, instructions, or know-how — fix them.**

AI agents should actively improve the project's agentic infrastructure. After completing tasks, consider:

- **Did you learn something non-obvious?** → Add a `docs/know-how/` entry (use the `learn` skill)
- **Is there a repeatable workflow you just did?** → Create a new skill in `.github/skills/`
- **Would a slash command help the user next time?** → Add a prompt in `.github/prompts/`
- **Are there file-specific rules worth encoding?** → Add an instruction in `.github/instructions/`
- **Does a new domain need a specialist?** → Add an agent persona in `.github/agents/`
- **Should a universal rule change?** → Update this file (`AGENTS.md`)

Use the `extend-agent` skill (`.github/skills/extend-agent/SKILL.md`) for guidance on what to create and where.

**The goal: every session should leave the project smarter for the next session.**

## Audio Plugin Domain Rules

These rules are specific to this JUCE audio plugin project:

- **Read `docs/tech-stack.md`** before any build or code change — it has build commands, versions, and links.
- **Read `docs/know-how/juce-plugin-architecture.md`** before modifying PluginProcessor or PluginEditor.
- **`processBlock()` is sacred** — real-time safe only. No allocations, locks, I/O, or exceptions.
- **Use APVTS** (AudioProcessorValueTreeState) for all user-facing parameters.
- **Parameter IDs are forever** — never rename them after a plugin has been released.
- **Use `juce::SmoothedValue`** for any parameter that controls audio to prevent clicks.
- **SharedCode is INTERFACE** — link new modules to it (not the plugin target directly).
- **Submodules need recursive init** — `git submodule update --init --recursive`.
- **JUCE docs:** https://docs.juce.com/master/ — always verify APIs against actual docs.
- **Pamplejuce manual:** https://melatonin.dev/manuals/pamplejuce/ — build system and CI reference.

