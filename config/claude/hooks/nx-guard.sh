#!/usr/bin/env bash
# PreToolUse Bash interceptor for the Nimbus Nx workspace.
#
# When the model runs a lint / build / test command *inside the Nimbus Nx
# workspace*, this hook runs the AFFECTED version of it itself, swallows the
# noisy output, and DENIES the original tool call — feeding back only pass/fail
# (and the failing lines on a failure). Goal: keep that output out of context.
#
# Portable + safe to install globally (~/.claude): it self-gates to the Nimbus
# workspace (an Nx root that contains apps/nimbus-app) and PASSES THROUGH
# untouched in every other repo, so it does nothing outside Nimbus.
#
# Wired via settings.snippet.json as hooks.PreToolUse[matcher="Bash"].
# Testing: set NX_GUARD_TEST_LOG (+ optional NX_GUARD_TEST_RC) to skip the real
#          Nx run and exercise the classify + summarise + JSON logic.

set -uo pipefail

input=$(cat)
cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // empty')
[ -z "$cmd" ] && exit 0 # not a readable Bash call -> let it through

lc=$(printf '%s' "$cmd" | tr '[:upper:]' '[:lower:]')

# Never hijack mutating / long-running variants — the model runs those itself.
# The agent-only lint (lint:agent / lint-agent.mjs) is a different rule set from
# project ESLint; substituting `nx affected -t lint` for it would report a PASS
# for a check that never ran.
case "$lc" in
*fix* | *--watch* | *" serve "* | *"nx serve"*) exit 0 ;;
*lint:agent* | *lint-agent*) exit 0 ;;
esac

# --- classify intent -------------------------------------------------------
target=""
# `nx` must appear as the command itself, not anywhere in the string: a bare
# `nx[^&|;]*` also matches any path containing /nx/ (e.g. a repo checkout), which
# made unrelated commands look like Nx targets.
nx_cmd='(^|[;&|] *)(npx +|npm +run +|yarn +|pnpm +)?nx\b'
if printf '%s' "$lc" | grep -Eq "($nx_cmd[^&|;]*\blint\b|run +lint\b|(^|[;&|] *)eslint\b|prettier)"; then
  target=lint
elif printf '%s' "$lc" | grep -Eq "($nx_cmd[^&|;]*\bbuild\b|run +build\b)"; then
  target=build
elif printf '%s' "$lc" | grep -Eq "($nx_cmd[^&|;]*\btest\b|(^|[;&|] *)(npm +(run +)?test|jest|karma)\b)"; then
  target=test
fi
[ -z "$target" ] && exit 0 # not a lint/build/test command -> don't intercept

# --- locate the Nx workspace ----------------------------------------------
find_root() {
  local d
  for d in "${CLAUDE_PROJECT_DIR:-}" "${CLAUDE_PROJECT_DIR:-}/nx" "$PWD" "$PWD/nx"; do
    [ -n "$d" ] && [ -f "$d/nx.json" ] && {
      printf '%s' "$d"
      return 0
    }
  done
  # walk up from CWD looking for an nx.json
  d="$PWD"
  while [ -n "$d" ] && [ "$d" != "/" ]; do
    [ -f "$d/nx.json" ] && {
      printf '%s' "$d"
      return 0
    }
    d=$(dirname "$d")
  done
  return 1
}
ROOT=$(find_root) || exit 0 # not in an Nx workspace -> pass through
# Self-gate: only act in the Nimbus workspace, never in any other Nx repo.
[ -d "$ROOT/apps/nimbus-app" ] || exit 0
cd "$ROOT" || exit 0

# --- detect an explicit single-project invocation --------------------------
# Forms: `nx run <proj>:<target>` or `nx <target> <proj>`. When the model
# names a specific project we must run THAT project, not widen to affected
# (the old behaviour turned `nx test apps/api` into the whole affected graph
# incl. the nimbus-app Karma suite). affected/run-many/etc => no explicit proj.
PROJECT=""
nxparse=$(printf '%s' "$cmd" | awk '
  { for (i=1;i<=NF;i++) if ($i=="nx") {
      tgt=$(i+1); pos="";
      for (j=i+2;j<=NF;j++){ if ($j=="--") break; if ($j ~ /^-/) continue; pos=$j; break }
      print tgt"\t"pos; exit } }')
nxsub=${nxparse%%$'\t'*}
nxpos=${nxparse#*$'\t'}
case "$nxsub" in
"" | affected | run-many | show | graph | reset | list | report | daemon) PROJECT="" ;;
run) PROJECT=${nxpos%%:*} ;; # nx run <proj>:<target>
*) PROJECT=$nxpos ;;         # nx <target> <proj>
esac
case "$PROJECT" in -* | "") PROJECT="" ;; esac # ignore stray flag / no positional

