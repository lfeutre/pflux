(defmodule pflux-influxdb
  (export all))

(defun make-ping-payload (ip latency)
  (++ "[{\"name\": \"" (pflux-config:get-stats-table) "\","
         "\"columns\": [\"ip\",\"latency\"],"
         "\"points\": [[\"" ip "\", \"" latency "\"]]}]"))

(defun store-ping (ip)
  (let* ((path (pflux-config:get-post-url))
         (latency (pflux-util:ping ip))
         (data (make-ping-payload ip latency))
         (req (tuple
                (++ (pflux-config:get-base-url) path)
                (pflux-config:get-headers)
                "application/json"
                data))
         (resp (httpc:request 'post req '() '())))
    ; XXX debug
    ;(io:format "data: ~p~n" (list data))
    ;resp))
    (element 1 resp)))

(defun store-pings ()
  (lists:map #'store-ping/1 (get-ips)))

(defun make-server-payload (name ip network)
  (++ "[{\"name\": \"" (pflux-config:get-servers-table) "\","
         "\"columns\": [\"name\",\"ip\",\"network\"],"
         "\"points\": [[\"" name "\", \"" ip "\", \"" network "\"]]}]"))

(defun store-server (name ip network)
  (let* ((path (pflux-config:get-post-url))
         (data (make-server-payload name ip network))
         (req (tuple
                (++ (pflux-config:get-base-url) path)
                (pflux-config:get-headers)
                "application/json"
                data))
         (resp (httpc:request 'post req '() '())))
    ; XXX debug
    ;(io:format "data: ~p~n" (list data))
    ;resp))
    (element 1 resp)))

(defun get-servers ()
  (let* ((query "select * from servers")
         (path (pflux-config:get-get-url query))
         (req (tuple
                (++ (pflux-config:get-base-url) path)
                (pflux-config:get-headers)))
         ((= (tuple 'ok (tuple status headers data)) resp)
          (httpc:request 'get req '() '()))
         (all-bin-data (car (jsx:decode (list_to_binary data))))
         (cols (ej:get #("columns") all-bin-data))
         (points (ej:get #("points") all-bin-data)))
    ; XXX debug
    ; (io:format (++ "request: ~p~n"
    ;                "response: ~p~n"
    ;                "status: ~p~n"
    ;                "headers: ~p~n"
    ;                "data: ~p~n") (list req resp status headers data))
    (lists:map
      (lambda (x) (lists:zip cols x))
      points)))

(defun check-tuple
  ((check-key (tuple key val)) (when (== check-key key))
   val)
  ((_ _) 'false))

(defun match-tuple? (key tuple-list)
  (lists:map
    (lambda (key-val) (check-tuple (list_to_binary key) key-val))
    tuple-list))

(defun find-value (key tuple-list)
  (binary_to_list
    (car
      (lists:filter
        (lambda (x) (=/= x 'false))
        (match-tuple? key tuple-list)))))

(defun filter-server-data (key servers-data)
  (lists:map
    (lambda (server-data)
      (find-value key server-data))
    servers-data))

(defun get-ips ()
  (filter-server-data "ip" (get-servers)))

(defun get-names ()
  (filter-server-data "name" (get-servers)))

(defun get-networks ()
  (filter-server-data "network" (get-servers)))

(defun get-server-data (ip)
  (lists:flatten
    (lists:map
      (lambda (x) x)
      (pflux-config:servers))))

(defun get-server-name (ip)
  (let (((list (tuple 'name name _ _)) (get-server-data ip)))
    name))

(defun get-server-network (ip)
  (let (((list (tuple _ _ 'network network)) (get-server-data ip)))
    network))

(defun drop-servers ()
  (let* ((query "drop series servers")
         (path (pflux-config:get-get-url query))
         (req (tuple
                (++ (pflux-config:get-base-url) path)
                (pflux-config:get-headers)))
         ((= (tuple 'ok (tuple status headers data)) resp)
          (httpc:request 'get req '() '())))
    resp))
