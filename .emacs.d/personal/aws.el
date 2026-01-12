(prelude-require-package 'kubed)

(defun kubed-switch-context (context)
  "Switch kubectl context interactively"
  (interactive
   (list (completing-read "Context: "
                          (split-string (shell-command-to-string "kubectl config get-contexts -o name")))))
  (shell-command (format "kubectl config use-context %s" context))
  (setopt kubed-default-context-and-namespace (cons context "default"))
  (message "Switched to context: %s" context))

(use-package kubed
  :bind ("C-c M-k k" . kubed-prefix-map)
  :config
  (setopt kubed-default-context-and-namespace nil)
  (define-key kubed-prefix-map (kbd "C-s") #'kubed-switch-context))

(add-hook 'shell-mode-hook
          (lambda ()
            (define-key shell-mode-map (kbd "TAB") 'completion-at-point)))


