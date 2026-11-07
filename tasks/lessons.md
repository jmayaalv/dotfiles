# Lessons

## Attention indicators mean "unseen", not "state" (2026-09-25)
- **Mistake:** the tmux "Claude is waiting" tab mark tracked Claude's state (waiting until you reply), so it stayed red after the user had already gone to the tab.
- **Rule:** when designing a notification mark, decide when it clears *from the viewer's side*. Default to tmux's own activity/bell behaviour: clear it when the window is visited, and don't set it while the viewer is already looking at the window.

## Test tmux changes on a private server, never the user's (2026-09-25)
- **Mistake:** a test client attached with `script ... tmux attach` was left behind. `detach-client` takes `-t`, not `-c`. Because of `detach-on-destroy off`, killing the test session moved that client into the user's `main` session, where it could shrink their windows through `aggressive-resize`.
- **Rule:** run throwaway sessions and clients on `tmux -L <test-socket>`, and point scripts at it with `TMUX=<socket>,0,0`. Before finishing, check with `list-clients` that only the user's client is left.
- **Again (2026-10-07):** a test `zsh -i` shares `~/.zsh_history` (sharehistory), so the commands I typed into it, including a stray `vim .../clear`, landed in the user's history and autosuggestions. Start test shells as `HISTFILE=/dev/null zsh -i`, and drive them without pressing Enter where possible.
- **Again (2026-10-14):** a herdr test tab (`herdr tab create`) runs the user's normal zsh, so a `herdr pane run` without a leading space went into `~/.zsh_history`. Create test tabs and splits with `--env HISTFILE=/dev/null`, or start every typed command with a space (hist_ignore_space).
- **Again, same day:** a timing test typed `sleep 3` into a test tab with `herdr pane send-text`, with neither guard. A test tab is a user shell: every `herdr tab create` for a test gets `--env HISTFILE=/dev/null`. Also find leftover test tabs by `"speedtest" in label`; radar renames them "[4] speedtest".

## "Can we somehow…?" is a question, not a go-ahead (2026-10-05)
- **Mistake:** asked whether a tmux session on the Mac mini could be "brought here" into herdr, I picked one reading (nest `tmux attach` in a new herdr workspace) and built it. That wasn't what the user wanted, so it had to be removed.
- **Rule:** when the request is open-ended and the options differ in kind (nest it, migrate it, mirror it), lay out the options with a recommendation and wait for a choice before creating anything. Reading and inspecting first is fine; making changes is not.
- **Again (2026-10-06):** "how can I hide the row numbers in herdr-peek?" got a patch on both machines instead of an answer, and it had to be reverted. "How can I…" asks for the way, not for the change: explain it, say what it costs, and offer to do it.

## Check the colors on screen before changing a theme (2026-10-05)
- **Mistake:** I read the terminal config's `import` of catppuccin-latte and decided the terminal was light, so I switched herdr to Latte. But the main file's own `[colors]` block (background `#1E1D2F`) overrode the import, so the terminal was dark. The result was a white tab bar and a blue tab, and the user had to send a screenshot to show it.
- **Rule:** before changing UI colors, confirm the colors that are actually in effect. When a config imports others, the main file's settings can win over the imports, so a commented or uncommented import line proves nothing. When the result is visual and I can't render it, ask for a screenshot first rather than iterating blind.

## Match whole words in a guard, and replay real commands before enabling it (2026-10-06)
- **Mistake:** the agents' database guard denied any command containing the letters "sqlit" or "db-connect". That blocked the hourly MR reviewer from reading its own run history with `sqlite3`, and it went on running reviews with less to check. It also blocked grep for `db-connection`, commit messages and scp of sqlit's files.
- **Rule:** a command guard matches names as whole words (`\bsqlit\b`, not a substring) and judges what a command runs, not what it mentions. Before switching on a hook that can deny commands, replay recent real Bash commands from `~/.claude/projects/**/*.jsonl` through it, and expect zero false denials among ordinary commands.

## A terse "ignore it" after I raise a risk is not a go-ahead (2026-10-09)
- **Mistake:** asked to let agents write to the local imsdev db through sqlit-guard, I found that `imsdev` is a superuser on a Postgres.app server running as the user, so a writable connection would let `COPY ... PROGRAM` run shell commands outside the guard. The user interrupted with "ignore it". I read that as "ignore the risk, carry on" and started building the patch. They meant drop the change: "dont do this".
- **Rule:** when a short reply could mean either "drop the concern" or "drop the task", and the task weakens a security control, stop and ask which one before making anything, even in a scratch directory.

## A new plugin can make an installed one redundant: check before keeping both (2026-10-14)
- **Mistake:** my design added herdr-fingers and kept peek "for images and PDFs". Peek draws those with the kitty graphics protocol, which the terminal then in use didn't support, so on this setup it had only ever shown text, which Emacs does better. The user had to ask whether peek was now irrelevant.
- **Rule:** when adding a tool, list the installed ones it overlaps and check each feature I'd keep one for actually works here (the terminal, the machine). Use the tool's own saved state or logs to see what the user really used it for. Propose removing what's left with no job.

