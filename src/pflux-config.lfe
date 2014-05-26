(defmodule pflux-config
  (export all))

(defun project-name () "" "p-flux")
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

(defun ping-command (ip)
  (++
    "ping -no "
    ip
    "|head -2|tail -1|awk '{print $7}'|awk -F= '{print $2}'"))
