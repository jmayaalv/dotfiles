;; Delete files by moving them to trash.
;;
;; The trash location is deliberately left unset on GNU/Linux: Emacs then uses
;; the freedesktop trash (~/.local/share/Trash), which is what Files and `gio
;; trash` read. Pointing `trash-directory' at ~/.Trash there would send
;; deletions somewhere neither of them looks, so they would appear to vanish.
(setq delete-by-moving-to-trash t)

(when (eq system-type 'darwin)
  (setq trash-directory "~/.Trash")

  ;; Set keys for Apple keyboard, for emacs in OS X
  (setq mac-option-modifier 'super)
  (setq mac-command-modifier 'meta)
  (setq ns-function-modifier 'hyper))
