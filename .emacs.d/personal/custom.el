(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("f9d423fcd4581f368b08c720f04d206ee80b37bfb314fa37e279f554b6f415e9"
     "ba98102679e7ed71a0b79c9a490328370b6b20537e04730bf0028bdd8a2418a9"
     default))
 '(package-selected-packages
   '(ag all-the-icons anzu beacon browse-kill-ring catppuccin-theme cider
        claude-code claude-code-ide clojure-snippets company
        consult-lsp crux csv-mode diff-hl diminish dimmer dirvish
        discover discover-my-major dockerfile-mode doom-modeline
        easy-kill eat elisp-slime-nav epl exec-path-from-shell
        expand-region flycheck gist git-modes git-timemachine
        gnu-elpa-keyring-update guru-mode helm hl-todo html-to-hiccup
        hurl-mode imenu-anywhere jet js2-mode json-mode key-chord
        kubed linkin-org lsp-mode lsp-treemacs magit move-text nlinum
        operate-on-number orderless projectile rainbow-delimiters
        rainbow-mode restclient smartparens smartrep super-save
        transient try undo-tree vertico volatile-highlights vterm
        web-mode web-server yaml-mode zenburn-theme zop-to-char))
 '(package-vc-selected-packages
   '((claude-code :url "https://github.com/stevemolitor/claude-code.el")
     (hurl-mode :vc-backend Git :url
                "https://github.com/JasZhe/hurl-mode")
     (claude-code-ide :url
                      "https://github.com/manzaltu/claude-code-ide.el")))
 '(safe-local-variable-values
   '((cider-ns-refresh-after-fn . "user/start")
     (cider-ns-refresh-before-fn . "user/stop")
     (projectile-grep-default-files quote ("*.clj" "*.cljs" "*.cljc"))
     (cider-inject-dependencies-at-startup)
     (cider-repl-set-type . "clojure-cli")
     (cider-preferred-build-tool . "clojure-cli"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cider-test-failure-face ((t (:foreground "#ed8796"))))
 '(cider-test-success-face ((t (:foreground "#a6da95"))))
 '(clojure-keyword-face ((t (:foreground "#f5e0dc" :weight normal))))
 '(font-lock-type-face ((t (:foreground "#f5e0dc")))))
