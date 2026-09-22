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
│   ├── karabiner/          # Karabiner-Elements key remapping
│   ├── macos/              # macOS system tweaks (animations on/off)
│   ├── ohmyposh/           # Oh My Posh prompt theme configuration
│   ├── tmux/               # Tmux configuration files
│   └── tmuxinator/         # Tmuxinator session configurations
├── .emacs.d/               # Emacs configuration directory
├── .psqlrc                 # PostgreSQL configuration
└── .zshrc                  # Zsh shell configuration
```

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
# Remove all symlinks
stow -D .

# Remove specific configuration
stow -D .config
```

## macOS animations

macOS UI animations mostly add latency. `.config/macos/animations.sh` turns them
off and back on:

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