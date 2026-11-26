# Codex currently sends only turn completion events to its notify command.
if ! jq -e '.type == "agent-turn-complete"' <<< "${1:-null}" >/dev/null 2>&1; then
  exit 0
fi

# Avoid making noise when the agent's pane is on the active tab and the
# terminal app is in front. A hidden tab can still have its own focused pane.
front_app=$(/usr/bin/osascript -l JavaScript -e '
  ObjC.import("AppKit");
  ObjC.unwrap($.NSWorkspace.sharedWorkspace.frontmostApplication.bundleIdentifier);
' 2>/dev/null) || front_app=

case "$front_app" in
  dev.zellij.Zellij|com.apple.Terminal|net.kovidgoyal.kitty)
    if active_tab=$(zellij action current-tab-info --json 2>/dev/null) &&
      zellij action list-panes --state --tab --json 2>/dev/null |
        jq -e --arg pane "${ZELLIJ_PANE_ID:-}" --argjson tab "$active_tab" '
          any(.[]; (.id | tostring) == $pane and .is_plugin == false
            and .is_focused == true and .tab_id == $tab.tab_id)
        ' >/dev/null 2>&1; then
      exit 0
    fi
    ;;
esac

/usr/bin/afplay /System/Library/Sounds/Glass.aiff
