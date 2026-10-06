# Lessons

## Attention indicators mean "unseen", not "state" (2026-09-25)
- **Mistake:** the tmux "Claude is waiting" tab mark tracked Claude's state (waiting until you reply), so it stayed red after the user had already gone to the tab.
- **Rule:** when designing a notification mark, decide when it clears *from the viewer's side*. Default to tmux's own activity/bell behaviour: clear it when the window is visited, and don't set it while the viewer is already looking at the window.

## Test tmux changes on a private server, never the user's (2026-09-25)
- **Mistake:** a test client attached with `script ... tmux attach` was left behind. `detach-client` takes `-t`, not `-c`. Because of `detach-on-destroy off`, killing the test session moved that client into the user's `main` session, where it could shrink their windows through `aggressive-resize`.
- **Rule:** run throwaway sessions and clients on `tmux -L <test-socket>`, and point scripts at it with `TMUX=<socket>,0,0`. Before finishing, check with `list-clients` that only the user's client is left.

## "Can we somehow…?" is a question, not a go-ahead (2026-10-05)
- **Mistake:** asked whether a tmux session on the Mac mini could be "brought here" into herdr, I picked one reading (nest `tmux attach` in a new herdr workspace) and built it. That wasn't what the user wanted, so it had to be removed.
- **Rule:** when the request is open-ended and the options differ in kind (nest it, migrate it, mirror it), lay out the options with a recommendation and wait for a choice before creating anything. Reading and inspecting first is fine; making changes is not.
- **Again (2026-10-06):** "how can I hide the row numbers in herdr-peek?" got a patch on both machines instead of an answer, and it had to be reverted. "How can I…" asks for the way, not for the change: explain it, say what it costs, and offer to do it.

## Check the colors on screen before changing a theme (2026-10-05)
- **Mistake:** I read Alacritty's `general.import = [catppuccin-latte]` and decided the terminal was light, so I switched herdr to Latte. But `alacritty.toml`'s own `[colors]` block (background `#1E1D2F`) overrides the import, so the terminal was dark. The result was a white tab bar and a blue tab, and the user had to send a screenshot to show it.
- **Rule:** before changing UI colors, confirm the colors that are actually in effect. In Alacritty, the main file's settings win over imported files, so a commented or uncommented import line proves nothing. When the result is visual and I can't render it, ask for a screenshot first rather than iterating blind.

## Match whole words in a guard, and replay real commands before enabling it (2026-10-06)
- **Mistake:** the agents' database guard denied any command containing the letters "sqlit" or "db-connect". That blocked the hourly MR reviewer from reading its own run history with `sqlite3`, and it went on running reviews with less to check. It also blocked grep for `db-connection`, commit messages and scp of sqlit's files.
- **Rule:** a command guard matches names as whole words (`\bsqlit\b`, not a substring) and judges what a command runs, not what it mentions. Before switching on a hook that can deny commands, replay recent real Bash commands from `~/.claude/projects/**/*.jsonl` through it, and expect zero false denials among ordinary commands.
