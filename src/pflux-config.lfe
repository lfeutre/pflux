(defmodule pflux-config
  (export all))

;; This is needed to load configuration data from the YAWS config file.
(include-lib "deps/yaws/include/yaws.hrl")

(defun project-name () "" "p-flux")
(defun app-name () "" 'pflux)
;;; Legal values for config backend are 'app or 'yaws
(defun config-backend () 'app)
(defun project-desc () "" "A simple host-monitoring tool written in LFE")
(defun project-url () "" "https://github.com/lfe/pflux")
(defun get-base-url () "" "http://localhost:8086")

(defun user-agent ()
  (++ (project-name) "/"
    (pflux-util:get-pflux-version)
    " HTTP Client (+" (project-url) ")"))

(defun user-agent-header ()
  (tuple "User-Agent" (user-agent)))

(defun get-headers ()
  (list
    (tuple "Accept" "application/vnd.github.v3+json")
    (user-agent-header)))

(defun load-config (key)
  (case (config-backend)
    ('app
      (element 2 (application:get_env (pflux-config:app-name) key)))
    ('yaws)))

(defun get-db-backend ()
  (load-config 'db-backend))

(defun get-db ()
  (load-config 'db))

(defun get-db-user ()
  (load-config 'db-user))

(defun get-db-pass ()
  (load-config 'db-pass))

(defun get-stats-table ()
  (load-config 'stats-table))

(defun get-servers-table ()
  (load-config 'servers-table))

(defun get-ping-type ()
  (load-config 'ping-type))

(defun get-ping-interval ()
  (load-config 'ping-interval))

(defun get-post-url ()
  (++ "/db/" (get-db)
      "/series?u=" (get-db-user)
      "&p=" (get-db-pass)))

(defun get-get-url (query)
  (++ "/db/" (get-db)
      "/series?u=" (get-db-user)
      "&p=" (get-db-pass)
      "&q=" (http_uri:encode query)))
