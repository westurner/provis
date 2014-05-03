.. _tools:

=======
Tools
=======


.. _apt:

:index:`Apt`
=============
| Wikipedia: `<https://en.wikipedia.org/wiki/Advanced_Packaging_Tool>`_
| Homepage: http://alioth.debian.org/projects/apt 
| Docs: https://wiki.debian.org/Apt 
| Docs: https://www.debian.org/doc/manuals/debian-reference/ch02.en.html
| Docs: https://www.debian.org/doc/manuals/apt-howto/
| Source: git git://anonscm.debian.org/git/apt/apt.git
| IRC: irc://irc.debian.org/debian-apt
|

APT is the Debian package management system.

APT retrieves packages over FTP, HTTP, HTTPS, and RSYNC.

.. code-block:: bash

   man apt-get
   man sources.list
   echo 'deb repo_URL distribution component1' >> /etc/apt/sources.list
   apt-get update
   apt-cache show bash
   apt-get install bash
   apt-get upgrade
   apt-get dist-upgrade


.. _bash:

:index:`Bash`
===============
| Wikipedia: `<https://en.wikipedia.org/wiki/Bash_(Unix_shell)>`_
| Homepage: http://www.gnu.org/software/bash/
| Docs: https://www.gnu.org/software/bash/manual/
| Source: git git://git.savannah.gnu.org/bash.git
|

Bash, the Bourne-again shell.

.. code-block:: bash

   type bash
   bash --help
   help help
   help type
   apropos bash
   info bash
   man bash


.. _dpkg:

:index:`Dpkg`
==============
| Wikipedia: `<https://en.wikipedia.org/wiki/Dpkg>`_
| Homepage: http://wiki.debian.org/Teams/Dpkg
| Docs: `<https://en.wikipedia.org/wiki/Debian_build_toolchain>`_
| Docs: `<https://en.wikipedia.org/wiki/Deb_(file_format)>`_
|

Lower-level package management scripts for creating and working with
.DEB Debian packages.


.. _docker:

:index:`Docker`
=================
| Wikipedia: `<https://en.wikipedia.org/wiki/Docker_(software)>`_
| Homepage: https://docker.io/
| Docs: http://docs.docker.io/
| Source: https://github.com/dotcloud/docker
|

Docker is an OS virtualization project which utilizes Linux LXC Containers
to partition process workloads all running under one kernel.

Limitations

* Writing to `/etc/hosts`: https://github.com/dotcloud/docker/issues/2267
* Apt-get upgrade: https://github.com/dotcloud/docker/issues/3934


.. _docutils:

:index:`Docutils`
===================
| Homepage: http://docutils.sourceforge.net
| Docs: http://docutils.sourceforge.net/docs/
| Docs: http://docutils.sourceforge.net/rst.html 
| Docs: http://docutils.sourceforge.net/docs/ref/doctree.html
| Source: svn http://svn.code.sf.net/p/docutils/code/trunk 
|

Docutils is a text processing system which 'parses" :ref:`ReStructuredText`
lightweight markup language into a doctree which it serializes into
HTML, LaTeX, man-pages, Open Document files, XML, and a number of other
formats.


.. _fhs:

:index:`Filesystem Hierarchy Standard`
=======================================
| Wikipedia: https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard
| Website: http://www.linuxfoundation.org/collaborate/workgroups/lsb/fhs
|

The Filesystem Hierarchy Standard is a well-worn industry-supported
system file naming structure.

:ref:`Ubuntu` and :ref:`Virtualenv` implement
a Filesystem Hierarchy.

:ref:`Docker` layers filesystem hierarchies with aufs and now
also btrfs subvolumes.


.. _git:

:index:`Git`
==============
| Wikipedia: `<https://en.wikipedia.org/wiki/Git_(software)>`_
| Homepage: http://git-scm.com/
| Docs: http://git-scm.com/documentation
| Docs: http://documentup.com/skwp/git-workflows-book
| Source: git https://github.com/git/git
|

Git is a distributed version control system for tracking a branching
and merging repository of file revisions.


.. _go:

:index:`Go`
=============
| Wikipedia: `<https://en.wikipedia.org/wiki/Go_(programming_language)>`_
| Homepage: http://golang.org/
| Docs: http://golang.org/doc/
| Source: hg https://code.google.com/p/go/
|

