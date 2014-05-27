(defmodule pflux-util
  (export all))

(defun get-pflux-version ()
  (lfe-utils:get-app-src-version "src/pflux.app.src"))

(defun get-version ()
  (++ (lfe-utils:get-version)
      `(#(pflux ,(get-pflux-version)))))

(defun quick-ping (ip)
  "This simple ping command just makes one connection and quits."
  (++
    "ping -no "
    ip
    "|head -2|tail -1|awk '{print $7}'|awk -F= '{print $2}'"))

(defun average-ping (ip)
  "This gets the longest ping time of three."
  (++
    "ping -Qnc 3 "
    ip
    "|tail -1|awk -F= '{print $2}'|awk -F/ '{print $3}'"))

(defun swap-last (list-data)
  (let ((trimmed-data (lists:reverse
                        (cdr
                          (lists:reverse list-data)))))
    (case (length trimmed-data)
      (0 "0.0")
      (_ (++ trimmed-data "0")))))

(defun raw-ping (ip)
  (os:cmd
    (call
      'pflux-util
      (pflux-config:get-ping-type)
      ip)))

(defun ping (ip)
  "Convert to a float and multiply by 1000 for microseconds."
  (erlang:round (* (list_to_float
                     (swap-last (raw-ping ip)))
                   1000)))

(defun ping-all (ips)
  (lists:map #'ping/1 ips))

(defun get-random-interval
  (((cons start (cons stop _)))
   (let ((adjusted-end (- stop start)))
     (+ start (random:uniform adjusted-end)))))
