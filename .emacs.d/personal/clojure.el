(require 'cider)

(prelude-require-packages '(jet html-to-hiccup))



;;; CIDER

;; config
(setq-default ediff-ignore-similar-regions t)
(setq cider-eldoc-display-for-symbol-at-point nil
      cider-clojure-cli-global-options "-A:dev"
      cider-history-file (concat user-emacs-directory "cider-history")
      cider-repl-wrap-history t
      clojure-toplevel-inside-comment-form t
      cider-repl-history-file "~/.cider-repl-history"
      clojure-align-forms-automatically t
      diff-custom-diff-options "--suppress-common-lines"
      cider-save-file-on-load t
      cider-prompt-for-symbol nil
      nrepl-log-messages nil
      nrepl-hide-special-buffers t
      cider-font-lock-dynamically '(macro core function var)
      cider-repl-display-help-banner nil)

(add-hook 'cider-repl-mode-hook #'cider-company-enable-fuzzy-completion)
(add-hook 'cider-mode-hook #'cider-company-enable-fuzzy-completion)

;;support for guardrails
(put '>defn 'clojure-doc-string-elt 2)


;;; Portal
(defun portal.api/open ()
  (interactive)
  (cider-nrepl-sync-request:eval
   "(do (ns dev) (def portal ((requiring-resolve 'portal.api/open))) (add-tap (requiring-resolve 'portal.api/submit)))"))


(defun portal.api/clear ()
  (interactive)
  (cider-nrepl-sync-request:eval "(portal.api/clear)"))

(defun portal.api/close ()
  (interactive)
  (cider-nrepl-sync-request:eval "(portal.api/close)"))

(defun personal/insert-comment ()
  (interactive)
  (end-of-defun)
  (insert "\n")
  (insert "(comment\n  )\n")
  (clojure-backward-logical-sexp)
  (forward-char 1)
  (clojure-forward-logical-sexp)
  (insert "\n")
  (indent-according-to-mode))



;; Additional Hot Keys
(define-key cider-mode-map (kbd "C-c M-o") #'cider-repl-clear-buffer)
(define-key cider-mode-map (kbd "C-c M-S") #'cider-selector)
(define-key cider-mode-map (kbd "<tab>") #'company-indent-or-complete-common)

;; Font lock for >defn
(font-lock-add-keywords
 'clojure-mode
 '(("(\\(>defn\\)\\s-+\\(\\w+\\)"
    (1 font-lock-keyword-face)
    (2 font-lock-function-name-face))))