Go is a relatively new statically-typed C-based language.


.. _json:

:index:`Json`
===============
| Wikipedia: https://en.wikipedia.org/wiki/JSON
| Homepage: http://json.org/
|

Parse and indent JSON with :ref:`Python` and :ref:`Bash`::

    cat example.json | python -m json.tool


.. _libcloud:

:index:`Libcloud`
==================
| Homepage: https://libcloud.apache.org/ 
| Docs: https://libcloud.readthedocs.org/
| Docs: https://libcloud.readthedocs.org/en/latest/supported_providers.html
| Source: git git://git.apache.org/libcloud.git
| Source: git https://github.com/apache/libcloud 
|

Apache Libcloud is a :ref:`Python` library
which abstracts and unifies a large number of Cloud APIs for
Compute Resources, Object Storage, Load Balancing, and DNS.


.. _libvirt:

:index:`Libvirt`
=================
| Wikipedia: http://libvirt.org/
| Homepage: http://libvirt.org/
| Docs: http://libvirt.org/docs.html 
| Docs: http://docs.saltstack.com/en/latest/ref/modules/all/salt.modules.virt.html
| Source: git git://libvirt.org/libvirt-appdev-guide.git
|

Libvirt is a system for platform virtualization with
various :ref:`Linux` hypervisors.

* KVM/QEMU
* Xen
* LXC
* OpenVZ
* VirtualBox


.. _linux:

:index:`Linux`
================
| Wikipedia: https://en.wikipedia.org/wiki/Linux
| Homepage: https://www.kernel.org
| Docs: https://www.kernel.org/doc/
| Source: git https://github.com/torvalds/linux
|

A free and open source operating system kernel written in C.

.. code-block:: bash

   uname -a


.. _make:

:index:`Make`
===============
| Wikipedia: `<https://en.wikipedia.org/wiki/Make_(software)>`_
| Homepage:  https://www.gnu.org/software/make/
| Project: https://savannah.gnu.org/projects/make/ 
| Docs:  https://www.gnu.org/software/make/manual/make.html
| Source: git git://git.savannah.gnu.org/make.git
|

GNU Make is a classic, ubiquitous software build tool
designed for file-based source code compilation.

Make build chains are represented in a :ref:`Makefile`.

:ref:`Bash`, :ref:`Python`, and the GNU/:ref:`Linux` kernel
are all built with Make.


.. _msgpack:

:index:`MessagePack`
=====================
| Wikipedia: https://en.wikipedia.org/wiki/MessagePack  
| Homepage: http://msgpack.org/ 
|

MessagePack is a data interchange format
with implementations in many languages.

:ref:`Salt` 


.. _packer:

:index:`Packer`
=================
| Homepage: http://www.packer.io/
| Docs: http://www.packer.io/docs
| Docs: http://www.packer.io/docs/basics/terminology.html
| Source: git https://github.com/mitchellh/packer
|

Packer generates machine images for multiple platforms, clouds,
and hypervisors from a parameterizable template.

.. glossary::

   Packer Artifact
      Build products: machine image and manifest

   Packer Template
      JSON build definitions with optional variables and templating

   Packer Build
      A task defined by a JSON file containing build steps
      which produce a machine image

   Packer Builder
      Packer components which produce machine images
      for one of many platforms:

      - VirtualBox
      - Docker
      - OpenStack
      - GCE
      - EC2
      - VMware
      - QEMU (KVM, Xen)
      - http://www.packer.io/docs/templates/builders.html

   Packer Provisioner
      Packer components for provisioning machine images at build time

      - Shell scripts
      - File uploads
      - ansible
      - chef
      - solo
      - puppet
      - salt

   Packer Post-Processor
      Packer components for compressing and uploading built machine images



.. _perl:

:index:`Perl`
===============
| Wikipedia: https://en.wikipedia.org/wiki/Perl
| Homepage: http://www.perl.org/
| Project: http://dev.perl.org/perl5/ 
| Docs: http://www.perl.org/docs.html
| Source: git git://perl5.git.perl.org/perl.git
|


Perl is a dynamically typed, C-based scripting language.

