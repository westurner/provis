=========
Roadmap
=========

Objectives
============

* Generate new servers as easily as possible
* Generate new servers from infrastructure as code
* Maintain flexibility across multiple virtualization and cloud
  providers


Use Cases
-----------

Testing
~~~~~~~~~
I want to test current configsets with Ubuntu 14.04, Vagrant, and
VirtualBox; because I only have one physical workstation and am not yet
prepared to switch over.

Deployment Workflow
~~~~~~~~~~~~~~~~~~~~~
* Create and configure an image locally
* Push to cloud
* Paste together


Goals and Constraints
------------------------
**Tool Boundaries**

There is a significant amount of overlap between
Packer, Vagrant, VirtualBox, and Salt.

In order to prevent having to re-implement features,
one goal here is to stay flexible in regards to Virtualization
and Cloud Hosting solutions.

Clouds and Hypervisors
~~~~~~~~~~~~~~~~~~~~~~~
Packer supports various deployment targets ("builders"); for example:

* VirtualBox
* Docker
* OpenStack
* GCE
* EC2
* VMware
* QEMU (KVM, Xen)
* http://www.packer.io/docs/templates/builders.html

Vagrant supports various hypervisors ("providers"):

* VirtualBox
* VMware
* Hyper-V
* `<https://github.com/mitchellh/vagrant/wiki/Available-Vagrant-Plugins#providers>`_

VirtualBox runs on many platforms with support for full NX/AMD-v virtualization:

* Linux
* OSX
* Windows

Salt can configure across a number of clouds/hypervisors:

* KVM  http://docs.saltstack.com/en/latest/topics/tutorials/cloud_controller.html
* http://docs.saltstack.com/en/latest/ref/clouds/all/index.html

  * LXC (Cgroups)
  * GCE (KVM)
  * EC2 (Xen)
  * Rackspace (KVM)
  * OpenStack (https://wiki.openstack.org/wiki/HypervisorSupportMatrix)

For local testing purposes, VirtualBox is probably the easiest target.

Docker/LXC are nearly sufficient; but, in addition to relying upon the
host kernel, some things just don't work:

* Writing to `/etc/hosts`: https://github.com/dotcloud/docker/issues/2267
* Apt-get upgrade: https://github.com/dotcloud/docker/issues/3934

Vagrant can provision multiple VMs to lots of cloud providers.

As a configuration management system, Salt can provision and configure
VMs with lots of cloud providers.

Instrumentation and scaling are primary concerns that should be kept in
mind while developing templated configurations and application
infrastructure topologies.


Networking
~~~~~~~~~~~~
Needs:

* Gateway-routed topology ('bridged' public / private internal network)

  * Single Point of Ingress/Egress
  * Single Point of Failure
  * Vagrant: multi-machine config with

    * https://docs.vagrantup.com/v2/networking/public_network.html
    * https://docs.vagrantup.com/v2/networking/private_network.html

  * GCE Route Collections
  * EC2 Network ACLs
  * RackSpace Cloud Networks
  * OpenStack Neutron

* Attach an additional NIC

  * Packer: virtualbox-iso provider (VBoxManager)
  * Vagrant: Vagrantfile (VBoxManager)

* DNS dependence

Wants:

* VLANs (OpenStack Neutron)

Storage
~~~~~~~~~

Machine Image Storage
++++++++++++++++++++++
No SAN here.

* Packer has builders for various clouds and virtualization solutions (GCE)
* VirtualBox: local filesystem: VDI, VMDK
* Vagrant 'boxes'
* EC2 AMI
* GCE Images
* Docker Images / Registries
* OpenStack Glance Images


Block Storage
+++++++++++++++
* VirtualBox supports (elastic) VDI and VMDK files
* Latest Docker can use BTRFS
* GCE Compute Engine Disks
* EC2 EBS Elastic Block Store
* RackSpace Block Storage
* OpenStack Cinder (RBD, Gluster, Nexenta, NFS)


Remote Filesystems
+++++++++++++++++++
While remote filesystem access is mostly the wrong pattern for
production, for development, it's nice to be able to work in local GVim
with synchronous reads and writes on a networked filesystem; though,
arguably, the correct deployment pattern is a commit/push CI hook.

* SSHFS is less than consistent; even when synchronized.
* NFS is fairly standard and supports labeling

  * Vagrant has NFS access tools
  * NFS requires at least three ports


Object Storage
++++++++++++++++
* GCE Cloud Storage
* AWS S3
* OpenStack Swift
* RackSpace Cloud Files


Operating Systems
~~~~~~~~~~~~~~~~~~
Ubuntu LTS 14.04 is just out with strong support for OpenStack.

Debian is Debian.

CentOS is more closely tracking RHEL than ever before.

CoreOS and etcd are designed to scale.


Tasks
======

* [x] Create templated pypackage

* [x] Create documentation pages

  * [x] Tools (homepage, documentation, source)
  * [x] Roadmap
  * [x] Installation
  * [x] Usage (Makefile)
  * [ ] Contributing

* [x] Download OS netboot ISOs

* [x] Configure package mirrors

  * [x] Cherrypick apt-cacher-ng binary from trusty
    (HTTPS support for docker apt repos)

* [x] Install tools

  * [x] Document Homepage, Source, Docs (docs/tools.rst)
  * [x] Script installation (scripts/install_tools.sh)

* [ ] Create new [VirtualBox / Vagrant] basebox with Packer

  * [ ] Create/adapt mimimal configsets for generating a Vagrant basebox

    * [x] setup shell scripts (thanks!)
    * [x] vagrant (SSH errors)
    * [x] vagrant FS errors
    * [x] VirtualBox guest tools image (~NTP)
    * [x] etckeeper
    * [x] ufw
    * [x] Apt.conf (apt proxy copied from preseed: apt.create.wrd.nu)

* [ ] Create Vagrantfile for launching basebox

  * [x] vagrant init
  * [x] vagrant up (vagrant SSH errors)
  * [ ] Choose network topology

    * [x] Test vagrant multi-guest vm.network + bridged gateway (vagrant adds 
      a default NAT Adapter 1)
    * [ ] Configure DNS support (landrush or salt config ?)

  * [ ] Configure Provisioning support (configsets)

    * [ ] Hosts file (salt)
    * [ ] Resolv.conf

* [ ] Create basic functional network tests

  * [*] ICMP
  * [*] TCP Ports
  * [*] TCP Banners
  * [*] HTTP GET 200 OK

* [ ] Create configsets

* [x] Launch basebox with configset

  * [x] Provision w/ salt --local (Vagrant/VBox NFS mounts)
  * [ ] Provision from salt master (DNS/hosts, keys)

[ ] Basebox configset::

  # currently accomplished by a sequence of shell scripts
  # launched by the packer virtualbox-iso provisioner

  users:
   - root/vagrant
   - vagrant/vagrant
     - insecure SSH key
  sudo:
    passwordless sudo for vagrant user
    no 'requiretty'
  etckeeper:


[ ] Configmgmt Master configset (masterless)::

  configmaster

  policies

  data


[ ] Workstation configset::

  TODO: list installed packages (transitive reduction)
  i3wm
  docker
  dotfiles
  apt-cacher-ng
  nginx


[ ] Gateway/Router configset::

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
