
######################
#### provis Makefile

## Usage::
##
##    $ make help

## Sections

# * Setup
# * Packer
# * Vagrant
# * Salt
# * Salt init master minion setup
# * Salt supervisord configuration (TST)
# * Provis python package
# * Provis tests (TST)
# * Provis clean (CLN)
# * Provis build (BLD)
# * Provis docs build (DOC,BLD)

# Requires::
#
#   sudo apt-get install make

HERE:=$(shell pwd)
APPNAME:=provis

PREFIX:=$(strip $(VIRTUAL_ENV))
SRC:=$(PREFIX)/src
ETC:=$(PREFIX)/etc
VARRUN:=$(PREFIX)/var/run
VARLOG:=$(PREFIX)/var/log

DOCS_PATH:= /srv/repos/var/www/docs
DOCS_URL_BASE:= https://code/docs
DOCS_URL:= $(DOCS_URL_BASE)/$(APPNAME)

PACKER:=packer
PACKER_SRC_PATH:= $(HERE)/packer
PACKER_BUILD_PATH:= $(PACKER_SRC_PATH)
PACKER_JSON:= $(PACKER_SRC_PATH)/packer_ubuntu-12.04-minimal-amd64.json
PACKER_VBOX:= packer_virtualbox_virtualbox.box

ISOS_PATH:= /srv/provis/isos

VBOX_BOX:= $(PACKER_VBOX)
VBOX_NAME:= pvbx
VBOX_VMPATH:= /srv/vm/vbox
VBOX_URL:= TODO

VAGRANT:=vagrant
VAGRANT_SRC_PATH:= $(HERE)/vagrant
VAGRANT_HOME:= /srv/vm/vagrant

SALT_CALL:= sudo salt-call
SALT_CALL_LOCAL:= $(SALT_CALL) --local

SUPERVISOR_CONF_SRC:= $(HERE)/salt/base/saltdev/files/supervisord.conf
SUPERVISOR_CONF:= $(PREFIX)/etc/supervisord.conf
SUPERVISOR_BIN:= $(PREFIX)/bin
#SUPERVISORCTL:= $(addsuffix '-c $(SUPERVISOR_CONF)', supervisorctl)
SUPERVISORCTL:=supervisorctl -c $(SUPERVISOR_CONF)
SUPERVISORD:=supervisord -c $(SUPERVISOR_CONF)

GLOSSARY_UNDEFINED_TERMS:= docs/_glossary_undefined.rst

TOX_CACHE:= .tox/

BROWSER="web"

SEARCHTERM:=""

# .PHONY ~= Always Run (even if a file with the build step name exists)
.PHONY: clean_pyc clean_build docs clean help default

.PHONY: default
default: help

.PHONY: help
help: makefile_help
	## Print help information for this Makefile

all: setup packer_img vagrant_box
	## Setup and configure tools env, create image (packer),

## Makefile debug and test
#
makefile_help:
	## Generate help from Makefile first-line comments starting with '##'
	egrep -nv '^--$$' Makefile --color=auto \
		| egrep '^(\w*):(\n|\s*)(.*)$$' -A 1 --color=auto \
		| sed 's/^\s##\(.*\)/  \1\n/g' -

makefile_help_list:
	## Generate a list of Make tasks (and variables*) in this Makefile
	## * variables with := assignments
	cat Makefile | egrep '^\w+:'

makefile_debug:
	## Debug Makefile
	env | sort
	##
	## make.log
	$(MAKE) -p help | tee $(VARLOG)/make.log

makefile_debug_search:
	## search for $(SEARCHTERM) in makefile configuration
	$(MAKE) makefile_debug \
		| egrep -nv '^#\s+' \
		| egrep $(SEARCHTERM) -B 6 -A 3 --color=auto

makefile_generate_phony_list:
	## Print a suggested Makefile .PHONY line for this Makefile
	cat ./Makefile \
		| egrep '^\w+:' \
		| grep -v ':=' \
		| sed 's/:.*//g' \
		| tr '\n' ' ' \
		| tee Makefile.PHONY


