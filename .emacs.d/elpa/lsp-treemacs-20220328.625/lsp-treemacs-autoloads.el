;;; lsp-treemacs-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "lsp-treemacs" "../../../../../.emacs.d/elpa/lsp-treemacs-20220328.625/lsp-treemacs.el"
;;;;;;  "d6749c2bc7568caaab0f59a8fb0789e3")
;;; Generated autoloads from ../../../../../.emacs.d/elpa/lsp-treemacs-20220328.625/lsp-treemacs.el

(autoload 'lsp-treemacs-symbols "lsp-treemacs" "\
Show symbols view." t nil)

(autoload 'lsp-treemacs-java-deps-list "lsp-treemacs" "\
Display java dependencies." t nil)

(autoload 'lsp-treemacs-java-deps-follow "lsp-treemacs" nil t nil)

(defvar lsp-treemacs-sync-mode nil "\
Non-nil if Lsp-Treemacs-Sync mode is enabled.
See the `lsp-treemacs-sync-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `lsp-treemacs-sync-mode'.")

(custom-autoload 'lsp-treemacs-sync-mode "lsp-treemacs" nil)

(autoload 'lsp-treemacs-sync-mode "lsp-treemacs" "\
Global minor mode for synchronizing lsp-mode workspace folders and treemacs projects.

If called interactively, enable Lsp-Treemacs-Sync mode if ARG is
positive, and disable it if ARG is zero or negative.  If called
from Lisp, also enable the mode if ARG is omitted or nil, and
toggle it if ARG is `toggle'; disable the mode otherwise.

\(fn &optional ARG)" t nil)

(autoload 'lsp-treemacs-references "lsp-treemacs" "\
Show the references for the symbol at point.
With a prefix argument, select the new window and expand the tree of references automatically.

\(fn ARG)" t nil)

(autoload 'lsp-treemacs-implementations "lsp-treemacs" "\
Show the implementations for the symbol at point.
With a prefix argument, select the new window expand the tree of implementations automatically.

\(fn ARG)" t nil)

(autoload 'lsp-treemacs-call-hierarchy "lsp-treemacs" "\
Show the incoming call hierarchy for the symbol at point.
With a prefix argument, show the outgoing call hierarchy.

\(fn OUTGOING)" t nil)

(autoload 'lsp-treemacs-type-hierarchy "lsp-treemacs" "\
Show the type hierarchy for the symbol at point.
With prefix 0 show sub-types.
With prefix 1 show super-types.
With prefix 2 show both.

\(fn DIRECTION)" t nil)

(autoload 'lsp-treemacs-errors-list "lsp-treemacs" nil t nil)

;;;### (autoloads "actual autoloads are elsewhere" "lsp-treemacs"
;;;;;;  "../../../../../.emacs.d/elpa/lsp-treemacs-20220328.625/lsp-treemacs.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from ../../../../../.emacs.d/elpa/lsp-treemacs-20220328.625/lsp-treemacs.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "lsp-treemacs" '("lsp-treemacs-")))

;;;***

;;;***

;;;### (autoloads "actual autoloads are elsewhere" "lsp-treemacs-themes"
;;;;;;  "../../../../../.emacs.d/elpa/lsp-treemacs-20220328.625/lsp-treemacs-themes.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from ../../../../../.emacs.d/elpa/lsp-treemacs-20220328.625/lsp-treemacs-themes.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "lsp-treemacs-themes" '("lsp-treemacs-theme")))

;;;***

;;;### (autoloads nil nil ("../../../../../.emacs.d/elpa/lsp-treemacs-20220328.625/lsp-treemacs-autoloads.el"
;;;;;;  "../../../../../.emacs.d/elpa/lsp-treemacs-20220328.625/lsp-treemacs-pkg.el"
;;;;;;  "../../../../../.emacs.d/elpa/lsp-treemacs-20220328.625/lsp-treemacs-themes.el"
;;;;;;  "../../../../../.emacs.d/elpa/lsp-treemacs-20220328.625/lsp-treemacs.el")
;;;;;;  (0 0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; lsp-treemacs-autoloads.el ends here
