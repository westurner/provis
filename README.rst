===============================
provis
===============================

.. ..  image:: https://badge.fury.io/py/provis.png
..        :target: http://badge.fury.io/py/provis

.. ..  image:: https://travis-ci.org/westurner/provis.png?branch=master
..         :target: https://travis-ci.org/westurner/provis

.. ..  image:: https://pypip.in/d/provis/badge.png
..         :target: https://crate.io/packages/provis?version=latest


Infrastructure Provisioning Scripts and Configuration Sets

* Free software: BSD license
* Documentation: http://provis.rtfd.org
* Source: https://github.com/westurner/provis

* See: :ref:`Products <products>`

This project :ref:`scripts` a number of helpful
:ref:`tools` to produce :ref:`products`
which satisfy the :ref:`goals`.


Installation
============
* :ref:`Install requirements`
* :ref:`Makefile <makefile>`

Requirements
--------------
* Python 2.6 or newer
* make
* sudo
* pip
* Ubuntu 12.04 LTS


Provis Python Package
----------------------
Create a `virtualenv`_ with `virtualenvwrapper`_ (optional)::

    mkvirtualenv provis
    workon provis

Clone and install the package from source::

    pip install -e ssh://git@github.com/westurner/provis#egg=provis

Or, clone the repository and manually install::

    ## clone
    git clone ssh://git@github.com/westurner/provis
    # -or-
    git clone https://github.com/westurner/provis

    ## install
    cd ./provis
    python setup.py develop  # creates a provis.egg-link in site-packages
    # -or-
    python setup.py install  # copies the binary dist to site-packages

Install Python requirements::

    cd ./provis
    pip install -r requirements.txt

.. _virtualenv: http://www.virtualenv.org/en/latest/
.. _virtualenvwrapper: http://virtualenvwrapper.readthedocs.org/en/latest/


Debian/Ubuntu
--------------
Sudo is necessary.

Install Make::

    sudo apt-get install make

Review the project Makefile::

    less ./Makefile

Run Make::

    make setup
    #-> make setup_provis
    #-> make setup_tools (scripts/setup_tools.sh)
    #-> make setup_download_isos
    #-> make packer_setup
    #-> make vagrant_setup
    #-> make salt_setup



