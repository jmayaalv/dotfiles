(global-unset-key (kbd "C-c a"))

(use-package agent-shell
  :ensure t
  :ensure-system-package
  ;; Add agent installation configs here
  ((claude . "brew install claude-code")
   (claude-agent-acp . "npm install -g @agentclientprotocol/claude-agent-acp"))
  :bind
  ("C-c a s" . agent-shell)
  ("C-c a d" . agent-shell-send-dwim)
  :config
  (setq agent-shell-preferred-agent-config (agent-shell-anthropic-make-claude-code-config)))
