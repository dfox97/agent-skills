# Portable agent configuration

This directory contains configuration that is safe to share. Runtime state such as credentials, sessions, caches, and trust decisions belongs in each sandbox or Docker volume and must not be committed.

- `shared/AGENTS.md` — instructions shared by all harnesses.
- `claude/settings.json` — additional Claude Code settings.
- `codex/config.toml` — Codex defaults.
- `pi/settings.json` — Pi defaults.
- `pi/extensions/`, `pi/prompts/`, `pi/themes/` — Pi resources.

The files are deliberately minimal placeholders. Replace them with the portable parts of your local setup. Keep authentication files and secrets out of this directory.
