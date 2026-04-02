(use-package monet
  :vc (:url "https://github.com/stevemolitor/monet" :rev :newest)
  :config
  (setq monet-diff-tool #'monet-ediff-tool)
  (setq monet-diff-cleanup-tool #'monet-ediff-cleanup-tool)
  ())



;; install required inheritenv dependency:
(use-package inheritenv
  :vc (:url "https://github.com/purcell/inheritenv" :rev :newest))

;; for eat terminal backend:
(use-package eat :ensure t)


(unless (package-installed-p 'claude-code)
  (package-vc-install "https://github.com/stevemolitor/claude-code.el"))

(use-package claude-code :ensure t
   :config
   ;;(add-hook 'claude-code-process-environment-functions #'monet-start-server-function)
   (setq claude-code-terminal-backend 'eat)
   (setq claude-code-display-window-fn
         (lambda (buffer)
           (display-buffer buffer '((display-buffer-below-selected)
                                    (window-height . 0.4)))))
   (monet-mode 1)
   (claude-code-mode)
   :bind-keymap ("C-c c" . claude-code-command-map)
   :bind
   (:repeat-map my-claude-code-map ("M" . claude-code-cycle-mode)))


(add-hook 'claude-code-start-hook
          (lambda ()
            (setq-local line-spacing 0.1)
            (setq-local truncate-lines t)))