## Signal a process by its PID, never by its name (2026-10-14)
- **Mistake:** to reload Ghostty's config I ran `kill -USR2 $(pgrep -x ghostty)`. The user's `ghostty +list-themes` in a herdr pane runs the same binary, so it got the signal too. It doesn't handle SIGUSR2, so it died with mouse reporting still on, and mouse movement typed escape codes into their prompt.
- **Rule:** before signalling, list the matches with `pgrep -lf <name>` and pick the one PID that is the app (for Ghostty, the one whose command line has no `+action`). A CLI's subcommands and its GUI often share one binary name.

## A running app's settings go through its UI, not `defaults write` (2026-11-06)
- **Mistake:** asked to set Rex's font to match Ghostty, I wrote `Workspace.terminalFontName` and the point size with `defaults write` while Rex was running. The app never read them back, so the user had to change the font in Settings themselves. The cell size had stayed at 14×28 px, which already showed the write hadn't applied, and the memory about menu bar items rewriting `defaults` warned about the same thing.
- **Rule:** for a running macOS app's own settings (no config file), give the user the Settings path, or write the setting and restart the app, but only after the user agrees to the restart. Check an observable effect (Rex: the terminal `size` method's cell_width_px/cell_height_px) before saying it's done.

## Never redirect into a live config from a command that can fail (2026-11-06)
- **Mistake:** to install an edited `karabiner.json` I ran `cat "$(ls -t scratch/karabiner.* | head -1)" > karabiner.json`. `ls` is aliased to a tool with a different `-t`, so the lookup failed, but the shell had already truncated the target. Karabiner loaded an empty file (it kept its old config) until I restored it 8 seconds later.
- **Rule:** install a config with `cp`/`mv` from a path I hold in a variable, after validating it (`jq -e`), never with `> target` around a command substitution. Don't use `ls` in scripts (aliased here); use globs or `command ls`.

## Look at the app's saved state before saying a feature doesn't exist (2026-11-06)
- **Mistake:** asked how to resize a pane in the Herdr GUI, I searched only the command list, said it wasn't supported and posted a feature request. Dragging the line between panes already worked: the tab trees saved in herdr-core's `herdr-app` document had split weights of 1.22 / 0.78, and the manual says rows and columns are `resizable` by default. The user had to ask again ("I really need it").
- **Rule:** before saying an app can't do something, read where it saves that state (`hc connect` doc.get, its config, its stored layout) and its defaults, not only its commands. A non-default value in saved state shows a way to change it exists.

## Write a new mod's mod.json before its main.js (2026-11-06)
- **Mistake:** making the Herdr GUI mod `resize`, I wrote main.js first and mod.json (`"place": "none"`) second. Herdr saw the folder in between with no mod.json, docked a copy as a 320 px pane on the right of the shown layout, and never re-reads `place` for a folder it has seen. The user found an unexplained pane.
- **Rule:** when creating a herdr-app mod, write mod.json first, then main.js. After adding a mod, grep `layouts/*.json` for its name and check that nothing was docked that I didn't put there.

## Rebasing a commit that untracks files deletes them from disk (2026-11-06)
- **Mistake:** my commit stopped tracking Herdr's shipped mods and layouts with `git rm --cached` (files kept on disk). To push, I rebased it onto the remote with `--autostash`. The rebase first checked out the remote, where those files were still tracked, then replayed the commit, and replaying it deleted them: 72 files across 20 mods plus 3 layouts. Their newer, uncommitted versions were ignored files, so autostash didn't save them. I compared `git status` before and after, which can't show ignored files, and found the loss only later, from the app's errors.
- **Rule:** when a branch contains a commit that untracks files, don't rebase or cherry-pick it onto a base that still tracks them. Merge instead, or back up the folder first. After any rebase, check that ignored and untracked files still exist on disk, not only that `git status` matches.

## In Rex, "cmd" is two physical keys: left Control and right Command (2026-11-07)
- **Mistake:** listing Rex shortcuts, I wrote the physical key for `cmd` as "left Control" only. Karabiner makes left Control a second Command, and the right Command key still is one, so both work; the user calls this modifier "super".
- **Rule:** when describing Rex (or Herdr GUI) keys, write the Rex key (`shift+cmd+down`) and, if a physical key helps, say "left Control or right Command" for cmd and "Caps Lock" for ctrl. Never name only one of the two cmd keys.

## "great" after an offer is not a yes (2026-11-07)
- **Mistake:** I offered to make Rex's close-session key press-twice; the user answered "great" and I changed init.lua. They didn't want it ("no no … leave it as it was").
- **Rule:** a bare acknowledgment ("great", "ok", "thanks") after I offer an optional change is not approval. Make the change only on an explicit yes ("do it", "yes, change it"); otherwise leave things as they are and stop.
