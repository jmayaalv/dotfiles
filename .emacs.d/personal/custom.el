(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("f654d73d7a0761cc4f7d99fffe4b16fce1b2d95844f37bc786e455cec744ac75"
     "c4df9006b9eb32599d758800a32f3487c2cdf13826084511783b47d419024af2"
     "f9d423fcd4581f368b08c720f04d206ee80b37bfb314fa37e279f554b6f415e9"
     "ba98102679e7ed71a0b79c9a490328370b6b20537e04730bf0028bdd8a2418a9"
     default))
 '(package-selected-packages '(hurl-mode monet))
 '(package-vc-selected-packages
   '((claude-code :vc-backend Git :url
                  "https://github.com/stevemolitor/claude-code.el")
     (monet :url "https://github.com/stevemolitor/monet")
     (hurl-mode :vc-backend Git :url
                "https://github.com/JasZhe/hurl-mode")
     (claude-code-ide :url
                      "https://github.com/manzaltu/claude-code-ide.el")))
 '(safe-local-variable-values
   '((cider-clojure-cli-global-options . "-A:dev")
     (cider-project-root . "/Users/jmayaalv/Developer/ms-edge/edge")
     (cider-preferred-build-tool . "lein")
     (cider-clojure-cli-global-options
      . "-A:dev -J-Dguardrails.enabled")
     (cider-ns-refresh-after-fn . "user/start")
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
