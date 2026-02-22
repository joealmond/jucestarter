---
name: Changelog Standards
description: Formatting rules for CHANGELOG entries — the project's universal history
applyTo: '**/CHANGELOG*'
---

# Changelog Standards

When editing `CHANGELOG.md`:

## Entry Format

```markdown
## [Unreleased]

### Added
- Short description of what was added

### Changed
- Short description of what changed

### Fixed
- Short description of what was fixed

### Removed
- Short description of what was removed
```

## Rules

- Group entries under: **Added**, **Changed**, **Fixed**, **Removed**
- Each entry is ONE line — a brief, clear summary (not a paragraph)
- Use past tense: "Added X" not "Add X"
- Reference GitHub Issues when applicable: `Closes #42`
- Newest entries go at the top, under `## [Unreleased]`
- When releasing, move unreleased entries under a version heading: `## [1.2.0] — YYYY-MM-DD`
- Never delete old entries — the changelog is append-only history
- If unsure whether a change deserves an entry: it does. Err on the side of documenting.
