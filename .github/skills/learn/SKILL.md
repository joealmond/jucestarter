---
name: learn
description: Save a lesson learned or important discovery to the project's know-how knowledge base. Use when something non-obvious was discovered, a version-specific gotcha was found, or a common approach didn't work. Creates a focused entry in docs/know-how/ so future sessions don't repeat the same mistakes.
---

# Learn — Save a Lesson to Know-How

## When to Use

- You discovered a non-obvious gotcha or workaround
- A library behaved differently than expected (version-specific)
- A common approach didn't work in this project
- Something would save a future developer (or AI) time

## Steps

1. Ask the user: "What did you learn? Give me a short title and the key insight."
2. Create a file in `docs/know-how/` named `kebab-case-title.md`
3. Use the [template](./template.md) format
4. If it's about a specific technology, prefix the filename (e.g., `convex-aggregate-counts.md`)

## Rules

- Keep it short — max 30 lines
- One lesson per file
- Focus on the "why" not just the "what"
- Include the date so we know when it was relevant
- If it involves a library version, note the version explicitly
