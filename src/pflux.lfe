(defmodule pflux
  (export all))

;;; Infrastructure functions.
(defun call-backend (func)
  (call (lfe-utils:atom-cat 'pflux- (pflux-config:get-backend))
        func))

(defun call-backend (func args)
  (eval `(call ',(lfe-utils:atom-cat 'pflux- (pflux-config:get-backend))
               ,func
               ,@args)))

;;; Data calls.
(defun store-server (name ip network)
  (call-backend `'store-server (list name ip network)))

(defun get-ips ()
  (call-backend 'get-ips))

(defun store-pings ()
  (call-backend 'store-pings))

(defun drop-servers ()
  (call-backend 'drop-servers))
