(use-package claude-code-ide
  :vc (:url "https://github.com/manzaltu/claude-code-ide.el" :rev :newest)
  :bind ("C-c C-'" . claude-code-ide-menu) ; Set your favorite keybinding
  :config
  ;; Use eat instead of vterm
  (setq claude-code-ide-terminal-backend 'eat)
  (add-hook 'eat-mode-hook (lambda () (display-line-numbers-mode -1)))

  ;;(add-hook 'vterm-mode-hook (lambda () (display-line-numbers-mode -1)))
  (claude-code-ide-emacs-tools-setup)) ; Optionally enable Emacs MCP tools
