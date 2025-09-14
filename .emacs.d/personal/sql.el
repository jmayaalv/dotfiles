;; Buffer name :  use the name of the pool *SQL: <host>_<db>,
;; which is easier to find when you M-x list-buffers, or C-x C-b

(defun sql-make-smart-buffer-name ()
  "Return a string that can be used to rename a SQLi buffer.
  This is used to set `sql-alternate-buffer-name' within
  `sql-interactive-mode'."
  (or (and (boundp 'sql-name) sql-name)
      (concat (if (not(string= "" sql-server))
                  (concat
                   (or (and (string-match "[0-9.]+" sql-server) sql-server)
                       (car (split-string sql-server "\\.")))
                   "/"))
              sql-database)))

 (add-hook 'sql-interactive-mode-hook
           (lambda ()
             (setq truncate-lines nil)
             (setq sql-alternate-buffer-name (sql-make-smart-buffer-name))
             (sql-rename-buffer)))

;; Add a newline before the output
(defun sql-add-newline-first (output)
  "Add newline to beginning of OUTPUT for `comint-preoutput-filter-functions'"
  (concat "\n" output))

 (defun sqli-add-hooks ()
   "Add hooks to `sql-interactive-mode-hook'."
   (add-hook 'comint-preoutput-filter-functions
             'sql-add-newline-first))

(defun my-sql-login-hook ()
  "Custom SQL log-in behaviours. See `sql-login-hook'."
  ;; n.b. If you are looking for a response and need to parse the
  ;; response, use `sql-redirect-value' instead of `comint-send-string'.
  (when (eq sql-product 'postgres)
    (let ((proc (get-buffer-process (current-buffer))))
      ;; Output each query before executing it. (n.b. this also avoids
      ;; the psql prompt breaking the alignment of query results.)
      (comint-send-string proc "\\set ECHO queries\n"))))

(add-hook 'sql-login-hook 'my-sql-login-hook)
;(add-hook 'sql-interactive-mode-hook 'sqli-add-hooks)

(add-hook 'sql-interactive-mode-hook #'yas-minor-mode)

;; add snnipets
(add-hook 'sql-mode-hook #'yas-minor-mode)
