
# provis Makefile

.PHONY: clean-pyc clean-build docs clean

######################
# provis tools
#

HERE=$(shell pwd)

ISOS_PATH:= /srv/provis/isos

PACKER_SRC_PATH:= $(HERE)/packer
PACKER_JSON:= $(PACKER_SRC_PATH)/packer_ubuntu-12.04-minimal-amd64.json
#PACKER_BUILD_PATH:= /srv/vm/packer
PACKER_BUILD_PATH:= $(PACKER_SRC_PATH)

VBOX_NAME:= pvbx
VBOX_BOX:= packer_virtualbox_virtualbox.box
VBOX_VMPATH:= /srv/vm/vbox

VAGRANT_SRC_PATH:= $(HERE)/vagrant
VAGRANT_HOME:= /srv/vm/vagrant

default: packer_vbox

all: setup packer_vbox vagrant_vbox


## Setup

setup: setup_provis setup_tools setup_download_isos packer_setup vagrant_setup

setup_provis:
	pip install -r ./requirements.txt
	python setup.py develop

setup_tools:
	bash ./scripts/setup_tools.sh

setup_download_isos: setup_download_isos_ubuntu

setup_download_isos_ubuntu:
	mkdir -p $(ISOS_PATH)/ubuntu && \
	cd $(ISOS_PATH)/ubuntu && \
	bash ./scripts/download_ubuntu_isos.sh


## Packer

packer_vbox: packer_vbox_build packer_vbox_clean packer_vbox_copy_to_svr

packer_setup:
	mkdir -p $(PACKER_BUILD_PATH)

packer_vbox_clean:
	rm -rfv $(PACKER_BUILD_PATH)/output-virtualbox
	rm -fv $(PACKER_BUILD_PATH)/$(VBOX_BOX)

packer_vbox_build: packer_vbox_clean
	# TODO
	cd $(PACKER_BUILD_PATH) && \
		packer build --only=virtualbox $(PACKER_JSON)

packer_vbox_copy_to_svr:
	#TODO: checksums
	rsync -ap $(PACKER_BUILD_PATH)/$(VBOX_BOX) $(VBOX_VMPATH)/$(VBOX_BOX)


packer_vagrant_rebuild: packer_vbox packer_vbox_copy_to_svr \
	vagrant_destroy vagrant_vbox_add vagrant_up


## Vagrant

# TODO: vagrant_destroy?
vagrant_vbox: vagrant_vbox_add vagrant_vbox_up

vagrant_setup: vagrant_init

vagrant_clean: vagrant_destroy
	rm -rf $(VAGRANT_HOME)

vagrant_init:
	cd $(VAGRANT_SRC_PATH) && \
		vagrant init $(VBOX_NAME)

vagrant_destroy:
	cd $(VAGRANT_SRC_PATH) && \
		vagrant -f destroy

vagrant_vbox_add:
	#TODO: vagrant --checksum --checksum-type
	cd $(VAGRANT_SRC_PATH) && \
		vagrant box list && \
		vagrant box add -f $(VBOX_VMPATH)/$(VBOX_BOX) --name $(VBOX_NAME) && \
		vagrant box list

vagrant_up:
	cd $(VAGRANT_SRC_PATH) && \
		vagrant up

vagrant_rebuild: vagrant_destroy vagrant_up


####################
# salt
#
salt_setup: salt_bootstrap salt_mount

salt_bootstrap:
	#wget -O - http://bootstrap.saltstack.org | sudo sh
	sudo sh ./scripts/salt-bootstrap.sh

salt_mount:
	sudo mkdir -p /srv/salt
	sudo mount -o bind ./salt /srv/salt

salt_local_test:
	sudo salt-call --local test.ping

salt_local_highstate:
	sudo salt-call --local state.highstate

salt_local_highstate_debug:
	sudo salt-call --local state.highstate -l debug

salt_start: salt_start_master salt_start_minion

salt_stop: salt_stop_minion salt_stop_master

salt_stop_minion:
	if [ -f /etc/init.d/salt-minion ]; then \
		sudo /etc/init.d/salt-minion stop; \
	fi

salt_start_minion:
	if [ -f /etc/init.d/salt-minion ]; then \
		sudo /etc/init.d/salt-minion start; \
	fi

salt_stop_master:
	if [ -f /etc/init.d/salt-master ]; then \
		sudo /etc/init.d/salt-master stop; \
	fi

salt_start_master:
	if [ -f /etc/init.d/salt-master ]; then \
		sudo /etc/init.d/salt-master start; \
	fi

salt_tail_minion:
	sudo tail -f /var/log/salt/minion || true

salt_tail_master:
	sudo tail -f /var/log/salt/master || true


########################
## provis tests
test_provis:
	py.test -v ./tests/provis_tests.py

test_all: test test_provis


#########################
## provis python package

help:
	@echo "clean-build - remove build artifacts"
	@echo "clean-pyc - remove Python file artifacts"
	@echo "lint - check style with flake8"
	@echo "test - run tests quickly with the default Python"
	@echo "test-all - run tests on every Python version with tox"
	@echo "coverage - check code coverage quickly with the default Python"
	@echo "docs - generate Sphinx HTML documentation, including API docs"
	@echo "release - package and upload a release"
	@echo "sdist - package"

clean: clean-build clean-pyc
	rm -fr htmlcov/

clean-build:
	rm -fr build/
	rm -fr dist/
	rm -fr *.egg-info

clean-pyc:
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +

lint:
	flake8 provis tests

test:
	python setup.py test

test-all:
	tox

coverage:
	coverage run --source provis setup.py test
	coverage report -m
	coverage html
	open htmlcov/index.html

docs_setup:
	pip install sphinx sphinxcontrib-napoleon

docs:
	rm -f docs/api.rst
	rm -f docs/modules.rst
	# https://bitbucket.org/birkenfeld/sphinx/issue/1456/apidoc-add-a-m-option-to-put-module
	# https://bitbucket.org/westurner/sphinx/branch/apidoc_output_order
	sphinx-apidoc -M --no-toc --no-headings -o docs/ provis
	mv docs/provis.rst docs/api.rst
	sed -i 's/provis package/API/' docs/api.rst
	$(MAKE) -C docs clean
	$(MAKE) -C docs html
	# x-www-browser docs/_build/html/index.html

release: clean
	python setup.py sdist upload
	python setup.py bdist_wheel upload

dist: clean
	python setup.py sdist
	python setup.py bdist_wheel
	ls -l dist

tox:
	tox

docs_test:
	tox -e docs

style:
	tox -e style