makefile_test:
	## Test this Makefile
	$(MAKE) help
	#$(MAKE) help_list
	$(MAKE) makefile_debug
	$(MAKE) makefile_debug_search
	$(MAKE) makefile_generate_phony_list
	#$(MAKE) bootstrap_all
	#$(MAKE) setup
	$(MAKE) setup_tools
	$(MAKE) download_isos
	$(MAKE) packer_setup
	$(MAKE) vagrant_setup
	$(MAKE) vagrant_box_list
	$(MAKE) packer_img
	$(MAKE) vagrant_box
	$(MAKE) vagrant_box_list
	$(MAKE) packer_img_rebuild_vagrant
	$(MAKE) vagrant_box_list
	$(MAKE) vagrant_ssh_rod_test

	#$(MAKE) docs_setup_ubuntu
	$(MAKE) docs_setup
	$(MAKE) docs_html_rebuild



## Setup
#
bootstrap_all: setup setup_tools download_isos packer_setup vagrant_setup
	## Install and configure provis, packer, vagrant, virtualbox, get isos

setup:
	## Install this package's requirements.txt and requirements
	pip install -r ./requirements.txt
	pip install -e .
	#python setup.py develop

setup_tools:
	## Install Vagrant, Packer, Docker, and VirtualBox
	bash scripts/install_tools.sh



## Download ISOs
#
download_isos: download_isos_ubuntu
	## Download install ISOs

download_isos_ubuntu:
	## Download ubuntu install ISOs
	mkdir -p $(ISOS_PATH)/ubuntu && \
	cd $(ISOS_PATH)/ubuntu && \
		bash $(HERE)/scripts/download_ubuntu_isos.sh
	touch download_isos_ubuntu



## Packer
#
packer_setup:
	## Setup a ./packer build environment
	## see: scripts/install_tools.sh : install_packer_binary
	mkdir -p $(PACKER_BUILD_PATH)

packer_img: packer_img_clean packer_img_build packer_img_copy_to_svr
	## Rebuild packer image

packer_img_rebuild_vagrant: packer_img vagrant_destroy vagrant_box
	## Rebuild packer image and $(VAGRANT) destroy, box add, up

packer_img_clean:
	## Remove packer build files and generated ISO
	rm -rfv $(PACKER_BUILD_PATH)/output-virtualbox
	rm -fv $(PACKER_BUILD_PATH)/$(VBOX_BOX)

packer_img_build: packer_img_clean
	## Build a VirtualBox image with packer
	cd $(PACKER_BUILD_PATH) && \
		$(PACKER) build --only=virtualbox $(PACKER_JSON)

packer_img_copy_to_svr:
	## Copy a generated packer ISO to local directory
	#TODO: checksums
	rsync -ap $(PACKER_BUILD_PATH)/$(VBOX_BOX) $(VBOX_VMPATH)/$(VBOX_BOX)



## Vagrant
#
vagrant_setup: vagrant_init
	## Initialize a $(VAGRANT) environment (See setup_tools)

vagrant_init:
	## Create a new Vagrantfile
	cd $(VAGRANT_SRC_PATH) && \
		test -f Vagrantfile || \
		$(VAGRANT) init $(VBOX_NAME)

vagrant_up:
	## Launch [and provision] all Vagrantfile servers
	cd $(VAGRANT_SRC_PATH) && \
		$(VAGRANT) up

vagrant_box: vagrant_box_add vagrant_up
	## Add vbox_box to $(VAGRANT) and start it

vagrant_clean: vagrant_destroy
	## Remove $(VAGRANT_HOME)
	rm -rf $(VAGRANT_HOME)

vagrant_destroy:
	## Shutdown and destroy all Vagrantfile instances
	cd $(VAGRANT_SRC_PATH) && \
		$(VAGRANT) -f destroy

vagrant_rebuild: vagrant_destroy vagrant_up
	## Destroy and rebuild all Vagrantfile servers


