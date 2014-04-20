============
Installation
============

Parts
======

* Python package
* Packer configuration
* Vagrant configuration
* Salt configuration


Provis Python Package
======================
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


Packer, Vagrant, Virtualbox, Salt
=================================
This project integrates a number of helpful :ref:`tools`.

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

