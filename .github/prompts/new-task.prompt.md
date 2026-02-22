---
name: new-task
description: "Draft a new GitHub Issue for task tracking"
agent: planner
tools: ['read', 'editFiles', 'search']
---

Help the user create a well-scoped GitHub Issue.

## Steps

1. Ask the user: what needs to be done and why?
2. Gather context so the issue is informed, not generic:
   - Read `CHANGELOG.md` — avoid duplicating recent work
   - Read `ROADMAP.md` — check alignment with planned direction
3. Draft the issue in this format:

```markdown
## Title: [action-oriented title]

**Labels:** `priority:high|medium|low`, `size:XS|S|M|L|XL`

### What
What needs to be done.

### Why
Why this matters.

### Done When
- [ ] Acceptance criterion 1
- [ ] Acceptance criterion 2
- [ ] CHANGELOG.md updated

### Notes
Any extra context.
```

5. Present the draft and ask the user to create it on GitHub
6. If the task is assignable to Copilot coding agent, note that in the output

## Rules

- Title should be short and action-oriented (e.g., "Add user auth", "Fix map zoom")
- Every issue MUST have at least 2 acceptance criteria
- If the task is XL, suggest breaking it into smaller issues
- Issues for Copilot should read like clear prompts with explicit file hints
