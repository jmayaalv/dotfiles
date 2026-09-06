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

`setup.sh` installs [GNU Stow](https://www.gnu.org/software/stow/) itself — it
is listed in both `tools/Brewfile` and `tools/packages.txt`. All you need first
is the platform's package manager:

- **macOS**: [Homebrew](https://brew.sh)
- **Omarchy / Arch**: nothing extra; `omarchy pkg add` or `pacman` is already there

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
   - Install packages — `tools/Brewfile` on macOS, `tools/packages.txt` on Linux
   - Install developer tooling with `mise install` from `.config/mise/config.toml`
   - Clone [Emacs Prelude](https://github.com/bbatsov/prelude) into `~/.emacs.d/` (if not already installed)
   - Clone [TPM](https://github.com/tmux-plugins/tpm) for tmux plugins
   - Run `stow .` to symlink all configurations, plus `stow omarchy` on Linux

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

### How packages are remembered

Two layers, deliberately separate:

| Layer | Managed by | Scope | Where |
|---|---|---|---|
| Developer tooling — clojure, java, node, gh, claude, codex | **mise** | both platforms | `.config/mise/config.toml` |
| System & desktop packages | pacman | Linux | `tools/packages.txt` |
| System & desktop packages | Homebrew | macOS | `tools/Brewfile` |

**mise owns the dev tools.** It works identically on macOS and Linux, so
versions are defined once and `setup.sh` runs `mise install` on both. Don't add
these to the OS package lists — `gh` installed via pacman or brew is just
shadowed by mise's copy on `PATH` anyway.

**The OS package lists are generated**, not hand-maintained. One command on
either platform:

```bash
tools/save-packages           # rewrite the list for this machine
tools/save-packages --check   # report anything installed but not recorded
```

On macOS that runs `brew bundle dump`; on Linux it computes the pacman delta
described below. `setup.sh` consumes whichever applies.

It records only what this machine has *beyond a stock Omarchy install*, by
diffing `pacman -Qqe` against Omarchy's own `omarchy-*.packages` manifests, the
`base`/`base-devel` groups, and a small list of Arch-ARM base packages that
Omarchy's x86 manifests don't mention. Hand-edits survive regeneration — the
file is rebuilt from the union of the computed delta and what's already
committed, so a package missing on one machine isn't dropped for the others.

Run `tools/save-packages` after installing something you want everywhere, and
commit the result.

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

### VPN

`SUPER+SHIFT+V` toggles the NetworkManager VPN, and a bar widget shows its
state — full brightness when connected, dimmed when not. Both run the same
`vpn-toggle` script, so they cannot disagree.

```
vpn-toggle              # toggle the default connection (kane-fra)
vpn-toggle other-vpn    # toggle a different one
vpn-toggle --status     # prints "up  10.0.110.2" or "down"
```

The widget is a user plugin at `.config/omarchy/plugins/jmayaalv.vpn/`. Its
connection name comes from `shell.json`, so pointing it elsewhere needs no code
change:

```json
{ "id": "jmayaalv.vpn", "connection": "kane-fra" }
```

Left or right click toggles; middle click opens `nm-connection-editor`.

#### Split tunnelling

The server pushes `redirect-gateway`, so by default the tunnel takes a default
route at metric 50 and *all* traffic leaves through Frankfurt — which shows up
as the weather widget reporting the wrong city, and every site geolocating you
to the exit node. It also pushes the internal `10.17.x` subnets separately, so
the default route can be dropped without losing access to anything:

```bash
nmcli connection modify kane-fra ipv4.never-default yes
nmcli connection modify kane-fra ipv6.never-default yes
```

General traffic then uses the normal interface while internal subnets still go
over the tunnel.

Note this also stops systemd-resolved sending any queries to the VPN's DNS
server, since the link no longer carries a default route and the server pushes
no search domain. Internal hosts stay reachable by IP. To resolve internal
*names* too, add the internal zone as a routing domain — the `~` prefix routes
queries there without appending it as a search suffix:

```bash
nmcli connection modify kane-fra ipv4.dns-search "~internal.example.com"
```

The NetworkManager profile itself is machine-local and not in this repo (it
holds the password). On a new machine, re-import the `.ovpn` and re-apply the
settings above.

Two things learned building it, worth keeping:

- **Omarchy has no secret agent.** The bar is Quickshell, not GNOME Shell or
  `nm-applet`, so a VPN profile with `password-flags=1` (agent-owned) can never
  be given its password — activation fails with *"No agents were available"*.
  Set `password-flags=0` so NetworkManager stores the secret itself.
- **`omarchy-shell shell rescanPlugins` does not reload edited QML** when the
  plugin directory is a symlink into this repo. Use `omarchy restart shell`
  after changing widget code.

### Emacs

The Prelude config in `.emacs.d/personal/` is shared with macOS. Two files are
Linux-only and live in the `omarchy` package instead:

- `omarchy.el` — shim that loads `/usr/share/omarchy-emacs/config/omarchy.el`,
  giving live theme and font sync with the desktop. Kept as a shim so package
  upgrades propagate without edits here.
- `omarchy-keys.el` — re-homes the seven Prelude `s-` bindings Hyprland
  swallows into free `C-c` slots.

Two traps worth remembering:

- **`prelude-modules.el` must be the version in this repo.** Prelude's stock
  default omits `prelude-clojure`, so cider never installs, and
  `personal/clojure.el` then throws on `(require 'cider)`. Prelude loads the
  personal files with `mapc`, so that error aborts the loop and *every file
  after `clojure.el` alphabetically silently fails to load* — `macos.el`,
  `omarchy*.el`, `ui.el` and the rest. Symptom: most of your config quietly
  missing, with no visible error outside `--debug-init`.
- **`macos.el` is guarded by `(eq system-type 'darwin)`.** It sets
  `trash-directory` to `~/.Trash`, which on Linux would send Emacs deletions
  somewhere Files and `gio trash` never look. `delete-by-moving-to-trash` stays
  on for both platforms; leaving `trash-directory` nil on Linux gets the
  freedesktop trash.

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