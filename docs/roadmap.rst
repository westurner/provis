=========
Roadmap
=========

Objectives:

* Generate new servers as easily as possible
* Generate new servers from infrastructure as code
* Maintain flexibility across multiple virtualization and cloud
  providers


Use Case:

I want to test current configsets with Ubuntu 14.04, Vagrant, and
VirtualBox; because I only have one physical workstation and am not yet
prepared to switch over.


Resources (Inputs):

* OS ISOs

  * http://releases.ubuntu.com/12.04/
  * https://help.ubuntu.com/community/Installation/MinimalCDa

    * Pull mini.iso from precise-updates (precise/mini.iso is broken)
      https://bugs.launchpad.net/ubuntu/+source/net-retriever/+bug/1067934

* Package Repositories

  * Cached locally

* Configsets


Tasks:

* [x] Cherrypick apt-cacher-ng binary from trusty
  (HTTPS support for docker apt repos)


* [ ] Create new [VirtualBox / Vagrant] basebox with Packer

  * [x] Install Packer (go)
  * [x] Download Ubuntu Minimal Image

  * [ ] Create/adapt mimimal configsets for generating a Vagrant basebox

    * [x] setup shell scripts (thanks!)
    * [ ] vagrant (SSH errors)
    * [x] VirtualBox guest tools image (~NTP)
    * [x] etckeeper
    * [x] ufw
    * [ ] Apt.conf
    * [ ] Hosts file

* [ ] Create Vagrantfile for launching basebox

  * [x] vagrant init
  * [ ] vagrant up (vagrant SSH errors)
  * [ ] Configure DNS support (landrush)
  * [ ] Configure Provisioning support (configsets)
  
* [ ] Create configsets

* [ ] Launch basebox with configset

  * [ ] Provision
  * [ ] Configset

[ ] Basebox configset::

  users:
   - root/vagrant
   - vagrant/vagrant
     - insecure SSH key
  sudo:
    passwordless sudo for vagrant user
    no 'requiretty'
  etckeeper:


[ ] Workstation configset::

  TODO: list installed packages (transitive reduction)
  i3wm
  docker
  dotfiles
  apt-cacher-ng
  nginx


[ ] Gateway configset::

  networking:
    ip_forward: True
  firewall:
    specific ports
  dns:
    local dns
    passthrough dns
  vpn:
    remote access


[ ] MySQL configset::

  mysql


[ ] Postgres configset::

  postgres


[ ] Appserver configset::

  nginx
  build-essentials?
  gunicorn
  supervisord / upstart
