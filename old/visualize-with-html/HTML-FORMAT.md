# HTML Format

Single self-contained HTML file. Tailwind CSS via CDN, Mermaid via CDN or inline SVG. No external assets.

## Base Scaffold

```html
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <title>{{Title}}</title>
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
              mono: ['JetBrains Mono', 'Fira Code', 'monospace'],
            }
          }
        }
      }
    </script>
    <style>
      @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap');
      .mermaid { background: transparent !important; }
    </style>
  </head>
  <body class="bg-stone-50 text-slate-900 dark:bg-slate-950 dark:text-slate-100 font-sans">
    <main class="max-w-6xl mx-auto px-6 py-12 space-y-12">
      <!-- Content here -->
    </main>
  </body>
</html>
```

## Visual Patterns

### Flow / Timeline

Best for: processes, sequences, workflows, step-by-step progression.

Suggested: Mermaid flowchart LR or TD, timeline with classDef for status coloring.

```html
<div class="rounded-xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900 p-6">
  <pre class="mermaid">
    flowchart LR
      A[Step 1] --> B[Step 2]
      B --> C[Step 3]
      classDef complete fill:#10b981,stroke:#059669,color:#fff
      classDef pending fill:#f59e0b,stroke:#d97706,color:#fff
      class A,B complete
      class C pending
  </pre>
</div>
```

### Hierarchy / Tree

Best for: file structures, decision trees, nested concepts, org charts.

Suggested: Mermaid mindmap or flowchart TD with subgraphs.

```html
<div class="rounded-xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900 p-6">
  <pre class="mermaid">
    mindmap
      root((System))
        Core
          Auth
          API
        Storage
          DB
          Cache
  </pre>
</div>
```

### Comparison / Side-by-Side

Best for: before vs after, alternatives, trade-offs.

Suggested: Two-column grid layout.

```html
<div class="grid grid-cols-1 md:grid-cols-2 gap-6">
  <div class="rounded-xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900 p-6">
    <h3 class="text-sm font-semibold uppercase tracking-wider text-slate-500 mb-4">Before</h3>
    <!-- Content -->
  </div>
  <div class="rounded-xl border border-emerald-200 dark:border-emerald-800 bg-emerald-50/50 dark:bg-emerald-950/20 p-6">
    <h3 class="text-sm font-semibold uppercase tracking-wider text-emerald-600 mb-4">After</h3>
    <!-- Content -->
  </div>
</div>
```

### Network / Graph

Best for: dependencies, relationships, ecosystem overviews.

Suggested: Mermaid flowchart with styled edges.

```html
<div class="rounded-xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900 p-6">
  <pre class="mermaid">
    flowchart LR
      A[Module X] --> B[Module Y]
      A --> C[Module Z]
      B --> D[Shared Lib]
      C --> D
  </pre>
</div>
```

### Dashboard / Cards

Best for: findings, summaries, status reports, triage results.

Suggested: Card grid with status badges.

```html
<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
  <article class="rounded-xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900 p-5">
    <div class="flex items-center gap-2 mb-3">
      <span class="px-2 py-1 text-xs font-medium rounded-full bg-emerald-100 text-emerald-700">Status</span>
    </div>
    <h3 class="font-semibold mb-2">Title</h3>
    <ul class="text-sm text-slate-600 dark:text-slate-400 space-y-1">
      <li>Point one</li>
    </ul>
  </article>
</div>
```

### Spatial / Map

Best for: architecture, domains, bounded contexts.

Suggested: CSS grid or positioned layout with SVG connectors.

```html
<div class="relative rounded-xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900 p-6 min-h-[400px]">
  <div class="absolute top-4 left-4 p-3 rounded-lg border border-slate-300 bg-slate-50">
    Domain A
  </div>
  <div class="absolute top-4 right-4 p-3 rounded-lg border border-slate-300 bg-slate-50">
    Domain B
  </div>
  <svg class="absolute inset-0 w-full h-full pointer-events-none">
    <line x1="20%" y1="20%" x2="80%" y2="20%" stroke="#94a3b8" stroke-dasharray="4 4" />
  </svg>
</div>
```
