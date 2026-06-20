---
name: refactor-agents-md
description: Refactor AGENTS.md or CLAUDE.md files to follow progressive disclosure principles by splitting monolithic docs into a minimal root file plus focused topic files. Use when user wants to reorganize, split, clean up, or improve their agent instructions file, or mentions progressive disclosure for project docs.
---

# Refactor Agents.md

Refactor a monolithic `AGENTS.md` / `CLAUDE.md` into a minimal root file plus focused topic files following progressive disclosure.

## 1. Find contradictions

Scan the full file for instructions that conflict with each other. Examples:
- "Use TypeScript strict mode" vs "Disable strict mode for faster builds"
- "Prefer functional components" vs "Use class components for state"
- "Run tests before every commit" vs "Skip tests in dev mode"

For each contradiction found, present it to the user and ask which version to keep. Do not proceed past this step until resolved.

## 2. Identify the essentials

Extract **only** what belongs in the root `AGENTS.md`. The root file should contain:

- One-sentence project description
- Package manager (if not npm)
- Non-standard build / typecheck / test commands
- Anything truly relevant to **every single task**

If an instruction only applies to some tasks, it belongs in a topic file, not the root.

## 3. Group the rest

Organize remaining instructions into logical categories. Common groupings:

- `coding-conventions.md` — TypeScript/JavaScript style, linting rules, naming conventions
- `testing-patterns.md` — Test frameworks, mocking rules, coverage requirements
- `api-design.md` — Endpoint conventions, serialization, validation patterns
- `git-workflow.md` — Branch naming, commit format, PR requirements
- `ui-patterns.md` — Component structure, styling rules, accessibility
- `database-patterns.md` — Query conventions, migration rules, ORM usage
- `deployment-ops.md` — CI/CD rules, environment config, monitoring

Keep groups focused. If a group exceeds ~100 lines, split it further.

## 4. Create the file structure

Output:

1. A minimal root `AGENTS.md` with:
   - The essentials from step 2
   - Markdown links to each topic file
2. Each separate topic file with its relevant instructions
3. A suggested folder structure (recommend `docs/` or `.agents/`)

Example root `AGENTS.md`:

```markdown
# Project Name

One-sentence description here.

## Quick commands
- Build: `pnpm build`
- Typecheck: `pnpm typecheck`
- Test: `pnpm test:unit`

## Topic guides
- [Coding conventions](docs/coding-conventions.md)
- [Testing patterns](docs/testing-patterns.md)
- [API design](docs/api-design.md)
```

## 5. Flag for deletion

Identify instructions that should be removed entirely:

- **Redundant** — things the agent already knows (e.g., "use async/await for promises", "imports go at the top of the file")
- **Too vague** — not actionable (e.g., "write performant code", "be careful with state")
- **Obvious** — universal best practices stated without project-specific nuance (e.g., "write clean code", "avoid bugs")

Present flagged items to the user as a checklist. Let them confirm deletion; do not delete without approval.

## Output format

Present the refactor as:

1. **Contradictions resolved** (or "None found")
2. **Proposed root AGENTS.md** (full content)
3. **Topic files** (full content, one per file)
4. **Flagged for deletion** (checklist, awaiting user approval)
5. **Suggested folder structure** (tree diagram)

Wait for user approval before writing any files to disk.
