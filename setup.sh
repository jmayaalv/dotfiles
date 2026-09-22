#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Setting up dotfiles from $DOTFILES_DIR..."

# Install GitHub CLI
if command -v gh &>/dev/null; then
  echo "GitHub CLI already installed, skipping."
else
  echo "Installing GitHub CLI..."
  brew install gh
fi

# Install pandoc
if command -v pandoc &>/dev/null; then
  echo "pandoc already installed, skipping."
else
  echo "Installing pandoc..."
  brew install pandoc
fi

# Install Fira Code font
if fc-list | grep -qi "Fira Code"; then
  echo "Fira Code font already installed, skipping."
else
  echo "Installing Fira Code font..."
  brew install --cask font-fira-code
fi

# Install Bun
if command -v bun &>/dev/null; then
  echo "Bun already installed, skipping."
else
  echo "Installing Bun..."
  brew tap oven-sh/bun && brew install bun
fi

# Install Leiningen
if command -v lein &>/dev/null; then
  echo "Leiningen already installed, skipping."
else
  echo "Installing Leiningen..."
  brew install leiningen
fi

# Install bat
if command -v bat &>/dev/null; then
  echo "bat already installed, skipping."
else
  echo "Installing bat..."
  brew install bat
fi

# Install libvterm (needed by Emacs vterm)
if brew list libvterm &>/dev/null; then
  echo "libvterm already installed, skipping."
else
  echo "Installing libvterm..."
  brew install libvterm
fi

# Install cmake (needed to build vterm module)
if command -v cmake &>/dev/null; then
  echo "cmake already installed, skipping."
else
  echo "Installing cmake..."
  brew install cmake
fi

# Install clojure-lsp
if command -v clojure-lsp &>/dev/null; then
  echo "clojure-lsp already installed, skipping."
else
  echo "Installing clojure-lsp..."
  brew install clojure-lsp/brew/clojure-lsp-native
fi

# Claude usage monitoring. Claude Usage is a menu bar app reading the real
# 5-hour, weekly and per-model limits; ccusage is the CLI behind the Raycast
# "Claude Usage (ccusage)" extension, which parses the local Claude Code logs.
# The Raycast extension itself installs from the Raycast store, not from here.
if [ -d "/Applications/Claude Usage.app" ]; then
  echo "Claude Usage already installed, skipping."
else
  echo "Installing Claude Usage..."
  brew install --cask hamed-elfayome/claude-usage/claude-usage-tracker
fi

if command -v ccusage &>/dev/null; then
  echo "ccusage already installed, skipping."
else
  echo "Installing ccusage..."
  brew install ccusage
fi

# Install the Claude Code statusline script. ~/.claude is not stowed (Claude Code
# writes into it), so this is copied rather than symlinked.
if [ -d "$HOME/.claude" ]; then
  echo "Installing Claude Code statusline script..."
  cp "$DOTFILES_DIR/.claude/statusline-command.sh" "$HOME/.claude/statusline-command.sh"
fi

# Put personal scripts on PATH. ~/.local/bin already holds real, untracked files
# (clj-nrepl-eval and friends), so it is not a stow package; each script is
# symlinked into it individually instead.
echo "Linking personal scripts into ~/.local/bin..."
mkdir -p "$HOME/.local/bin"
for script in "$DOTFILES_DIR"/.config/scripts/*; do
  [ -f "$script" ] || continue
  target="$HOME/.local/bin/$(basename "$script")"
  if [ -L "$target" ] && [ "$(readlink "$target")" = "$script" ]; then
    echo "  $(basename "$script") already linked, skipping."
  elif [ -e "$target" ] && [ ! -L "$target" ]; then
    echo "  $(basename "$script") exists in ~/.local/bin as a real file, leaving it alone."
  else
    ln -sfn "$script" "$target"
    echo "  linked $(basename "$script")"
  fi
done

# Install Prelude (Emacs distribution) if not already present
if [ ! -d "$HOME/.emacs.d/.git" ]; then
  echo "Installing Emacs Prelude..."
  git clone https://github.com/bbatsov/prelude.git "$HOME/.emacs.d"
else
  echo "Emacs Prelude already installed, skipping."
fi

# Install TPM (Tmux Plugin Manager)
if [ -d "$HOME/.tmux/plugins/tpm" ]; then
  echo "TPM already installed, skipping."
else
  echo "Installing TPM..."
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

# Stow all dotfiles
echo "Stowing dotfiles..."
cd "$DOTFILES_DIR"
stow --target="$HOME" .

# Adopt any real files that should be managed by stow.
# This handles the case where directories like ~/.emacs.d/personal/ already exist
# (e.g. from Prelude clone) and files were created there directly instead of in the
# dotfiles repo. --adopt moves the real file into the repo and replaces it with a symlink.
echo "Adopting any unmanaged files into stow..."
stow --adopt --target="$HOME" .

echo "Done. Restart your shell or run: source ~/.zshrc"