# --- pick the affected base ------------------------------------------------
BASE=$(git symbolic-ref -q refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/@@')
if [ -z "$BASE" ]; then
  for c in origin/dev origin/main origin/master; do
    git rev-parse -q --verify "$c" >/dev/null 2>&1 && {
      BASE="$c"
      break
    }
  done
fi
[ -z "$BASE" ] && BASE="origin/dev"

log=$(mktemp)
rc=0

if [ -n "${NX_GUARD_TEST_LOG:-}" ]; then
  printf '%s' "$NX_GUARD_TEST_LOG" >"$log"
  rc="${NX_GUARD_TEST_RC:-0}"
elif [ -n "$PROJECT" ]; then
  # Explicit single-project run: run exactly what was asked, just make it
  # non-interactive and force headless for the nimbus-app Karma suite.
  runcmd="$cmd"
  if ! printf '%s' "$lc" | grep -q -- ' -- '; then
    printf '%s' "$lc" | grep -q -- '--tuiautoexit' || runcmd="$runcmd --tuiAutoExit"
    if [ "$target" = test ] && [ "$PROJECT" = nimbus-app ] &&
      ! printf '%s' "$lc" | grep -q -- '--browsers'; then
      runcmd="$runcmd --browsers=ChromeNoSandboxHeadless"
    fi
  fi
  eval "$runcmd" >>"$log" 2>&1 || rc=$?
else
  case "$target" in
  lint)
    npx nx affected -t lint --base="$BASE" >>"$log" 2>&1 || rc=$?
    # Flexible fallback: if Nx itself couldn't run, lint changed files directly.
    if [ $rc -ne 0 ] && grep -qiE 'command not found|cannot find|could not find|no such file|unknown argument' "$log"; then
      changed=$(git diff --name-only "$BASE"...HEAD -- '*.ts' '*.tsx' '*.html' '*.js' 2>/dev/null | tr '\n' ' ')
      if [ -n "${changed// /}" ]; then
        echo "--- nx unavailable; falling back to eslint on changed files ---" >>"$log"
        rc=0
        npx eslint $changed >>"$log" 2>&1 || rc=$?
      fi
    fi
    ;;
  build)
    npx nx affected -t build --base="$BASE" >>"$log" 2>&1 || rc=$?
    ;;
  test)
    # Everything except nimbus-app (mirrors the package.json "test" script).
    npx nx affected -t test --base="$BASE" --exclude nimbus-app --tuiAutoExit -- -i >>"$log" 2>&1 || rc=$?
    # nimbus-app is Karma: MUST run headless or it hangs waiting for a browser.
    if npx nx show projects --affected --base="$BASE" 2>/dev/null | grep -qx nimbus-app; then
      echo "--- nimbus-app (karma, headless) ---" >>"$log"
      npx nx test nimbus-app --browsers=ChromeNoSandboxHeadless >>"$log" 2>&1 || rc=$?
    fi
    ;;
  esac
fi

# --- summarise for the model ----------------------------------------------
if [ -n "$PROJECT" ]; then scope="$PROJECT"; else scope="affected, base=${BASE}"; fi
if [ "$rc" -eq 0 ]; then
  if grep -qiE 'no projects|no tasks' "$log"; then
    reason="[nx-guard] ${target}: nothing to run for ${scope} — skipped. Treat as done; do NOT re-run this command."
  else
    reason="[nx-guard] ${target} PASSED (${scope}). Full output suppressed to save context. Treat as done; do NOT re-run this command."
  fi
else
  fails=$(grep -iE 'error|✖|✗|fail|expected|cannot|unable|TS[0-9]{3,}|●' "$log" | grep -viE 'warning: |0 errors' | head -60)
  [ -z "$fails" ] && fails=$(tail -60 "$log")
  reason=$(printf '[nx-guard] %s FAILED (%s). The full log was suppressed; fix the failures below:\n\n%s' "$target" "$scope" "$fails")
fi
rm -f "$log"

jq -n --arg r "$reason" \
  '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"deny",permissionDecisionReason:$r}}'
exit 0
