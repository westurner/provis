==========
Patterns
==========

Patterns of Collaboration
===========================
Generate :
    space.

Reduce :
    space.

Clarify :
    space.

Organize :
    space.

Evaluate :
    space.

Build Commitment :
    space.





Networking Patterns
=====================
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


Storage Patterns
===================

Image Storage
---------------

* Packer has builders for various clouds and virtualization solutions (GCE)
* VirtualBox: local filesystem: VDI, VMDK
* Vagrant 'boxes'
* EC2 AMI
* GCE Images
* Docker Images / Registries
* OpenStack Glance Images


Block Storage
---------------
* VirtualBox supports (elastic) VDI and VMDK files
* Latest Docker can use BTRFS
* GCE Compute Engine Disks
* EC2 EBS Elastic Block Store
* RackSpace Block Storage
* OpenStack Cinder (RBD, Gluster, Nexenta, NFS)


Object Storage
----------------
* GCE Cloud Storage
* AWS S3
* OpenStack Swift
* RackSpace Cloud Files



Remote Filesystems
====================
While remote filesystem access is mostly the wrong pattern for
production, for development, it's nice to be able to work in local GVim
with synchronous reads and writes on a networked filesystem; though,
arguably, the correct deployment pattern is a commit/push CI hook.

* SSHFS is less than consistent; even when synchronized.
* NFS is fairly standard and supports labeling

  * Vagrant has NFS access tools
  * NFS requires at least three ports


Operating Systems
===================
Ubuntu LTS 12.04 is widely implemented.

Ubuntu LTS 14.04 is just out with strong support for OpenStack.

Debian is Debian.

CentOS is more closely tracking RHEL than ever before.

CoreOS and etcd are designed to scale.



