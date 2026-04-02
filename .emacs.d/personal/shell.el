(add-hook 'vterm-mode-hook (lambda ()
                             (display-line-numbers-mode -1)
                             (setq-local blink-cursor-mode nil)))

(add-hook 'eat-mode-hook (lambda ()
                           (display-line-numbers-mode -1)
                           (setq-local truncate-lines t)
                           (setq-local cursor-type nil)))

;;(setq eat-minimum-latency 0.033
      ;;eat-maximum-latency 0.1)
