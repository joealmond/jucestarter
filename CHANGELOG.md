# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added
- `docs/autodocs/` — separated autodocs template reference docs from project docs (mirroring joealmond/autodocs PR #2)
- `docs/autodocs/README.md` — explains the separation between template docs and project docs
- `build.ps1` — one-command PowerShell build script for Windows (`build.ps1`, `build.ps1 test`, `build.ps1 release`, `build.ps1 clean`) mirroring `build.sh`
- `build.ps1` auto-detects Visual Studio's bundled CMake, Ninja, and MSVC compiler via `vswhere.exe` + `vcvarsall.bat` — no manual PATH setup required
- `build.ps1` gracefully handles VST3 copy-after-build permission errors (needs admin to install to Program Files)
- `docs/know-how/windows-toolchain-path.md` — explains Windows PATH issues, MSVC environment setup, CMake 4.x Ninja bug, and VST3 permissions
- `docs/know-how/aax-plugin-support.md` — comprehensive AAX (Pro Tools) support guide covering SDK setup, CMake config, PACE signing, CI integration, and licensing
- AAX guide link in README Documentation section

### Changed
- Moved 4 autodocs template know-how files from `docs/know-how/` → `docs/autodocs/know-how/` (`coding-agent-sandbox.md`, `github-issues-workflow.md`, `instruction-files.md`, `working-with-libraries.md`)
- `docs/know-how/README.md` — clarified as project-specific, added pointer to autodocs reference
- `AGENTS.md` — updated context-gathering list, "Where Things Live" table, and project structure to include `docs/autodocs/`
- `README-Autodocs.md` — updated structure diagram with `docs/autodocs/` directory
- `.github/skills/onboard/SKILL.md` — added `docs/autodocs/` to context-gathering steps
- `build.ps1` uses "Ninja Multi-Config" generator — CMake 4.x (bundled with VS 2022) has a bug with the single-config Ninja generator that puts unresolved `$BuildType` variables in rule names
- `.vscode/settings.json` — switched generator to "Ninja Multi-Config" and `CMAKE_DEFAULT_BUILD_TYPE` for CMake 4.x compatibility
- `README.md` — added Windows build commands (build.ps1) alongside macOS/Linux, Windows standalone run command, updated project structure and useful commands
- `docs/tech-stack.md` — added Windows VS Code extensions, build.ps1 commands, and Windows standalone run command

### Added

**Beginner-Friendly Template**
- `README.md` — complete rewrite with 5-minute quickstart, platform-specific setup (collapsible), customization table, project structure map, and useful commands reference
- `build.sh` — one-command build script (`./build.sh`, `./build.sh test`, `./build.sh release`, `./build.sh clean`) with dependency checking and submodule auto-init
- `.vscode/settings.json` — pre-configured CMake Tools integration (auto-configure, Ninja generator, IntelliSense, search exclusions for build/submodule dirs)
- `.vscode/extensions.json` — recommended extensions prompt (CMake Tools, C/C++)

**Agents**
- `.github/agents/audio-dev.agent.md` — audio DSP development specialist agent

**Skills**
- `.github/skills/build/` — build the plugin locally (configure, compile, test)
- `.github/skills/add-dsp/` — add DSP processing to the plugin with JUCE patterns
- `.github/skills/add-parameter/` — add automatable parameters using APVTS
- `.github/skills/extend-agent/` — self-improve agentic capabilities

**Prompts**
- `.github/prompts/build.prompt.md` — `/build` slash command
- `.github/prompts/extend-agent.prompt.md` — `/extend-agent` slash command

**Instructions**
- `.github/instructions/cmake.instructions.md` — auto-applied CMake file rules
- `.github/instructions/juce-cpp.instructions.md` — auto-applied JUCE C++ source rules

**Knowledge Base**
- `docs/tech-stack.md` — complete tech stack with JUCE, CMake, C++23 versions and doc links
- `docs/know-how/pamplejuce-build-system.md` — Pamplejuce build system architecture
- `docs/know-how/juce-plugin-architecture.md` — JUCE plugin patterns and real-time rules

### Changed
- `AGENTS.md` — added JUCE/Pamplejuce context, project structure, audio domain rules, and self-improvement section reminding LLMs to extend their own capabilities through agents, skills, prompts, and instructions
- `docs/tech-stack.md` — added "Initial Setup by Platform" section with per-OS prerequisites (macOS, Windows, Linux), VS Code extensions, and standalone launch command
- `CMakeLists.txt` — reorganized with clear boxed customization section at top, simplified verbose comments, removed redundant "Change me!" markers, added section headers

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
