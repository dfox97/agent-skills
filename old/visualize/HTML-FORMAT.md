# HTML Format

The visualization is a single self-contained HTML file. All styling comes from Tailwind CDN; all diagrams from Mermaid CDN or inline SVG. No external assets, no build step.

## Base Scaffold

```html
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <title>{{Title}} — Visual Summary</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <script src="https://cdn.tailwindcss.com"></script>
    <script type="module">
      import mermaid from "https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs";
      mermaid.initialize({ startOnLoad: true, theme: "neutral", securityLevel: "loose" });
    </script>
    <script>
      tailwind.config = {
        darkMode: 'class',
        theme: {
          extend: {
            fontFamily: {
              sans: ['Inter', 'system-ui', 'sans-serif'],
              serif: ['Georgia', 'Cambria', 'serif'],
              mono: ['JetBrains Mono', 'Fira Code', 'monospace'],
            }
          }
        }
      }
    </script>
    <style>
      @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap');
      .mermaid { background: transparent !important; }
      .node rect, .node circle, .node polygon { stroke-width: 1.5px; }
    </style>
  </head>
  <body class="bg-stone-50 text-slate-900 dark:bg-slate-950 dark:text-slate-100 font-sans">
    <main class="max-w-6xl mx-auto px-6 py-12 space-y-12">
      <header>...</header>
      <section id="overview">...</section>
      <section id="detail">...</section>
      <footer>...</footer>
    </main>
  </body>
</html>
```

## Header

Title, subtitle, date, and a compact legend if the visualization uses symbols. Keep it minimal — the content carries the weight.

```html
<header class="border-b border-slate-200 dark:border-slate-700 pb-6">
  <h1 class="text-3xl font-bold tracking-tight">{{Title}}</h1>
  <p class="mt-2 text-slate-600 dark:text-slate-400">{{Subtitle or date}}</p>
</header>
```

## Visual Patterns

### Flow / Timeline

Best for: processes, sequences, step-by-step research progression.

Use Mermaid `flowchart LR` or `flowchart TD` for horizontal/vertical flow. Style nodes with `classDef` to colour by status (e.g. `complete`, `pending`, `blocked`).

```html
<div class="rounded-xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900 p-6">
  <pre class="mermaid">
    flowchart LR
      A[Discovery] --> B[Analysis]
      B --> C[Synthesis]
      C --> D[Recommendations]
      classDef complete fill:#10b981,stroke:#059669,color:#fff
      classDef pending fill:#f59e0b,stroke:#d97706,color:#fff
      class A,B complete
      class C,D pending
  </pre>
</div>
```

### Hierarchy / Tree

Best for: decision trees, nested concepts, file structures.

Use Mermaid `flowchart TD` with nested subgraphs, or `mindmap` for radial hierarchy.

```html
<div class="rounded-xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900 p-6">
  <pre class="mermaid">
    mindmap
      root((System))
        Core
          Authentication
          Authorization
        Integration
          API Gateway
          Event Bus
        Storage
          Primary DB
          Cache Layer
  </pre>
</div>
```

### Comparison / Side-by-Side

Best for: before/after, option A vs B, trade-off matrices.

Hand-built HTML with a two-column layout. Use Mermaid inside each column if each side has internal structure.

```html
<div class="grid grid-cols-1 md:grid-cols-2 gap-6">
  <div class="rounded-xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900 p-6">
    <h3 class="text-sm font-semibold uppercase tracking-wider text-slate-500 mb-4">Before</h3>
    <!-- diagram or bullets -->
  </div>
  <div class="rounded-xl border border-emerald-200 dark:border-emerald-800 bg-emerald-50/50 dark:bg-emerald-950/20 p-6">
    <h3 class="text-sm font-semibold uppercase tracking-wider text-emerald-600 mb-4">After</h3>
    <!-- diagram or bullets -->
  </div>
</div>
```

### Network / Graph

Best for: dependency maps, relationship webs, ecosystem overviews.

Use Mermaid `flowchart` or `graph` with many nodes and styled edges. For dense graphs, add a filter or legend.

```html
<div class="rounded-xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900 p-6">
  <pre class="mermaid">
    flowchart LR
      A[Module X] --> B[Module Y]
      A --> C[Module Z]
      B --> D[Shared Lib]
      C --> D
      style D fill:#f1f5f9,stroke:#64748b
  </pre>
</div>
```

### Dashboard / Cards

Best for: triage results, checklist summaries, multi-faceted findings.

Grid of cards. Each card is a self-contained unit with a status badge, title, and 1–3 bullets.

```html
<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
  <article class="rounded-xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900 p-5">
    <div class="flex items-center gap-2 mb-3">
      <span class="px-2 py-1 text-xs font-medium rounded-full bg-emerald-100 text-emerald-700">Complete</span>
    </div>
    <h3 class="font-semibold mb-2">Finding title</h3>
    <ul class="text-sm text-slate-600 dark:text-slate-400 space-y-1">
      <li>Bullet one</li>
      <li>Bullet two</li>
    </ul>
  </article>
</div>
```

### Spatial / Map

Best for: architecture layouts, conceptual territories, domain boundaries.

Hand-built with absolute-positioned divs over a relative container, or inline SVG. Use Mermaid only if the layout is strictly graph-shaped.

```html
<div class="relative rounded-xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900 p-6 min-h-[400px]">
  <!-- Territory boxes positioned absolutely or via CSS grid -->
  <div class="absolute top-4 left-4 p-3 rounded-lg border border-slate-300 bg-slate-50">
    Domain A
  </div>
  <div class="absolute top-4 right-4 p-3 rounded-lg border border-slate-300 bg-slate-50">
    Domain B
  </div>
  <!-- Connector SVG -->
  <svg class="absolute inset-0 w-full h-full pointer-events-none">
    <line x1="20%" y1="20%" x2="80%" y2="20%" stroke="#94a3b8" stroke-dasharray="4 4" />
  </svg>
</div>
```

## Detail Sections

After the primary visual, add depth:

- **Key findings** — 3–5 bullets, each ≤12 words.
- **Sources / References** — monospaced file paths or URLs, one per line.
- **Open questions** — if the research has gaps, list them as an amber-tinted box.

```html
<section id="findings" class="space-y-4">
  <h2 class="text-xl font-semibold">Key Findings</h2>
  <ul class="space-y-2">
    <li class="flex items-start gap-3">
      <span class="mt-1.5 w-1.5 h-1.5 rounded-full bg-emerald-500 shrink-0"></span>
      <span>Finding text here, concise and specific.</span>
    </li>
  </ul>
</section>
```

## Style Guidance

- **Editorial, not corporate.** Generous whitespace. Rounded corners (`rounded-xl`). Subtle borders.
- **Colour sparingly.** One accent (emerald, indigo, or amber) plus red for problems/risks and slate for neutrals.
- **Typography.** Sans-serif for everything except optional serif headings. `text-xs uppercase tracking-wider` for labels inside diagrams.
- **Dark mode.** Use `dark:` Tailwind prefixes everywhere. The base scaffold sets `darkMode: 'class'` — add `<html class="dark">` or a toggle if desired.
- **Mermaid theming.** Use `theme: "neutral"` or `"dark"` depending on the page mode. Override with `classDef` for specific nodes.
- **No raw paragraphs as content.** If a section is text-heavy, break it into cards, bullets, or a table.

## Footer

Optional. A single line: source, generation date, or "Generated by Claude Code — Visualize skill".

```html
<footer class="border-t border-slate-200 dark:border-slate-700 pt-6 text-sm text-slate-500">
  Generated {{date}} from {{source description}}
</footer>
```
