===============================
README
===============================

.. ..  image:: https://badge.fury.io/py/provis.png
..        :target: http://badge.fury.io/py/provis

.. ..  image:: https://travis-ci.org/westurner/provis.png?branch=master
..         :target: https://travis-ci.org/westurner/provis

.. ..  image:: https://pypip.in/d/provis/badge.png
..         :target: https://crate.io/packages/provis?version=latest

`Docs <https://provis.readthedocs.org/>`_ |
`Github <https://github.com/westurner/provis>`_ |
`Issues <https://github.com/westurner/provis/issues>`_

Provis
========

Infrastructure Provisioning Scripts and Configuration Sets

A Python package with a few tests, system bootstrap scripts, and a Makefile
for building and configuring cloud servers.


This project :ref:`scripts` a number of helpful
:ref:`tools` to automate :ref:`activities`
that produce :ref:`products`
which satisfy the :ref:`goals`.

The :ref:`Provis Package <provis-package>` is one :ref:`product
<products>` of this project.

Within the :ref:`Provis Package <provis-package>` is a :ref:`Makefile`
containing untold secrets of the universe.


.. include:: goals.rst


Installation
============
* `Install build requirements`_
* `Install the Provis Package`_


Install the Provis Package
----------------------------
Clone and install the package from source::

    pip install -e ssh://git@github.com/westurner/provis#egg=provis

Or, clone the repository and manually install::

    ## clone
    git clone ssh://git@github.com/westurner/provis
    git clone https://github.com/westurner/provis

    cd ./provis

    ## install
    python setup.py develop  # creates a provis.egg-link in site-packages
    python setup.py install  # copies the binary dist to site-packages

Install Python requirements::

    cd ./provis
    pip install -r requirements.txt

.. _virtualenv: http://www.virtualenv.org/en/latest/
.. _virtualenvwrapper: http://virtualenvwrapper.readthedocs.org/en/latest/



Install Build Requirements
----------------------------

Ubuntu 12.04 LTS
~~~~~~~~~~~~~~~~~~

Install make, build requirements:

   apt-get install make python pip

* Install :ref:`make`::

   apt-get install make

* Install :ref:`pip`::

   apt-get install pip
   pip install --upgrade pip

* Install :ref:`virtualenv` and :ref:`virtualenvwrapper` (optional)::

   pip install virtualenv virtualenvwrapper

  Create a `virtualenv`_ with `virtualenvwrapper`_ (optional)::

   mkvirtualenv provis
   workon provis


Usage
=======

Tests
--------
Run the Provis Python package tests with the current environment::


   ## Check localhost
   python runtests.py  # python setup.py test

   ## Check reference set
   python runtests.py tests/provis_tests.py

Run the Provis Python package tests with tox and many environments::

   tox


Makefile
----------
Install ``make`` (if it is not already installed)::

   sudo apt-get install make

List ``Makefile`` command descriptions::

   make help
   make 

::

   #cd ./provis
   ls -al

::

   $EDITOR Makefile


Run ``make`` with the :ref:`Makefile`::


   cd ./provis
   make
   make help
   make setup
















Patterns
==========

Techniques
============

Tools
=======

Scripts
=========

Contributing
==============

License
=========

* Free software: `BSD license <#license>`_

.. include:: ../LICENSE

