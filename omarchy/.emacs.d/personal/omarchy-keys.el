;;; omarchy-keys.el --- Re-home the bindings Hyprland swallows -*- lexical-binding: t -*-

;; Hyprland owns the Super key on Omarchy (184 bindings, 42 of them plain
;; SUPER+key), so 12 of Prelude's 16 `s-' bindings never reach Emacs at all.
;; Most of those are duplicates of bindings that still work -- `s-j' is also
;; `C-^', `s-/' is `M-/', `s-p' is `C-c p', `s-,' is `C-:', `s-o' is
;; `C-S-<return>' -- so only the seven below were left with no way to invoke
;; them. They move into free `C-c' slots.
;;
;; The original `s-' bindings are deliberately left in place: they cost
;; nothing while Hyprland eats them, and they still work under a session
;; that doesn't claim Super.

;; Capitals, because Prelude has already taken 23 of the 26 lowercase
;; letters under `C-c'. Both keep their original mnemonic letter.
(define-key prelude-mode-map (kbd "C-c K") #'crux-kill-whole-line) ; was s-k
(global-set-key (kbd "C-c W") #'ace-window)                        ; was s-w

;; Smartparens structural editing. The arrows keep their original geometry --
;; only the modifier changes, so the muscle memory carries over.
(with-eval-after-load 'smartparens
  (define-key smartparens-mode-map (kbd "C-c ;")       #'sp-splice-sexp)                   ; was s-s
  (define-key smartparens-mode-map (kbd "C-c <right>") #'sp-forward-slurp-sexp)            ; was s-<right>
  (define-key smartparens-mode-map (kbd "C-c <left>")  #'sp-forward-barf-sexp)             ; was s-<left>
  (define-key smartparens-mode-map (kbd "C-c <up>")    #'sp-splice-sexp-killing-backward)  ; was s-<up>
  (define-key smartparens-mode-map (kbd "C-c <down>")  #'sp-splice-sexp-killing-forward))  ; was s-<down>

;;; omarchy-keys.el ends here