vagrant_box_list:
	## List $(VAGRANT) boxes
	cd $(VAGRANT_SRC_PATH) && \
		$(VAGRANT) box list -i

## Vagrant local configuration

vagrant_box_add:
	## Add a virtualbox image named VBOX_NAME to vagrant
	#TODO: $(VAGRANT) --checksum --checksum-type
	echo "## box list: before" && \
		$(MAKE) vagrant_box_list && \
	cd $(VAGRANT_SRC_PATH) && \
		echo "## adding box" && \
		$(VAGRANT) box add -f $(VBOX_VMPATH)/$(VBOX_BOX) --name $(VBOX_NAME)
	echo "## box list: after" && \
		$(MAKE) vagrant_box_list

vagrant_ssh_rod_test:
	## SSH into the <rod> vm
	cd $(VAGRANT_SRC_PATH) && \
		$(VAGRANT) ssh rod -c 'date'

vagrant_ssh_rod:
	## SSH into the <rod> vm
	cd $(VAGRANT_SRC_PATH) && \
		$(VAGRANT) ssh rod

vagrant_ssh_rod_provision:
	## Provision the <rod> vm with $(VAGRANT) provisioning scripts
	cd $(VAGRANT_SRC_PATH) && \
		$(VAGRANT) provision rod

vagrant_ssh_rod_salt:
	## Provision with standalone salt minion from local conf
	cd $(VAGRANT_SRC_PATH) && \
		$(VAGRANT) ssh rod -c 'sudo salt-call --local state.highstate'


## salt
#
salt_setup: salt_bootstrap salt_mount
	## Bootstrap a local salt minion and mount salt directories into /srv/salt

salt_bootstrap_download_to_scripts:
	@#wget -O - http://bootstrap.saltstack.org > scripts/bootstrap-salt.sh
	wget -O - https://raw.githubusercontent.com/saltstack/salt-bootstrap/develop/bootstrap-salt.sh > scripts/bootstrap-salt.sh
	gd scripts/bootstrap-salt.sh
	# ln -s ./scripts/bootstrap-salt.sh ./scripts/salt-bootstrap.sh

salt_bootstrap: salt_bootstrap_minion

salt_bootstrap_minion:
	## Bootstrap a salt minion
	sudo bash scripts/salt-bootstrap.sh \
		| logger --tag=salt.minion.bootstrap $(VARLOG)/salt-bootstrap-minion.log
	$(MAKE) salt_minion_local
	# see: Vagrantfile

salt_bootstrap_master:
	## Bootstrap a salt master
	sudo bash scripts/salt-bootstrap.sh -M \
		| logger --tag=salt.minion.bootstrap $(VARLOG)/salt-bootstrap-master.log

salt_minion_local:
	## Copy the /etc/salt/minion file into place (w/ pillar roots)
	sudo mkdir /etc/salt
	sudo cp salt/etc/minion /etc/salt/minion
	sudo salt-call --local test.ping
	$(MAKE) salt_local_grains
	$(MAKE) salt_local_pillar
	#$(MAKE) salt_local_highstate

salt_mount_local:
	## Mount salt directories into /srv/salt and /srv/pillar
	sudo mkdir -p /srv/salt \
		| logger --tag=salt.mount >> $(VARLOG)/salt-bootstrap-mount.log
	sudo mount -o bind ./salt /srv/salt \
		| logger --tag=salt.mount >> $(VARLOG)/salt-bootstrap-mount.log
	sudo mkdir -p /srv/pillar \
		| logger --tag=salt.mount >> $(VARLOG)/salt-bootstrap-mount.log
	sudo mount -o bind ./pillar /srv/pillar \
		| logger --tag=salt.mount >> $(VARLOG)/salt-bootstrap-mount.log

salt_mount: salt_mount_local


salt_local_test:
	## Test local salt configuration
	$(SALT_CALL_LOCAL) test.ping

salt_local_grains:
	## Print local grains
	$(SALT_CALL_LOCAL) --grains
	# $(SALT_CALL_LOCAL) grains.items

