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
;;                    --profile kane-nonprod-db_writer)                                                             ;;
;;                                                                                                                  ;;
;; psql "host=qa-allan-gray-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com \                    ;;
;;       port=5432 \                                                                                                ;;
;;       sslmode=require \                                                                                          ;;
;;       dbname=imsallangrayt1adb \                                                                                 ;;
;;       user=db_writer \                                                                                           ;;
;;       password=$TOKEN"                                                                                           ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun kane/aurora-get-auth-token (hostname profile)
  (string-trim
   (shell-command-to-string
    (format "aws rds generate-db-auth-token --hostname %s --port 5432 --region eu-central-1 --username db_writer --profile %s"
            hostname
            profile))))

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
         (sql-database "imsallangrayadb")
         (sql-user "db_maintainer"))

        (allangray.prod.ibm
         (sql-name "allangray.prod.ibm")
         (sql-postgres-program "/usr/local/pgsql/bin/psql")
         (sql-default-directory "/ssh:devel.jmayaalv@allangraydb:")
         (sql-product 'postgres)
         (sql-port 5432)
         (sql-server "localhost")
         (sql-user "imsagrayprod")
         (sql-database "imsagrayproddb"))

        (agl.test1
         (sql-name "agl.test1")
         (sql-product 'postgres)
         (sql-server "qa-agl-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com")
         (sql-port 5432)
         (sql-database "imsaglt1a")
         (sql-user "db_writer"))

        (agl.test2
         (sql-name "agl.test2")
         (sql-product 'postgres)
         (sql-server "qa-agl-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com")
         (sql-port 5432)
         (sql-database "imsaglt2a")
         (sql-user "db_writer"))

        (agl.test3
         (sql-name "agl.test3")
         (sql-product 'postgres)
         (sql-server "qa-agl-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com")
         (sql-port 5432)
         (sql-database "imsaglt3a")
         (sql-user "db_writer"))

        (agl.test4
         (sql-name "agl.test4")
         (sql-product 'postgres)
         (sql-server "qa-agl-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com")
         (sql-port 5432)
         (sql-database "imsaglt4a")
         (sql-user "db_writer"))

        (agl.test5
         (sql-name "agl.test5")
         (sql-product 'postgres)
         (sql-server "qa-agl-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com")
         (sql-port 5432)
         (sql-database "imsaglt5a")
         (sql-user "db_writer"))

        (agl.prod
         (sql-name "agl.prod")
         (sql-product 'postgres)
         (sql-server "pdn-agl-aurora-cluster.cluster-czaaseae8xw7.eu-central-1.rds.amazonaws.com")
         (sql-port 5432)
         (sql-database "imsagladb")
         (sql-user "db_maintainer"))

        (agl.prod.ibm
         (sql-name "agl.prod.ibm")
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
         (sql-database "imsaxonicadb")
         (sql-user "db_maintainer"))

        (fnb.test1
         (sql-name "fnb.test1")
         (sql-product 'postgres)
         (sql-server "qa-fnb-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com")
         (sql-port 5432)
         (sql-database "imsfnbt1adb")
         (sql-user "db_writer"))

        (fnb.test1
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

        (glacier.prod
         (sql-name "glacier.prod")
         (sql-product 'postgres)
         (sql-server "pdn-glacier-aurora-cluster.cluster-czaaseae8xw7.eu-central-1.rds.amazonaws.co")
         (sql-port 5432)
         (sql-database "imsglacieradb")
         (sql-user "db_maintainer"))

        (glacier.prod.ibm
         (sql-name "glacier.prod.ibm")
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
         (sql-database "imsgosaveradb")
         (sql-user "db_writer"))

        (gosaver.prod.ibm
         (sql-name "gosaver.prod.ibm")
         (sql-default-directory "/ssh:devel.jmayaalv@gosaverdb:")
         (sql-postgres-program "/usr/local/pgsql/bin/psql")
         (sql-product 'postgres)
         (sql-port 5432)
         (sql-server "localhost")
         (sql-user "imsgosaverprod")
         (sql-database "imsgosaverproddb"))

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
         (sql-database "imslicadb")
         (sql-user "db_maintainer"))

        (nav.prod
         (sql-name "nav.prod")
         (sql-product 'postgres)
         (sql-server "pdn-nav-aurora-cluster.cluster-czaaseae8xw7.eu-central-1.rds.amazonaws.com")
         (sql-port 5432)
         (sql-database "imsnavadb")
         (sql-user "db_maintainer"))

        (omnia.prod
         (sql-name "omnia.prod")
         (sql-product 'postgres)
         (sql-server "pdn-omnia-aurora-cluster.cluster-czaaseae8xw7.eu-central-1.rds.amazonaws.com")
         (sql-port 5432)
         (sql-database "imsomniaadb")
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
         (sql-database "imsomiadb")
         (sql-user "db_maintainer"))

        (omi.prod.ibm
         (sql-name "omi.prod.ibm")
         (sql-default-directory "/ssh:devel.jmayaalv@omidb:")
         (sql-postgres-program "/usr/local/pgsql/bin/psql")
         (sql-product 'postgres)
         (sql-port 5432)
         (sql-server "localhost")
         (sql-user "imsomiprod")
         (sql-database "imsomiproddb"))

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
         (sql-database "imsplacadb")
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
         (sql-name "plac.prod")
         (sql-product 'postgres)
         (sql-server "pdn-provlife-aurora-cluster.cluster-czaaseae8xw7.eu-central-1.rds.amazonaws.com")
         (sql-port 5432)
         (sql-database "imsprovlifeadb")
         (sql-user "db_maintainer"))

        (provlife.prod.ibm
         (sql-name "provlife.prod")
         (sql-postgres-program "/usr/local/pgsql/bin/psql")
         (sql-default-directory "/ssh:devel.jmayaalv@provlifedb:")
         (sql-product 'postgres)
         (sql-port 5432)
         (sql-server "localhost")
         (sql-user "imsplifeprod")
         (sql-database "imsplifeproddb"))

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
         (sql-database "imssbiadb")
         (sql-user "db_maintainer"))

       (sbi.prod.aws
        (sql-name "sbi.prod")
        (sql-default-directory "/ssh:devel.jmayaalv@sbidb:")
        (sql-postgres-program "/usr/local/pgsql/bin/psql")
        (sql-product 'postgres)
        (sql-port 5432)
        (sql-server "localhost")
        (sql-user "imssbiprod")
        (sql-database "imssbiproddb"))

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
        (sql-database "imssecuraadb")
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
        (sql-database "imssukoonadb")
        (sql-user "db_maintainer"))

       (veritas.prod
        (sql-name "veritas.prod")
        (sql-product 'postgres)
        (sql-server "pdn-veritas-aurora-cluster.cluster-czaaseae8xw7.eu-central-1.rds.amazonaws.com")
        (sql-port 5432)
        (sql-database "imsveritasadb")
        (sql-user "db_maintainer"))

       (vertias.test1
        (sql-name "veritas.test1")
        (sql-product 'postgres)
        (sql-server "qa-veritas-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com")
        (sql-port 5432)
        (sql-database "imsveritast1adb")
        (sql-user "db_writer"))))

 (defun sql-localhost.dev ()
   "Create a new sql connection to the local dev db."
   (interactive)
   (my-sql-connect  'postgres 'localhost.dev))

(defun sql-localhost.agl ()
  "Create a new sql connection to the local agl db."
  (interactive)
  (my-sql-connect  'postgres 'localhost.agl))

(defun sql-allangray.test1 ()
   "Create a new sql connection to allan gray test1 db."
   (interactive)
   (setq sql-password
         (kane/aurora-get-auth-token "qa-allan-gray-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com"
                                     "kane-nonprod-db_writer"))
   (setenv "PGPASSWORD" sql-password)
   (setq sql-login-params '(server port database user))
   (my-sql-connect  'postgres 'allangray.test1))

(defun sql-allangray.test2 ()
  "Create a new sql connection to allan gray test1 db."
  (interactive)
  (setq sql-password
        (kane/aurora-get-auth-token "qa-allan-gray-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com"
                                    "kane-nonprod-db_writer"))
  (setenv "PGPASSWORD" sql-password)
  (setq sql-login-params '(server port database user))

  (my-sql-connect  'postgres 'allangray.test2))

(defun sql-allangray.prod ()
  "Create a new sql connection to allan gray prod db."
  (interactive)
  (my-sql-connect  'postgres 'allangray.prod))

(defun sql-axonic.test1 ()
  "Create a new sql connection to axonic test1 db."
  (interactive)
  (setq sql-password
        (kane/aurora-get-auth-token "qa-axonic-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com"
                                    "kane-nonprod-db_writer"))
  (setenv "PGPASSWORD" sql-password)
  (setq sql-login-params '(server port database user))
  (my-sql-connect  'postgres 'axonic.test1))

(defun sql-axonic.test2 ()
  "Create a new sql connection to axonic test2 db."
  (interactive)
  (setq sql-password
        (kane/aurora-get-auth-token "qa-axonic-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com"
                                    "kane-nonprod-db_writer"))
  (setenv "PGPASSWORD" sql-password)
  (setq sql-login-params '(server port database user))
  (my-sql-connect  'postgres 'axonic.test2))

(defun sql-axonic.prod ()
  "Create a new sql connection to axonic prod db."
  (interactive)
  (my-sql-connect  'postgres 'axonic.prod))


(defun sql-agl.test1 ()
  "Create a new sql connection to agl test1 db."
  (interactive)
  (setq sql-password
        (kane/aurora-get-auth-token "qa-agl-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com"
                                    "kane-nonprod-db_writer"))
  (setenv "PGPASSWORD" sql-password)
  (message "Token set: " sql-password)
  (setq sql-login-params '(server port database user))
  (my-sql-connect  'postgres 'agl.test1))

(defun sql-agl.test2 ()
  "Create a new sql connection to agl test2 db."
  (interactive)
  (setq sql-password
        (kane/aurora-get-auth-token "qa-agl-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com"
                                    "kane-nonprod-db_writer"))
  (setenv "PGPASSWORD" sql-password)
  (message "Token set: " sql-password)
  (setq sql-login-params '(server port database user))
  (my-sql-connect  'postgres 'agl.test2))

(defun sql-agl.test3 ()
  "Create a new sql connection to agl test5 db."
  (interactive)
  (setq sql-password
        (kane/aurora-get-auth-token "qa-agl-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com"
                                    "kane-nonprod-db_writer"))
  (setenv "PGPASSWORD" sql-password)
  (message "Token set: " sql-password)
  (setq sql-login-params '(server port database user))
  (my-sql-connect  'postgres 'agl.test3))

(defun sql-agl.test4 ()
  "Create a new sql connection to agl test4 db."
  (interactive)
  (setq sql-password
        (kane/aurora-get-auth-token "qa-agl-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com"
                                    "kane-nonprod-db_writer"))
  (setenv "PGPASSWORD" sql-password)
  (message "Token set: " sql-password)
  (setq sql-login-params '(server port database user))
  (my-sql-connect  'postgres 'agl.test4))

(defun sql-agl.test5 ()
  "Create a new sql connection to agl test5 db."
  (interactive)
  (setq sql-password
        (kane/aurora-get-auth-token "qa-agl-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com"
                                    "kane-nonprod-db_writer"))
  (setenv "PGPASSWORD" sql-password)
  (message "Token set: " sql-password)
  (setq sql-login-params '(server port database user))
  (my-sql-connect  'postgres 'agl.test5))

 (defun sql-allangray.test2 ()
  "Create a new sql connection to allan gray test2 db."
  (interactive)
  (my-sql-connect  'postgres 'allangray.test2))

 (defun sql-nav.prod ()
   "Create a new sql connection to nav  db."
   (interactive)
   (my-sql-connect  'postgres 'nav.prod))

 (defun sql-localhost.test ()
   "Create a new sql connection to the local test db."
   (interactive)
   (my-sql-connect  'postgres 'localhost.test))

 (defun sql-prospero.test ()
   "Create a new sql connection to the next geokn test db"
   (interactive)
   (my-sql-connect  'postgres 'prospero.test))

(defun sql-prospero.prod ()
  "Create a new sql connection to prospero db."
  (interactive)
  (my-sql-connect  'postgres 'prospero.prod))

(defun sql-lic.test ()
  "Create a new sql connection to lic test1"
  (interactive)
  (my-sql-connect  'postgres 'lic.test))

(defun sql-lic.prod ()
  "Create a new sql connection to lic prod"
  (interactive)
  (my-sql-connect  'postgres 'lic.prod))

(defun sql-sbi.test1 ()
  "Create a new sql connection to sbi test1 db."
  (interactive)
  (setq sql-password
        (kane/aurora-get-auth-token "qa-sbi-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com"
                                    "kane-nonprod-db_writer"))
  (setenv "PGPASSWORD" sql-password)
  (setq sql-login-params '(server port database user))

  (my-sql-connect  'postgres 'sbi.test1))

(defun sql-sbi.test2 ()
  "Create a new sql connection to sbi test2 db."
  (interactive)
  (setq sql-password
        (kane/aurora-get-auth-token "qa-sbi-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com"
                                    "kane-nonprod-db_writer"))
  (setenv "PGPASSWORD" sql-password)
  (setq sql-login-params '(server port database user))

  (my-sql-connect  'postgres 'sbi.test2))

(defun sql-sbi.test3 ()
  "Create a new sql connection to sbi test3 db."
  (interactive)
  (setq sql-password
        (kane/aurora-get-auth-token "qa-sbi-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com"
                                    "kane-nonprod-db_writer"))
  (setenv "PGPASSWORD" sql-password)
  (setq sql-login-params '(server port database user))

  (my-sql-connect  'postgres 'sbi.test3))

(defun sql-sbi.test4 ()
  "Create a new sql connection to sbi test4 db."
  (interactive)
  (setq sql-password
        (kane/aurora-get-auth-token "qa-sbi-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com"
                                    "kane-nonprod-db_writer"))
  (setenv "PGPASSWORD" sql-password)
  (setq sql-login-params '(server port database user))
  (my-sql-connect  'postgres 'sbi.test4))

(defun sql-fnb.test1 ()
  "Create a new sql connection to fnb test1"
  (interactive)
  (my-sql-connect  'postgres 'fnb.test1))

(defun sql-fnb.test2 ()
  "Create a new sql connection to fnb test2"
  (interactive)
  (my-sql-connect  'postgres 'fnb.test2))

(defun sql-sbi.prod ()
  "Create a new sql connection to sbi prod"
  (interactive)
  (my-sql-connect  'postgres 'sbi.prod))

(defun sql-oic.prod ()
   "Create a new sql connection to the oic prod db."
    (interactive)
    (my-sql-connect 'postgres 'oic.prod))

(defun sql-omnia.prod ()
   "Create a new sql connection to the omnia prod db."
   (interactive)
   (my-sql-connect 'postgres 'omnia.prod))

 (defun sql-agl.prod ()
   "Create a new sql connection to the agl prod db."
   (interactive)
   (my-sql-connect 'postgres 'agl.prod))

 (defun sql-omi.prod ()
   "Create a new sql connection to the omi prod db."
   (interactive)
   (my-sql-connect 'postgres 'omi.prod))

(defun sql-omi.ps ()
  "Create a new sql connection to the omi ps db."
  (interactive)
  (my-sql-connect 'postgres 'omi.ps))

(defun sql-gosaver.test1 ()
  "Create a new sql connection to the gosaver test1 db."
  (interactive)
  (my-sql-connect 'postgres 'gosaver.test1))

(defun sql-gosaver.prod ()
  "Create a new sql connection to the gosaver prod db."
  (interactive)
  (my-sql-connect 'postgres 'gosaver.prod))

(defun sql-sukoon.test1 ()
  "Create a new sql connection to sukoon test1 db."
  (interactive)
  (setq sql-password
        (kane/aurora-get-auth-token "qa-sukoon-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com"
                                    "kane-nonprod-db_writer"))
  (setenv "PGPASSWORD" sql-password)
  (setq sql-login-params '(server port database user))
  (my-sql-connect  'postgres 'sukoon.test1))

(defun sql-sukoon.test2 ()
  "Create a new sql connection to sukoon test2 db."
  (interactive)
  (setq sql-password
        (kane/aurora-get-auth-token "qa-sukoon-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com"
                                    "kane-nonprod-db_writer"))
  (setenv "PGPASSWORD" sql-password)
  (setq sql-login-params '(server port database user))
  (my-sql-connect  'postgres 'sukoon.test2))

(defun sql-sukoon.test3 ()
  "Create a new sql connection to sukoon test3 db."
  (interactive)
  (setq sql-password
        (kane/aurora-get-auth-token "qa-sukoon-aurora-cluster.cluster-cf4s6q6esomf.eu-central-1.rds.amazonaws.com"
                                    "kane-nonprod-db_writer"))
  (setenv "PGPASSWORD" sql-password)
  (setq sql-login-params '(server port database user))
  (my-sql-connect  'postgres 'sukoon.test3))


 (defun sql-glacier.prod ()
   "Create a new sql connection to the glacier prod db."
   (interactive)
   (my-sql-connect 'postgres 'glacier.prod))

 (defun sql-argus.prod ()
   "Create a new sql connection to the argus prod db."
    (interactive)
    (my-sql-connect 'postgres 'argus.prod))

 (defun sql-argus.test2 ()
   "Create a new sql connection to the argus prod db."
    (interactive)
    (my-sql-connect 'postgres 'argus.test2))

 (defun sql-plac.prod ()
   "Create a new sql connection to the plac prod db."
    (interactive)
    (my-sql-connect 'postgres 'plac.prod))

 (defun sql-plac.test ()
   "Create a new sql connection to the plac test db."
    (interactive)
    (my-sql-connect 'postgres 'plac.test))

 (defun sql-glacier.test ()
   "Create a new sql connection to the glacier test db."
    (interactive)
    (my-sql-connect 'postgres 'glacier.test))

 (defun sql-glacier.test2 ()
   "Create a new sql connection to the glacier test2 db."
    (interactive)
    (my-sql-connect 'postgres 'glacier.test2))

 (defun sql-glacier.test3 ()
  "Create a new sql connection to the glacier test3 db."
  (interactive)
  (my-sql-connect 'postgres 'glacier.test3))

(defun sql-glacier.test4 ()
  "Create a new sql connection to the glacier test4 db."
  (interactive)
  (my-sql-connect 'postgres 'glacier.test4))

 (defun sql-veritas.test ()
   "Create a new sql connection to the veritas test db."
    (interactive)
    (my-sql-connect 'postgres 'veritas.test))

 (defun sql-veritas.prod ()
   "Create a new sql connection to the veritas prod db."
    (interactive)
    (my-sql-connect 'postgres 'veritas.prod))

 (defun sql-sanlam.prod ()
   "Create a new sql connection to the sanlam prod db."
    (interactive)
    (my-sql-connect 'postgres 'sanlam.prod))

(defun sql-sanlam.test ()
   "Create a new sql connection to the sanlam test 1 db."
    (interactive)
    (my-sql-connect 'postgres 'sanlam.test))

 (defun sql-northstar.prod ()
   "Create a new sql connection to the sanlam prod db."
    (interactive)
    (my-sql-connect 'postgres 'northstar.prod))

 (defun sql-northstar.test ()
   "Create a new sql connection to the northstar test db."
    (interactive)
    (my-sql-connect 'postgres 'northstar.test))

 (defun sql-omi.test1 ()
   "Create a new sql connection to the omi test1 db."
    (interactive)
    (my-sql-connect 'postgres 'omi.test1))

 (defun sql-omi.test2 ()
   "Create a new sql connection to the omi test2 db."
    (interactive)
    (my-sql-connect 'postgres 'omi.test2))

 (defun sql-omi.test4 ()
   "Create a new sql connection to the omi test4 db."
    (interactive)
    (my-sql-connect 'postgres 'omi.test4))

(defun sql-provlife.test1 ()
  "Create a new sql connection to the providence life test1 db."
  (interactive)
  (my-sql-connect 'postgres 'provlife.test1))

(defun sql-provlife.test2 ()
  "Create a new sql connection to the providence life test2 db."
  (interactive)
  (my-sql-connect 'postgres 'provlife.test2))

(defun sql-provlife.test3 ()
  "Create a new sql connection to the providence life test3 db."
  (interactive)
  (my-sql-connect 'postgres 'provlife.test3))

(defun sql-provlife.prod ()
  "Create a new sql connection to the providence life prod db."
  (interactive)
  (my-sql-connect 'postgres 'provlife.prod))

 (defun sql-omnia.test ()
   "Create a new sql connection to the omnia test db."
    (interactive)
    (my-sql-connect 'postgres 'omnia.test))

(defun sql-secura.test1 ()
  "Create a new sql connection to the secura test 1 db."
  (interactive)
  (my-sql-connect  'postgres 'secura.test1))

(defun sql-secura.prod ()
  "Create a new sql connection to the secura prod  db."
  (interactive)
  (my-sql-connect  'postgres 'secura.prod))

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
