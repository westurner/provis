.. _tools:

=======
Tools
=======


.. _bash:

:index:`Bash`
===============
| Wikipedia: `<https://en.wikipedia.org/wiki/Bash_(Unix_shell)>`_
| Homepage: http://www.gnu.org/software/bash/
| Docs: https://www.gnu.org/software/bash/manual/
| Source: `<git://git.savannah.gnu.org/bash.git>`_
|


.. _docker:

:index:`Docker`
=================
Limitations

* Writing to `/etc/hosts`: https://github.com/dotcloud/docker/issues/2267
* Apt-get upgrade: https://github.com/dotcloud/docker/issues/3934


.. _git:

:index:`Git`
==============
| Wikipedia: `<https://en.wikipedia.org/wiki/Git_(software)>`_
| Homepage: http://git-scm.com/
| Docs: http://git-scm.com/documentation
| Source: https://github.com/git/git
|

* http://documentup.com/skwp/git-workflows-book


.. _go:

:index:`Go`
=============
| Wikipedia: `<https://en.wikipedia.org/wiki/Go_(programming_language)>`_
| Homepage: http://golang.org/
| Docs: http://golang.org/doc/
| Source: https://code.google.com/p/go/
|


.. _linux:

:index:`Linux`
================
| Wikipedia: https://en.wikipedia.org/wiki/Linux
| Homepage: https://www.kernel.org
| Docs: https://www.kernel.org/doc/
| Source: https://github.com/torvalds/linux
|


.. _packer:

:index:`Packer`
=================
| Homepage: http://www.packer.io/
| Docs: http://www.packer.io/docs
| Source: https://github.com/mitchellh/packer
|

Packer supports various deployment targets ("builders"); for example:

* VirtualBox
* Docker
* OpenStack
* GCE
* EC2
* VMware
* QEMU (KVM, Xen)
* http://www.packer.io/docs/templates/builders.html




.. _puppet:

:index:`Puppet`
=================
| Wikipedia: `<https://en.wikipedia.org/wiki/Puppet_(software)>`_
| Homepage: https://puppetlabs.com/
| Docs: http://docs.puppetlabs.com/
| Source: https://github.com/puppetlabs/puppet
|


.. _python:

:index:`Python`
=================
| Wikipedia: `<https://en.wikipedia.org/wiki/Python_(programming_language)>`_
| Homepage: https://www.python.org
| Docs: https://docs.python.org/2/
| Source: http://hg.python.org/cpython
|

.. _salt:

:index:`Salt`
===============
| Wikipedia: `<https://en.wikipedia.org/wiki/Salt_(software)>`_
| Homepage: http://www.saltstack.com
| Docs: http://docs.saltstack.com/en/latest/
| Source: https://github.com/saltstack/salt
|


Salt can configure very many things.


Salt Glossary
~~~~~~~~~~~~~~~

.. glossary::
   :sorted: 

   Grains
      collectable system information keys and values

      Show grains on the local system::

         salt-call --local grains.items

   Modules
      Remote execution functions for files, packages, services, commands.

      Can be called with salt-call

   States
      Graphs of nodes and attributes which are templated and compiled into
      ordered sequences of system configuration steps.

      Naturally stored in YAML ``.sls`` (salt stack) files
      parsed by ``salt.states.<state>.py``.

   Renderers
      Templating engines (by default: Jinja) for processing templated
      states and configuration files.

      When states ``.sls`` files are processed as Jinja templates,
      they can access system-specific grains and pillar data at compile time.
    
   Pillar
      An interface which shares global and host-specific values for minions:
      values like hostnames, usernames, and keys.
    
      Pillar configuration must be kept separate from states (e.g. users, keys) but
      works the same way.

      In a master/minion configuration, nodes are only served

   Salt Cloud
      Salt Cloud can provision cloud image, instance, and networking services
      with various cloud providers (libcloud)

        - Google Compute Engine (GCE) [KVM]
        - Amazon EC2 [Xen]
        - Rackspace Cloud [KVM]
        - OpenStack [https://wiki.openstack.org/wiki/HypervisorSupportMatrix]
        - Linux LXC (Cgroups)
        - KVM 

http://docs.saltstack.com/en/latest/topics/tutorials/cloud_controller.html
http://docs.saltstack.com/en/latest/ref/clouds/all/index.html



Network architectures:

* Master/Minion

  * Requires a salt master

    * [ ] Parallel execution: ``salt '*' cmd hostname -a`` # TODO: check syntax

  * Requires a minion to be configured to point to salt master

    * [ ] /etc/hosts "salt"
    * [ ] /etc/salt/minion.conf
    * [ ] /etc/salt/minion_id

  * Requires a minion to pair keys with salt master

    * [ ] #TODO


* Standalone Minion

  * Requires salt-minion to be installed
    
    ``salt-call --local``

  * Limitations

    * Does not support salt mine collection (e.g. for /etc/hosts)


.. _ruby:

:index:`Ruby`
===============
| Wikipedia: `<https://en.wikipedia.org/wiki/Ruby_(programming_language)>`_
| Homepage: https://www.ruby-lang.org/
| Docs: https://www.ruby-lang.org/en/documentation/
| Source: http://svn.ruby-lang.org/repos/ruby/trunk
|


.. _ubuntu:

:index:`Ubuntu`
=================
| Wikipedia: `<https://en.wikipedia.org/wiki/Ubuntu_(operating_system)>`_
| Homepage: http://www.ubuntu.com/
| Docs: https://help.ubuntu.com/
| Source: http://archive.ubuntu.com/
| Source: http://releases.ubuntu.com/
|


.. _vagrant:

:index:`Vagrant`
==================
| Wikipedia: `<https://en.wikipedia.org/wiki/Vagrant_(software)>`_
| Homepage: http://www.vagrantup.com/
| Docs: http://docs.vagrantup.com/v2/
| Source: https://github.com/mitchellh/vagrant
|

Vagrant supports various "providers"(hypervisors, clouds) both natively
and with third-party plugins.

Natively: VirtualBox, VMware, Hyper-V

With Plugins: https://github.com/mitchellh/vagrant/wiki/Available-Vagrant-Plugins#providers


.. note:: Vagrant adds a default NAT Adapter as eth0.


.. _virtualbox:

:index:`VirtualBox`
=====================
| Wikipedia: https://en.wikipedia.org/wiki/VirtualBox
| Homepage: https://www.virtualbox.org/
| Docs: https://www.virtualbox.org/wiki/Documentation
| Source: `<svn://www.virtualbox.org/svn/vbox/trunk>`_
|


For local testing purposes, VirtualBox is probably the easiest target.

* runs on many platforms: Linux, OSX, Windows
* has support for full NX/AMD-v virtualization
* requires matching kernel modules



.. note:: There is a significant amount of overlap between
    Packer, Vagrant, VirtualBox, and Salt.

