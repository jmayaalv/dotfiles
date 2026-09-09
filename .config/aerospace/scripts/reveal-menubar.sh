#!/usr/bin/env bash

# Toggle sketchybar out of the way so the macOS menu bar can be used.
#
# The bar runs topmost=on (see sketchybar/sketchybarrc), which puts it one
# window layer above the menu bar. That is what stops the auto-hidden menu bar
# from revealing over the bar every time the pointer brushes the top edge - but
# it also means a click aimed at Chrome's File or Profiles menu lands on the
# bar instead. So:
#
#   first press   drop the bar below the menu bar; hover the top edge to
#                 reveal the menu bar as usual
#   press again   put the bar back at once, without waiting
#   do nothing    the bar puts itself back after HOLD seconds
#
# The timer is a safety net, not the way out: a toggle you forget to flip back
# leaves you with exactly the hover annoyance topmost=on exists to prevent.

HOLD=10
GEN="${TMPDIR:-/tmp}/sketchybar-menubar-reveal.gen"

# A generation token, not a PID: a pending sleeper checks whether it is still
# the newest press before restoring, so nothing has to be hunted down and
# killed. Bumped first, so both branches below invalidate any sleeper waiting.
TOKEN=$(( $(cat "$GEN" 2>/dev/null || echo 0) + 1 ))
echo "$TOKEN" > "$GEN"

topmost() { sketchybar --query bar | sed -n 's/.*"topmost": *"\([a-z]*\)".*/\1/p'; }

if [ "$(topmost)" = "off" ]; then
  # Already stepped aside - this press means "done, hide it again".
  sketchybar --bar topmost=on
  exit 0
fi

sketchybar --bar topmost=off

(
  sleep "$HOLD"
  [ "$(cat "$GEN" 2>/dev/null)" = "$TOKEN" ] && sketchybar --bar topmost=on
) >/dev/null 2>&1 &
