---
name: visualize
description: Create a self-contained HTML visualization of any document, research findings, documentation, or structured information. Use when the user wants to "visualize this", create a visual summary, make a diagram of findings, or render research into an explorable page.
---

# Visualize

Turn any document, research, or structured information into a **self-contained HTML visualization** — explorable, shareable, and readable without extra tooling.

## When to use

- User says "visualize this", "make a diagram of this", "can you render that as a page?"
- Summarizing research, findings, documentation, comparisons, or decision trees.
- Any situation where a static wall of text is harder to parse than a spatial layout.

## Output

A single `.html` file written to the OS temp directory (resolve from `$TMPDIR`, fall back to `/tmp`, or `%TEMP%` on Windows). Name it `<tmpdir>/visualize-<topic>-<timestamp>.html` so each run is unique. Open it automatically — `xdg-open <path>` on Linux, `open <path>` on macOS, `start <path>` on Windows — and tell the user the absolute path.

The file is **self-contained**: Tailwind CSS via CDN, Mermaid via CDN, all data inline. No build step, no server, no dependencies.

## Process

### 1. Understand the content

Read whatever the user is referring to — a document, research notes, findings, code analysis, ADRs, issue triage results, etc. Identify:

- **Entities** — the nouns: concepts, systems, decisions, files, people, stages.
- **Relationships** — how entities connect: hierarchy, flow, dependency, sequence, comparison.
- **Groupings** — which entities belong together by theme, phase, priority, or ownership.
- **Key takeaways** — the 1–3 things the reader should leave with.

### 2. Choose a visual pattern

Pick the pattern that matches the shape of the information. See [HTML-FORMAT.md](HTML-FORMAT.md) for full scaffolds and examples.

| Pattern | Best for |
|---------|----------|
| **Flow / timeline** | Processes, sequences, historical progression, step-by-step findings |
| **Hierarchy / tree** | Decision trees, org charts, file structures, nested concepts |
| **Comparison / side-by-side** | Before/after, option A vs B, trade-off matrices |
| **Network / graph** | Dependency maps, relationship webs, ecosystem overviews |
| **Dashboard / cards** | Triage results, checklist summaries, multi-faceted findings |
| **Spatial / map** | Architecture layouts, conceptual territories, domain boundaries |

Mix patterns if the content has multiple layers. A research summary might lead with a network diagram and follow with card-deep dives.

### 3. Build the HTML

Use the scaffold in [HTML-FORMAT.md](HTML-FORMAT.md). Rules:

- **Tailwind CDN** for all layout and styling.
- **Mermaid CDN** for graph-shaped diagrams (flowcharts, sequences, mind maps, timelines).
- **Hand-built HTML/SVG** for editorial visuals that Mermaid can't render cleanly (custom layouts, mass diagrams, cross-sections, styled cards).
- **All data inline** — no external files, no fetch calls.
- **Dark mode support** — respect `prefers-color-scheme: dark` with a small toggle or automatic switch.

### 4. Present

Write the file, open it, and report the absolute path. Keep the chat response brief — the HTML is the deliverable.

If the user wants changes, edit the same file and re-open it. Don't create numbered versions unless asked.

## Constraints

- One file only. No folder of assets.
- No interactivity beyond Mermaid's native rendering and simple CSS toggles (accordion, tab switch, dark mode).
- No prose walls. If a section needs a paragraph, consider whether a diagram or bullet card replaces it.
- Source references are fine if the content comes from specific files — link them as monospaced file paths.
