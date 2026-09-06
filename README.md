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
│   ├── alacritty/          # Terminal emulator configuration
│   ├── claude/             # Claude Code configuration and data
│   ├── ohmyposh/           # Oh My Posh prompt theme configuration
│   ├── tmux/               # Tmux configuration files
│   └── tmuxinator/         # Tmuxinator session configurations
├── .emacs.d/               # Emacs configuration directory
├── .psqlrc                 # PostgreSQL configuration
├── .zshrc                  # Zsh shell configuration
│
├── omarchy/                # Omarchy (Linux) desktop config — separate package
├── omarchy-vm/             # VM-specific display/input tuning — opt-in
└── tools/                  # Helper scripts (not stowed)
```

Everything above `omarchy/` is the **root package**, stowed with `stow .` on
every platform. `omarchy/` and `omarchy-vm/` are **separate stow packages**
stowed by name on Linux only, so macOS never sees them — they're excluded from
`stow .` by `.stow-local-ignore`.

## Applications Configured

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
# Remove all symlinks from the root package
stow -D .

# Remove a platform package (Linux)
stow -D omarchy
stow -D omarchy-vm
```

## Notes

- All configuration files are stored in this repository and symlinked to their proper locations
- The `.zshrc` includes Zinit plugin manager setup and various environment configurations
- Tmuxinator configurations include multiple pre-configured session layouts
- Make sure to backup existing configurations before stowing
- **Emacs**: Uses [Prelude](https://github.com/bbatsov/prelude) as the base distribution (installed separately by `setup.sh`). Personal config lives in `.emacs.d/personal/` and is symlinked into the Prelude directory by stow.

## Omarchy (Linux)

`setup.sh` detects the OS: macOS gets the Homebrew installs, Linux gets the
equivalent `omarchy pkg add` set, then stows the `omarchy` package on top of the
root one.

```bash
./setup.sh                 # root package + omarchy package
DOTFILES_VM=1 ./setup.sh   # also stow omarchy-vm (see below)
```

Not in the Arch repos for aarch64: `pandoc`, `bun`, `clojure-lsp`. Install
those by hand if needed.

### Files the root package skips on Linux

These conflict on Omarchy and are macOS-specific or owned by the distro, so
`setup.sh` passes `--ignore` for them on Linux. They are untouched on macOS.

| File | Why |
|---|---|
| `.config/alacritty/alacritty.toml` | Omarchy's version imports the active theme's generated colors; the macOS one hardcodes them |
| `.bash_profile` | Omarchy ships its own in `/etc/skel` |
| `.config/tmux/tmux.conf` | same — and `tmux.conf` already sources `tmux.mac` / `tmux.linux` by `uname` |
| `.claude/settings.json` | hooks reference macOS-only tooling (`clj-paren-repair-claude-hook`) |
| `.emacs.d/personal/prelude-modules.el`, `preload/.gitkeep` | Prelude writes these directly |

Two gotchas worth knowing if you add to that list:

- **stow's ignore patterns.** A pattern containing `/` is matched against the
  full package-relative path; one without is matched against the basename.
  `--ignore='^alacritty$'` silently matches nothing. Always confirm with
  `stow -n -v` before trusting an ignore.
- **`--adopt` runs on macOS only.** It moves the file already on disk *into*
  the repo, which is right when a local app wrote it, and wrong on Omarchy
  where the conflicting file is a pristine `/etc/skel` copy — adopting there
  would overwrite the real macOS versions and push distro defaults everywhere.
  On Linux, plain stow aborts on conflict instead; resolve those by hand.

### What the `omarchy` package adds

| File | What it does |
|---|---|
| `.config/hypr/bindings.lua` | `SUPER+Z` / `SUPER+ALT+Z` window switcher bindings |
| `.config/hypr/looknfeel.lua` | Dims inactive windows (`dim_strength = 0.30`), scratchpad exempt |
| `.config/omarchy/shell.json` | Bar layout: clock format, Tailscale widget |
| `.config/omarchy/themed/fuzzel.ini.tpl` | Makes fuzzel follow the active Omarchy theme |
| `.config/omarchy/themed/omarchy-colors.el.tpl` | Emacs colors from the active theme |
| `.config/omarchy/backgrounds/catppuccin/` | Generated wallpapers |
| `.local/bin/window-switcher` | fuzzel-based window switcher |

### `omarchy-vm` — opt in only

Tuned for an **aarch64 QEMU VM on Apple Silicon**, and wrong on real hardware:

- `monitors.lua` hardcodes `scale = 2` / `GDK_SCALE=2` and branches on the
  `omarchy.qemu_virgl=1` kernel option. Omarchy regenerates this for the real
  display; forcing it gives you wrong scaling.
- `input.lua` sets `scroll_factor = 0.3`, because the VM's trackpad arrives as
  `qemu-virtio-tablet` (an absolute pointer), so `input.touchpad.*` and
  `accel_profile` don't apply. On a laptop you want the touchpad settings.

### Window switcher

```
window-switcher           # current workspace       (SUPER+Z)
window-switcher --all     # all workspaces + scratchpad  (SUPER+ALT+Z)
```

Focuses via `hyprctl dispatch "hl.dsp.focus({ window = \"address:…\" })"`.
Omarchy's Hyprland parses dispatch arguments as **Lua**, so the plain
`hyprctl dispatch focuswindow address:…` form fails.

Don't bother with `hyprpm` plugins that register custom dispatchers (e.g.
`hyprland-easymotion`) — they build and load, but are unreachable from the Lua
config layer: `hl.dsp` is a fixed table of built-ins, `hyprctl keyword` is
rejected with *"keyword can't work with non-legacy parsers"*, and `hl.plugin`
exposes only `load`.

### Wallpapers

```bash
cd tools
python3 gen_cyberpunk.py 7 > /tmp/w.svg && rsvg-convert -w 3456 -h 2170 -o out.png /tmp/w.svg
python3 gen_geometric.py 3 > /tmp/w.svg && rsvg-convert -w 3456 -h 2170 -o out.png /tmp/w.svg
```

The argument is a seed — change it to re-roll the skyline, star field, and
scattered elements while keeping the Catppuccin palette. `W, H` at the top of
each script set the resolution. Needs `librsvg`. Cycle with
`omarchy theme bg next`.

## Dependencies

Some configurations may require additional software:
- **Homebrew** (macOS): Package manager used in zsh configuration
- **Zinit**: Zsh plugin manager (auto-installed by .zshrc)
- **Oh My Posh**: Prompt theming (configured in .config/ohmyposh/)
- **Tmux**: Terminal multiplexer
- **Alacritty**: Terminal emulator