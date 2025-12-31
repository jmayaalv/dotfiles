(prelude-require-package 'kubed)

(use-package kubed
  :bind ("C-c M-k k" . kubed-prefix-map))

(add-hook 'shell-mode-hook
          (lambda ()
            (define-key shell-mode-map (kbd "TAB") 'completion-at-point)))
