(defun dired-dim-git-ignores ()
  "Dim out .gitignore contents"
  (when-let ((_ (require 'vc))
             (ignores (vc-default-ignore-completion-table 'git ".gitignore"))
             (exts (make-local-variable 'completion-ignored-extensions)))
    (dolist (item ignores) (add-to-list exts item))))

(add-hook 'dired-mode-hook #'dired-dim-git-ignores)
