============
Activities
============


Create a new repository
-------------------------
* [x] Create a new git repository

  * [x] git init

* [x] Fork an existing repository

  * [x] git clone https://path/to/gitrepo
  * [x] git checkout -b feature_branch_name


Create a new package
----------------------

* [x] Create templated python package

  * [x] pip install cookiecutter
  * [x] ``cookiecutter`` https://github.com/audreyr/cookiecutter-pypackage.git

* [x] Create documentation pages

  * [x] ``README.rst``
  * [x] ``AUTHORS.rst`` -- Authors / Contributors
  * [x] docs/conf.py -- sphinx configuration
  * [x] docs/Makefile -- sphinx Makefile)
  * [x] docs/index.rst -- sphinx ReStructuredText Index
  - [x] docs/authors.rst -- Credits
  * [x] docs/tools.rst -- Tools Catalog Notes (homepage, documentation, source)
  * [x] docs/installation.rst -- Installation Procedure
  * [x] docs/usage.rst -- Usage (Makefile)
  * [ ] Contributing


Create seven layer model documentation
----------------------------------------
- [x] docs/goals.rst
- [x] docs/products.rst
- [x] docs/activities.rst
- [x] docs/patterns.rst
- [x] docs/techniques.rst
- [x] docs/tools.rst
- [x] docs/scripts.rst
- [x] Add {...} to docs/index.rst


Setup host machine
--------------------
* [x] Download OS netboot ISOs

* [x] Configure OS package mirrors

  * [x] Cherrypick apt-cacher-ng binary from trusty
    (HTTPS support for docker apt repos)

* [x] Install tools

  * [x] Document Homepage, Source, Docs (docs/tools.rst)
  * [x] Script installation (scripts/install_tools.sh)


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


Provision virtual image instance
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

* [x] Set minion id::
          
    hostname --fqdn | sudo tee /etc/salt/minion_id

* [x] Mount filesystems::

    # Configure Vagrantfile
    # mount nfs /srv/salt
    # mount nfs /srv/pillar

* [x] Run provisioner::

    salt-call --local state.highstate

* [ ] Provision from salt masterless


Bootstrap salt master
-----------------------

* [ ] Provision from salt master (DNS/hosts, keys)

  + [ ] Bootstrap salt master
  + [ ] /etc/salt/minion.conf ``master: salt``
  + [ ] /etc/salt/minion.d/\*.conf



Create salt configsets
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


