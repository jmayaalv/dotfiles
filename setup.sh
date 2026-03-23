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

# Install Bitbucket CLI
if command -v bb &>/dev/null; then
  echo "Bitbucket CLI already installed, skipping."
else
  echo "Installing Bitbucket CLI..."
  brew install philipkram/tap/bb
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

echo "Done. Restart your shell or run: source ~/.zshrc"
