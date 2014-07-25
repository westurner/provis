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

`A Python package`_ with a few tests, system bootstrap scripts, and a Makefile
for building and configuring cloud servers with a number of helpful
`tools`_:

* Ubuntu Linux
* Packer (Go)
* Vagrant (Ruby)
* Salt (Python)

.. _A Python package: http://provis.readthedocs.org/en/latest/products.html#provis-package
.. _tools: http://provis.readthedocs.org/en/latest/tools.html

.. .. include:: goals.rst

.. contents::   

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

* Install `make`_::

   apt-get install make

* Install `pip`_::

   apt-get install pip
   pip install --upgrade pip

* Install `virtualenv`_ and `virtualenvwrapper`_ (optional)::

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


Run ``make`` with the `Makefile`_::


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

.. include:: ./LICENSE

