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

        (nav.prod
         (sql-name "nav.prod")
          (sql-default-directory "/ssh:devel.jmayaalv@navdb:")
         (sql-postgres-program "/usr/local/pgsql/bin/psql")
         (sql-product 'postgres)
         (sql-port 5432)
         (sql-server "localhost")
         (sql-user "imsnavprod")
         (sql-database "imsnavproddb"))

       (axonic.test
         (sql-name "axonic.test")
         (sql-default-directory "/ssh:devel.jmayaalv@axonictest1:")
         (sql-postgres-program "/usr/local/pgsql/bin/psql")
         (sql-product 'postgres)
         (sql-port 5432)
         (sql-server "localhost")
         (sql-user "imsaxonict1")
         (sql-database "imsaxonict1db"))

       (axonic.prod
        (sql-name "axonic.prod")
        (sql-default-directory "/ssh:devel.jmayaalv@axonicdb:")
        (sql-postgres-program "/usr/local/pgsql/bin/psql")
        (sql-product 'postgres)
        (sql-port 5432)
        (sql-server "localhost")
        (sql-user "imsaxonicprod")
        (sql-database "imsaxonicproddb"))

       (axonic.test2
        (sql-name "axonic.test2")
        (sql-default-directory "/ssh:devel.jmayaalv@axonictest2:")
        (sql-postgres-program "/usr/local/pgsql/bin/psql")
        (sql-product 'postgres)
        (sql-port 5432)
        (sql-server "localhost")
        (sql-user "imsaxonict2")
        (sql-database "imsaxonict2db"))

        (oic.prod
         (sql-name "oic.prod")
         (sql-default-directory "/ssh:devel.jmayaalv@oicdb:")
         (sql-postgres-program "/usr/local/pgsql/bin/psql")
         (sql-product 'postgres)
         (sql-port 5432)
         (sql-server "localhost")
         (sql-user "imsoicprod")
         (sql-database "imsoicproddb"))

        (omi.prod
         (sql-name "omi.prod")
         (sql-default-directory "/ssh:devel.jmayaalv@omidb:")
         (sql-postgres-program "/usr/local/pgsql/bin/psql")
         (sql-product 'postgres)
         (sql-port 5432)
         (sql-server "localhost")
         (sql-user "imsomiprod")
         (sql-database "imsomiproddb"))

        (omi.ps
         (sql-name "omi.ps")
         (sql-default-directory "/ssh:devel.jmayaalv@omips:")
         (sql-postgres-program "/usr/local/pgsql/bin/psql")
         (sql-product 'postgres)
         (sql-port 5432)
         (sql-server "localhost")
         (sql-user "imsomiedgecheck")
         (sql-database "imsomiedgecheckdb"))

        (omnia.test
         (sql-name "omnia.test")
         (sql-default-directory "/ssh:devel.jmayaalv@omniatest:")
         (sql-postgres-program "/usr/local/pgsql/bin/psql")
         (sql-product 'postgres)
         (sql-port 5432)
         (sql-server "localhost")
         (sql-user "imsombps")
         (sql-database "imsombpsdb"))

        (oic.test1
         (sql-name "oic.test1")
         (sql-default-directory "/ssh:devel.jmayaalv@oictest1:")
         (sql-postgres-program "/usr/local/pgsql/bin/psql")
         (sql-product 'postgres)
         (sql-port 5432)
         (sql-server "localhost")
         (sql-user "imsoictest1")
         (sql-database "imsoictest1db"))

        (oic.test2
         (sql-name "oic.test2")
         (sql-default-directory "/ssh:devel.jmayaalv@oictest2:")
         (sql-postgres-program "/usr/local/pgsql/bin/psql")
         (sql-product 'postgres)
         (sql-port 5432)
         (sql-server "localhost")
         (sql-user "imsoictest2")
         (sql-database "imsoictest2db"))

        (oic.test3
         (sql-name "oic.test3")
         (sql-default-directory "/ssh:devel.jmayaalv@oictest3:")
         (sql-postgres-program "/usr/local/pgsql/bin/psql")
         (sql-product 'postgres)
         (sql-port 5432)
         (sql-server "localhost")
         (sql-user "imsoictest3")
         (sql-database "imsoictest3db"))

        (gosaver.test1
         (sql-name "gosaver.test1")
         (sql-default-directory "/ssh:devel.jmayaalv@gosavertest1:")
         (sql-postgres-program "/usr/local/pgsql/bin/psql")
         (sql-product 'postgres)
         (sql-port 5432)
         (sql-server "localhost")
         (sql-user "imsgosavertest1")
         (sql-database "imsgosavertest1db"))

        (gosaver.prod
         (sql-name "gosaver.prod")
         (sql-default-directory "/ssh:devel.jmayaalv@gosaverdb:")
         (sql-postgres-program "/usr/local/pgsql/bin/psql")
         (sql-product 'postgres)
         (sql-port 5432)
         (sql-server "localhost")
         (sql-user "imsgosaverprod")
         (sql-database "imsgosaverproddb"))

        (veritas.test
         (sql-name "veritas.test")
         (sql-postgres-program "/usr/local/postgresql-12.2/bin/psql")
         (sql-default-directory "/ssh:devel.jmayaalv@veritastest:")
         (sql-product 'postgres)
         (sql-port 5432)
         (sql-server "localhost")
         (sql-user "imsveritastest1")
         (sql-database "imsveritastest1db"))

        (veritas.prod
         (sql-name "veritas.prod")
         (sql-postgres-program "/usr/local/pgsql/bin/psql")
         (sql-default-directory "/ssh:devel.jmayaalv@veritasprod:")
         (sql-product 'postgres)
         (sql-port 5432)
         (sql-server "localhost")
         (sql-user "imsveritasprod")
         (sql-database "imsveritasproddb"))

        (omi.test1
         (sql-name "omi.test1")
         (sql-postgres-program "/usr/local/pgsql/bin/psql")
         (sql-default-directory "/ssh:devel.jmayaalv@omitest:")
         (sql-product 'postgres)
         (sql-port 5432)
         (sql-server "localhost")
         (sql-user "imsomitest1")
         (sql-database "imsomitest1db"))

       (omi.test2
         (sql-name "omi.test2")
         (sql-postgres-program "/usr/local/pgsql/bin/psql")
         (sql-default-directory "/ssh:devel.jmayaalv@omitest2:")
         (sql-product 'postgres)
         (sql-port 5432)
         (sql-server "localhost")
         (sql-user "imsomitest2")
         (sql-database "imsomitest2db"))

      (omi.test4
         (sql-name "omi.test4")
         (sql-postgres-program "/usr/local/pgsql/bin/psql")
         (sql-default-directory "/ssh:devel.jmayaalv@omitest4:")
         (sql-product 'postgres)
         (sql-port 5432)
         (sql-server "localhost")
         (sql-user "imsomitest4")
         (sql-database "imsomitest4db"))

        (northstar.prod
         (sql-name "northstar.prod")
         (sql-postgres-program "/usr/local/pgsql/bin/psql")
         (sql-default-directory "/ssh:devel.jmayaalv@nsdb:")
         (sql-product 'postgres)
         (sql-port 5432)
         (sql-server "localhost")
         (sql-user "imsbcgprod")
         (sql-database "imsbcgproddb"))


       (northstar.test
         (sql-name "northstar.test")
         (sql-postgres-program "/usr/local/pgsql/bin/psql")
         (sql-default-directory "/ssh:devel.jmayaalv@nstest1:")
         (sql-product 'postgres)
         (sql-port 5432)
         (sql-server "localhost")
         (sql-user "imsnfstest1db")
         (sql-database "imsnfstest1"))

        (sanlam.prod
         (sql-name "sanlam.prod")
         (sql-postgres-program "/usr/local/pgsql/bin/psql")
         (sql-default-directory "/ssh:devel.jmayaalv@sanlamdb:")
         (sql-product 'postgres)
         (sql-port 5432)
         (sql-server "localhost")
         (sql-user "imssanlamprod")
         (sql-database "imssanlamproddb"))

       (sanlam.test
         (sql-name "sanlam.test")
         (sql-postgres-program "/usr/local/pgsql/bin/psql")
         (sql-default-directory "/ssh:devel.jmayaalv@sanlamtest1:")
         (sql-product 'postgres)
         (sql-port 5432)
         (sql-server "localhost")
         (sql-user "imssgist1")
         (sql-database "imssgist1db"))

       (glacier.test
         (sql-name "glacier.test1")
         (sql-postgres-program "/usr/local/pgsql/bin/psql")
         (sql-default-directory "/ssh:devel.jmayaalv@glaciertest1:")
         (sql-product 'postgres)
         (sql-port 5432)
         (sql-server "localhost")
         (sql-user "imsglaciertest1")
         (sql-database "imsglaciertest1db"))

       (glacier.test2
         (sql-name "glacier.test2")
         (sql-postgres-program "/usr/local/pgsql/bin/psql")
         (sql-default-directory "/ssh:devel.jmayaalv@glaciertest2:")
         (sql-product 'postgres)
         (sql-port 5432)
         (sql-server "localhost")
         (sql-user "imsglaciertest2")
         (sql-database "imsglaciertest2db"))

       (glacier.test3
        (sql-name "glacier.test3")
        (sql-postgres-program "/usr/local/pgsql/bin/psql")
        (sql-default-directory "/ssh:devel.jmayaalv@glaciertest3:")
        (sql-product 'postgres)
        (sql-port 5432)
        (sql-server "localhost")
        (sql-user "imsglaciert3")
        (sql-database "imsglaciert3db"))

       (glacier.test4
        (sql-name "glacier.test4")
        (sql-postgres-program "/usr/local/pgsql/bin/psql")
        (sql-default-directory "/ssh:devel.jmayaalv@glaciertest4:")
        (sql-product 'postgres)
        (sql-port 5432)
        (sql-server "localhost")
        (sql-user "imsglaciertest4")
        (sql-database "imsglaciertest4db"))

        (glacier.prod
         (sql-name "glacier.prod")
         (sql-postgres-program "/usr/local/pgsql/bin/psql")
         (sql-default-directory "/ssh:devel.jmayaalv@glacierdb:")
         (sql-product 'postgres)
         (sql-port 5432)
         (sql-server "localhost")
         (sql-user "imsglacierprod")
         (sql-database "imsglacierproddb"))

        (omnia.prod
         (sql-name "omnia.prod")
         (sql-postgres-program "/usr/local/pgsql/bin/psql")
         (sql-default-directory "/ssh:devel.jmayaalv@omniaprod:")
         (sql-product 'postgres)
         (sql-port 5432)
         (sql-server "localhost")
         (sql-user "imsombprod")
         (sql-database "imsombproddb"))

        (agl.prod
         (sql-name "agl.prod")
         (sql-postgres-program "/usr/local/pgsql/bin/psql")
         (sql-default-directory "/ssh:devel.jmayaalv@agldb:")
         (sql-product 'postgres)
         (sql-port 5432)
         (sql-server "localhost")
         (sql-user "imsaglprod")
         (sql-database "imsaglproddb"))

        (agl.test1
         (sql-name "agl.test1")
         (sql-postgres-program "/usr/local/pgsql/bin/psql")
         (sql-default-directory "/ssh:devel.jmayaalv@agltest1:")
         (sql-product 'postgres)
         (sql-port 5432)
         (sql-server "localhost")
         (sql-user "imsdartatest1")
         (sql-database "imsdartatest1db"))

        (agl.test2
         (sql-name "agl.test2")
         (sql-postgres-program "/usr/local/pgsql/bin/psql")
         (sql-default-directory "/ssh:devel.jmayaalv@agltest2:")
         (sql-product 'postgres)
         (sql-port 5432)
         (sql-server "localhost")
         (sql-user "imsdartatest2")
         (sql-database "imsdartatest2db"))

        (agl.test3
         (sql-name "agl.test3")
         (sql-postgres-program "/usr/local/pgsql/bin/psql")
         (sql-default-directory "/ssh:devel.jmayaalv@agltest3:")
         (sql-product 'postgres)
         (sql-port 5432)
         (sql-server "localhost")
         (sql-user "imsdartatest3")
         (sql-database "imsdartatest3db"))

        (argus.prod
         (sql-name "argus.prod")
         (sql-postgres-program "/bin/psql")
         (sql-default-directory "/ssh:devel.jmayaalv@argusprod:")
         (sql-product 'postgres)
         (sql-port 5432)
         (sql-server "localhost")
         (sql-user "imsargusprod")
         (sql-database "imsargusproddb"))

       (argus.test2
         (sql-name "argus.test2")
         (sql-postgres-program "/usr/local/pgsql/bin/psql")
         (sql-default-directory "/ssh:devel.jmayaalv@argustest2:")
         (sql-product 'postgres)
         (sql-port 5432)
         (sql-server "localhost")
         (sql-user "imsargust2")
         (sql-database "imsargust2db"))

        (plac.prod
         (sql-name "plac.prod")
         (sql-postgres-program "/usr/local/pgsql/bin/psql")
         (sql-default-directory "/ssh:devel.jmayaalv@placprod:")
         (sql-product 'postgres)
         (sql-port 5432)
         (sql-server "localhost")
         (sql-user "imsprovidenceprod")
         (sql-database "imsprovidenceproddb"))

       (allangray.test1
         (sql-name "allangray.test1")
         (sql-postgres-program "/usr/local/pgsql/bin/psql")
         (sql-default-directory "/ssh:devel.jmayaalv@allangraytest1:")
         (sql-product 'postgres)
         (sql-port 5432)
         (sql-server "localhost")
         (sql-user "imsagrayt1")
         (sql-database "imsagrayt1db"))

       (allangray.test2
         (sql-name "allangray.test2")
         (sql-postgres-program "/usr/local/pgsql/bin/psql")
         (sql-default-directory "/ssh:devel.jmayaalv@allangraytest2:")
         (sql-product 'postgres)
         (sql-port 5432)
         (sql-server "localhost")
         (sql-user "imsagrayt2")
         (sql-database "imsagrayt2db"))

       (allangray.prod
        (sql-name "allangray.prod")
        (sql-postgres-program "/usr/local/pgsql/bin/psql")
        (sql-default-directory "/ssh:devel.jmayaalv@allangraydb:")
        (sql-product 'postgres)
        (sql-port 5432)
        (sql-server "localhost")
        (sql-user "imsagrayprod")
        (sql-database "imsagrayproddb"))

       (plac.test
         (sql-name "plac.test")
         (sql-postgres-program "/usr/local/pgsql/bin/psql")
         (sql-default-directory "/ssh:devel.jmayaalv@plactest:")
         (sql-product 'postgres)
         (sql-port 5432)
         (sql-server "localhost")
         (sql-user "imsprovidencetest")
         (sql-database "imsprovidencetestdb"))

       (provlife.test1
        (sql-name "provlife.test1")
        (sql-postgres-program "/usr/local/pgsql/bin/psql")
        (sql-default-directory "/ssh:devel.jmayaalv@provlifetest1:")
        (sql-product 'postgres)
        (sql-port 5432)
        (sql-server "localhost")
        (sql-user "imsprovlifetest1")
        (sql-database "imsprovlifetest1db"))

       (provlife.test2
        (sql-name "provlife.test2")
        (sql-postgres-program "/usr/local/pgsql/bin/psql")
        (sql-default-directory "/ssh:devel.jmayaalv@provlifetest2:")
        (sql-product 'postgres)
        (sql-port 5432)
        (sql-server "localhost")
        (sql-user "imsprovlifetest2")
        (sql-database "imsprovlifetest2db"))

       (provlife.test3
        (sql-name "provlife.test3")
        (sql-postgres-program "/usr/local/pgsql/bin/psql")
        (sql-default-directory "/ssh:devel.jmayaalv@provlifetest3:")
        (sql-product 'postgres)
        (sql-port 5432)
        (sql-server "localhost")
        (sql-user "imsprovlifetest3")
        (sql-database "imsprovlifetest3db"))

       (provlife.prod
        (sql-name "provlife.prod")
        (sql-postgres-program "/usr/local/pgsql/bin/psql")
        (sql-default-directory "/ssh:devel.jmayaalv@provlifedb:")
        (sql-product 'postgres)
        (sql-port 5432)
        (sql-server "localhost")
        (sql-user "imsplifeprod")
        (sql-database "imsplifeproddb"))

       (prospero.test
         (sql-name "nextgen.test")
         (sql-default-directory "/ssh:devel.jmayaalv@nextgentest1:")
         (sql-postgres-program "/usr/local/pgsql/bin/psql")
         (sql-product 'postgres)
         (sql-port 5432)
         (sql-server "localhost")
         (sql-user "imsngt1")
         (sql-database "imsngt1db"))

       (prospero.prod
        (sql-name "prospero.prod")
        (sql-default-directory "/ssh:devel.jmayaalv@prosperodb:")
        (sql-postgres-program "/usr/local/pgsql/bin/psql")
        (sql-product 'postgres)
        (sql-port 5432)
        (sql-server "localhost")
        (sql-user "imsprosprod")
        (sql-database "imsprosproddb"))

       (secura.test1
        (sql-name "secura.test1")
        (sql-default-directory "/ssh:devel.jmayaalv@securatest1:")
        (sql-postgres-program "/usr/local/pgsql/bin/psql")
        (sql-product 'postgres)
        (sql-port 5432)
        (sql-server "localhost")
        (sql-user "imssecurat1")
        (sql-database "imssecurat1db"))

       (secura.prod
        (sql-name "secura.prod")
        (sql-default-directory "/ssh:devel.jmayaalv@securaprod:")
        (sql-postgres-program "/usr/local/pgsql/bin/psql")
        (sql-product 'postgres)
        (sql-port 5432)
        (sql-server "localhost")
        (sql-user "imssecuraprod")
        (sql-database "imssecuraproddb"))

       (lic.test
        (sql-name "lic.test")
        (sql-default-directory "/ssh:devel.jmayaalv@lictest1:")
        (sql-postgres-program "/usr/local/pgsql/bin/psql")
        (sql-product 'postgres)
        (sql-port 5432)
        (sql-server "localhost")
        (sql-user "imslict1")
        (sql-database "imslict1db"))

       (lic.prod
        (sql-name "lic.prod")
        (sql-default-directory "/ssh:devel.jmayaalv@licprod:")
        (sql-postgres-program "/usr/local/pgsql/bin/psql")
        (sql-product 'postgres)
        (sql-port 5432)
        (sql-server "localhost")
        (sql-user "imslicprod")
        (sql-database "imslicproddb"))

       (fnb.test1
        (sql-name "fnb.test1")
        (sql-default-directory "/ssh:devel.jmayaalv@fnbtest1:")
        (sql-postgres-program "/usr/local/pgsql/bin/psql")
        (sql-product 'postgres)
        (sql-port 5432)
        (sql-server "localhost")
        (sql-user "imsfnbt1")
        (sql-database "imsfnbt1db"))

       (fnb.test2
        (sql-name "fnb.test2")
        (sql-default-directory "/ssh:devel.jmayaalv@fnbtest2:")
        (sql-postgres-program "/usr/local/pgsql/bin/psql")
        (sql-product 'postgres)
        (sql-port 5432)
        (sql-server "localhost")
        (sql-user "imsfnbt2")
        (sql-database "imsfnbt2db"))

       (sbi.test1
        (sql-name "sbi.test1")
        (sql-default-directory "/ssh:devel.jmayaalv@sbitest1:")
        (sql-postgres-program "/usr/local/pgsql/bin/psql")
        (sql-product 'postgres)
        (sql-port 5432)
        (sql-server "localhost")
        (sql-user "imssbit1")
        (sql-database "imssbit1db"))

       (sbi.test2
        (sql-name "sbi.test2")
        (sql-default-directory "/ssh:devel.jmayaalv@sbitest2:")
        (sql-postgres-program "/usr/local/pgsql/bin/psql")
        (sql-product 'postgres)
        (sql-port 5432)
        (sql-server "localhost")
        (sql-user "imssbit2")
        (sql-database "imssbit2db"))

       (sbi.test3
        (sql-name "sbi.test3")
        (sql-default-directory "/ssh:devel.jmayaalv@sbitest3:")
        (sql-postgres-program "/usr/local/pgsql/bin/psql")
        (sql-product 'postgres)
        (sql-port 5432)
        (sql-server "localhost")
        (sql-user "imssbit3")
        (sql-database "imssbit3db"))

       (sbi.prod
        (sql-name "sbi.prod")
        (sql-default-directory "/ssh:devel.jmayaalv@sbidb:")
        (sql-postgres-program "/usr/local/pgsql/bin/psql")
        (sql-product 'postgres)
        (sql-port 5432)
        (sql-server "localhost")
        (sql-user "imssbiprod")
        (sql-database "imssbiproddb"))

       ))

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
   (my-sql-connect  'postgres 'allangray.test1))

(defun sql-allangray.prod ()
  "Create a new sql connection to allan gray prod db."
  (interactive)
  (my-sql-connect  'postgres 'allangray.prod))

(defun sql-axonic.prod ()
  "Create a new sql connection to axonic prod db."
  (interactive)
  (my-sql-connect  'postgres 'axonic.prod))

(defun sql-axonic.test ()
  "Create a new sql connection to axonic test db."
  (interactive)
  (my-sql-connect  'postgres 'axonic.test))

(defun sql-axonic.test2 ()
  "Create a new sql connection to axonic test 2db."
  (interactive)
  (my-sql-connect  'postgres 'axonic.test2))

(defun sql-agl.test1 ()
  "Create a new sql connection to agl test1 db."
  (interactive)
  (my-sql-connect  'postgres 'agl.test1))

(defun sql-agl.test2 ()
  "Create a new sql connection to agl test2 db."
  (interactive)
  (my-sql-connect  'postgres 'agl.test2))

(defun sql-agl.test3 ()
  "Create a new sql connection to agl test3 db."
  (interactive)
  (my-sql-connect  'postgres 'agl.test3))

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
  "Create a new sql connection to sbi test1"
  (interactive)
  (my-sql-connect  'postgres 'sbi.test1))

(defun sql-sbi.test2 ()
  "Create a new sql connection to sbi test2"
  (interactive)
  (my-sql-connect  'postgres 'sbi.test2))

(defun sql-sbi.test3 ()
  "Create a new sql connection to sbi test3"
  (interactive)
  (my-sql-connect  'postgres 'sbi.test3))

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

(defun sql-oic.test1 ()
  "Create a new sql connection to the oic test1 db."
  (interactive)
  (my-sql-connect 'postgres 'oic.test1))

 (defun sql-oic.test2 ()
   "Create a new sql connection to the oic test2 db."
    (interactive)
    (my-sql-connect 'postgres 'oic.test2))

 (defun sql-oic.test3 ()
   "Create a new sql connection to the oic test3 db."
    (interactive)
    (my-sql-connect 'postgres 'oic.test3))

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
