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

- `.config/aerospace/aerospace.toml` — window manager: gaps, bindings, per-app float rules,
  workspace-to-monitor assignment. Starts SketchyBar and `borders` on launch and pushes a
  `aerospace_workspace_change` event to SketchyBar on every workspace switch.
- `.config/sketchybar/sketchybarrc` — bar appearance and item load order.
- `.config/sketchybar/colors.sh` — Catppuccin Macchiato palette.
- `.config/sketchybar/icons.sh` — SF Symbols glyphs (needs SF Pro installed).
- `.config/sketchybar/items/` — one file per bar item.
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

`alt` is the modifier throughout.

| Binding | Action |
|---|---|
| `alt-h/j/k/l` | Focus left/down/up/right |
| `alt-shift-h/j/k/l` | Move window left/down/up/right |
| `alt-shift-<arrow>` | Join with window in that direction |
| `alt-1..4` | Switch to workspace |
| `alt-shift-1..4` | Move window to workspace and follow it |
| `alt-tab` | Back and forth between last two workspaces |
| `alt-shift-tab` | Move current workspace to the next monitor |
| `alt-slash` | Toggle tiles horizontal/vertical |
| `alt-comma` | Toggle accordion horizontal/vertical |
| `alt-shift-minus` / `alt-shift-equal` | Resize -50 / +50 |
| `alt-ctrl-f` | Toggle floating/tiling |
| `alt-ctrl-shift-f` | Fullscreen |
| `alt-shift-semicolon` | Enter *service* mode |
| `alt-shift-enter` | Enter *apps* mode |

**Service mode** (`alt-shift-semicolon`): `esc` reload config · `r` reset layout ·
`f` toggle float · `backspace` close all windows but current.

**Apps mode** (`alt-shift-enter`, then one key): `a` Alacritty · `e` Emacs · `o` Obsidian ·
`f` Firefox · `s` Slack · `t` Telegram · `c` Chrome · `m` Mail · `esc` cancel.

### Manual steps

1. **Accessibility permission** — AeroSpace cannot move windows without it:
   System Settings → Privacy & Security → Accessibility → enable AeroSpace.
2. **SF Pro font** — installs via a `.pkg` and needs a sudo password, so it can't run
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