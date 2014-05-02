
.. _activities:

============
Activities
============

Create a new repository
-------------------------
See :ref:`Contributing`.

* [x] Create a new git repository

  * [x] git init

* [x] Fork an existing repository

  * [x] git clone https://path/to/gitrepo
  * [x] git checkout -b feature_branch_name


Create a new package
----------------------

* [x] Create templated :ref:`python` package

  * [x] pip install cookiecutter
  * [x] ``cookiecutter`` https://github.com/audreyr/cookiecutter-pypackage.git
  * [x] README.rst
  * [x] AUTHORS.rst -- Authors / Contributors
  * [x] CONTRIBUTING.rst -- 



Create project documentation
-----------------------------
* [x] Create :ref:`Sphinx` documentation set

  * [x] docs/conf.py -- :ref:`sphinx` build configuration
  * [x] docs/Makefile -- :ref:`sphinx` :ref:`Make` file
  * [x] docs/index.rst -- :ref:`sphinx` :ref:`ReStructuredText` Index
  * [x] docs/readme.rst -- :ref:`sphinx` README
  * [x] docs/authors.rst -- Credits
  * [x] docs/tools.rst -- Tools Catalog Notes (homepage, documentation, source)
  * [x] docs/installation.rst -- Installation Procedure
  * [x] docs/usage.rst -- Usage (Makefile)

* [x] Create Seven Layer Model pages

  + [x] docs/goals.rst
  + [x] docs/products.rst
  + [x] docs/activities.rst
  + [x] docs/patterns.rst
  + [x] docs/techniques.rst
  + [x] docs/tools.rst
  + [x] docs/scripts.rst
  + [x] Add {...} to docs/index.rst


Setup host machine
--------------------
* [x] Download OS netboot ISOs

* [x] Configure OS package mirrors

  * [x] Cherrypick apt-cacher-ng binary from trusty
    (HTTPS support for docker apt repos)

* [x] Install tools

  * [x] Document Homepage, Source, Docs (docs/tools.rst)
  * [x] Script installation (scripts/install_tools.sh)

    * [x] Install Python, Ruby, Go, Git, Wget::

        apt-get install python ruby golang-go git wget

    * [x] Install :ref:`Vagrant`
    * [x] Install :ref:`Packer`
    * [x] Install :ref:`Docker`
    * [x] Install :ref:`VirtualBox`


Configure networking and DNS
------------------------------
* [ ] Configure networking support (configsets)

* [ ] /etc/network/interfaces (salt)

  * [ ] Ethernet interfaces
  * [ ] DHCP IP addresses
  * [ ] Static IP addresses
  * [ ] IP routes
  * [ ] IP tunneling

* [ ] /etc/network/interfaces.d (TODO)

* [ ] Configure DNS

  + [ ] /etc/host.conf (salt)
  + [ ] /etc/hosts Hosts file (salt)
  + [ ] /etc/hostname (salt)
  + [ ] /etc/resolv.conf (resolvconf, salt)
  + [ ] /etc/resolvconf/interface-order
  + [ ] /etc/resolfconf/{base, head, tail}



Create virtual image
----------------------
* [ ] Create new [VirtualBox]/[Vagrant] basebox with Packer

  * [ ] Create/adapt mimimal configsets for generating a Vagrant basebox

    * [x] setup shell scripts (thanks!)
    * [x] vagrant (SSH errors)
    * [x] vagrant FS errors
    * [x] VirtualBox guest tools image (~NTP)
    * [x] etckeeper
    * [x] ufw
    * [x] Apt.conf (apt proxy copied from preseed: apt.create.wrd.nu)


Provision vagrant image instance
----------------------------------
* [ ] Create Vagrantfile for launching VirtualBox Vagrant basebox

  * [x] Create a new Vagrantfile: ``vagrant init``
  * [x] Configure virtualbox networking support (Vagrant)

    * [x] Rod: eth0 NAT, eth1 Bridged to host eth0, eth2 Host-Only

  * [x] Configure vagrant salt provisioning bootstrap
  * [ ] Configure DNS support 
* [x] Launch virtual instance: ``vagrant up [<hostname>]``
* [x] Provision with salt: ``vagrant provision [<hostname>]``
* [x] Shudown with salt: ``vagrant halt [<hostname>]``


Bootstrap salt minion
------------------------

* [x] `Bootstrap salt installation <http://docs.saltstack.com/en/latest/topics/tutorials/salt_bootstrap.html>`_

* [x] Configure salt minion ID

  * [ ] /etc/hosts "salt"
  * [ ] Set minion ID in /etc/salt/minion
  * [ ] Set minion ID in /etc/salt/minion_id::
          
      hostname --fqdn | sudo tee /etc/salt/minion_id

* [ ] Configure for standalone minion setup

  * [ ] Check `file_roots` and `pillar_roots` in /etc/salt/minion
  * [ ] Verify that salt files are in /srv/salt and /srv/pillar

* [ ] Configure for master/minion setup

  * [ ] DNS resolve 'salt'
  * [ ] Set ``master:`` in /etc/salt/minion.conf
  * [ ] Pair salt minion/master keys::

      salt-key --help

* [x] Run salt

  * [x] Run salt locally as a standalone minion::

      salt-call --local grains.items

  * [ ] Run salt from master::

      salt 'minion_id' grains.items

  * [ ] Run salt over SSH::

      salt-ssh 'minion_id' grains.items


Bootstrap salt master
-----------------------

* [x] `Bootstrap salt installation <http://docs.saltstack.com/en/latest/topics/tutorials/salt_bootstrap.html>`_

  * [ ] TODO


Create salt environment
------------------------
* salt/top.sls
* pillar/top.sls


Create salt formula
-----------------------

* [ ] Create configsets


Test bootstrapped setup
-------------------------

* [ ] Create basic functional network tests

  * [ ] **Python standard library** sockets
  * [*] ICMP
  * [*] TCP Ports
  * [*] TCP Banners
  * [*] HTTP GET 200 OK


