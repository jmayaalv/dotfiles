;;; -*- lexical-binding: t -*-
;; One jdtls per project.el project, so every Claude worktree gets its own.
(prelude-require-packages '(eglot-java))
(require 'eglot-java)

(defun java-init-opts (_server _class)
  "Maven only: the Gradle importer builds beluca's IntelliJ plugin projects.
Projects build on the JDK 21 that .sdkmanrc names.  No autobuild: errors in
unopened files show after `java-build'."
  '(:settings (:java (:import (:gradle (:enabled :json-false))
                      :autobuild (:enabled :json-false)
                      :configuration (:runtimes [(:name "JavaSE-21"
                                                  :path "/Users/jmayaalv/.sdkman/candidates/java/21.0.7-amzn"
                                                  :default t)])))))

;; Absolute paths: sdkman sets PATH in .zshrc, which the daemon never sees
(setq eglot-java-java-program "/Users/jmayaalv/.sdkman/candidates/java/25.0.5.0+9-amzn/bin/java" ; jdtls 1.63 needs 25
      eglot-java-eclipse-jdt-config-directory (expand-file-name "config_mac_arm" eglot-java-server-install-dir)
      eglot-java-eclipse-jdt-args
      '("-Xmx4G" "--add-modules=ALL-SYSTEM"
        "--add-opens" "java.base/java.util=ALL-UNNAMED"
        "--add-opens" "java.base/java.lang=ALL-UNNAMED"
        ;; shortcut: pinned Lombok, bump it when a newer jdtls or JDK stops seeing @Getter
        "-javaagent:/Users/jmayaalv/.m2/repository/org/projectlombok/lombok/1.18.48/lombok-1.18.48.jar")
      eglot-java-user-init-opts-fn #'java-init-opts)

(defun java-eglot ()
  "Start eglot-java without eglot's imenu, waiting for jdtls to connect.
which-func asks imenu synchronously on every open and a busy jdtls blocks
Emacs for seconds; java-mode's own imenu is instant.  A numeric sync wait
returns on any process output, and the next Java buffer then starts a second
jdtls on the same workspace; t blocks for the ~2s handshake instead."
  (setq-local eglot-ignored-server-capabilities
              (cons :documentSymbolProvider eglot-ignored-server-capabilities)
              eglot-sync-connect t)
  (eglot-java-mode))

(add-hook 'java-mode-hook #'java-eglot)

(defun java-build ()
  "Build the project incrementally, which autobuild no longer does.
`eglot-java-project-build-refresh' also re-imports the pom, and that clears
the errors the build just found."
  (interactive)
  (jsonrpc-async-request (eglot-java--find-server) :java/buildWorkspace :json-false
                         :success-fn (lambda (status)
                                       (message "jdtls build %s"
                                                (aref ["failed" "done" "done, with errors" "cancelled"] status)))))

(defun java--jdt-uri-handler (_operation &rest args)
  "`eglot-java--jdt-uri-handler', also matching jdtls 1.63's `Name.java?=' URIs.
Sources land in <project>/.eglot-java/ (globally gitignored) so eglot
manages them and navigation keeps working from inside a library."
  (let* ((uri (car args))
         (cache-dir (expand-file-name ".eglot-java" (project-root (project-current t))))
         (source-file
          (expand-file-name
           (save-match-data
             (when (string-match "jdt://contents/\\(.*?\\)/\\(.*\\)\\.\\(?:class\\|java\\)\\?" uri)
               (format "%s.java" (replace-regexp-in-string "/" "." (match-string 2 uri) t t))))
           cache-dir)))
    (unless (file-readable-p source-file)
      (let ((content (jsonrpc-request (eglot-java--find-server) :java/classFileContents (list :uri uri))))
        (make-directory cache-dir t)
        (with-temp-file source-file (insert content))))
    source-file))

(setf (alist-get "\\`jdt://" file-name-handler-alist nil nil #'equal) #'java--jdt-uri-handler)

(defun java--stop-fswatch (jdtls _event)
  (unless (process-live-p jdtls)
    (when-let ((watcher (process-get jdtls 'fswatch)))
      (delete-process watcher))))

(cl-defmethod eglot-register-capability
  ((server eglot-java-eclipse-jdt) (_method (eql workspace/didChangeWatchedFiles)) _id &key watchers)
  "Watch the project with one fswatch (FSEvents) process.
eglot's default takes a kqueue fd per directory, ~8k per beluca worktree,
which runs the daemon out of file descriptors."
  (let* ((jdtls (jsonrpc--process server))
         (root (expand-file-name (project-root (eglot--project server))))
         (globs (mapcar (lambda (watcher)
                          (let ((glob (plist-get watcher :globPattern)))
                            ;; project roots come as RelativePattern objects, not strings
                            (eglot--glob-compile
                             (if (stringp glob)
                                 glob
                               (concat (file-name-as-directory (eglot-uri-to-path (plist-get glob :baseUri)))
                                       (plist-get glob :pattern)))
                             t t)))
                        watchers))
         (pending ""))
    (when-let ((old (process-get jdtls 'fswatch)))
      (delete-process old))
    (process-put
     jdtls 'fswatch
     (make-process
      :name "jdtls-fswatch" :noquery t
      :command (list "fswatch" "-r" "-x" "-E" "--event-flag-separator=,"
                     "-e" (concat "^" (regexp-quote root) "\\.claude/")
                     "-e" "/(\\.git|\\.eglot-java|target|node_modules)/"
                     root)
      :filter (lambda (_proc output)
                (let ((lines (split-string (concat pending output) "\n"))
                      changes)
                  (setq pending (car (last lines)))
                  (dolist (line (butlast lines))
                    (when (string-match "\\`\\(.+\\) \\([^ ]+\\)\\'" line)
                      (let ((file (match-string 1 line))
                            (flags (match-string 2 line)))
                        (when (seq-some (lambda (glob) (funcall glob file)) globs)
                          (push `(:uri ,(eglot-path-to-uri file)
                                  :type ,(cond ((not (file-exists-p file)) 3)
                                               ((string-match-p "Created" flags) 1)
                                               (t 2)))
                                changes)))))
                  (when (and changes (jsonrpc-running-p server))
                    (jsonrpc-notify server :workspace/didChangeWatchedFiles
                                    `(:changes ,(vconcat (nreverse changes)))))))))
    (add-function :after (process-sentinel jdtls) #'java--stop-fswatch))
  (list t "OK"))
