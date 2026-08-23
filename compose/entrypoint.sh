#!/bin/sh
set -eu

agent=${1:-}
if [ -z "$agent" ]; then
  printf '%s\n' 'Expected one of: claude, codex, pi' >&2
  exit 2
fi
shift

skills=/opt/agent-skills
config=/opt/agent-config

replace_link() {
  source=$1
  destination=$2
  if [ -d "$destination" ] && [ ! -L "$destination" ]; then
    rm -rf "$destination"
  else
    rm -f "$destination"
  fi
  ln -s "$source" "$destination"
}

mkdir -p "$HOME/.agents" "$HOME/.claude" "$HOME/.codex" "$HOME/.pi/agent"
replace_link "$skills" "$HOME/.agents/skills"

if [ -s "$config/shared/AGENTS.md" ]; then
  replace_link "$config/shared/AGENTS.md" "$HOME/.claude/CLAUDE.md"
  replace_link "$config/shared/AGENTS.md" "$HOME/.codex/AGENTS.md"
  replace_link "$config/shared/AGENTS.md" "$HOME/.pi/agent/AGENTS.md"
fi

case "$agent" in
  claude)
    replace_link "$skills" "$HOME/.claude/skills"
    exec claude --settings "$config/claude/settings.json" "$@"
    ;;
  codex)
    replace_link "$config/codex/config.toml" "$HOME/.codex/config.toml"
    exec codex "$@"
    ;;
  pi)
    replace_link "$config/pi/settings.json" "$HOME/.pi/agent/settings.json"
    for resource in extensions prompts themes; do
      replace_link "$config/pi/$resource" "$HOME/.pi/agent/$resource"
    done
    exec pi "$@"
    ;;
  *)
    printf 'Unknown agent: %s\n' "$agent" >&2
    exit 2
    ;;
esac