salt_local_doc:
	## Print documentation (for all *modules*)
	$(SALT_CALL_LOCAL) --doc


salt_local_grains_json:
	## Print local grains as JSON
	$(SALT_CALL_LOCAL) grains.items --output=json

salt_local_grains_pprint:
	## Print local grains with pprint
	$(SALT_CALL_LOCAL) grains.items --output=pprint

salt_local_pillar:
	## Print local pillar
	$(SALT_CALL_LOCAL) pillar.items

salt_local_pillar_json:
	## Print local pillar as JSON
	$(SALT_CALL_LOCAL) pillar.items --output=json

salt_local_pillar_pprint:
	## Print local pillar with pprint
	$(SALT_CALL_LOCAL) pillar.items --output=pprint

salt_local_highstate:
	## Run salt with local configset
	$(SALT_CALL_LOCAL) state.highstate

salt_local_highstate_test:
	## Run salt with localconfigset and test=True
	$(SALT_CALL_LOCAL) state.highstate test=True

salt_local_highstate_debug:
	## Run salt with local configset and debug logging
	$(SALT_CALL_LOCAL) state.highstate -l debug


## Salt init master minion setup
#

salt_init_start: salt_init_master_start salt_init_start_minion
	## Start salt master and salt minion

salt_init_stop: salt_init_stop_minion salt_init_master_stop
	## Stop salt minion and salt master

salt_init_stop_minion:
	## Stop init salt minion
	if [ -f /etc/init/salt-minion.conf ]; then \
		sudo stop salt-minion ; \
	elif [ -f /etc/init.d/salt-minion ]; then \
		sudo /etc/init.d/salt-minion stop; \
	fi

salt_init_start_minion:
	## Start init salt minion
	if [ -f /etc/init/salt-minion.conf ]; then \
		sudo service salt-minion start; \
	elif [ -f /etc/init.d/salt-minion ]; then \
		sudo /etc/init.d/salt-minion start; \
	fi

salt_init_master_stop:
	## Stop salt init master
	if [ -f /etc/init/salt-master.conf ]; then \
		sudo stop salt-master ; \
	elif [ -f /etc/init.d/salt-master ]; then \
		sudo /etc/init.d/salt-master stop; \
	fi

salt_init_master_start:
	## Start salt init master
	if [ -f /etc/init/salt-master.conf ]; then \
		sudo service salt-master start; \
	elif [ -f /etc/init.d/salt-master ]; then \
		sudo /etc/init.d/salt-master start; \
	fi

salt_init_master_check:
	## Salt salt init master status
	if [ -f /etc/init/salt-master.conf ]; then \
		sudo status salt-master; \
	elif [ -f /etc/init.d/salt-master.conf ]; then \
		sudo /etc/init.d/salt-master start; \
	fi

salt_init_minion_check:
	## Check salt init minion status
	if [ -f /etc/init/salt-minion.conf ]; then \
		sudo status salt-minion; \
	elif [ -f /etc/init.d/salt-minion.conf ]; then \
		sudo /etc/init.d/salt-minion start; \
	fi

salt_init_minion_tail:
	## Tail salt init minion log
	sudo tail -n20 -f /var/log/salt/minion || true

salt_init_master_tail:
	## Tail salt init master log
	sudo tail -n20 -f /var/log/salt/master || true

salt_init_tail_follow:
	## Tail salt init minion and master logs
	sudo tail -n20 -f /var/log/salt/minion /var/log/salt/master




## Salt supervisord configuration
#
salt_sv_start:
	## Start supervisord
	$(SUPERVISORD)

salt_ssv: salt_sv_start
	## Start supervisord

salt_sv_setup: salt_sv_setup_prefix salt_sv_create_conf salt_sv_start
	## Prepare supervisord within $(PREFIX)

salt_sv_setup_prefix:
	## Create prefix directories
	mkdir -p \
		$(PREFIX)/etc \
		$(PREFIX)/var/log \
		$(PREFIX)/var/run \
		$(PREFIX)/src

