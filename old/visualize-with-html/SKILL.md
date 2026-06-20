---
name: visualize-with-html
description: Transform plans, research, documentation, code analysis, or structured information into a self-contained HTML visualization optimized for understanding.
---

# Visualize with HTML

Convert information into an HTML page that is easier to understand than the original source.

## Goal

Help the reader understand:

- Structure
- Relationships
- Flow
- Decisions
- Dependencies
- Key takeaways

Prefer visual communication over prose.

## Process

### Understand

Identify:

- Entities
- Relationships
- Groupings
- Key insights

### Select visual patterns

Choose the most appropriate combination of:

- Flow diagrams
- Timelines
- Mind maps
- Hierarchies
- Architecture diagrams
- Dependency graphs
- Comparison tables
- Dashboards
- Summary cards

Refer to HTML-FORMAT.md for example layouts, scaffolds, and visualization patterns when useful.

### Generate

Create a single self-contained HTML document.

Use:

- Tailwind CSS
- Mermaid when useful
- Inline SVG when Mermaid is insufficient

### Design principles

- Visual first
- Minimal text
- Progressive disclosure
- Clear hierarchy
- Easy scanning
- Mobile friendly
- Dark mode support

### Success criteria

A reader should understand the content significantly faster than by reading the original document.

## Output

Write a single `.html` file. The calling agent handles file location, naming, and opening.
