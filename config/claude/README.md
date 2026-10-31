# Claude Code configuration

Portable user-level Claude Code config, synced from a working `~/.claude`. Nothing here is
secret and nothing here is tied to one machine or one repository.

| File | Purpose |
|---|---|
| `settings.json` | User settings: model, permission denials, disabled features, status line, plugins, theme |
| `statusline-command.sh` | The status line: model + branch, context tokens, prompt-cache saved + TTL countdown, 5-hour usage |
| `hooks/notify-when-away.sh` | Optional desktop notification when a turn finishes while you are away. Not wired by default |
| `hooks/update-status.sh` | Optional. Writes `~/.claude/state/<session>.json` for the previous 3-line status line. Not wired by default |

## Install on another machine

`settings.json` refers to the status line through `~/.claude/...`, so the files must live at those
paths. From a clone of this repository:

```sh
mkdir -p ~/.claude/hooks
cp config/claude/settings.json ~/.claude/settings.json
cp config/claude/statusline-command.sh ~/.claude/statusline-command.sh
cp config/claude/hooks/*.sh ~/.claude/hooks/
chmod +x ~/.claude/statusline-command.sh ~/.claude/hooks/*.sh
```

Back up any existing `~/.claude/settings.json` first. Then start Claude Code and run `/config` to
check the theme, TUI mode, and permission denials. The status line needs `jq` and a transcript on
disk, which Claude Code provides.

To opt into a hook, add it to `settings.json` yourself — for example the away notification:

```json
"Stop": [
  {
    "hooks": [
      { "type": "command", "command": "bash ~/.claude/hooks/notify-when-away.sh", "async": true }
    ]
  }
]
```

`notify-when-away.sh` uses `powershell.exe` on WSL/Windows, `afplay` on macOS, or a terminal bell.

## What is in `settings.json`

- `permissions.deny` — the "disabled stuff": plan-mode toggles, notebook edits, push
  notifications, cron/scheduling, and every shell/read route to `.env` files.
- `permissions.ask` — `git push` always asks.
- `disableClaudeAiConnectors`, `disableRemoteControl`, `disableWorkflows` — off.
- `statusLine` — points at `statusline-command.sh`.
- `enabledPlugins` — official marketplace only: `frontend-design`, `typescript-lsp`, `pyright-lsp`.
- `model`, `effortLevel`, `modelSettings`, `theme`, `tui`, `skipDangerousModePermissionPrompt`,
  `skipAutoPermissionPrompt`.

## Deliberately excluded

- **Credentials and runtime state** — `.credentials.json`, sessions, history, `projects/`,
  `file-history/`, `state/`, caches, telemetry, `policy-limits.json`, `remote-settings.json`.
- **`~/.claude.json`** — mostly runtime state, machine paths, and account identifiers. It is not a
  settings file you can move between machines.
- **Breeze** — the inline `breeze` plugin and its `breeze-mcp` server.
- **Hubexo / work-specific configuration** — the `autoMode.environment` trust block (nimbus-api,
  `thenbs.visualstudio.com`, prod-name heuristics) and anything else naming the employer or a
  private repo. Re-create it per machine with `/config` or by hand.
- **Machine-specific hooks** — `nx-guard.sh` (gates to the Nimbus Nx workspace),
  `herdr-agent-state.sh` (installed and managed by herdr), `diff-review-hook.mjs` plus
  `commands/diff-review.md` (needs the local `diff-review` GUI binary).
- **`plugins/installed_plugins.json`** — holds absolute host paths. `enabledPlugins` is enough;
  Claude Code reinstalls from the marketplace on first use.
