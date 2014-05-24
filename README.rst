#####
pflux
#####

**An LFE client for InfluxDB**

Introduction
============

Clojure nabbed the obvious choice for an InfluxDB client: `Capacitor`_.
Naturally, quantum mechanics was the next thought, which lead to the inexorable
"probability flux" (easier to type "pflux"), a term which denotes the
probability per unit time per unit area.

There you have it.


Dependencies
------------

This project assumes that you have `rebar`_ installed somwhere in your
``$PATH``.

This project depends upon the following, which are installed to the ``deps``
directory of this project when you run ``make deps``:

* `LFE`_ (Lisp Flavored Erlang; needed only to compile)
* `lfeunit`_ (needed only to run the unit tests)


Installation
============

Just add it to your ``rebar.config`` deps:

.. code:: erlang

    {deps, [
        ...
        {pflux, ".*", {git, "git@github.com:lfe/pflux.git", "master"}}
      ]}.


And then do the usual:

.. code:: bash

    $ rebar get-deps
    $ rebar compile


Usage
=====

This is being used to post data from an LFE application to an InfluxDB instance
which is saving monitoring data. As such, the client is pretty bare right now:

.. code:: cl

   > (slurp "src/pflux.lfe")

.. Links
.. -----
.. _rebar: https://github.com/rebar/rebar
.. _LFE: https://github.com/rvirding/lfe
.. _lfeunit: https://github.com/lfe/lfeunit
.. _Capacitor: https://github.com/olauzon/capacitor
