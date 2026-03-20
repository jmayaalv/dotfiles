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