Many of the Debian system management tools are or were originally written
in Perl.


.. _python:

:index:`Python`
=================
| Wikipedia: `<https://en.wikipedia.org/wiki/Python_(programming_language)>`_
| Homepage: https://www.python.org/
| Docs: https://docs.python.org/2/
| Source: hg http://hg.python.org/cpython
|

Python is a dynamically-typed, C-based scripting language.

Many of the RedHat system management tools are or were originally written
in Python.

:ref:`Pip`, :ref:`Sphinx`, :ref:`Salt`, :ref:`Tox`, :ref:`Virtualenv`,
and :ref:`Virtualenvwrapper` are all written in Python.


.. _pip:

:index:`Pip`
==============
| Wikipedia: `<https://en.wikipedia.org/wiki/Pip_(package_manager)>`_
| Homepage: http://www.pip-installer.org/
| Docs: http://www.pip-installer.org/en/latest/user_guide.html 
| Docs: https://pip.readthedocs.org/en/latest/
| Docs: http://packaging.python.org/en/latest/
| Source: git https://github.com/pypa/pip
| Pypi: https://pypi.python.org/pypi/pip
| IRC: #pypa
| IRC: #pypa-dev
|

Pip is a tool for working with :ref:`Python` packages.

::

   pip help
   pip help install
   pip --version

   sudo apt-get install python-pip
   pip install --upgrade pip

   pip install libcloud
   pip install -r requirements.txt
   pip uninstall libcloud


Pip configuration is in ``${HOME}/.pip/pip.conf``.

Pip can maintain a local cache of downloaded packages.

With :ref:`Python` 2, pip is preferable to ``easy_install``
because Pip installs ``backports.ssl_match_hostname``.

.. glossary::

   Pip Requirements File
      Plaintext list of packages and package URIs to install.

      Requirements files may contain version specifiers (``pip >= 1.5``)

      Pip installs Pip Requirement Files::

         pip install -r requirements.txt
         pip install --upgrade -r requirements.txt
         pip install --upgrade --user --force-reinstall -r requirements.txt

      An example ``requirements.txt`` file::

         # Install a package from pypi
         pip >= 1.5

         # Git clone and install as an editable develop egg
         -e git+https://github.com/pypa/pip#egg=pip


.. _restructuredtext:

:index:`ReStructuredText`
==========================
| Wikipedia: https://en.wikipedia.org/wiki/ReStructuredText 
| Homepage: http://docutils.sourceforge.net/rst.html 
| Docs: http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html
| Docs: http://docutils.sourceforge.net/docs/ref/rst/directives.html 
| Docs: http://docutils.sourceforge.net/docs/ref/rst/roles.html
| Docs: http://sphinx-doc.org/rest.html
| 

ReStructuredText (RST, ReST) is a plaintext
lightweight markup language commonly used for
narrative documentation and Python docstrings.

:ref:`Sphinx` is built on :ref:`Docutils`, 
which is the primary implementation of ReStructuredText.

Pandoc also supports a form of ReStructuredText.

.. glossary::

   ReStructuredText Directive
      Actionable blocks of ReStructuredText
      
      .. code-block:: rest

         .. include:: goals.rst

         .. contents:: Table of Contents
            :depth: 3

         .. include:: LICENSE


   ReStructuredText Role
      RestructuredText role extensions
      
      .. code-block:: rest

            .. _anchor-name:

            :ref:`Anchor <anchor-name>` 


.. _salt:

:index:`Salt`
===============
| Wikipedia: `<https://en.wikipedia.org/wiki/Salt_(software)>`_
| Homepage: http://www.saltstack.com
| Docs: http://docs.saltstack.com/en/latest/
| Docs: 
| Docs: http://docs.saltstack.com/en/latest/topics/development/hacking.html 
| Glossary: http://docs.saltstack.com/en/latest/glossary.html 
| Source: git https://github.com/saltstack/salt
| Pypi: https://pypi.python.org/pypi/salt
| IRC: #salt
|

Salt is an open source configuration management system for managing 
one or more physical and virtual machines running various operating systems.

