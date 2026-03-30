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

# Install Prelude (Emacs distribution) if not already present
if [ ! -d "$HOME/.emacs.d/.git" ]; then
  echo "Installing Emacs Prelude..."
  git clone https://github.com/bbatsov/prelude.git "$HOME/.emacs.d"
else
  echo "Emacs Prelude already installed, skipping."
fi

# Stow all dotfiles
echo "Stowing dotfiles..."
cd "$DOTFILES_DIR"
stow --target="$HOME" .

echo "Done. Restart your shell or run: source ~/.zshrc"
