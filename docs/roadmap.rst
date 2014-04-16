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
* Minimal ISO
* Package Repositories
* Configsets


Tasks:
* Create new [VirtualBox / Vagrant] basebox with Packer
  * Install Packer (go)
  * Download Ubuntu Minimal Image
  * Create/adapt mimimal configsets for generating a Vagrant basebox
    * VirtualBox guest tools (~NTP)
* Create Vagrantfile for launching basebox
  * Configure DNS support (landrush)
  * Configure Provisioning support (configsets)
* Create configsets

* Launch basebox with configset
  * Provision
  * Configset

Basebox configset:
  users:
   - root/vagrant
   - vagrant/vagrant
     - insecure SSH key
  sudo:
    passwordless sudo for vagrant user
    no 'requiretty'
  etckeeper:


Workstation configset:
  TODO: list installed packages (transitive reduction)
  i3wm
  docker
  dotfiles
  apt-cacher-ng
  nginx


Gateway configset:
  networking:
    ip_forward: True
  firewall:
    specific ports
  dns:
 
  vpn:
    remote access


MySQL configset:
  mysql


Postgres configset:
  postgres


Appserver configset:
  nginx
  build-essentials?
  gunicorn
  supervisord / upstart
