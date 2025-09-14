;; Disable siganture checking of packages. Use only on rare occasions;
;; (setq package-check-signature nil)
(prelude-require-packages '(gnu-elpa-keyring-update))

;; Handle querying the passphrase through minibuffer.
(setq epa-pinentry-mode 'loopback)
(setq epg-gpg-program "/opt/homebrew/bin/gpg")
(setq auth-sources
      '((:source "~/.emacs.d/personal/secrets/authinfo.gpg")))
