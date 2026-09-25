# Lessons

## Attention indicators mean "unseen", not "state" (2026-09-25)
- **Mistake:** the tmux "Claude is waiting" tab mark tracked Claude's state (waiting until you reply), so it stayed red after the user had already gone to the tab.
- **Rule:** when designing a notification mark, decide when it clears *from the viewer's side*. Default to tmux's own activity/bell behaviour: clear it when the window is visited, and don't set it while the viewer is already looking at the window.

## Test tmux changes on a private server, never the user's (2026-09-25)
- **Mistake:** a test client attached with `script ... tmux attach` was left behind. `detach-client` takes `-t`, not `-c`. Because of `detach-on-destroy off`, killing the test session moved that client into the user's `main` session, where it could shrink their windows through `aggressive-resize`.
- **Rule:** run throwaway sessions and clients on `tmux -L <test-socket>`, and point scripts at it with `TMUX=<socket>,0,0`. Before finishing, check with `list-clients` that only the user's client is left.
