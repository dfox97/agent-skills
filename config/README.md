# Portable agent configuration

This directory contains configuration that is safe to share. Runtime state such as credentials, sessions, caches, and trust decisions belongs in each sandbox or Docker volume and must not be committed.

- `shared/AGENTS.md` — instructions shared by all harnesses.
- `claude/settings.json` — Claude Code user settings.
- `claude/statusline-command.sh` — the status line.
- `claude/hooks/` — optional hooks, not wired by default.
  See [`claude/README.md`](claude/README.md) for what is included, what is excluded, and how to
  install it all on another machine.
- `codex/config.toml` — Codex defaults.
- `pi/settings.json` — Pi defaults and reproducible package sources.
- `pi/extensions/`, `pi/prompts/`, `pi/themes/` — Pi resources.

The Pi setup includes the portable local extensions from `~/.pi/agent/extensions` and `pi-web-access`. Machine-specific local model endpoints, Herdr integration, the local agent-lint package, the GUI diff-review package, authentication, trust decisions, sessions, caches, and installed package directories are intentionally excluded. Web search uses `auto-summary` so it does not try to open the host-only curator window from a container.

Replace or extend these files with portable configuration. Keep authentication files and secrets out of this directory.
