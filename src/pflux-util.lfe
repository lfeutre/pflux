(defmodule pflux-util
  (export all))

(defun get-pflux-version ()
  (lfe-utils:get-app-src-version "src/pflux.app.src"))

(defun get-version ()
  (++ (lfe-utils:get-version)
      `(#(pflux ,(get-pflux-version)))))

(defun ping-command (ip)
  (++
    "ping -no "
    ip
    "|head -2|tail -1|awk '{print $7}'|awk -F= '{print $2}'"))

(defun drop-last (list-data)
  (lists:reverse
    (cdr
      (lists:reverse list-data))))

(defun ping (ip)
  (pflux-util:drop-last
    (os:cmd (pflux-util:ping-command ip))))

(defun ping-all (ips)
  (lists:map #'ping/1 ips))
