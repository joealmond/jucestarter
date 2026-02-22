# Working with External Libraries

**Learned:** 2026-02-21
**Context:** AI agents frequently guess API signatures from training data, causing version mismatch bugs

## The Problem

AI agents are trained on older library versions. When the project uses newer (or bleeding-edge) versions, the agent confidently writes code using **deprecated or non-existent APIs**. This silently compiles sometimes but fails at runtime, or causes subtle bugs that waste hours.

Common failure modes:
- Using a removed config option (e.g., Tailwind v3 syntax in a v4 project)
- Calling an API that changed its signature between major versions
- Assuming a default behavior that was changed in a new release
- Mixing patterns from different framework versions (e.g., React 18 vs 19)

## The Solution

### 1. Maintain a Tech Stack Reference

Keep a `docs/tech-stack.md` file (use the template in `templates/tech-stack.md`) listing every major dependency with its **exact version** and a link to the **correct version's docs**. Agents read this before writing code.

### 2. Check Docs Online Before Writing Code

When working with any library:
- **Look up the official docs** for the installed version — don't rely on memory
- If the version is very recent, fetch the docs page to verify API signatures
- If you find a discrepancy between your knowledge and the docs, trust the docs

### 3. Record Library Quirks in Know-How

When you discover a version-specific gotcha:
- Add a know-how entry: `docs/know-how/{lib}-{topic}.md`
- Include the version it applies to, the wrong approach, and the right one
- Example: `convex-aggregate-counts.md`, `tailwind-v4-dark-mode.md`

### 4. Document Known Issues

When a library has a bug or incompatibility:
- Add a section in `docs/know-how/` or the tech stack doc
- Include: problem, affected versions, workaround, upstream issue link
- Update when the issue is resolved upstream

## Key Takeaway

Never trust training data for API details — always verify against the installed version's official docs. One wrong assumption costs more time than one web search.
