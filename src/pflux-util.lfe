(defmodule pflux-util
  (export all))

(defun get-pflux-version ()
  (lfe-utils:get-app-src-version '"src/pflux.app.src"))

(defun get-version ()
  (++ (lfe-utils:get-version)
      `(#(pflux ,(get-pflux-version)))))

(defun match-ip
  ((passed (tuple 'name name 'ip ip 'network network)) (when (== ip passed))
   `#(name ,name network ,network))
  ((_ _)))

(defun get-server-data (ip)
  (lists:flatten
    (lists:map
      (lambda (x) (match-ip ip x))
      (pflux-config:servers))))

(defun get-server-name (ip)
  (let (((list (tuple 'name name _ _)) (get-server-data ip)))
    name))

(defun get-server-network (ip)
  (let (((list (tuple _ _ 'network network)) (get-server-data ip)))
    network))

(defun get-ips ()
  (lists:map
    (lambda (x) (element 4 x))
    (pflux-config:servers)))

(defun ping (ip)
  (lists:reverse
    (cdr
      (lists:reverse
        (os:cmd (pflux-config:ping-command ip))))))