salt_sv_create_conf:
	## Copy default supervisord to $(PREFIX)/etc/supervisord.conf
	cp $(SUPERVISOR_CONF_SRC) $(SUPERVISOR_CONF)

salt_sv_rebuild: salt_sv_shutdown salt_sv_check_status salt_sv_setup salt_sv_start
	## Supervisord { shutdown, check, setup, start, { and check } }
	$(MAKE) salt_sv_check_status

salt_sv_check_status: salt_sv_status
	## Supervisord salt master minion report
	$(MAKE) salt_sv_status
	#
	## supervisorctl tail master
	#
	$(SUPERVISORCTL) tail mas
	#
	## supervisorctl tail minion
	#
	$(SUPERVISORCTL) tail min
	## /var/log
	find $(VARLOG) -print0 | xargs -0 ls -ld
	## supervisord main log
	$(SUPERVISORCTL) maintail

salt_sv_shell:
	## Run a supervisorctl shell
	$(SUPERVISORCTL)

salt_sv_shutdown:
	## Shutdown configured supervisord
	$(SUPERVISORCTL) shutdown
	sleep 4

salt_sv_start_all:
	## Start supervisord services
	$(SUPERVISORCTL) start all

salt_sv_stop:
	## Shutdown supervisord
	$(SUPERVISORCTL) stop all

salt_sv_restart:
	## Restart supervisord
	$(SUPERVISORCTL) restart all

salt_sv_status:
	## Run supervisorctl status
	sleep 4
	$(SUPERVISORCTL) status

salt_sv_reload:
	## Reload SUPERVISOR_CONF
	$(SUPERVISORCTL) reload

salt_sv_update:
	## Update supervisorctl with SUPERVISOR_CONF
	$(SUPERVISORCTL) update

salt_sv_main_tail_follow:
	## Tail salt supervisord main tail
	$(SUPERVISORCTL) maintail -f

salt_sv_minion_tail_follow:
	## Tail salt supervisord minion log
	$(SUPERVISORCTL) tail -f min

salt_sv_master_tail_follow:
	## Tail salt supervisord minion log
	$(SUPERVISORCTL) tail -f mas

salt_sv_tail_follow:
	## Tail --follow salt supervisord master minion and supervisord.log
	tail --follow="$(PREFIX)/var/log/master.log" \
		--follow="$(PREFIX)/var/log/minion.log" \
		--follow="$(PREFIX)/var/log/supervisord.log"


salt_list_keys:
	salt-key -L

salt_test_all:
	salt '*' test.ping
	salt '*' cmd.run 'hostname -a'

### provis python package

## provis tests
#

test: test_setup-py test_local test_lint
	## Run provis tests

test_setup-py:
	## Run python setup.py test
	python setup.py test

test_local:
	## Run local tests
	py.test -v ./tests/

test_lint:
	## Run flake8 tests for source and tests
	flake8 provis tests

## provis build
#
clean: clean_build clean_pyc
	## Clean build, pyc, and development files

clean_build:
	## Clean build files
	rm -fr build/
	rm -fr *.egg-info

clean_coverage:
	## Clean coverage report files
	rm -fr htmlcov/

clean_dist:
	## Remove all built packages in ./dist
	rm -fr dist/

clean_pyc:
	## Clean *.pyc *.pyo and *~ files
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +


build: test build_coverage clean
	## Run all tox.ini environments
	$(MAKE) tox
	$(MAKE) build_coverage


build_coverage: build_coverage_report view_coverage_report
	## Generate and surf to a coverage report

build_coverage_report:
	## Generate coverage report
	coverage run --source provis setup.py test
	coverage report -m
	coverage html

view_coverage_report:
	## Surf to local coverage report
	$(BROWSER) htmlcov/index.html


release: clean
	## Build and upload a new sdist and bdist_wheel
	python setup.py sdist upload
	python setup.py bdist_wheel upload

dist: clean
	## Build a new sdist and bdist_wheel
	python setup.py sdist
	python setup.py bdist_wheel
	ls -lh dist


python_print_site:
	## Print python site information
	python -m site


