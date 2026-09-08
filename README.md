# Dotfiles

Personal configuration files managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Quick Start

```bash
cd ~
git clone <repository-url> dotfiles
cd dotfiles
./setup.sh
```

## Structure

```
.
├── .clojure/               # Clojure configuration and history
├── .config/
│   ├── aerospace/          # AeroSpace tiling window manager
│   ├── alacritty/          # Terminal emulator configuration
│   ├── claude/             # Claude Code configuration and data
│   ├── karabiner/          # Karabiner-Elements: right Command -> SUPER
│   ├── macos/              # macOS system tweaks (animations on/off)
│   ├── ohmyposh/           # Oh My Posh prompt theme configuration
│   ├── sketchybar/         # SketchyBar status bar (items, plugins, C helper)
│   ├── tmux/               # Tmux configuration files
│   └── tmuxinator/         # Tmuxinator session configurations
├── .emacs.d/               # Emacs configuration directory
├── .psqlrc                 # PostgreSQL configuration
└── .zshrc                  # Zsh shell configuration
```

## Applications Configured

- **AeroSpace**: Tiling window manager (i3-like) with 4 workspaces and vim-style focus/move bindings
- **SketchyBar**: Status bar showing AeroSpace workspaces with per-app glyphs, front app, clock, CPU, volume and battery
- **Zsh**: Shell configuration with Zinit plugin manager, Homebrew integration, and custom PATH settings
- **Alacritty**: GPU-accelerated terminal emulator
- **Claude Code**: AI-powered development environment configuration and data
- **Tmux**: Terminal multiplexer with custom configuration
- **Tmuxinator**: Tmux session manager with predefined layouts
- **Oh My Posh**: Cross-platform prompt theme engine
- **Emacs**: Text editor configuration
- **Clojure**: Development tools and REPL configuration
- **PostgreSQL**: Database client configuration

## Installation

### Prerequisites

