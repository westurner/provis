
.. _products:

==========
Products
==========

.. _provis-package:

Provis Package
=================
| Source:  https://github.com/westurner/provis
| Documentation: https://provis.readthedocs.org/
|

| ``README.rst`` -- ref:`Provis README Documentation <readme>`
| ``setup.py`` -- Python packaging
| ``Makefile`` -- `Provis Makefile`_
| ``docs/`` -- `Provis Documentation`_
| ``tox.ini`` -- tox build configuration
| ``scripts/`` -- host bootstrap scripts
| ``packer/TODOTOTODO`` -- `Packer Configuration`_ JSON
| ``packer/scripts/`` -- packer image bootstrap scripts
| ``vagrant/Vagrantfile`` -- vagrant configuration
| ``salt/`` -- `salt configuration set`_
| ``pillar/`` -- salt pillar configset
| ``tests/`` -- testing utilities
| ``runtests.py`` -- test runner
|


Provis Documentation
======================
https://github.com/westurner/provis/tree/master/docs

System documentation.

* https://provis.readthedocs.org/en/latest/ -- ReadTheDocs hosted version

  * Manually update ReadTheDocs for the time being.


Provis Makefile
================
https://github.com/westurner/provis/blob/master/Makefile

:ref:`Make` :ref:`Makefile <makefile>` with make tasks to bootstrap a host BLD:

* Vagrant
* Packer
* Docker
* VirtualBox
* Downloading ISOs


Provis Tests
==============
https://github.com/westurner/provis/blob/master/tox.ini
https://github.com/westurner/provis/tree/master/tests

make test
make debugfile

Packer Configuration
======================
Packer build configuration for scripting an Debian/Ubuntu OS install from an ISO
in order to create a virtual image.



Vagrant Basebox Image
=======================
Virtual image created with Packer, Vagrant, and VirtualBox from which Vagrant VirtualBox instances can be provisioned.



Vagrant Configuration
=======================
Vagrantfile to launch image instances and provision salt



.. _provis stack:
.. _stack:

Provis Stack
==============
Host-specific catalog of files, packages, and services.

Salt Formulas
---------------
Reusable :ref:`salt` state packages.

Salt Modules
-------------
Python functions of the Salt API which are remotely-callable

Salt States
------------
Salt policies


Salt Environment
-----------------
An 

* /etc/salt/minion.conf
* /etc/salt/master.conf
* /srv/salt/`top.sls`

:ref:`Salt` states and modules.


Basebox Configset
---------------------
::

  # currently accomplished by a sequence of shell scripts
  # launched by the packer virtualbox-iso provisioner
  # in
  #$ ls ./packer/scripts/
  #$ ls ./scripts/bootstrap-salt.sh

  users:
   - root/vagrant
   - vagrant/vagrant
     + insecure SSH key
     + 
         
   - ubuntu/ubuntu

  sudo:
    passwordless sudo for vagrant user
    no 'requiretty'
  etckeeper:

Salt Minion Configset
-----------------------
::

  configmaster

  policies

  data

Salt Master Configset
-------------------------
::

  configmaster

  policies

  data

Gateway/Router Configset
--------------------------
::

    networking:
     ip_forward: True
    firewall:
     specific ports
    dns:
     local dns
     passthrough dns
    vpn:
     remote access


MySQL Configset
------------------
::

    mysql


Postgres Configset
-------------------
::

    postgres

Appserver Configset
---------------------
::

    nginx
    build-essentials?
    gunicorn
    supervisord
    upstart


Devserver Configset
---------------------
::

    #TODO

Workstation Configset
-----------------------
::

    TODO: list installed packages (transitive reduction)
    i3wm
    docker
    dotfiles
    apt-cacher-ng
    nginx





Deployment Workflow
=====================
* Create and configure an image locally
* Push to cloud
* Paste together


Instrumentation Plan
======================
Instrumentation and scaling are primary concerns that should be kept in
mind while developing these templated configurations and application
infrastructure topologies.



Collaboration Plan
====================
See :ref:`Contributing`

