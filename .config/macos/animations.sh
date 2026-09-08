#!/usr/bin/env bash
# Enable or disable macOS UI animations.
#
# Mostly useful with a tiling window manager, where every retile animates a
# window resize and the open/close effects just add latency.
#
#   animations.sh disable   turn animations off
#   animations.sh enable    restore macOS defaults (deletes the keys)
#   animations.sh status    show what is currently set
#   animations.sh toggle    flip based on current state
#
# 'enable' deletes the keys rather than writing "on" values, so macOS falls back
# to its own defaults instead of whatever this script guessed they were.
#
# Reduce Motion is included, but with a caveat: the plist write is accepted,
# yet the accessibility daemon caches the value, so it may not take effect until
# you log out and back in. The GUI toggle (System Settings > Accessibility >
# Display > Reduce motion) applies immediately and is the reliable route. It is
# the single most effective setting of the lot.
#
# Note that 'enable' therefore also turns Reduce Motion off, since restoring
# animations means clearing it.

set -uo pipefail

# domain <tab> key <tab> type <tab> disabled-value
SETTINGS=$(cat <<'TSV'
-g	NSAutomaticWindowAnimationsEnabled	bool	false
-g	NSWindowResizeTime	float	0.001
com.apple.dock	launchanim	bool	false
com.apple.dock	expose-animation-duration	float	0.1
com.apple.dock	autohide-time-modifier	float	0
com.apple.finder	DisableAllAnimations	bool	true
com.apple.universalaccess	reduceMotion	bool	true
TSV
)

read_val() { defaults read "$1" "$2" 2>/dev/null; }

cmd_status() {
  printf '%-26s %-36s %-10s %s\n' DOMAIN KEY CURRENT DEFAULT-WHEN-OFF
  while IFS=$'\t' read -r domain key type off; do
    [ -z "${domain:-}" ] && continue
    cur="$(read_val "$domain" "$key")"
    printf '%-26s %-36s %-10s %s\n' "$domain" "$key" "${cur:-<unset>}" "$off"
  done <<< "$SETTINGS"
  echo
  echo "Reduce Motion may need a logout to take effect; the System Settings"
  echo "toggle (Accessibility > Display > Reduce motion) applies immediately."
}

cmd_disable() {
  while IFS=$'\t' read -r domain key type off; do
    [ -z "${domain:-}" ] && continue
    defaults write "$domain" "$key" "-$type" "$off" && echo "  set    $domain $key = $off"
  done <<< "$SETTINGS"
  killall Dock >/dev/null 2>&1 && echo "  restarted Dock"
  killall Finder >/dev/null 2>&1 && echo "  restarted Finder"
  echo
  echo "Animations disabled. Apps read the global keys at launch, so restart"
  echo "them (or log out and back in) for the change to apply everywhere."
}

cmd_enable() {
  while IFS=$'\t' read -r domain key type off; do
    [ -z "${domain:-}" ] && continue
    if defaults delete "$domain" "$key" >/dev/null 2>&1; then
      echo "  reset  $domain $key"
    else
      echo "  absent $domain $key (already at the macOS default)"
    fi
  done <<< "$SETTINGS"
  killall Dock >/dev/null 2>&1 && echo "  restarted Dock"
  killall Finder >/dev/null 2>&1 && echo "  restarted Finder"
  echo
  echo "Animations restored to the macOS defaults. Restart apps or log out"
  echo "and back in for the change to apply everywhere."
}

# Disabled if the window-animation key is explicitly off; that one is the marker.
is_disabled() { [ "$(read_val -g NSAutomaticWindowAnimationsEnabled)" = "0" ]; }

case "${1:-status}" in
  disable) cmd_disable ;;
  enable)  cmd_enable ;;
  status)  cmd_status ;;
  toggle)  if is_disabled; then cmd_enable; else cmd_disable; fi ;;
  *) echo "usage: $(basename "$0") {disable|enable|status|toggle}" >&2; exit 2 ;;
esac
