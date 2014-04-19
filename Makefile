
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

setup: setup_tools setup_download_isos packer_setup vagrant_setup

setup_tools:
	bash ./scripts/setup_tools.sh

setup_download_isos:
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

docs:
	rm -f docs/provis.rst
	rm -f docs/modules.rst
	sphinx-apidoc -o docs/ provis
	$(MAKE) -C docs clean
	$(MAKE) -C docs html
	open docs/_build/html/index.html

release: clean
	python setup.py sdist upload
	python setup.py bdist_wheel upload

dist: clean
	python setup.py sdist
	python setup.py bdist_wheel
	ls -l dist


