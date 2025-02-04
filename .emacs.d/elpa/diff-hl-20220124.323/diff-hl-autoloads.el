;;; diff-hl-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "diff-hl" "../../../../../.emacs.d/elpa/diff-hl-20220124.323/diff-hl.el"
;;;;;;  "51db11325dbf33021e206b9f2eae2902")
;;; Generated autoloads from ../../../../../.emacs.d/elpa/diff-hl-20220124.323/diff-hl.el

(autoload 'diff-hl-mode "diff-hl" "\
Toggle VC diff highlighting.

If called interactively, enable Diff-Hl mode if ARG is positive,
and disable it if ARG is zero or negative.  If called from Lisp,
also enable the mode if ARG is omitted or nil, and toggle it if
ARG is `toggle'; disable the mode otherwise.

\(fn &optional ARG)" t nil)

(autoload 'turn-on-diff-hl-mode "diff-hl" "\
Turn on `diff-hl-mode' or `diff-hl-dir-mode' in a buffer if appropriate." nil nil)

(autoload 'diff-hl--global-turn-on "diff-hl" "\
Call `turn-on-diff-hl-mode' if the current major mode is applicable." nil nil)

(autoload 'diff-hl-set-reference-rev "diff-hl" "\
Set the reference revision globally to REV.
When called interactively, REV read with completion.

The default value chosen using one of methods below:

- In a log view buffer, it uses the revision of current entry.
Call `vc-print-log' or `vc-print-root-log' first to open a log
view buffer.
- In a VC annotate buffer, it uses the revision of current line.
- In other situations, it uses the symbol at point.

Notice that this sets the reference revision globally, so in
files from other repositories, `diff-hl-mode' will not highlight
changes correctly, until you run `diff-hl-reset-reference-rev'.

Also notice that this will disable `diff-hl-amend-mode' in
buffers that enables it, since `diff-hl-amend-mode' overrides its
effect.

\(fn REV)" t nil)

(autoload 'diff-hl-reset-reference-rev "diff-hl" "\
Reset the reference revision globally to the most recent one." t nil)

(put 'global-diff-hl-mode 'globalized-minor-mode t)

(defvar global-diff-hl-mode nil "\
Non-nil if Global Diff-Hl mode is enabled.
See the `global-diff-hl-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `global-diff-hl-mode'.")

(custom-autoload 'global-diff-hl-mode "diff-hl" nil)

(autoload 'global-diff-hl-mode "diff-hl" "\
Toggle Diff-Hl mode in all buffers.
With prefix ARG, enable Global Diff-Hl mode if ARG is positive;
otherwise, disable it.  If called from Lisp, enable the mode if
ARG is omitted or nil.

Diff-Hl mode is enabled in all buffers where
`diff-hl--global-turn-on' would do it.
See `diff-hl-mode' for more information on Diff-Hl mode.

\(fn &optional ARG)" t nil)

;;;### (autoloads "actual autoloads are elsewhere" "diff-hl" "../../../../../.emacs.d/elpa/diff-hl-20220124.323/diff-hl.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from ../../../../../.emacs.d/elpa/diff-hl-20220124.323/diff-hl.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "diff-hl" '("diff-hl-")))

;;;***

;;;***

;;;### (autoloads nil "diff-hl-amend" "../../../../../.emacs.d/elpa/diff-hl-20220124.323/diff-hl-amend.el"
;;;;;;  "eeb4a7192a7f0ea765803434c4a21fa6")
;;; Generated autoloads from ../../../../../.emacs.d/elpa/diff-hl-20220124.323/diff-hl-amend.el

(autoload 'diff-hl-amend-mode "diff-hl-amend" "\
Show changes against the second-last revision in `diff-hl-mode'.
Most useful with backends that support rewriting local commits,
and most importantly, \"amending\" the most recent one.
Currently only supports Git, Mercurial and Bazaar.

If called interactively, enable Diff-Hl-Amend mode if ARG is
positive, and disable it if ARG is zero or negative.  If called
from Lisp, also enable the mode if ARG is omitted or nil, and
toggle it if ARG is `toggle'; disable the mode otherwise.

\(fn &optional ARG)" t nil)

(put 'global-diff-hl-amend-mode 'globalized-minor-mode t)

(defvar global-diff-hl-amend-mode nil "\
Non-nil if Global Diff-Hl-Amend mode is enabled.
See the `global-diff-hl-amend-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `global-diff-hl-amend-mode'.")

(custom-autoload 'global-diff-hl-amend-mode "diff-hl-amend" nil)

(autoload 'global-diff-hl-amend-mode "diff-hl-amend" "\
Toggle Diff-Hl-Amend mode in all buffers.
With prefix ARG, enable Global Diff-Hl-Amend mode if ARG is positive;
otherwise, disable it.  If called from Lisp, enable the mode if
ARG is omitted or nil.

Diff-Hl-Amend mode is enabled in all buffers where
`turn-on-diff-hl-amend-mode' would do it.
See `diff-hl-amend-mode' for more information on Diff-Hl-Amend mode.

\(fn &optional ARG)" t nil)

;;;### (autoloads "actual autoloads are elsewhere" "diff-hl-amend"
;;;;;;  "../../../../../.emacs.d/elpa/diff-hl-20220124.323/diff-hl-amend.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from ../../../../../.emacs.d/elpa/diff-hl-20220124.323/diff-hl-amend.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "diff-hl-amend" '("diff-hl-amend-setup" "turn-on-diff-hl-amend-mode")))

;;;***

;;;***

;;;### (autoloads nil "diff-hl-dired" "../../../../../.emacs.d/elpa/diff-hl-20220124.323/diff-hl-dired.el"
;;;;;;  "f46a2b71d98b4df4d93abb12e5ca641d")
;;; Generated autoloads from ../../../../../.emacs.d/elpa/diff-hl-20220124.323/diff-hl-dired.el

(autoload 'diff-hl-dired-mode "diff-hl-dired" "\
Toggle VC diff highlighting on the side of a Dired window.

If called interactively, enable Diff-Hl-Dired mode if ARG is
positive, and disable it if ARG is zero or negative.  If called
from Lisp, also enable the mode if ARG is omitted or nil, and
toggle it if ARG is `toggle'; disable the mode otherwise.

\(fn &optional ARG)" t nil)

(autoload 'diff-hl-dired-mode-unless-remote "diff-hl-dired" nil nil nil)

;;;### (autoloads "actual autoloads are elsewhere" "diff-hl-dired"
;;;;;;  "../../../../../.emacs.d/elpa/diff-hl-20220124.323/diff-hl-dired.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from ../../../../../.emacs.d/elpa/diff-hl-20220124.323/diff-hl-dired.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "diff-hl-dired" '("diff-hl-dired-")))

;;;***

;;;***

;;;### (autoloads nil "diff-hl-flydiff" "../../../../../.emacs.d/elpa/diff-hl-20220124.323/diff-hl-flydiff.el"
;;;;;;  "551c1734d500368518582383c5ba4b0c")
;;; Generated autoloads from ../../../../../.emacs.d/elpa/diff-hl-20220124.323/diff-hl-flydiff.el

(defvar diff-hl-flydiff-mode nil "\
Non-nil if Diff-Hl-Flydiff mode is enabled.
See the `diff-hl-flydiff-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `diff-hl-flydiff-mode'.")

(custom-autoload 'diff-hl-flydiff-mode "diff-hl-flydiff" nil)

(autoload 'diff-hl-flydiff-mode "diff-hl-flydiff" "\
Perform highlighting on-the-fly.
This is a global minor mode.  It alters how `diff-hl-mode' works.

If called interactively, enable Diff-Hl-Flydiff mode if ARG is
positive, and disable it if ARG is zero or negative.  If called
from Lisp, also enable the mode if ARG is omitted or nil, and
toggle it if ARG is `toggle'; disable the mode otherwise.

\(fn &optional ARG)" t nil)

;;;### (autoloads "actual autoloads are elsewhere" "diff-hl-flydiff"
;;;;;;  "../../../../../.emacs.d/elpa/diff-hl-20220124.323/diff-hl-flydiff.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from ../../../../../.emacs.d/elpa/diff-hl-20220124.323/diff-hl-flydiff.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "diff-hl-flydiff" '("diff-hl-flydiff")))

;;;***

;;;***

;;;### (autoloads nil "diff-hl-inline-popup" "../../../../../.emacs.d/elpa/diff-hl-20220124.323/diff-hl-inline-popup.el"
;;;;;;  "4c4c142cf29dcc3988d9b16bdd612936")
;;; Generated autoloads from ../../../../../.emacs.d/elpa/diff-hl-20220124.323/diff-hl-inline-popup.el

(autoload 'diff-hl-inline-popup-hide "diff-hl-inline-popup" "\
Hide the current inline popup." t nil)

(autoload 'diff-hl-inline-popup-show "diff-hl-inline-popup" "\
Create a phantom overlay to show the inline popup, with some
content LINES, and a HEADER and a FOOTER, at POINT.  KEYMAP is
added to the current keymaps.  CLOSE-HOOK is called when the popup
is closed.

\(fn LINES &optional HEADER FOOTER KEYMAP CLOSE-HOOK POINT HEIGHT)" nil nil)

;;;### (autoloads "actual autoloads are elsewhere" "diff-hl-inline-popup"
;;;;;;  "../../../../../.emacs.d/elpa/diff-hl-20220124.323/diff-hl-inline-popup.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from ../../../../../.emacs.d/elpa/diff-hl-20220124.323/diff-hl-inline-popup.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "diff-hl-inline-popup" '("diff-hl-inline-popup-")))

;;;***

;;;***

;;;### (autoloads nil "diff-hl-margin" "../../../../../.emacs.d/elpa/diff-hl-20220124.323/diff-hl-margin.el"
;;;;;;  "7fefbc4d3fdb4044aa153022e69fd43d")
;;; Generated autoloads from ../../../../../.emacs.d/elpa/diff-hl-20220124.323/diff-hl-margin.el

(defvar diff-hl-margin-mode nil "\
Non-nil if Diff-Hl-Margin mode is enabled.
See the `diff-hl-margin-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `diff-hl-margin-mode'.")

(custom-autoload 'diff-hl-margin-mode "diff-hl-margin" nil)

(autoload 'diff-hl-margin-mode "diff-hl-margin" "\
Toggle displaying `diff-hl-mode' highlights on the margin.

If called interactively, enable Diff-Hl-Margin mode if ARG is
positive, and disable it if ARG is zero or negative.  If called
from Lisp, also enable the mode if ARG is omitted or nil, and
toggle it if ARG is `toggle'; disable the mode otherwise.

\(fn &optional ARG)" t nil)

(autoload 'diff-hl-margin-local-mode "diff-hl-margin" "\
Toggle displaying `diff-hl-mode' highlights on the margin locally.
You probably shouldn't use this function directly.

If called interactively, enable Diff-Hl-Margin-Local mode if ARG
is positive, and disable it if ARG is zero or negative.  If
called from Lisp, also enable the mode if ARG is omitted or nil,
and toggle it if ARG is `toggle'; disable the mode otherwise.

\(fn &optional ARG)" t nil)

;;;### (autoloads "actual autoloads are elsewhere" "diff-hl-margin"
;;;;;;  "../../../../../.emacs.d/elpa/diff-hl-20220124.323/diff-hl-margin.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from ../../../../../.emacs.d/elpa/diff-hl-20220124.323/diff-hl-margin.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "diff-hl-margin" '("diff-hl-")))

;;;***

;;;***

;;;### (autoloads nil "diff-hl-show-hunk" "../../../../../.emacs.d/elpa/diff-hl-20220124.323/diff-hl-show-hunk.el"
;;;;;;  "4945ca442a6cd20bbd04eb7b20dd9f2f")
;;; Generated autoloads from ../../../../../.emacs.d/elpa/diff-hl-20220124.323/diff-hl-show-hunk.el

(autoload 'diff-hl-show-hunk-inline-popup "diff-hl-show-hunk" "\
Implementation to show the hunk in a inline popup.
BUFFER is a buffer with the hunk.

\(fn BUFFER &optional IGNORED-LINE)" nil nil)

(autoload 'diff-hl-show-hunk-previous "diff-hl-show-hunk" "\
Go to previous hunk/change and show it." t nil)

(autoload 'diff-hl-show-hunk-next "diff-hl-show-hunk" "\
Go to next hunk/change and show it." t nil)

(autoload 'diff-hl-show-hunk "diff-hl-show-hunk" "\
Show the VC diff hunk at point.
The backend is determined by `diff-hl-show-hunk-function'." t nil)

(autoload 'diff-hl-show-hunk-mouse-mode "diff-hl-show-hunk" "\
Enables the margin and fringe to show a posframe/popup with vc diffs when clicked.
By default, the popup shows only the current hunk, and
the line of the hunk that matches the current position is
highlighted.  The face, border and other visual preferences are
customizable.  It can be also invoked with the command
`diff-hl-show-hunk'
\\{diff-hl-show-hunk-mouse-mode-map}

If called interactively, enable Diff-Hl-Show-Hunk-Mouse mode if
ARG is positive, and disable it if ARG is zero or negative.  If
called from Lisp, also enable the mode if ARG is omitted or nil,
and toggle it if ARG is `toggle'; disable the mode otherwise.

\(fn &optional ARG)" t nil)

(put 'global-diff-hl-show-hunk-mouse-mode 'globalized-minor-mode t)

(defvar global-diff-hl-show-hunk-mouse-mode nil "\
Non-nil if Global Diff-Hl-Show-Hunk-Mouse mode is enabled.
See the `global-diff-hl-show-hunk-mouse-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `global-diff-hl-show-hunk-mouse-mode'.")

(custom-autoload 'global-diff-hl-show-hunk-mouse-mode "diff-hl-show-hunk" nil)

(autoload 'global-diff-hl-show-hunk-mouse-mode "diff-hl-show-hunk" "\
Toggle Diff-Hl-Show-Hunk-Mouse mode in all buffers.
With prefix ARG, enable Global Diff-Hl-Show-Hunk-Mouse mode if ARG is positive;
otherwise, disable it.  If called from Lisp, enable the mode if
ARG is omitted or nil.

Diff-Hl-Show-Hunk-Mouse mode is enabled in all buffers where
`diff-hl-show-hunk-mouse-mode' would do it.
See `diff-hl-show-hunk-mouse-mode' for more information on Diff-Hl-Show-Hunk-Mouse mode.

\(fn &optional ARG)" t nil)

;;;### (autoloads "actual autoloads are elsewhere" "diff-hl-show-hunk"
;;;;;;  "../../../../../.emacs.d/elpa/diff-hl-20220124.323/diff-hl-show-hunk.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from ../../../../../.emacs.d/elpa/diff-hl-20220124.323/diff-hl-show-hunk.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "diff-hl-show-hunk" '("diff-hl-show-hunk-")))

;;;***

;;;***

;;;### (autoloads nil "diff-hl-show-hunk-posframe" "../../../../../.emacs.d/elpa/diff-hl-20220124.323/diff-hl-show-hunk-posframe.el"
;;;;;;  "90cbc7e2ce2aa90757a1a37f551712fd")
;;; Generated autoloads from ../../../../../.emacs.d/elpa/diff-hl-20220124.323/diff-hl-show-hunk-posframe.el

(autoload 'diff-hl-show-hunk-posframe "diff-hl-show-hunk-posframe" "\
Implementation to show the hunk in a posframe.

\(fn BUFFER &optional LINE)" nil nil)

;;;### (autoloads "actual autoloads are elsewhere" "diff-hl-show-hunk-posframe"
;;;;;;  "../../../../../.emacs.d/elpa/diff-hl-20220124.323/diff-hl-show-hunk-posframe.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from ../../../../../.emacs.d/elpa/diff-hl-20220124.323/diff-hl-show-hunk-posframe.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "diff-hl-show-hunk-posframe" '("diff-hl-show-hunk-")))

;;;***

;;;***

;;;### (autoloads nil nil ("../../../../../.emacs.d/elpa/diff-hl-20220124.323/diff-hl-amend.el"
;;;;;;  "../../../../../.emacs.d/elpa/diff-hl-20220124.323/diff-hl-autoloads.el"
;;;;;;  "../../../../../.emacs.d/elpa/diff-hl-20220124.323/diff-hl-dired.el"
;;;;;;  "../../../../../.emacs.d/elpa/diff-hl-20220124.323/diff-hl-flydiff.el"
;;;;;;  "../../../../../.emacs.d/elpa/diff-hl-20220124.323/diff-hl-inline-popup.el"
;;;;;;  "../../../../../.emacs.d/elpa/diff-hl-20220124.323/diff-hl-margin.el"
;;;;;;  "../../../../../.emacs.d/elpa/diff-hl-20220124.323/diff-hl-pkg.el"
;;;;;;  "../../../../../.emacs.d/elpa/diff-hl-20220124.323/diff-hl-show-hunk-posframe.el"
;;;;;;  "../../../../../.emacs.d/elpa/diff-hl-20220124.323/diff-hl-show-hunk.el"
;;;;;;  "../../../../../.emacs.d/elpa/diff-hl-20220124.323/diff-hl.el")
;;;;;;  (0 0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; diff-hl-autoloads.el ends here
