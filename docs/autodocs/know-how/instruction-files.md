# Instruction Files

**Learned:** 2026-02-22
**Context:** Exploring how to give agents context-specific rules

## What They Are

Files in `.github/instructions/*.instructions.md` auto-apply when the agent works on files matching an `applyTo` glob pattern. The agent gains that knowledge only when editing matching files.

> **Not the same as Agent Skills.** Instruction files are always-on for matching paths. Agent Skills (`.github/skills/<name>/SKILL.md`) are portable, on-demand, and can include resource files. Use instruction files for path-specific rules; use skills for reusable workflows.

## Format

```yaml
---
name: Documentation Standards
description: Rules for writing and maintaining project documentation
applyTo: 'docs/**'
---
```

The body is plain markdown with rules, patterns, or conventions.

## When To Create One

Create an instruction file when you have **file-pattern-specific rules** that:
- Apply only to a subset of files (not project-wide — those go in `AGENTS.md`)
- Would clutter `AGENTS.md` if included there
- Are detailed enough to need their own document (e.g., styling conventions, testing patterns, backend rules)

## Good Candidates

| File | Glob | Purpose |
|------|------|---------|
| `docs.instructions.md` | `docs/**` | Documentation standards |
| `tests.instructions.md` | `**/*.test.*` | Testing conventions, mocking patterns |
| `styles.instructions.md` | `**/*.css` | CSS/styling rules, design tokens |
| `backend.instructions.md` | `server/**` or `convex/**` | Backend patterns, auth rules |
| `components.instructions.md` | `src/components/**` | Component patterns, prop conventions |

## Key Takeaway

Use instruction files for rules that are too specific for `AGENTS.md` but too important to leave undocumented. One file per concern, matched by glob.
