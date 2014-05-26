(defmodule pflux
  (export all))

(defun call-backend (func)
  (call (lfe-utils:atom-cat 'pflux- (pflux-config:get-backend))
        func))

(defun call-backend (func args)
  (eval `(call ',(lfe-utils:atom-cat 'pflux- (pflux-config:get-backend))
               ,func
               ,@args)))

(defun store-server (name ip network)
  (call-backend `'store-server (list name ip network)))

(defun get-ips ()
  (call-backend 'get-ips))

(defun drop-servers ()
  (call-backend 'drop-servers))
