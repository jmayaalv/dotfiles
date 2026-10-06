;;; terminal.el --- Emacs in a terminal (inside herdr)  -*- lexical-binding: t; -*-

;; Mouse in terminal frames: click to move point, wheel to scroll, drag to
;; select. herdr forwards mouse reports to programs that ask for them.
(xterm-mouse-mode 1)

;; Kills reach the macOS clipboard through OSC 52, which herdr forwards to
;; Alacritty. clipetty only acts in terminal frames; GUI frames are untouched.
(use-package clipetty
  :ensure t
  :config (global-clipetty-mode 1))

;; Kitty keyboard protocol, so terminal frames get the GUI's keys: C-=, C-;,
;; Ctrl+Shift combos, and Super from the right Option key (Karabiner hands it
;; to Alacritty as Command, which herdr passes on as Super). Meta comes from
;; the right Command key (Karabiner + Alacritty option_as_alt).
(use-package kkp
  :ensure t
  :config (global-kkp-mode 1))

;; The daemon behind `ec' (see ~/.zshrc) shares buffers across herdr spaces;
;; ui.el keeps it out of desktop saving, which stays with the GUI Emacs.