pip_install: pip_install_requirements pip_install_local python_print_site
	## Install requirements and provis packages

pip_install_develop: pip_install_requirements pip_install_requirements_dev pip_install_local_develop python_print_site
	## Install requirements and provis package (as a develop egg)

pip_install_requirements:
	## Install requirements and provis packages
	pip install -r requirements.txt

pip_install_requirements_dev:
	## Install requirements
	pip install -r requirements-docs.txt

pip_install_local:
	## Pip install from local setup.py
	pip install .

pip_install_local_develop:
	## Install as Pip editable
	pip install -e .



## Tox
#
tox:
	## Run tox with all envionments in tox.ini
	cat tox.ini
	tox

tox_clean:
	## Clean tox caches
	rm -rfv .tox/$(APPNAME)

tox_style:
	## Run tox code style check tests
	cat tox.ini
	tox -e style

tox_docs:
	## Run tox documentation tests
	cat tox.ini
	tox -e docs



## Provis docs build
#
docs_setup:
	## Install docs build requirements
	pip install -r requirements-docs.txt
	## See also:
	##  make docs_setup_ubuntu
	##  make 

docs_setup_ubuntu: docs_auto_setup docs_rst2pdf_setup_ubuntu docs_setup_latex_ubuntu
	## Install sphinx build requirements on Ubuntu

docs_clean:
	## Clean the built docs from docs/_build/
	$(MAKE) -C docs clean

docs_build: docs_clean docs_api docs_html_build
	## Build the docs

docs_html_rebuild: docs_build docs_html_rsync_local
	## Rebuild the docs and sync HTML to local hosting

docs_html_build: docs_html_clean
	## Build the docs (requires `make docs_setup`)
	$(MAKE) -C docs html

docs_html_clean:
	## Clean the html docs
	rm -rf ./docs/_build/html

docs_rst2pdf_build:
	## Build rst2pdf PDF from index.rst
	mkdir -p docs/_build/rst2pdf
	cd docs/ && \
		rst2pdf --break-level=1 \
				--stylesheets=_static/pdf.styles \
				--repeat-table-rows \
				-o _build/rst2pdf/$(APPNAME)-docs.rst2pdf.pdf \
				index.rst

docs_rst2pdf_clean:
	## Clean rst2pdf build files
	rm -rfv docs/_build/rst2pdf/

docs_rst2pdf_view:
	## Launch PDF viewer with
	evince docs/_build/rst2pdf/$(APPNAME)-docs.rst2pdf.pdf

docs_rst2pdf_rebuild: docs_rst2pdf_clean docs_rst2pdf_build docs_rst2pdf_view
	## Build rst2pdf PDF and launch PDF viewer

docs_latex_build:
	## Build the latex docs
	$(MAKE) -C docs latex

docs_latex_debug:
	## Debug existing latex build
	cd docs/_build/latex/
	$(EDITOR) docs/_build/latex/*.tex \
				_build/latex/*.aux \
				_build/latex/*.toc \
				_build/latex/*.out \
				_build/latex/*.log \
				_build/latex/*.idx


docs_latexpdf_build:
	## Build the latexpdf docs
	$(MAKE) -C docs latexpdf

docs_latexpdf_view:
	## Open a GUI PDF viewer of the latexpdf 
	evince docs/_build/latex/*.pdf

docs_latexpdf_preview: docs_latex_build docs_latex_view
	## Generate latex

docs_s5_build:
	[ -d $(SLIDES_BUILDDIR) ] || rm -rf $(SLIDES_BUILDDIR)
	mkdir -p $(SLIDES_BUILDDIR)
	cp $(SLIDES_FILE) $(SLIDES_TMP)
	#sed -i 's/:term:`\(.*\)`/**\1**/g' $(SLIDES_TMP)
	#sed -i 's/:ref:`\(.*\)`/**\1**/g' $(SLIDES_TMP)
	#sed -i 's/:pypi:`\(.*\)/**\1**/g' $(SLIDES_TMP)
	# TODO
	rst2s5.py \
		--section-numbering \
		--title='' \
		--date \
		--time \
		--strip-elements-with-class notes \
		--current-slide \
		--compact-lists \
		--embed-stylesheet \
		--attribution=parentheses \
		--table-style=borderless \
		--cloak-email-addresses \
		--view-mode=outline \
		--theme=small-white \
		 $(SLIDES_TMP) \
		 $(SLIDES_OUTP)

