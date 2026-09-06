;;; quiet-warnings.el --- Silence upstream warning noise -*- lexical-binding: t -*-

;; Loaded from personal/preload, which Prelude reads before its own core and
;; modules — early enough to take effect while those files are being loaded.

;; Emacs 31 warns once per file that lacks a `lexical-binding' cookie. That is
;; 68 warnings here, almost all of them Prelude's own core/ and modules/ files,
;; which drowns out anything real in *Warnings*. Suppress that one type only,
;; rather than raising `warning-minimum-level', so genuine warnings still show.
;; Both variables are needed: `warning-suppress-types' only stops the warning
;; popping up, while `warning-suppress-log-types' keeps it out of *Warnings*
;; altogether. Declared with defvar first because `warnings' may not be loaded
;; yet when the first cookie warning fires.
(defvar warning-suppress-types nil)
(defvar warning-suppress-log-types nil)
(add-to-list 'warning-suppress-types '(files missing-lexbind-cookie))
(add-to-list 'warning-suppress-log-types '(files missing-lexbind-cookie))

;; Native compilation of third-party packages reports warnings from code that is
;; not ours to fix (e.g. beacon.el). Compile quietly; errors are still logged to
;; the *Native-Compile-Log* buffer if something actually breaks.
(setq native-comp-async-report-warnings-errors 'silent)

;;; quiet-warnings.el ends here
