.. :changelog:

History
-------

0.1.0 (Unreleased)
++++++++++++++++++

* Created roadmap.rst
* Created repository with `cookiecutter`_ and `cookiecutter-pypackage`_
* Created docs/tools.rst
* Created scripts/install_tools.sh
* Created scripts/download_ubuntu_isos.sh
* Created scripts/parse_ubuntu_miniiso_checksums.py
* Created and tested packer JSON and ubuntu 12.04 mini.iso preseed
* Imported packer/scripts from `cargomedia/vagrant-boxes
  <https://github.com/cargomedia/vagrant-boxes>`_
* Adapted, modified, and tested Packer JSON, preseed, and scripts
* Created Vagrantfile
* Created initial salt policies (webserver package, service, and ufw cmd)
* Created provis.net utilities: ICMP, Ports, Banners; socket, sarge, structlog)
* Created vm tests with net utilities
* Switched to py.test w/ pytest-capturelog (setup.py, runtests)
* Updated tox.ini (py.test, style (flake8), docs)
* Updated Makefile
* Imported scripts/salt-bootstrap.sh from `salt-bootstrap
  <https://github.com/saltstack/salt-bootstrap>`_
* Updated packer JSON: salt-bootstrap.sh from git@develop,
* Updated packer JSON: update tty config in /root/.profile for vagrant
  provisioner

.. _cookiecutter: https://github.com/audreyr/cookiecutter
.. _cookiecutter-pypackage: https://github.com/audreyr/cookiecutter-pypackage