docs_s5_rebuild: docs_s5_clean  docs_s5_build

docs_s5_view_local:
	## View s5 slides
	$(BROWSER) $(SLIDES_OUTP)

docs_s5_preview: s5 s5_open

docs_autocompile_setup:
	pip install pyinotify
	#wget https://raw.github.com/seb-m/pyinotify/master/python2/examples/autocompile.py

docs_html_autocompile:
	python $(HERE)/scripts/autocompile.py . \
		'.rst,Makefile,conf.py,theme.conf' \
		"make docs_html_rebuild"

docs_latex_autocompile:
	## Auto-rebuild docs on inotify
	cd docs/ && \
		python $(HERE)/scripts/autocompile.py . \
			'.rst,.bib,.tex,Makefile,conf.py,theme.conf' \
			"make latexpdf"

docs_s5_autocompile: docs_rebuild_s5 docs_view_s5
	## Auto-rebuild slides on inotify
	cd docs/ && \
		python $(HERE)/scripts/autocompile.py . \
			'.rst,.bib,.tex,Makefile,conf.py,theme.conf' \
			"make docs_s5_rebuild"


docs_glossary_terms: clean
	$(MAKE) docs_html_build 2>&1 \
		| grep 'term not in glossary' \
		| awk '{ path = print $$7,$$8,$$9,$$10  }' \
	    | tee $(GLOSSARY_TERMS)

docs_glossary_terms_uniq: check_glossary_terms
	cat $(GLOSSARY_TERMS) \
		| sort \
	   	| uniq -c \
		| sort -n -r


docs_api:
	## Generate API docs with sphinx-autodoc (requires `make docs_setup`)
	rm -f docs/api.rst
	rm -f docs/modules.rst
	# https://bitbucket.org/birkenfeld/sphinx/issue/1456/apidoc-add-a-m-option-to-put-module
	# https://bitbucket.org/westurner/sphinx/branch/apidoc_output_order
	sphinx-apidoc -M --no-toc --no-headings -o docs/ provis
	mv docs/provis.rst docs/api.rst
	sed -i 's/provis package/API/' docs/api.rst

docs_linkcheck:
	## Check docs links with sphinx
	cd $(HERE)/docs && \
		sphinx-build -v -b linkcheck . ./_build


docs_and_rsync: docs_build docs_html_rsync_local
	## Build the docs and sync to local docs hosting

docs_html_rsync_local:
	## Rsync docs to locally hosted docs directory
	rsync -ar docs/_build/html/ $(DOCS_PATH)/$(APPNAME)

docs_and_rsync_and_view: docs_and_rsync docs_view_hosted
	## Build, sync, and surf to hosted local docs version


docs_view_local:
	## Build the docs and surf to local version
	$(BROWSER) $(HERE)/docs/_build/html/index.html

docs_view_hosted:
	## Surf to the locally hosted docs
	$(BROWSER) "$(DOCS_URL)/"

edit:
	## Edit the project
	$(EDITOR) \
		README.rst \
		HISTORY.rst \
		Makefile \
		docs/index.rst \
		docs/ \
		salt/ \
		pillar/ \
		vagrant/Vagrantfile

salt_dev_report:
	#TODO: git receive hooks / GitFS
	(cd salt; find . -maxdepth 2 -type d -or -type l \
		| sort \
		| xargs ls -dl > pyrpo.ls-dl.log)
	(cd salt; pyrpo -s . -r full > pyrpo.full.log)
	(cd salt; pyrpo -s . -r sh > pyrpo.sh.log)
	(cd salt; pyrpo -s . -r status > pyrpo.status.log)

