;;; omarchy.el --- Omarchy desktop integration for Prelude -*- lexical-binding: t -*-

;; Loads the omarchy-emacs package's implementation (live theme + font
;; syncing with the Omarchy desktop, server autostart, shell setup) on top
;; of Prelude. Kept as a shim so AUR upgrades of omarchy-emacs propagate
;; without editing anything here.
;;
;; Remove this file to opt out of Omarchy integration.

(let ((omarchy--system-file "/usr/share/omarchy-emacs/config/omarchy.el"))
  (when (file-exists-p omarchy--system-file)
    (load omarchy--system-file)))

;;; omarchy.el ends here
