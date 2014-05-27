(defmodule pflux-app
  (behaviour application)
  (export (load 0)
          (start 0)
          (start 2)
          (stop 1)))

(defun start-deps ()
  (inets:start)
  (ssl:start))

(defun load ()
  (start-deps)
  (application:load (pflux-config:app-name)))

(defun start ()
  (start '() '()))

(defun start (type args)
  (let ((result (: pflux-sup start_link)))
    (case result
      ((tuple 'ok pid)
        result)
      (_
        (tuple 'error result)))))

(defun stop (state)
  'ok)
