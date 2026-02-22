---
name: done
description: "Record completed work in the CHANGELOG"
agent: coder
tools: ['read', 'editFiles', 'search']
---

Record completed work by updating the changelog. This is how future AI sessions (and humans) will know what happened.

## Steps

1. Ask the user: "What did you just finish?"
2. Read `CHANGELOG.md` to see the current state and avoid duplicate entries
3. Append an entry under `## [Unreleased]` with:
   - The date
   - The type (Added, Changed, Fixed, Removed, Improved)
   - A brief summary of what was completed
   - Reference to the GitHub Issue if applicable (e.g., `Closes #42`)
4. If a lesson was learned, suggest using the `learn` skill to capture it

## Changelog Entry Format

```markdown
### [type]: title (YYYY-MM-DD)
Brief description of what was done.
Closes #NN (if applicable)
```

Where type is one of: Added, Changed, Fixed, Removed, Improved
