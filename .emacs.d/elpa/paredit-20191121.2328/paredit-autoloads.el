;;; paredit-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "paredit" "../../../../../.emacs.d/elpa/paredit-20191121.2328/paredit.el"
;;;;;;  "7f0d8daf49bb1aa4db5ce72cd8a9a365")
;;; Generated autoloads from ../../../../../.emacs.d/elpa/paredit-20191121.2328/paredit.el

(autoload 'paredit-mode "paredit" "\
Minor mode for pseudo-structurally editing Lisp code.
With a prefix argument, enable Paredit Mode even if there are
  unbalanced parentheses in the buffer.
Paredit behaves badly if parentheses are unbalanced, so exercise
  caution when forcing Paredit Mode to be enabled, and consider
  fixing unbalanced parentheses instead.
\\<paredit-mode-map>

If called interactively, enable Paredit mode if ARG is positive,
and disable it if ARG is zero or negative.  If called from Lisp,
also enable the mode if ARG is omitted or nil, and toggle it if
ARG is `toggle'; disable the mode otherwise.

\(fn &optional ARG)" t nil)

(autoload 'enable-paredit-mode "paredit" "\
Turn on pseudo-structural editing of Lisp code." t nil)

;;;### (autoloads "actual autoloads are elsewhere" "paredit" "../../../../../.emacs.d/elpa/paredit-20191121.2328/paredit.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from ../../../../../.emacs.d/elpa/paredit-20191121.2328/paredit.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "paredit" '("?\\" "disable-paredit-mode" "paredit-")))

;;;***

;;;***

;;;### (autoloads nil nil ("../../../../../.emacs.d/elpa/paredit-20191121.2328/paredit-autoloads.el"
;;;;;;  "../../../../../.emacs.d/elpa/paredit-20191121.2328/paredit.el")
;;;;;;  (0 0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; paredit-autoloads.el ends here
