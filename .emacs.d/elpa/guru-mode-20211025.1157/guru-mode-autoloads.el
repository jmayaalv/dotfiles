;;; guru-mode-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "guru-mode" "../../../../../.emacs.d/elpa/guru-mode-20211025.1157/guru-mode.el"
;;;;;;  "ee218c52f25fa7744ea756632b41aa8d")
;;; Generated autoloads from ../../../../../.emacs.d/elpa/guru-mode-20211025.1157/guru-mode.el

(autoload 'guru-mode "guru-mode" "\
A minor mode that teaches you to use Emacs effectively.

If called interactively, enable Guru mode if ARG is positive, and
disable it if ARG is zero or negative.  If called from Lisp, also
enable the mode if ARG is omitted or nil, and toggle it if ARG is
`toggle'; disable the mode otherwise.

\(fn &optional ARG)" t nil)

(put 'guru-global-mode 'globalized-minor-mode t)

(defvar guru-global-mode nil "\
Non-nil if Guru-Global mode is enabled.
See the `guru-global-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `guru-global-mode'.")

(custom-autoload 'guru-global-mode "guru-mode" nil)

(autoload 'guru-global-mode "guru-mode" "\
Toggle Guru mode in all buffers.
With prefix ARG, enable Guru-Global mode if ARG is positive;
otherwise, disable it.  If called from Lisp, enable the mode if
ARG is omitted or nil.

Guru mode is enabled in all buffers where
`guru-mode' would do it.
See `guru-mode' for more information on Guru mode.

\(fn &optional ARG)" t nil)

;;;### (autoloads "actual autoloads are elsewhere" "guru-mode" "../../../../../.emacs.d/elpa/guru-mode-20211025.1157/guru-mode.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from ../../../../../.emacs.d/elpa/guru-mode-20211025.1157/guru-mode.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "guru-mode" '("guru-")))

;;;***

;;;***

;;;### (autoloads nil nil ("../../../../../.emacs.d/elpa/guru-mode-20211025.1157/guru-mode-autoloads.el"
;;;;;;  "../../../../../.emacs.d/elpa/guru-mode-20211025.1157/guru-mode.el")
;;;;;;  (0 0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; guru-mode-autoloads.el ends here
