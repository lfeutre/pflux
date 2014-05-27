# pflux [![Build Status](https://travis-ci.org/lfe/pflux.png?branch=master)](https://travis-ci.org/lfe/pflux)

<img src="resources/images/pflux-small.png"/>

**A simple host-monitoring tool written in LFE**


## Introduction

pflux is built with LFE, `InfluxDB`_, `Grafana`_, and `YAWS`_.


As for the name, Clojure nabbed the obvious choice for an InfluxDB
client: `Capacitor`_.
Naturally, quantum mechanics was the next thought, which lead to the
inexorable "probability flux" (easier to type "pflux"), a term which denotes
the probability per unit time per unit area.

There you have it.


### Dependencies

This project assumes that you have `rebar`_  and `lfetool`_ installed
somwhere in your ``$PATH``.

pflux installs LFE/Erlang dependencies automatically when you compile.
Non-LFE/Erlang dependencies have separate instructions below.

### Screenshots

Here are some views of some ping results (3 network classifications, 8
hosts):

<a href="resources/images/Screenshot-2014-05-26-16.58.31.png"><img src="resources/images/Screenshot-2014-05-26-16.58.31-small.png" /></a>

<a href="resources/images/Screenshot-2014-05-26-16.59.04.png"><img src="resources/images/Screenshot-2014-05-26-16.59.04-small.png" /></a>

<a href="resources/images/Screenshot-2014-05-26-16.59.42.png"><img src="resources/images/Screenshot-2014-05-26-16.59.42-small.png" /></a>


## Configuration

### ElasticSearch

* Send a ``PUT`` to http://localhost:9200/ping-stats

* Send a ``PUT`` to http://localhost:9200/ping-stats/ping-stat/_mapping
  with the following data in the body:

```json

    {"ping-stat": {
       "properties": {
         "ip": {"type": "string"},
         "network": {"type": "string"},
         "latency": {"type": "float"}
         }}}
```


### InfluxDB

* Download and install `InfluxDB`_, following the `instructions`_.

* Load http://localhost:8083/ in your browser, connect using the default
  username and password (root/root) on port 8086.

* In the field under "Create Database" type "ping-stats" and then click
  "Create".


### pflux

* ``make compile``
* ``make dev``

You'll need to set up your servers as well:

```cl

    $ make shell
    > (pflux-app:start)
    #(ok <0.32.0>)
    > (pflux-app:load)
    ok
    > (pflux:store-server "google-dns" "8.8.8.8" "external")
    ok
    > (pflux:store-server "router" "192.168.1.1" "wired")
    ok
    > (pflux:store-server "wifi-ap" "192.168.1.1" "wireless")
    ok
```

Quick sanity check:

```cl

    > (get-ips)
    ("192.168.1.1" "192.168.1.1" "8.8.8.8")
```

Once your servers are set up, the application will start pinging them immediately. If you load up your local InfluxDB in a browser, you can
execute the following query to see that the monitoring data is indeed
showing up:

```sql

    select * from ping-times
```


### YAWS

TBD


### Grafana

* Open http://localhost:8080/dashboard/ in your browser.

*



## Usage

This is being used to post data from an LFE application to an InfluxDB
instance which is saving monitoring data. As such, the client is pretty bare
right now. We just need to post some JSON data.

In particular, the data we are posting is this:

```js

    {"name": "<human-readable-name>",
     "server": "<hostname-or-ip>",
     "network": "<network-description>"
     "latency": <float-milliseconds>}
```

```cl
   > (slurp "src/pflux.lfe")
   #(ok pflux)
```

.. Links
.. -----
.. _rebar: https://github.com/rebar/rebar
.. _lfetool: https://github.com/lfe/lfetool
.. _LFE: https://github.com/rvirding/lfe
.. _lfeunit: https://github.com/lfe/lfeunit
.. _Capacitor: https://github.com/olauzon/capacitor
.. _InfluxDB: http://influxdb.com/download/
.. _Grafana: http://grafana.org/
.. _YAWS: http://yaws.hyber.org/
.. _instructions: http://influxdb.com/docs/v0.7/introduction/installation.html
