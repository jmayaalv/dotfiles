#!/bin/sh
# Claude Code hook: mark this pane's tmux window as waiting on the user (`on`)
# or not (`off`). window-status-format in tmux.conf paints the tab's number pill
# red while @claude_waiting is set, and visiting the window clears it (see the
# session-window-changed hook there). Outside tmux this is a no-op.
[ -n "$TMUX_PANE" ] || exit 0
case "$1" in
  on)
    # You're already looking at this window, so there is nothing unseen to flag.
    [ "$(tmux display -p -t "$TMUX_PANE" '#{&&:#{window_active},#{session_attached}}')" = 1 ] && exit 0
    tmux set -w -t "$TMUX_PANE" @claude_waiting 1 ;;
  off) tmux set -wu -t "$TMUX_PANE" @claude_waiting ;;
esac
exit 0
