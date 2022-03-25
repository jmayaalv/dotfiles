;;; multiple-cursors-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads "actual autoloads are elsewhere" "mc-cycle-cursors"
;;;;;;  "../../../../../.emacs.d/elpa/multiple-cursors-20211112.2223/mc-cycle-cursors.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from ../../../../../.emacs.d/elpa/multiple-cursors-20211112.2223/mc-cycle-cursors.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "mc-cycle-cursors" '("mc/")))

;;;***

;;;### (autoloads nil "mc-edit-lines" "../../../../../.emacs.d/elpa/multiple-cursors-20211112.2223/mc-edit-lines.el"
;;;;;;  "6c9ca469b86ca3f125e17855b380ed8a")
;;; Generated autoloads from ../../../../../.emacs.d/elpa/multiple-cursors-20211112.2223/mc-edit-lines.el

(autoload 'mc/edit-lines "mc-edit-lines" "\
Add one cursor to each line of the active region.
Starts from mark and moves in straight down or up towards the
line point is on.

What is done with lines which are not long enough is governed by
`mc/edit-lines-empty-lines'.  The prefix argument ARG can be used
to override this.  If ARG is a symbol (when called from Lisp),
that symbol is used instead of `mc/edit-lines-empty-lines'.
Otherwise, if ARG negative, short lines will be ignored.  Any
other non-nil value will cause short lines to be padded.

\(fn &optional ARG)" t nil)

(autoload 'mc/edit-ends-of-lines "mc-edit-lines" "\
Add one cursor to the end of each line in the active region." t nil)

(autoload 'mc/edit-beginnings-of-lines "mc-edit-lines" "\
Add one cursor to the beginning of each line in the active region." t nil)

;;;### (autoloads "actual autoloads are elsewhere" "mc-edit-lines"
;;;;;;  "../../../../../.emacs.d/elpa/multiple-cursors-20211112.2223/mc-edit-lines.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from ../../../../../.emacs.d/elpa/multiple-cursors-20211112.2223/mc-edit-lines.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "mc-edit-lines" '("mc/edit-lines-empty-lines")))

;;;***

;;;***

;;;### (autoloads nil "mc-hide-unmatched-lines-mode" "../../../../../.emacs.d/elpa/multiple-cursors-20211112.2223/mc-hide-unmatched-lines-mode.el"
;;;;;;  "a152bf12db4ae7706004def13290ef03")
;;; Generated autoloads from ../../../../../.emacs.d/elpa/multiple-cursors-20211112.2223/mc-hide-unmatched-lines-mode.el

(autoload 'mc-hide-unmatched-lines-mode "mc-hide-unmatched-lines-mode" "\
Minor mode when enabled hides all lines where no cursors (and
also hum/lines-to-expand below and above) To make use of this
mode press \"C-'\" while multiple-cursor-mode is active. You can
still edit lines while you are in mc-hide-unmatched-lines
mode. To leave this mode press <return> or \"C-g\"

If called interactively, enable Mc-Hide-Unmatched-Lines mode if
ARG is positive, and disable it if ARG is zero or negative.  If
called from Lisp, also enable the mode if ARG is omitted or nil,
and toggle it if ARG is `toggle'; disable the mode otherwise.

\(fn &optional ARG)" t nil)

;;;### (autoloads "actual autoloads are elsewhere" "mc-hide-unmatched-lines-mode"
;;;;;;  "../../../../../.emacs.d/elpa/multiple-cursors-20211112.2223/mc-hide-unmatched-lines-mode.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from ../../../../../.emacs.d/elpa/multiple-cursors-20211112.2223/mc-hide-unmatched-lines-mode.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "mc-hide-unmatched-lines-mode" '("hum/")))

;;;***

;;;***

;;;### (autoloads nil "mc-mark-more" "../../../../../.emacs.d/elpa/multiple-cursors-20211112.2223/mc-mark-more.el"
;;;;;;  "f3d87cc7ab47483e6228e6890620d64c")
;;; Generated autoloads from ../../../../../.emacs.d/elpa/multiple-cursors-20211112.2223/mc-mark-more.el

(autoload 'mc/mark-next-like-this "mc-mark-more" "\
Find and mark the next part of the buffer matching the currently active region
If no region is active add a cursor on the next line
With negative ARG, delete the last one instead.
With zero ARG, skip the last one and mark next.

\(fn ARG)" t nil)

(autoload 'mc/mark-next-like-this-word "mc-mark-more" "\
Find and mark the next part of the buffer matching the currently active region
If no region is active, mark the word at the point and find the next match
With negative ARG, delete the last one instead.
With zero ARG, skip the last one and mark next.

\(fn ARG)" t nil)

(autoload 'mc/mark-next-word-like-this "mc-mark-more" "\
Find and mark the next word of the buffer matching the currently active region
The matching region must be a whole word to be a match
If no region is active add a cursor on the next line
With negative ARG, delete the last one instead.
With zero ARG, skip the last one and mark next.

\(fn ARG)" t nil)

(autoload 'mc/mark-next-symbol-like-this "mc-mark-more" "\
Find and mark the next symbol of the buffer matching the currently active region
The matching region must be a whole symbol to be a match
If no region is active add a cursor on the next line
With negative ARG, delete the last one instead.
With zero ARG, skip the last one and mark next.

\(fn ARG)" t nil)

(autoload 'mc/mark-previous-like-this "mc-mark-more" "\
Find and mark the previous part of the buffer matching the currently active region
If no region is active add a cursor on the previous line
With negative ARG, delete the last one instead.
With zero ARG, skip the last one and mark next.

\(fn ARG)" t nil)

(autoload 'mc/mark-previous-like-this-word "mc-mark-more" "\
Find and mark the previous part of the buffer matching the currently active region
If no region is active, mark the word at the point and find the previous match
With negative ARG, delete the last one instead.
With zero ARG, skip the last one and mark previous.

\(fn ARG)" t nil)

(autoload 'mc/mark-previous-word-like-this "mc-mark-more" "\
Find and mark the previous part of the buffer matching the currently active region
The matching region must be a whole word to be a match
If no region is active add a cursor on the previous line
With negative ARG, delete the last one instead.
With zero ARG, skip the last one and mark next.

\(fn ARG)" t nil)

(autoload 'mc/mark-previous-symbol-like-this "mc-mark-more" "\
Find and mark the previous part of the buffer matching the currently active region
The matching region must be a whole symbol to be a match
If no region is active add a cursor on the previous line
With negative ARG, delete the last one instead.
With zero ARG, skip the last one and mark next.

\(fn ARG)" t nil)

(autoload 'mc/mark-next-lines "mc-mark-more" "\


\(fn ARG)" t nil)

(autoload 'mc/mark-previous-lines "mc-mark-more" "\


\(fn ARG)" t nil)

(autoload 'mc/unmark-next-like-this "mc-mark-more" "\
Deselect next part of the buffer matching the currently active region." t nil)

(autoload 'mc/unmark-previous-like-this "mc-mark-more" "\
Deselect prev part of the buffer matching the currently active region." t nil)

(autoload 'mc/skip-to-next-like-this "mc-mark-more" "\
Skip the current one and select the next part of the buffer matching the currently active region." t nil)

(autoload 'mc/skip-to-previous-like-this "mc-mark-more" "\
Skip the current one and select the prev part of the buffer matching the currently active region." t nil)

(autoload 'mc/mark-all-like-this "mc-mark-more" "\
Find and mark all the parts of the buffer matching the currently active region" t nil)

(autoload 'mc/mark-all-words-like-this "mc-mark-more" nil t nil)

(autoload 'mc/mark-all-symbols-like-this "mc-mark-more" nil t nil)

(autoload 'mc/mark-all-in-region "mc-mark-more" "\
Find and mark all the parts in the region matching the given search

\(fn BEG END &optional SEARCH)" t nil)

(autoload 'mc/mark-all-in-region-regexp "mc-mark-more" "\
Find and mark all the parts in the region matching the given regexp.

\(fn BEG END)" t nil)

(autoload 'mc/mark-more-like-this-extended "mc-mark-more" "\
Like mark-more-like-this, but then lets you adjust with arrows key.
The adjustments work like this:

   <up>    Mark previous like this and set direction to 'up
   <down>  Mark next like this and set direction to 'down

If direction is 'up:

   <left>  Skip past the cursor furthest up
   <right> Remove the cursor furthest up

If direction is 'down:

   <left>  Remove the cursor furthest down
   <right> Skip past the cursor furthest down

The bindings for these commands can be changed. See `mc/mark-more-like-this-extended-keymap'." t nil)

(autoload 'mc/mark-all-like-this-dwim "mc-mark-more" "\
Tries to guess what you want to mark all of.
Can be pressed multiple times to increase selection.

With prefix, it behaves the same as original `mc/mark-all-like-this'

\(fn ARG)" t nil)

(autoload 'mc/mark-all-dwim "mc-mark-more" "\
Tries even harder to guess what you want to mark all of.

If the region is active and spans multiple lines, it will behave
as if `mc/mark-all-in-region'. With the prefix ARG, it will call
`mc/edit-lines' instead.

If the region is inactive or on a single line, it will behave like
`mc/mark-all-like-this-dwim'.

\(fn ARG)" t nil)

(autoload 'mc/mark-all-like-this-in-defun "mc-mark-more" "\
Mark all like this in defun." t nil)

(autoload 'mc/mark-all-words-like-this-in-defun "mc-mark-more" "\
Mark all words like this in defun." t nil)

(autoload 'mc/mark-all-symbols-like-this-in-defun "mc-mark-more" "\
Mark all symbols like this in defun." t nil)

(autoload 'mc/toggle-cursor-on-click "mc-mark-more" "\
Add a cursor where you click, or remove a fake cursor that is
already there.

\(fn EVENT)" t nil)

(defalias 'mc/add-cursor-on-click 'mc/toggle-cursor-on-click)

(autoload 'mc/mark-sgml-tag-pair "mc-mark-more" "\
Mark the tag we're in and its pair for renaming." t nil)

;;;### (autoloads "actual autoloads are elsewhere" "mc-mark-more"
;;;;;;  "../../../../../.emacs.d/elpa/multiple-cursors-20211112.2223/mc-mark-more.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from ../../../../../.emacs.d/elpa/multiple-cursors-20211112.2223/mc-mark-more.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "mc-mark-more" '("mc--" "mc/")))

;;;***

;;;***

;;;### (autoloads nil "mc-mark-pop" "../../../../../.emacs.d/elpa/multiple-cursors-20211112.2223/mc-mark-pop.el"
;;;;;;  "d6ca90158891ee1716fda33be322cacd")
;;; Generated autoloads from ../../../../../.emacs.d/elpa/multiple-cursors-20211112.2223/mc-mark-pop.el

(autoload 'mc/mark-pop "mc-mark-pop" "\
Add a cursor at the current point, pop off mark ring and jump
to the popped mark." t nil)

;;;***

;;;### (autoloads nil "mc-separate-operations" "../../../../../.emacs.d/elpa/multiple-cursors-20211112.2223/mc-separate-operations.el"
;;;;;;  "b68080cee012df6c15517624131f9c64")
;;; Generated autoloads from ../../../../../.emacs.d/elpa/multiple-cursors-20211112.2223/mc-separate-operations.el

(autoload 'mc/insert-numbers "mc-separate-operations" "\
Insert increasing numbers for each cursor, starting at
`mc/insert-numbers-default' or ARG.

\(fn ARG)" t nil)

(autoload 'mc/insert-letters "mc-separate-operations" "\
Insert increasing letters for each cursor, starting at 0 or ARG.
     Where letter[0]=a letter[2]=c letter[26]=aa

\(fn ARG)" t nil)

(autoload 'mc/reverse-regions "mc-separate-operations" nil t nil)

(autoload 'mc/sort-regions "mc-separate-operations" nil t nil)

(autoload 'mc/vertical-align "mc-separate-operations" "\
Aligns all cursors vertically with a given CHARACTER to the one with the
highest column number (the rightest).
Might not behave as intended if more than one cursors are on the same line.

\(fn CHARACTER)" t nil)

(autoload 'mc/vertical-align-with-space "mc-separate-operations" "\
Aligns all cursors with whitespace like `mc/vertical-align' does" t nil)

;;;### (autoloads "actual autoloads are elsewhere" "mc-separate-operations"
;;;;;;  "../../../../../.emacs.d/elpa/multiple-cursors-20211112.2223/mc-separate-operations.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from ../../../../../.emacs.d/elpa/multiple-cursors-20211112.2223/mc-separate-operations.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "mc-separate-operations" '("mc--" "mc/insert-numbers-default")))

;;;***

;;;***

;;;### (autoloads nil "multiple-cursors-core" "../../../../../.emacs.d/elpa/multiple-cursors-20211112.2223/multiple-cursors-core.el"
;;;;;;  "db2a397c0a090cc77de2e896c0190b70")
;;; Generated autoloads from ../../../../../.emacs.d/elpa/multiple-cursors-20211112.2223/multiple-cursors-core.el

(autoload 'multiple-cursors-mode "multiple-cursors-core" "\
Mode while multiple cursors are active.

If called interactively, enable Multiple-Cursors mode if ARG is
positive, and disable it if ARG is zero or negative.  If called
from Lisp, also enable the mode if ARG is omitted or nil, and
toggle it if ARG is `toggle'; disable the mode otherwise.

\(fn &optional ARG)" t nil)

;;;### (autoloads "actual autoloads are elsewhere" "multiple-cursors-core"
;;;;;;  "../../../../../.emacs.d/elpa/multiple-cursors-20211112.2223/multiple-cursors-core.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from ../../../../../.emacs.d/elpa/multiple-cursors-20211112.2223/multiple-cursors-core.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "multiple-cursors-core" '("activate-cursor-for-undo" "deactivate-cursor-after-undo" "multiple-cursors-mode" "unsupported-cmd")))

;;;***

;;;***

;;;### (autoloads nil "rectangular-region-mode" "../../../../../.emacs.d/elpa/multiple-cursors-20211112.2223/rectangular-region-mode.el"
;;;;;;  "26bb3393c7feea07b835e4b3cc010d9d")
;;; Generated autoloads from ../../../../../.emacs.d/elpa/multiple-cursors-20211112.2223/rectangular-region-mode.el

(autoload 'set-rectangular-region-anchor "rectangular-region-mode" "\
Anchors the rectangular region at point.

Think of this one as `set-mark' except you're marking a rectangular region. It is
an exceedingly quick way of adding multiple cursors to multiple lines." t nil)

(autoload 'rectangular-region-mode "rectangular-region-mode" "\
A mode for creating a rectangular region to edit

If called interactively, enable Rectangular-Region mode if ARG is
positive, and disable it if ARG is zero or negative.  If called
from Lisp, also enable the mode if ARG is omitted or nil, and
toggle it if ARG is `toggle'; disable the mode otherwise.

\(fn &optional ARG)" t nil)

;;;### (autoloads "actual autoloads are elsewhere" "rectangular-region-mode"
;;;;;;  "../../../../../.emacs.d/elpa/multiple-cursors-20211112.2223/rectangular-region-mode.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from ../../../../../.emacs.d/elpa/multiple-cursors-20211112.2223/rectangular-region-mode.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "rectangular-region-mode" '("rectangular-region-mode" "rrm/")))

;;;***

;;;***

;;;### (autoloads nil nil ("../../../../../.emacs.d/elpa/multiple-cursors-20211112.2223/mc-cycle-cursors.el"
;;;;;;  "../../../../../.emacs.d/elpa/multiple-cursors-20211112.2223/mc-edit-lines.el"
;;;;;;  "../../../../../.emacs.d/elpa/multiple-cursors-20211112.2223/mc-hide-unmatched-lines-mode.el"
;;;;;;  "../../../../../.emacs.d/elpa/multiple-cursors-20211112.2223/mc-mark-more.el"
;;;;;;  "../../../../../.emacs.d/elpa/multiple-cursors-20211112.2223/mc-mark-pop.el"
;;;;;;  "../../../../../.emacs.d/elpa/multiple-cursors-20211112.2223/mc-separate-operations.el"
;;;;;;  "../../../../../.emacs.d/elpa/multiple-cursors-20211112.2223/multiple-cursors-autoloads.el"
;;;;;;  "../../../../../.emacs.d/elpa/multiple-cursors-20211112.2223/multiple-cursors-core.el"
;;;;;;  "../../../../../.emacs.d/elpa/multiple-cursors-20211112.2223/multiple-cursors-pkg.el"
;;;;;;  "../../../../../.emacs.d/elpa/multiple-cursors-20211112.2223/multiple-cursors.el"
;;;;;;  "../../../../../.emacs.d/elpa/multiple-cursors-20211112.2223/rectangular-region-mode.el")
;;;;;;  (0 0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; multiple-cursors-autoloads.el ends here
