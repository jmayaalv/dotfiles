(prelude-require-package 'restclient)
(add-to-list 'auto-mode-alist '("\\.rest\\'" . restclient-mode))

;; Requires brew install hurl
;;(package-vc-install "https://github.com/JasZhe/hurl-mode")
(use-package hurl-mode :mode "\\.hurl\\'")
