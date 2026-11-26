if [ "$#" -gt 1 ]; then
  printf 'Usage: zellij-share [pane-id]\n' >&2
  exit 2
fi

session=${ZELLIJ_SESSION_NAME:-}
pane=${1:-${ZELLIJ_PANE_ID:-}}
if [ -z "$session" ] || [ -z "$pane" ]; then
  printf 'Run zellij-share from a Zellij pane.\n' >&2
  exit 2
fi

umask 077
snapshot=$(mktemp "${TMPDIR:-/tmp}/zellij-context.XXXXXX")
if ! {
  printf 'Zellij session: %s\nPane: %s\n\n' "$session" "$pane"
  zellij --session "$session" action dump-screen --pane-id "$pane"
} > "$snapshot"; then
  rm -f -- "$snapshot"
  exit 1
fi
printf '%s\n' "$snapshot"
