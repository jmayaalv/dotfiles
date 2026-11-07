;;; terminal.el --- Emacs in a terminal (inside herdr)  -*- lexical-binding: t; -*-

;; Mouse in terminal frames: click to move point, wheel to scroll, drag to
;; select. herdr forwards mouse reports to programs that ask for them.
(xterm-mouse-mode 1)

;; No menu bar in terminal frames, where it costs a line; GUI frames keep
;; theirs, which lives in the macOS menu bar anyway.
(defun kane/hide-terminal-menu-bar (&optional frame)
  (unless (display-graphic-p frame)
    (set-frame-parameter frame 'menu-bar-lines 0)))
(add-hook 'after-make-frame-functions #'kane/hide-terminal-menu-bar)
(kane/hide-terminal-menu-bar)

;; Kills reach the macOS clipboard through OSC 52, which herdr forwards to
;; Ghostty. clipetty only acts in terminal frames; GUI frames are untouched.
(use-package clipetty
  :ensure t
  :config (global-clipetty-mode 1))

;; Kitty keyboard protocol, so terminal frames get the GUI's keys: C-=, C-;,
;; Ctrl+Shift combos, and Super from the right Option key (Karabiner hands it
;; to Ghostty as Command, which herdr passes on as Super). Meta comes from
;; the left Command key (Karabiner + Ghostty's macos-option-as-alt).
(use-package kkp
  :ensure t
  :config (global-kkp-mode 1))

;; In Rex, Karabiner sends the right Option key as Control+Option+Command,
;; which arrives as C-M-s-<key> (Rex keeps plain Command for its own
;; shortcuts). Turn it back into Super. Real C-M-s- chords can't be typed on
;; this keyboard anyway: both Option keys are remapped.
;; With Control held, case is lost, so Shift comes as S-: C-M-S-s-p is s-P.
(dolist (key (append (mapcar #'char-to-string (number-sequence ?0 ?9))
                     '("-" "=" "[" "]" "\\" ";" "'" "," "." "/" "`"
                       "<left>" "<right>" "<up>" "<down>"
                       "RET" "<return>" "TAB" "<tab>" "SPC" "DEL" "<backspace>")))
  (define-key key-translation-map (kbd (concat "C-M-s-" key)) (kbd (concat "s-" key))))
(dolist (c (number-sequence ?a ?z))
  (define-key key-translation-map (kbd (format "C-M-s-%c" c)) (kbd (format "s-%c" c)))
  (define-key key-translation-map (kbd (format "C-M-S-s-%c" c)) (kbd (format "s-%c" (upcase c)))))

;; The daemon behind `ec' (see ~/.zshrc) shares buffers across herdr spaces;
;; ui.el keeps it out of desktop saving, which stays with the GUI Emacs.
