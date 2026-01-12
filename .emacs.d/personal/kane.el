;; Atlas
(defvar *atlas-home* "/Users/jmayaalv/Developer/db-support")

(defun atlas-migration-name (path client branch)
  "New migration with `PATH` name on the given `CLIENT` using the `BRANCH` and current time."
  (format "%s/sql/%s/%s-%s.up.sql" path client (format-time-string "%Y%m%d%H%M%S") branch))

(defun atlas-migration (client branch)
  "Create a new migration on the given `CLIENT` in the new `BRANCH` and outputs the migration on a new buffer."
  (interactive "sclient? \nsbranch? ")
  (let ((migration-file-path (atlas-migration-name *atlas-home* client branch)))
    (switch-to-buffer (generate-new-buffer migration-file-path))
    (write-file migration-file-path)
    (message (format "new migration: %s on branch: %s" migration-file-path branch))))




;; CONNECT TO DB
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; aws sso login --profile kane-nonprod-db_writer                                                                   ;;
;; export TOKEN=$(aws rds generate-db-auth-token \                                                                  ;;
;;                    --hostname qa-allan-gray-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com \ ;;
;;                    --port 5432 \                                                                                 ;;
;;                    --region eu-central-1 \                                                                       ;;
;;                    --username db_writer \                                                                        ;;
;;                    --profile kane-nonprod-db_writer)
; aws rds describe-db-clusters \
;;--query 'DBClusters[*].[DBClusterIdentifier,Endpoint,Engine]' \
;;--output table --profile kane-nonprod-dev
;;
;;                                                                                                                  ;;
;; psql "host=qa-allan-gray-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com \                    ;;
;;       port=5432 \                                                                                                ;;
;;       sslmode=require \                                                                                          ;;
;;       dbname=imsallangrayt1adb \                                                                                 ;;
;;       user=db_writer \                                                                                           ;;
;;       password=$TOKEN"                                                                                           ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Aurora configuration
(defvar kane-aurora-port 5432
  "Default port for Aurora database connections.")

(defvar kane-aurora-region "eu-central-1"
  "AWS region for Aurora clusters.")

