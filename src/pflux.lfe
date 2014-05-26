(defmodule pflux
  (export all))

(defun make-ping-payload (name server network latency)
  (++ "[{\"name\": \"ping-times\","
         "\"columns\": [\"name\",\"server\",\"networks\",\"latency\"],"
         "\"points\": [[\"" name "\", \"" server "\", \"" network "\", \"" latency "\"]]}]"))

(defun store-ping (ip)
  (let* ((user "root")
         (pass "root")
         (database-name "ping-stats")
         (path (++ "/db/" database-name "/series?u=" user "&p=" pass))
         (latency (pflux-util:ping ip))
         (name (pflux-util:get-server-name ip))
         (network (pflux-util:get-server-network ip))
         (data (make-ping-payload name ip network latency))
         (req (tuple
                (++ (pflux-config:get-base-url) path)
                (pflux-config:get-headers)
                "application/json"
                data))
         (resp (httpc:request 'post req '() '())))
    ;(io:format "data: ~p~n" (list data))
    ; XXX debug
    ;resp))
    (element 1 resp)))

(defun store-pings ()
  (lists:map #'store-ping/1 (pflux-util:get-ips)))

