(defmodule pflux-config
  (export all))

(defun project-name () "" "p-flux")
(defun app-name () "" 'pflux)
(defun project-desc () "" "An LFE Client for InfluxDB")
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

(defun get-backend ()
  (element 2 (application:get_env (pflux-config:app-name) 'backend)))

(defun get-db ()
  (element 2 (application:get_env (pflux-config:app-name) 'db)))

(defun get-db-user ()
  (element 2 (application:get_env (pflux-config:app-name) 'db-user)))

(defun get-db-pass ()
  (element 2 (application:get_env (pflux-config:app-name) 'db-pass)))

(defun get-stats-table ()
  (element 2 (application:get_env (pflux-config:app-name) 'stats-table)))

(defun get-servers-table ()
  (element 2 (application:get_env (pflux-config:app-name) 'servers-table)))

(defun get-ping-interval ()
  (element 2 (application:get_env (pflux-config:app-name) 'ping-interval)))

(defun get-post-url ()
  (++ "/db/" (get-db)
      "/series?u=" (get-db-user)
      "&p=" (get-db-pass)))

(defun get-get-url (query)
  (++ "/db/" (get-db)
      "/series?u=" (get-db-user)
      "&p=" (get-db-pass)
      "&q=" (http_uri:encode query)))