.. glossary::

   Salt Top File
      Root of a Salt Environment (`top.sls`)

   Salt Environment
      Folder of Salt States with a top.sls top file.

   Salt Bootstrap
      Installer for salt master and/or salt minion 

   Salt Minion
      Daemon process which executes Salt States on the local machine.

      Can run as a background daemon.
      Can retrieve and execute states from a salt master

      Can execute local states in a standalone minion setup::

         salt-call --local grains.items
 
   Salt Minion ID
      Machine ID value uniquely identifying a minion instance
      to a Salt Master.

      By default the minion ID is set to the FQDN
      
      .. code-block:: bash
      
         python -c 'import socket; print(socket.getfqdn())'
      
      The minion ID can be set explicitly in two ways:

      * /etc/salt/minion.conf::
        
         id: devserver-123.example.org
      
      * /etc/salt/minion_id::

         $ hostname -f > /etc/salt/minion_id
         $ cat /etc/salt/minion_id
         devserver-123.example.org

   Salt Master
      Server daemon which compiles pillar data for and executes commands
      on Salt Minions::

         salt '*' grains.items

   Salt SSH
      Execute salt commands and states over SSH without a minion process::

          salt-ssh '*' grains.items

   Salt Grains
      Static system information keys and values
      
      * hostname
      * operating system
      * ip address
      * interfaces

      Show grains on the local system::

         salt-call --local grains.items

   Salt Modules
      Remote execution functions for files, packages, services, commands.

      Can be called with salt-call

   Salt States
      Graphs of nodes and attributes which are templated and compiled into
      ordered sequences of system configuration steps.

      Naturally stored in ``.sls`` :ref:`YAML` files
      parsed by ``salt.states.<state>.py``.

      Salt States files are processed as Jinja templates (by default)
      they can access system-specific grains and pillar data at compile time.

   Salt Renderers
      Templating engines (by default: Jinja) for processing templated
      states and configuration files.

   Salt Pillar
      Key Value data interface for storing and making available
      global and host-specific values for minions:
      values like hostnames, usernames, and keys.
 
      Pillar configuration must be kept separate from states
      (e.g. users, keys) but works the same way.

      In a master/minion configuration, minions do not have access to
      the whole pillar.

   Salt Cloud
      Salt Cloud can provision cloud image, instance, and networking services
      with various cloud providers (libcloud):

      + Google Compute Engine (GCE) [KVM]
      + Amazon EC2 [Xen]
      + Rackspace Cloud [KVM]
      + OpenStack [https://wiki.openstack.org/wiki/HypervisorSupportMatrix]
      + Linux LXC (Cgroups)
      + KVM 


.. _sphinx:

:index:`Sphinx`
=================
| Wikipedia: `<https://en.wikipedia.org/wiki/Sphinx_(documentation_generator)>`_
| Homepage: https://pypi.python.org/pypi/Sphinx
| Docs: http://sphinx-doc.org/contents.html  
| Docs: http://sphinx-doc.org/markup/code.html 
| Docs: http://pygments.org/docs/lexers/
| Docs: http://thomas-cokelaer.info/tutorials/sphinx/rest_syntax.html 
| Source: hg https://bitbucket.org/birkenfeld/sphinx/
| Pypi: https://pypi.python.org/pypi/Sphinx 
|

Sphinx is a tool for working with
:ref:`ReStructuredText` documentation trees
and rendering them into HTML, PDF, LaTeX, ePub,
and a number of other formats.

Sphinx extends :ref:`Docutils` with a number of useful behaviors.

.. glossary::

   Sphinx Builder
      Render Sphinx ReStructuredText into various forms:

         * HTML
         * LaTeX
         * PDF
         * ePub
    
      See: `Sphinx Builders <http://sphinx-doc.org/builders.html>`_

   Sphinx ReStructuredText
      Sphinx extends :ref:`ReStructuredText` with roles and directives
      which only work with Sphinx.

   Sphinx Directive

      .. code-block:: rest

         .. toctree::

            readme
            installation
            usage

      See: `Sphinx Directives <http://sphinx-doc.org/rest.html#directives>`_

   Sphinx Role
        RestructuredText role extensions
        
        .. code-block:: rest

            .. _anchor-name:

            :ref:`Anchor <anchor-name>`        


.. _ruby:

:index:`Ruby`
===============
| Wikipedia: `<https://en.wikipedia.org/wiki/Ruby_(programming_language)>`_
| Homepage: https://www.ruby-lang.org/
| Docs: https://www.ruby-lang.org/en/documentation/
| Source: svn http://svn.ruby-lang.org/repos/ruby/trunk
|

Ruby is a dynamically-typed programming language.

:ref:`Vagrant` is written in Ruby.


.. _tox:

:index:`Tox`
==============
| Homepage: https://testrun.org/tox/
| Docs: https://tox.readthedocs.org
| Source: hg https://bitbucket.org/hpk42/tox
| Pypi: https://pypi.python.org/pypi/tox
|

Tox is a build automation tool designed to build and test Python projects
with multiple language versions and environments
in separate :ref:`virtualenvs <virtualenv>`.

Run the py27 environment::

   tox -v -e py27
   tox --help


.. _ubuntu:

:index:`Ubuntu`
=================
| Wikipedia: `<https://en.wikipedia.org/wiki/Ubuntu_(operating_system)>`_
| Homepage: http://www.ubuntu.com/
| Docs: https://help.ubuntu.com/
| Source: https://launchpad.net/ubuntu 
| Source: http://archive.ubuntu.com/
| Source: http://releases.ubuntu.com/
|

.. _vagrant:

:index:`Vagrant`
==================
| Wikipedia: `<https://en.wikipedia.org/wiki/Vagrant_(software)>`_
| Homepage: http://www.vagrantup.com/
| Docs: http://docs.vagrantup.com/v2/
| Source: git https://github.com/mitchellh/vagrant
|

Vagrant supports various "providers"(hypervisors, clouds) both natively
and with third-party plugins.

Natively: VirtualBox, VMware, Hyper-V

With Plugins: https://github.com/mitchellh/vagrant/wiki/Available-Vagrant-Plugins


.. note:: Vagrant adds a default NAT Adapter as eth0.


.. _virtualbox:

:index:`VirtualBox`
=====================
| Wikipedia: https://en.wikipedia.org/wiki/VirtualBox
| Homepage: https://www.virtualbox.org/
| Docs: https://www.virtualbox.org/wiki/Documentation
| Source: svn svn://www.virtualbox.org/svn/vbox/trunk
|

VirtualBox is platform virtualization package
for running one or more guest VMs (virtual machines) within a host system.

For local testing purposes, VirtualBox is probably the easiest target.

VirtualBox:

* runs on many platforms: Linux, OSX, Windows
* has support for full NX/AMD-v virtualization
* requires matching kernel modules


.. _virtualenv:

:index:`Virtualenv`
====================
| Homepage: http://www.virtualenv.org
| Docs: http://www.virtualenv.org/en/latest/ 
| Source: git https://github.com/pypa/virtualenv
| PyPi: https://pypi.python.org/pypi/virtualenv 
| IRC: #pip
|

Virtualenv is a tool for creating reproducible :ref:`Python` environments.

Create a virtualenv, work on it, and show how ``sys.path`` is managed:

.. code-block:: bash

   python -m site

   virtualenv example
   source ./example/bin/activate
   python -m site


.. _virtualenvwrapper:

:index:`Virtualenvwrapper`
===========================
| Docs: http://virtualenvwrapper.readthedocs.org/en/latest/
| Source: hg https://bitbucket.org/dhellmann/virtualenvwrapper
| Pypi: https://pypi.python.org/pypi/virtualenvwrapper
|

Virtualenvwrapper extends :ref:`Virtualenv` with a number of convenient
conventions.

.. code-block:: bash

   mkvirtualenv example
   workon example
   cdvirtualenv; pwd; ls
   mkdir src; cd src/
   deactivate
   rmvirtualenv example


.. _yaml:

:index:`YAML`
==============
| Wikipedia: https://en.wikipedia.org/wiki/YAML 
| Homepage: http://yaml.org
|

YAML ("YAML Ain't Markup Language") is a concise data serialization format.


Most :ref:`Salt` states and pillar data are written in YAML. Here's an
example ``top.sls`` file:

.. code-block:: yaml

   base:
    '*':
      - openssh
    '*-webserver':
      - webserver
    '*-workstation':
      - gnome
      - i3