1. Install [GNU Stow](https://www.gnu.org/software/stow/):
   ```bash
   # macOS (using Homebrew)
   brew install stow

   # Ubuntu/Debian
   sudo apt install stow

   # Arch Linux
   sudo pacman -S stow
   ```

### Setup

1. Clone this repository to your home directory:
   ```bash
   cd ~
   git clone <repository-url> dotfiles
   cd dotfiles
   ```

2. Run the setup script:
   ```bash
   ./setup.sh
   ```
   This will:
   - Clone [Emacs Prelude](https://github.com/bbatsov/prelude) into `~/.emacs.d/` (if not already installed)
   - Run `stow .` to symlink all configurations

3. Restart your shell or source the configuration:
   ```bash
   source ~/.zshrc
   ```

## Usage

### Adding New Configurations

1. Create the configuration file/directory in the appropriate location within this repository
2. Use stow to create symlinks:
   ```bash
   stow .
   ```

### Removing Configurations

To unlink configurations:
```bash
# Remove all symlinks
stow -D .

# Remove specific configuration
stow -D .config
```

## Window Management (AeroSpace + SketchyBar)

Adapted from [omerxx/dotfiles](https://github.com/omerxx/dotfiles), retargeted from
a vertical right-hand bar to a conventional top bar and from yabai to AeroSpace.

### Layout

- `.config/aerospace/scripts/keybindings.py` — renders the cheatsheet by parsing
  `aerospace.toml` at runtime, so it cannot drift from the real bindings.
  `show-keybindings.sh` opens it in a floating Alacritty window on `SUPER+K`.
- `.config/aerospace/aerospace.toml` — window manager: gaps, bindings, per-app float rules,
  workspace-to-monitor assignment. Starts SketchyBar and `borders` on launch and pushes a
  `aerospace_workspace_change` event to SketchyBar on every workspace switch.
- `.config/sketchybar/sketchybarrc` — bar appearance and item load order.
- `.config/sketchybar/colors.sh` — Catppuccin Macchiato palette.
- `.config/sketchybar/icons.sh` — SF Symbols glyphs (needs SF Pro installed).
- `.config/sketchybar/items/` — one file per bar item. Clickable items:

  | Item | Left click | Right click |
  |---|---|---|
  | Clock | Calendar | Date & Time settings |
  | VPN | Toggle Tunnelblick connection | Open Tunnelblick |
  | CPU | Activity Monitor | — |
  | Claude | Popup usage breakdown | Full figures in a window |
  | Apple logo | Popup: Settings, Activity, Lock | — |

  A sketchybar item is a single click target, so the clock's date and time
  cannot be clicked separately. The CPU handler is applied to all four cpu.*
  items at once via sketchybar's `/cpu\..*/ ` regex form, so any part of the
  cluster responds.
- `.config/sketchybar/plugins/` — the scripts those items call.
  `icon_map.sh` maps app names to `sketchybar-app-font` ligatures. Upstream
  generates this file from its `mappings/` dir, so the vendored copy drifts behind
  the installed font. To add an app, find its ligature in the font and add a case
  branch:

  ```bash
  # list every ligature the installed font actually supports
  strings ~/Library/Fonts/sketchybar-app-font.ttf | grep -oE ':[a-z0-9_]+:' | sort -u
  ```

  Apps with no glyph in the font fall through to `:default:` — currently `Lens`.
- `.config/sketchybar/helper/` — small C mach helper driving the CPU graphs and the clock.
  Built by `setup.sh`; the `helper` binary itself is gitignored.

### Keybindings

Bindings follow [Omarchy](https://omarchy.org)'s Hyprland layout. Omarchy's
`SUPER` is the right Command key, which Karabiner rewrites to `cmd+ctrl+alt`
(`.config/karabiner/karabiner.json`); holding shift as well gives the
`SUPER+SHIFT` second level.

**Why right Command.** `macos.el` hands Emacs every other modifier —
Option is `super`, Command is `meta`, fn is `hyper` — and macOS maps Caps Lock
to Right Control, so Caps is Emacs's `C-`. Of those, only fn has no bindings at
all, and taking it would cost Home/End/PageUp/PageDown and forward-delete.
Right Command is a duplicate of left Command and is otherwise unused, so
sacrificing it costs nothing. Karabiner intercepts the key before Emacs sees
it, so no Emacs configuration changes were needed.

#### Windows

| Binding | Action |
|---|---|
| `SUPER+W` | Close window |
| `SUPER+T` | Toggle floating/tiling |
| `SUPER+F` | Fullscreen |
| `SUPER+J` | Toggle split (tiles horizontal/vertical) |
| `SUPER+,` | Toggle accordion (not an Omarchy binding) |
| `SUPER+K` | Show this keybinding cheatsheet |
| `SUPER+<arrow>` | Focus in that direction |
| `SUPER+SHIFT+<arrow>` | Move/swap window in that direction |
| `SUPER+-` / `SUPER+=` | Narrower / wider |
| `SUPER+SHIFT+-` / `SUPER+SHIFT+=` | Shorter / taller |

#### Workspaces

Five workspaces, not Omarchy's ten — ten indicators is too wide for a single
laptop display. SketchyBar enumerates them dynamically, so changing the count
in `aerospace.toml` is enough.

| Binding | Action |
|---|---|
| `SUPER+1..5` | Switch to workspace |
| `SUPER+SHIFT+1..5` | Move window to workspace and follow it |
| `SUPER+TAB` / `SUPER+SHIFT+TAB` | Next / previous workspace (wraps) |
| `SUPER+\`` | Back and forth between last two |

#### Applications

| Binding | App |
|---|---|
| `SUPER+RETURN` | Alacritty |
| `SUPER+SHIFT+RETURN` / `SUPER+SHIFT+B` | Firefox |
| `SUPER+SHIFT+N` | Emacs |
| `SUPER+SHIFT+O` | Obsidian |
| `SUPER+SHIFT+M` | Spotify |
| `SUPER+SHIFT+F` | Finder |
| `SUPER+SHIFT+A` | Claude |
| `SUPER+SHIFT+S` | Slack |
| `SUPER+SHIFT+G` | WhatsApp |
| `SUPER+SHIFT+T` | Telegram |
| `SUPER+SHIFT+E` | Mail |
| `SUPER+SHIFT+C` | Calendar |
| `SUPER+SHIFT+/` | Bitwarden |

#### Service mode

`SUPER+SHIFT+;` enters it: `esc` reload config, `r` reset layout, `f` toggle
float, `backspace` close all windows but the current one.

#### Cheatsheet

`SUPER+K` opens a floating window listing every binding, the equivalent of
Omarchy's `SUPER+K` keybindings menu. It parses `aerospace.toml` on each run and
rewrites the `cmd-ctrl-alt` prefix back to `SUPER`, so editing a binding updates
the cheatsheet with no extra step. Dismiss with `q` or Enter. It also renders
standalone in a terminal:

```bash
python3 ~/.config/aerospace/scripts/keybindings.py
```

It lays out in two columns at 108 columns or wider and falls back to a single
tall column below that, so keep `COLS` at 108 or more.

The window is **not centred**, and currently cannot be: Alacritty's
`window.position` is ignored on macOS (verified with both `--option` and a
generated `--config-file`), AeroSpace has no command to place a floating window,
and System Events cannot write the position because Alacritty reports its
accessibility window title as `Alacritty` rather than the `--title` value, so the
window cannot be addressed. macOS does place it consistently, so it is at least
repeatable. Centring it would mean rendering the sheet in Terminal.app instead,
which can be floated by `app-id` and positioned with AppleScript `set bounds`. Window size is set by `COLS`, `LINES` and `FONT_SIZE` at
the top of `show-keybindings.sh`. Note that `alacritty.toml` sets
`startup_mode = "Maximized"`, which overrides `window.dimensions` entirely, so
the launcher passes an explicit `window.startup_mode="Windowed"` override — drop
that and the window opens full screen.

#### Omarchy bindings with no AeroSpace equivalent

Window groups (`togglegroup`, `moveintogroup`, `changegroupactive`), `pseudo`,
the scratchpad special workspace, mouse drag-to-move/resize, monitor scaling,
and pop-window-out-and-pin. `SUPER+CTRL+TAB` (former workspace) is also
unreachable because `ctrl` is already inside SUPER, so back-and-forth lives on
`SUPER+\`` instead.

### Troubleshooting

**Two windows overlap at near-full width instead of splitting.** The workspace
is in accordion layout, not tiles. Layout is per-workspace runtime state, so
`default-root-container-layout = 'tiles'` does not prevent it — `SUPER+,`
toggles accordion and it stays until toggled back. Press `SUPER+SHIFT+;` then
`r` to force the root back to tiles and flatten the tree. `accordion-padding` is
set to 30 rather than omerxx's 300 so the mode is visually obvious rather than
looking like broken tiling.

**The bar has no workspace indicators.** SketchyBar builds them from
`aerospace list-workspaces`, so AeroSpace must be running when the bar starts.
`items/spaces.sh` falls back to the workspaces declared in `aerospace.toml`, but
if that is edited, check the fallback's grep still matches the binding names.

**SUPER does nothing.** Karabiner-Elements is not running, or lost Input
Monitoring permission.

### Claude Code quota widget

The macOS counterpart to Omarchy's Waybar Claude widget
([claudebar](https://github.com/mryll/claudebar),
[ai-usagebar](https://github.com/akitaonrails/ai-usagebar)). Those read plan
limits from an OAuth token in a credentials file; on macOS the token is in the
Keychain and the limits endpoint is undocumented, so this takes a different
route with no credentials and no network.

The bar shows whichever rate-limit window is closest to exhaustion — percent
left and a countdown to its reset — with the icon graded green/yellow/orange/red
by how much is used. Left click opens a popup:

```
5h    ▰▰▱▱▱▱▱▱▱▱   83% left  ·  14:40      (2h26m)
7d    ▰▱▱▱▱▱▱▱▱▱   88% left  ·  Thu 22:00  (2d9h)

opus-5     100M   $88.08
today      100M   $88.08
session           $36.79
```

`today` is every session since midnight, estimated from the logs. `session` is
Claude Code's own `total_cost_usd` for the current conversation only — one of
those sessions, and an exact figure rather than an estimate. The context-window
gauge was dropped: it describes a single conversation, which does not belong in
a bar shared by all of them.

Right click opens the same figures as a table in a window, and the script runs
standalone:

```bash
~/.config/sketchybar/plugins/claude_usage.py --detail
```

#### Where the numbers come from

**Quota and reset times** come from `~/.claude/statusline-cache.json`. Claude Code
passes a payload to the statusline command on stdin containing
`rate_limits.five_hour`, `rate_limits.seven_day` (each with `used_percentage` and
a `resets_at` unix timestamp), `cost.total_cost_usd` and `context_window`, and it writes that nowhere
else on disk — so `.claude/statusline-command.sh` tees stdin to that file
atomically. **The widget therefore depends on the statusline being configured**
(`statusLine` in `~/.claude/settings.json`) and on Claude Code having run
recently; the popup marks the figures stale after 15 minutes.

**Per-model token counts** come from `~/.claude/projects/**/*.jsonl`, skipping
files not modified today and deduping on `(message.id, requestId)` because
resumed sessions re-log entries.

Note that `~/.claude` is not stowed — Claude Code writes into it — so `setup.sh`
copies the statusline script there rather than symlinking it.

#### Limitations

**There is no per-model quota.** Claude Code exposes only the two global windows,
5-hour and 7-day; it does not report a separate allowance per model. What the
popup breaks out per model is token consumption, not remaining quota.

**Cost is an estimate, not a bill.** On a Claude subscription there is no
per-token charge — the figure is what the same usage would cost at published API
rates. Rates live in `PRICING` in `claude_usage.py` and will drift; a model with
no entry contributes tokens but no cost. Cache tokens use the documented
multipliers: reads at 0.1x the model's input rate, writes at 1.25x for the
5-minute TTL and 2x for the 1-hour TTL, which the logs distinguish via
`ephemeral_5m_input_tokens` and `ephemeral_1h_input_tokens`. The `session` row is
Claude Code's own `total_cost_usd`, not an estimate.

### macOS animations

A tiling window manager animates a window resize on every retile, so the UI
animations mostly add latency. `.config/macos/animations.sh` turns them off and
back on:

```bash
~/.config/macos/animations.sh status    # what is currently set
~/.config/macos/animations.sh disable
~/.config/macos/animations.sh enable    # back to macOS defaults
~/.config/macos/animations.sh toggle
```

`enable` deletes the keys rather than writing "on" values, so macOS falls back to
its own defaults instead of values the script guessed. It covers window
open/close (`NSAutomaticWindowAnimationsEnabled`), window resize timing
(`NSWindowResizeTime`), Dock launch/autohide, Mission Control, and Finder, then
restarts Dock and Finder. Apps read the global keys at launch, so restart them or
log out for the change to apply everywhere.

**Reduce Motion** is included, with a caveat: the plist write is accepted, but
the accessibility daemon caches the value, so it may not apply until you log out
and back in. The GUI toggle (System Settings → Accessibility → Display → Reduce
motion) takes effect immediately and is the reliable route. It is the single most
effective setting of the lot, and `enable` clears it, since restoring animations
means turning it off.

### Manual steps

1. **Accessibility permission** — AeroSpace cannot move windows without it:
   System Settings → Privacy & Security → Accessibility → enable AeroSpace.
2. **Karabiner-Elements** must be running for SUPER to exist, and needs Input
   Monitoring permission plus its driver extension approved. Launch
   Karabiner-Elements once and grant what it asks for.
3. **SF Pro font** — installs via a `.pkg` and needs a sudo password, so it can't run
   unattended: `brew install --cask font-sf-pro`. Until it's installed the bar falls back
   to Hack Nerd Font for text and the SF Symbols glyphs in `icons.sh` (Apple logo, popup
   menu icons) render as empty boxes.

### Editing the config

```bash
# after changing aerospace.toml
aerospace reload-config

# after changing anything under .config/sketchybar
sketchybar --reload

# after changing helper/*.c
make -C ~/.config/sketchybar/helper && sketchybar --reload
```

## Notes

- All configuration files are stored in this repository and symlinked to their proper locations
- The `.zshrc` includes Zinit plugin manager setup and various environment configurations
- Tmuxinator configurations include multiple pre-configured session layouts
- Make sure to backup existing configurations before stowing
- **Emacs**: Uses [Prelude](https://github.com/bbatsov/prelude) as the base distribution (installed separately by `setup.sh`). Personal config lives in `.emacs.d/personal/` and is symlinked into the Prelude directory by stow.

## Dependencies

Some configurations may require additional software:
- **Homebrew** (macOS): Package manager used in zsh configuration
- **Zinit**: Zsh plugin manager (auto-installed by .zshrc)
- **Oh My Posh**: Prompt theming (configured in .config/ohmyposh/)
- **Tmux**: Terminal multiplexer
- **Alacritty**: Terminal emulator