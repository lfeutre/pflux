(defmodule pflux-util
  (export all))

(defun get-prqu-version ()
  (lfe-utils:get-app-src-version '"src/prqu.app.src"))

(defun get-version ()
  (++ (lfe-utils:get-version)
      `(#(prqu ,(get-prqu-version)))))
