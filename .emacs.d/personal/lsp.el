(prelude-require-packages '(lsp-mode consult-lsp lsp-treemacs))
(require 'cider)
(require 'lsp)

(defun find-definition ()
  "Try to find definition of cursor via LSP otherwise fallback to cider."
  (interactive)
  (let ((cursor (point))
        (buffer (current-buffer)))
    (lsp-find-definition)
    ;;(when (and (eq buffer (current-buffer))
               ;;(eq cursor (point)))
    ;;(cider-find-var))
    ))

;; Better find definition
(define-key clojure-mode-map (kbd "M-.") #'find-definition)
(define-key cider-mode-map (kbd "M-.") #'find-definition)
(define-key clojurec-mode-map (kbd "M-.") #'find-definition)
(define-key clojurescript-mode-map (kbd "M-.") #'find-definition)

(add-hook 'clojure-mode-hook #'lsp)
(add-hook 'clojurec-mode-hook #'lsp)
(add-hook 'clojurescript-mode-hook #'lsp)

;; Path for lsp
(setenv "PATH" (concat "/opt/homebrew/bin" path-separator  (getenv "PATH")))

(dolist (m '(clojure-mode
             clojurec-mode
             clojurescript-mode
             clojurex-mode))
  (add-to-list 'lsp-language-id-configuration `(,m . "clojure")))

(set-face-foreground 'lsp-face-highlight-textual nil)
(set-face-background 'lsp-face-highlight-textual nil)
(set-face-attribute 'lsp-face-highlight-textual nil :weight 'extra-bold)
(set-face-attribute 'lsp-face-highlight-textual nil :underline t)

(setq gc-cons-threshold (* 100 1024 1024)
                lsp-keymap-prefix "s-l"
                read-process-output-max (* 1024 1024)
                lsp-file-watch-threshold 10000
                ;;lsp-idle-delay 0.5
                lsp-modeline-diagnostics-enable t
                company-idle-delay 0.5
                company-minimum-prefix-length 1
                treemacs-space-between-root-nodes nil
                lsp-lens-enable t
                lsp-semantic-tokens-enable nil
                lsp-signature-auto-activate t
                lsp-signature-render-documentation t
                lsp-clojure-server-command '("bash" "-c" "clojure-lsp")
                lsp-enable-indentation nil
                lsp-headerline-breadcrumb-enable nil
                lsp-completion-provider :capf
                lsp-enable-symbol-highlighting t
                ;; lsp-enable-completion-at-point nil ;; uncomment to use cider completion instead of lsp
                ;;lsp-diagnostics-provider :none
                lsp-eldoc-enable-hover t
                lsp-log-io nil
                cljr-add-ns-to-blank-clj-files nil ;; disable clj-refactor adding ns to blank files
                cljr-magic-requires nil ;; temp disable to avoid problem with trade component
                lsp-enable-which-key-integration  t)