;; IAM token cache - tokens are valid for 15 minutes
(defvar kane-iam-token-cache (make-hash-table :test 'equal)
  "Cache for IAM tokens. Key is (hostname . username), value is (token . timestamp).")

(defvar kane-iam-token-ttl (* 14 60)
  "IAM token time-to-live in seconds. Default 14 minutes (tokens valid for 15).")

;; Last connection for quick reconnect
(defvar kane-last-connection nil
  "Last connection used with kane-sql for quick reconnect.")

(defun kane/get-cached-token (hostname username)
  "Get cached IAM token for HOSTNAME and USERNAME if still valid.
Returns token string or nil if not cached or expired."
  (let* ((cache-key (cons hostname username))
         (cached (gethash cache-key kane-iam-token-cache)))
    (when cached
      (let ((token (car cached))
            (timestamp (cdr cached))
            (now (float-time)))
        (if (< (- now timestamp) kane-iam-token-ttl)
            token
          ;; Token expired, remove from cache
          (remhash cache-key kane-iam-token-cache)
          nil)))))

(defun kane/cache-token (hostname username token)
  "Cache IAM TOKEN for HOSTNAME and USERNAME with current timestamp."
  (let ((cache-key (cons hostname username)))
    (puthash cache-key (cons token (float-time)) kane-iam-token-cache)))

(defun kane/aurora-get-auth-token (hostname username profile)
  "Generate AWS IAM auth token for HOSTNAME with USERNAME using PROFILE.
Checks cache first; generates new token if needed. Returns nil on error."
  (or (kane/get-cached-token hostname username)
      (condition-case err
          (let ((token (string-trim
                        (shell-command-to-string
                         (format "aws rds generate-db-auth-token --hostname %s --port %s --region %s --username %s --profile %s"
                                 hostname
                                 kane-aurora-port
                                 kane-aurora-region
                                 username
                                 profile)))))
            (if (string-prefix-p "An error occurred" token)
                (progn
                  (message "AWS IAM token generation failed. Check credentials: aws sso login --profile %s" profile)
                  nil)
              (progn
                (kane/cache-token hostname username token)
                token)))
        (error
         (message "Failed to generate IAM token: %s" (error-message-string err))
         nil))))

(defun kane/connection-needs-iam-p (connection-symbol)
  "Return non-nil if CONNECTION-SYMBOL requires AWS IAM authentication.
Detects Aurora clusters (both QA and prod) by hostname pattern.
Excludes SSH tunnel connections (localhost)."
  (let* ((conn-alist (cdr (assoc connection-symbol sql-connection-alist)))
         (server (cadr (assoc 'sql-server conn-alist))))
    (and server
         (stringp server)
         ;; Match any Aurora cluster (qa- or pdn-), but exclude localhost
         (string-match-p "aurora-cluster" server)
         (not (string= server "localhost")))))

(defun kane/get-aws-profile (connection-symbol)
  "Get the appropriate AWS profile for CONNECTION-SYMBOL.
Maps database username to AWS profile:
  db_writer -> kane-nonprod-db_writer
  db_maintainer -> kane-prod-db_maintainer"
  (let* ((conn-alist (cdr (assoc connection-symbol sql-connection-alist)))
         (user (cadr (assoc 'sql-user conn-alist))))
    (cond
     ((string= user "db_writer") "kane-nonprod-db_writer")
     ((string= user "db_maintainer") "kane-prod-db_maintainer")
     (t "kane-nonprod-db_writer")))) ; default fallback

(defun kane/format-connection-for-completion (connection-symbol)
  "Format CONNECTION-SYMBOL for better completion display.
Returns formatted string like 'agl          test1  [QA]'."
  (let* ((name (symbol-name connection-symbol))
         (parts (split-string name "\\."))
         (client (car parts))
         (env (or (cadr parts) ""))
         (env-tag (cond
                   ((kane/is-qa-connection-p connection-symbol) " [QA]")
                   ((kane/is-prod-connection-p connection-symbol) " [PROD]")
                   ((kane/is-localhost-connection-p connection-symbol) " [LOCAL]")
                   (t ""))))
    (format "%-12s %-6s%s" client env env-tag)))

(defun kane/filter-connections (predicate)
  "Return connections matching PREDICATE function."
  (seq-filter predicate (mapcar #'car sql-connection-alist)))

(defun kane/is-qa-connection-p (connection-symbol)
  "Return non-nil if CONNECTION-SYMBOL is a QA/test environment."
  (let ((name (symbol-name connection-symbol)))
    (string-match-p "test\\|qa" name)))

(defun kane/is-prod-connection-p (connection-symbol)
  "Return non-nil if CONNECTION-SYMBOL is a production environment."
  (let ((name (symbol-name connection-symbol)))
    (string-match-p "prod" name)))

(defun kane/is-localhost-connection-p (connection-symbol)
  "Return non-nil if CONNECTION-SYMBOL is a localhost connection."
  (let ((name (symbol-name connection-symbol)))
    (string-prefix-p "localhost" name)))

;; SQL servers
(setq sql-connection-alist
      '((localhost.dev
         (sql-name "localhost.dev")
         (sql-default-directory nil)
         (sql-postgres-program "psql")
         (sql-product 'postgres)
         (sql-port 5432)
         (sql-server "localhost")
         (sql-user "imsdev")
         (sql-database "imsdb_dev"))

        (localhost.agl
         (sql-name "localhost.agl")
         (sql-default-directory nil)
         (sql-postgres-program "psql")
         (sql-product 'postgres)
         (sql-port 5432)
         (sql-server "localhost")
         (sql-user "agldev")
         (sql-database "agldb_dev"))

        (localhost.test
         (sql-name "localhost.test")
         (sql-postgres-program "psql")
         (sql-default-directory nil)
         (sql-product 'postgres)
         (sql-port 5432)
         (sql-server "localhost")
         (sql-user "imstest")
         (sql-database "imsdb_test"))

        (allangray.test1
         (sql-name "allangray.test1")
         (sql-product 'postgres)
         (sql-server "qa-allan-gray-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com")
         (sql-port 5432)
         (sql-database "imsallangrayt1adb")
         (sql-user "db_writer"))

        (allangray.test2
         (sql-name "allangray.test2")
         (sql-product 'postgres)
         (sql-server "qa-allan-gray-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com")
         (sql-port 5432)
         (sql-database "imsallangrayt2adb")
         (sql-user "db_writer"))

        (allangray.prod
          (sql-name "allangray.prod")
          (sql-product 'postgres)
          (sql-server "pdn-allan-gray-aurora-cluster.cluster-czaaseae8xw7.eu-central-1.rds.amazonaws.com")
          (sql-port 5432)
          (sql-database "imsallangraypdnadb")
          (sql-user "db_maintainer"))

        (agl.test1
         (sql-name "agl.test1")
         (sql-product 'postgres)
         (sql-server "qa-agl-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com")
         (sql-port 5432)
         (sql-database "imsaglt1adb")
         (sql-user "db_writer"))

        (agl.test2
         (sql-name "agl.test2")
         (sql-product 'postgres)
         (sql-server "qa-agl-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com")
         (sql-port 5432)
         (sql-database "imsaglt2adb")
         (sql-user "db_writer"))

        (agl.test3
         (sql-name "agl.test3")
         (sql-product 'postgres)
         (sql-server "qa-agl-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com")
         (sql-port 5432)
         (sql-database "imsaglt3adb")
         (sql-user "db_writer"))

        (agl.test4
         (sql-name "agl.test4")
         (sql-product 'postgres)
         (sql-server "qa-agl-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com")
         (sql-port 5432)
         (sql-database "imsaglt4adb")
         (sql-user "db_writer"))

        (agl.test5
         (sql-name "agl.test5")
         (sql-product 'postgres)
         (sql-server "qa-agl-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com")
         (sql-port 5432)
         (sql-database "imsaglt5adb")
         (sql-user "db_writer"))

        ;; (agl.prod
        ;;  (sql-name "agl.prod")
        ;;  (sql-product 'postgres)
        ;;  (sql-server "pdn-agl-aurora-cluster.cluster-czaaseae8xw7.eu-central-1.rds.amazonaws.com")
        ;;  (sql-port 5432)
        ;;  (sql-database "imsaglpdnadb")
        ;;  (sql-user "db_maintainer"))

        (agl.prod
         (sql-name "agl.prod")
         (sql-postgres-program "/usr/local/pgsql/bin/psql")
         (sql-default-directory "/ssh:devel.jmayaalv@agldb:")
         (sql-product 'postgres)
         (sql-port 5432)
         (sql-server "localhost")
         (sql-user "imsaglprod")
         (sql-database "imsaglproddb"))

        (axonic.test1
         (sql-name "axonic.test1")
         (sql-product 'postgres)
         (sql-server "qa-axonic-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com")
         (sql-port 5432)
         (sql-database "imsaxonict1adb")
         (sql-user "db_writer"))

        (axonic.test2
         (sql-name "axonic.test2")
         (sql-product 'postgres)
         (sql-server "qa-axonic-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com")
         (sql-port 5432)
         (sql-database "imsaxonict2adb")
         (sql-user "db_writer"))

        (axonic.prod
         (sql-name "axonic.prod")
         (sql-product 'postgres)
         (sql-server "pdn-axonic-aurora-cluster.cluster-czaaseae8xw7.eu-central-1.rds.amazonaws.com")
         (sql-port 5432)
         (sql-database "imsaxonicpdnadb")
         (sql-user "db_maintainer"))

        (fnb.test1
         (sql-name "fnb.test1")
         (sql-product 'postgres)
         (sql-server "qa-fnb-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com")
         (sql-port 5432)
         (sql-database "imsfnbt1adb")
         (sql-user "db_writer"))

        (fnb.test2
         (sql-name "fnb.test2")
         (sql-product 'postgres)
         (sql-server "qa-fnb-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com")
         (sql-port 5432)
         (sql-database "imsfnbt2adb")
         (sql-user "db_writer"))

        (glacier.test1
         (sql-name "glacier.test1")
         (sql-product 'postgres)
         (sql-server "qa-glacier-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com")
         (sql-port 5432)
         (sql-database "imsglaciert1adb")
         (sql-user "db_writer"))

        (glacier.test2
         (sql-name "glacier.test2")
         (sql-product 'postgres)
         (sql-server "qa-glacier-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com")
         (sql-port 5432)
         (sql-database "imsglaciert2adb")
         (sql-user "db_writer"))

        (glacier.test3
         (sql-name "glacier.test3")
         (sql-product 'postgres)
         (sql-server "qa-glacier-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com")
         (sql-port 5432)
         (sql-database "imsglaciert3adb")
         (sql-user "db_writer"))

        (glacier.test4
         (sql-name "glacier.test4")
         (sql-product 'postgres)
         (sql-server "qa-glacier-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com")
         (sql-port 5432)
         (sql-database "imsglaciert4adb")
         (sql-user "db_writer"))

        ;; (glacier.prod
        ;;  (sql-name "glacier.prod")
        ;;  (sql-product 'postgres)
        ;;  (sql-server "pdn-glacier-aurora-cluster.cluster-czaaseae8xw7.eu-central-1.rds.amazonaws.com")
        ;;  (sql-port 5432)
        ;;  (sql-database "imsglacierpdnadb")
        ;;  (sql-user "db_maintainer"))

        (glacier.prod
         (sql-name "glacier.prod")
         (sql-postgres-program "/usr/local/pgsql/bin/psql")
         (sql-default-directory "/ssh:devel.jmayaalv@glacierdb:")
         (sql-product 'postgres)
         (sql-port 5432)
         (sql-server "localhost")
         (sql-user "imsglacierprod")
         (sql-database "imsglacierproddb"))

        (gosaver.test1
         (sql-name "gosaver.test1")
         (sql-product 'postgres)
         (sql-server "qa-gosaver-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com")
         (sql-port 5432)
         (sql-database "imsgosavert1adb")
         (sql-user "db_writer"))

         (gosaver.prod
          (sql-name "gosaver.prod")
          (sql-product 'postgres)
          (sql-server "pdn-gosaver-aurora-cluster.cluster-czaaseae8xw7.eu-central-1.rds.amazonaws.com")
          (sql-port 5432)
          (sql-database "imsgosaverpdnadb")
          (sql-user "db_maintainer"))

        (lic.test1
         (sql-name "lic.test1")
         (sql-product 'postgres)
         (sql-server "qa-lic-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com")
         (sql-port 5432)
         (sql-database "imslict1adb")
         (sql-user "db_writer"))

        (lic.prod
         (sql-name "lic.prod")
         (sql-product 'postgres)
         (sql-server "pdn-lic-aurora-cluster.cluster-czaaseae8xw7.eu-central-1.rds.amazonaws.com")
         (sql-port 5432)
         (sql-database "imslicpdnadb")
         (sql-user "db_maintainer"))

        (nav.prod
         (sql-name "nav.prod")
         (sql-product 'postgres)
         (sql-server "pdn-nav-aurora-cluster.cluster-czaaseae8xw7.eu-central-1.rds.amazonaws.com")
         (sql-port 5432)
         (sql-database "imsnavpdnadb")
         (sql-user "db_maintainer"))

        (omnia.prod
         (sql-name "omnia.prod")
         (sql-product 'postgres)
         (sql-server "pdn-omnia-aurora-cluster.cluster-czaaseae8xw7.eu-central-1.rds.amazonaws.com")
         (sql-port 5432)
         (sql-database "imsomniapdnadb")
         (sql-user "db_maintainer"))

        (omnia.test1
         (sql-name "omnia.test1")
         (sql-product 'postgres)
         (sql-server "qa-omnia-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com")
         (sql-port 5432)
         (sql-database "imsomniat1adb")
         (sql-user "db_writer"))

        (omi.prod
          (sql-name "omi.prod")
          (sql-product 'postgres)
          (sql-server "pdn-omi-aurora-cluster.cluster-czaaseae8xw7.eu-central-1.rds.amazonaws.com")
          (sql-port 5432)
          (sql-database "imsomipdnadb")
          (sql-user "db_maintainer"))

        (omi.test1
         (sql-name "omi.test1")
         (sql-product 'postgres)
         (sql-server "qa-omi-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com")
         (sql-port 5432)
         (sql-database "imsomit1adb")
         (sql-user "db_writer"))

        (omi.test2
         (sql-name "omi.test2")
         (sql-product 'postgres)
         (sql-server "qa-omi-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com")
         (sql-port 5432)
         (sql-database "imsomit2adb")
         (sql-user "db_writer"))

        (omi.test3
         (sql-name "omi.test3")
         (sql-product 'postgres)
         (sql-server "qa-omi-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com")
         (sql-port 5432)
         (sql-database "imsomit3adb")
         (sql-user "db_writer"))

        (omi.test4
         (sql-name "omi.test4")
         (sql-product 'postgres)
         (sql-server "qa-omi-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com")
         (sql-port 5432)
         (sql-database "imsomit4adb")
         (sql-user "db_writer"))

        (plac.prod
         (sql-name "plac.prod")
         (sql-product 'postgres)
         (sql-server "pdn-plac-aurora-cluster.cluster-czaaseae8xw7.eu-central-1.rds.amazonaws.com")
         (sql-port 5432)
         (sql-database "imsplacpdnadb")
         (sql-user "db_maintainer"))

        (plac.test1
         (sql-name "plac.test")
         (sql-product 'postgres)
         (sql-server "qa-plac-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com")
         (sql-port 5432)
         (sql-database "imsplact1adb")
         (sql-user "db_writer"))

        (provlife.test1
         (sql-name "provlife.test1")
         (sql-product 'postgres)
         (sql-server "qa-provlife-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com")
         (sql-port 5432)
         (sql-database "imsprovlifet1adb")
         (sql-user "db_writer"))

        (provlife.test2
         (sql-name "provlife.test2")
         (sql-product 'postgres)
         (sql-server "qa-provlife-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com")
         (sql-port 5432)
         (sql-database "imsprovlifet2adb")
         (sql-user "db_writer"))

        (provlife.test3
         (sql-name "provlife.test3")
         (sql-product 'postgres)
         (sql-server "qa-provlife-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com")
         (sql-port 5432)
         (sql-database "imsprovlifet3adb")
         (sql-user "db_writer"))

         (provlife.prod
          (sql-name "provlife.prod")
          (sql-product 'postgres)
          (sql-server "pdn-provlife-aurora-cluster.cluster-czaaseae8xw7.eu-central-1.rds.amazonaws.com")
          (sql-port 5432)
          (sql-database "imsprovlifepdnadb")
          (sql-user "db_maintainer"))


        (prospero.test1
         (sql-name "prospero.test1")
         (sql-product 'postgres)
         (sql-server "qa-prospero-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com")
         (sql-port 5432)
         (sql-database "imsprosperot1adb")
         (sql-user "db_writer"))

        (prospero.test2
         (sql-name "prospero.test2")
         (sql-product 'postgres)
         (sql-server "qa-prospero-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com")
         (sql-port 5432)
         (sql-database "imsprosperot2adb")
         (sql-user "db_writer"))

        (prospero.prod
         (sql-name "prospero.prod")
         (sql-product 'postgres)
         (sql-server "pdn-prospero-aurora-cluster.cluster-czaaseae8xw7.eu-central-1.rds.amazonaws.com")
         (sql-port 5432)
         (sql-database "imsprosperoadb")
         (sql-user "db_maintainer"))

        (sbi.test1
         (sql-name "sbi.test1")
         (sql-product 'postgres)
         (sql-server "qa-sbi-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com")
         (sql-port 5432)
         (sql-database "imssbit1adb")
         (sql-user "db_writer"))

        (sbi.test2
         (sql-name "sbi.test2")
         (sql-product 'postgres)
         (sql-server "qa-sbi-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com")
         (sql-port 5432)
         (sql-database "imssbit2adb")
         (sql-user "db_writer"))

        (sbi.test3
         (sql-name "sbi.test3")
         (sql-product 'postgres)
         (sql-server "qa-sbi-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com")
         (sql-port 5432)
         (sql-database "imssbit3adb")
         (sql-user "db_writer"))

        (sbi.test4
         (sql-name "sbi.test4")
         (sql-product 'postgres)
         (sql-server "qa-sbi-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com")
         (sql-port 5432)
         (sql-database "imssbit4adb")
         (sql-user "db_writer"))

         (sbi.prod
          (sql-name "sbi.prod")
          (sql-product 'postgres)
          (sql-server "pdn-sbi-aurora-cluster.cluster-czaaseae8xw7.eu-central-1.rds.amazonaws.com")
          (sql-port 5432)
          (sql-database "imssbipdnadb")
          (sql-user "db_maintainer"))


       (secura.test1
        (sql-name "secura.test1")
        (sql-product 'postgres)
        (sql-server "qa-secura-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com")
        (sql-port 5432)
        (sql-database "imssecurat1adb")
        (sql-user "db_writer"))

       (secura.prod
        (sql-name "secura.prod")
        (sql-product 'postgres)
        (sql-server "pdn-secura-aurora-cluster.cluster-czaaseae8xw7.eu-central-1.rds.amazonaws.com")
        (sql-port 5432)
        (sql-database "imssecurapdnadb")
        (sql-user "db_maintainer"))

       (sukoon.test1
        (sql-name "sukoon.test1")
        (sql-product 'postgres)
        (sql-server "qa-sukoon-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com")
        (sql-port 5432)
        (sql-database "imssukoont1adb")
        (sql-user "db_writer"))

       (sukoon.test2
        (sql-name "sukoon.test2")
        (sql-product 'postgres)
        (sql-server "qa-sukoon-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com")
        (sql-port 5432)
        (sql-database "imssukoont2adb")
        (sql-user "db_writer"))

       (sukoon.test3
        (sql-name "sukoon.test3")
        (sql-product 'postgres)
        (sql-server "qa-sukoon-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com")
        (sql-port 5432)
        (sql-database "imssukoont3adb")
        (sql-user "db_writer"))


        (sukoon.prod
         (sql-name "sukoon.prod")
         (sql-product 'postgres)
         (sql-server "pdn-sukoon-aurora-cluster.cluster-czaaseae8xw7.eu-central-1.rds.amazonaws.com")
         (sql-port 5432)
         (sql-database "imssukoonpdnadb")
         (sql-user "db_maintainer"))

       (veritas.prod
        (sql-name "veritas.prod")
        (sql-product 'postgres)
        (sql-server "pdn-veritas-aurora-cluster.cluster-czaaseae8xw7.eu-central-1.rds.amazonaws.com")
        (sql-port 5432)
        (sql-database "imsveritaspdnadb")
        (sql-user "db_maintainer"))

       (vertias.test1
        (sql-name "veritas.test1")
        (sql-product 'postgres)
        (sql-server "qa-veritas-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com")
        (sql-port 5432)
        (sql-database "imsveritast1adb")
        (sql-user "db_writer"))))

(defvar kane-sql-history nil
  "History list for kane-sql database selections.")

(defun kane-sql (&optional filter-fn filter-desc)
  "Connect to a database using interactive selection.
Automatically handles AWS IAM authentication for Aurora QA clusters.
Optional FILTER-FN filters connections; FILTER-DESC describes the filter."
  (interactive)
  (let* ((all-connections (mapcar #'car sql-connection-alist))
         (connections (if filter-fn
                          (seq-filter filter-fn all-connections)
                        all-connections))
         ;; Create formatted display -> symbol mapping
         (display-alist (mapcar (lambda (conn)
                                  (cons (kane/format-connection-for-completion conn) conn))
                                connections))
         (prompt (if filter-desc
                     (format "Database (%s): " filter-desc)
                   "Database connection: "))
         (selected-display (completing-read prompt
                                            (mapcar #'car display-alist)
                                            nil t nil
                                            'kane-sql-history))
         (connection-name (cdr (assoc selected-display display-alist)))
         (conn-alist (cdr (assoc connection-name sql-connection-alist)))
         (server (cadr (assoc 'sql-server conn-alist)))
         (username (cadr (assoc 'sql-user conn-alist))))

    ;; Save for quick reconnect
    (setq kane-last-connection connection-name)

    ;; Handle IAM authentication for QA Aurora clusters
    (if (kane/connection-needs-iam-p connection-name)
        (let ((profile (kane/get-aws-profile connection-name))
              (cached (kane/get-cached-token server username)))
          (if cached
              (progn
                (setq sql-password cached)
                (setenv "PGPASSWORD" sql-password)
                (setenv "PGSSLMODE" "require")
                (setq sql-login-params '(server port database user))
                (message "Using cached IAM token for %s" server))
            (progn
              (message "Generating AWS IAM token for %s using profile %s..." server profile)
              (let ((token (kane/aurora-get-auth-token server username profile)))
                (if token
                    (progn
                      (setq sql-password token)
                      (setenv "PGPASSWORD" sql-password)
                      (setenv "PGSSLMODE" "require")
                      (setq sql-login-params '(server port database user))
                      (message "IAM token generated successfully"))
                  (error "Cannot connect: IAM token generation failed. Run: aws sso login --profile %s" profile))))))
      ;; For non-IAM connections, reset to default login params
      (progn
        (setq sql-password nil)
        (setenv "PGPASSWORD" "")
        (setenv "PGSSLMODE" "")
        (setq sql-login-params '(server port database user password))))

    ;; Connect using existing helper
    (my-sql-connect 'postgres connection-name)))

(defun kane-sql-reconnect ()
  "Reconnect to the last database connection without prompting."
  (interactive)
  (if kane-last-connection
      (let* ((connection-name kane-last-connection)
             (conn-alist (cdr (assoc connection-name sql-connection-alist)))
             (server (cadr (assoc 'sql-server conn-alist)))
             (username (cadr (assoc 'sql-user conn-alist))))

        ;; Handle IAM authentication for QA Aurora clusters
        (if (kane/connection-needs-iam-p connection-name)
            (let ((profile (kane/get-aws-profile connection-name))
                  (cached (kane/get-cached-token server username)))
              (if cached
                  (progn
                    (setq sql-password cached)
                    (setenv "PGPASSWORD" sql-password)
                    (setenv "PGSSLMODE" "require")
                    (setq sql-login-params '(server port database user))
                    (message "Using cached IAM token for %s" server))
                (progn
                  (message "Generating AWS IAM token for %s using profile %s..." server profile)
                  (let ((token (kane/aurora-get-auth-token server username profile)))
                    (if token
                        (progn
                          (setq sql-password token)
                          (setenv "PGPASSWORD" sql-password)
                          (setenv "PGSSLMODE" "require")
                          (setq sql-login-params '(server port database user))
                          (message "IAM token generated successfully"))
                      (error "Cannot connect: IAM token generation failed. Run: aws sso login --profile %s" profile))))))
          ;; For non-IAM connections, reset to default login params
          (progn
            (setq sql-password nil)
            (setenv "PGPASSWORD" "")
            (setenv "PGSSLMODE" "")
            (setq sql-login-params '(server port database user password))))

        ;; Connect using existing helper
        (message "Reconnecting to %s..." connection-name)
        (my-sql-connect 'postgres connection-name))
    (error "No previous connection to reconnect to. Use M-x kane-sql first")))

(defun kane-sql-qa ()
  "Connect to a QA/test database."
  (interactive)
  (kane-sql #'kane/is-qa-connection-p "QA/Test"))

(defun kane-sql-prod ()
  "Connect to a production database."
  (interactive)
  (kane-sql #'kane/is-prod-connection-p "Production"))

(defun kane-sql-localhost ()
  "Connect to a localhost database."
  (interactive)
  (kane-sql #'kane/is-localhost-connection-p "Localhost"))

(defun my-sql-connect (product connection)
   "Create a new sql CONNECTION with a given PRODUCT."
    (setq sql-product product)
    (sql-connect connection))

(defun sql-connect-preset (product name)
  "Connect to a predefined SQL connection listed in `sql-connection-alist'"
  (setq sql-product product)
  (eval `(let ,(cdr (assoc name sql-connection-alist))
           (flet ((sql-get-login (&rest what)))
                 (sql-product-interactive sql-product)))))


;; Kane SQL prefix map
(define-prefix-command 'kane-sql-map)
(global-set-key (kbd "C-c M-k s") 'kane-sql-map)

;; Keybindings for kane-sql functions
(define-key kane-sql-map (kbd "s") 'kane-sql)
(define-key kane-sql-map (kbd "r") 'kane-sql-reconnect)
(define-key kane-sql-map (kbd "q") 'kane-sql-qa)
(define-key kane-sql-map (kbd "p") 'kane-sql-prod)
(define-key kane-sql-map (kbd "l") 'kane-sql-localhost)
