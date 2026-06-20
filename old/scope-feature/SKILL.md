---
name: scope-feature
description: Scope a feature request against the existing codebase — explore the relevant implementation, assess complexity, identify decision points, and produce a scoping table. Use when the user describes a feature idea and wants to know how hard it is, what needs to change, or whether an approach is viable.
---

The user has described a feature or change they are considering. Your job is to scope it: explore the codebase to understand the current implementation, then assess what needs to change, flag genuine risks, and summarise the result clearly.

## Steps

1. **Explore first.** Spawn an Explore agent (search breadth: very thorough) targeting the relevant area. Find:
   - The current implementation of the behaviour being changed
   - Any blocking/guard logic that would need to be modified
   - All entry points (drag, paste, click, etc.) that would need the same change
   - Any analogous already-implemented paths you can reuse or follow as a model

2. **Identify decision points.** For each part of the request where multiple approaches exist (the user may have already listed ideas), assess each option:
   - What code changes it requires
   - Whether it reuses existing patterns or needs new infrastructure
   - Any structural risks (tree invariants, validation errors, permission edge cases)

3. **Produce a scoping table.** Columns: Case | Change needed | Complexity (None / Low / Medium / High). One row per distinct scenario. Be specific about file/service names where you know them.

4. **Give a bottom line.** One short paragraph: what the minimal viable path is, what to defer, and any one genuine risk worth investigating before committing.

## Principles

- Prefer reusing existing patterns over new infrastructure.
- Call out UX/product decisions that haven't been made yet — don't resolve them yourself.
- If a risk requires investigation (e.g. backend invariant violation), say so explicitly rather than guessing.
- Keep the scoping table tight — if two cases reduce to the same code change, merge them.
