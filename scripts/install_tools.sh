#!/bin/bash -x
## Install tools for westurner/provis
#
# * Apt Packages
# * Vagrant
# * VirtualBox
# * Go (optionally)
# * Packer
#
set -x
set -e

_BIN=${_BIN:-'./bin'}  # where to install scripts and binaries
mkdir -p $_BIN

INSTALLDIR="./install_"  # directory to store downloaded files in
INSTALLDIR=$(readlink -f $INSTALLDIR)
mkdir -p $INSTALLDIR
cd $INSTALLDIR

ARCH=$(uname -m)  # i686 || x86_64

####
### Debian / Ubuntu
DISTRO=$(lsb_release -cs)  # "precise"
BUILD_ARCH=$(dpkg-architecture -qDEB_BUILD_ARCH)  # i386 | amd64


## Apt Packages
install_main_apt() {
  sudo apt-get install python ruby golang-go git wget
}


## Vagrant
install_vagrant_dpkg() {
  VAGRANT_VER="1.5.3"
  VAGRANT="vagrant_${VAGRANT_VER}_${ARCH}.deb"  # i386 | x86_64
  wget -c "https://dl.bintray.com/mitchellh/vagrant/${VAGRANT}"
  sudo dpkg -i $VAGRANT
}


## VirtualBox
install_virtualbox_dpkg() {
  # https://www.virtualbox.org/wiki/Linux_Downloads
  VIRTUALBOX="virtualbox-4.3_4.3.10-93012~Ubuntu~precise_${BUILD_ARCH}.deb"
  wget "http://download.virtualbox.org/virtualbox/4.3.10/${VIRTUALBOX}"
  sudo dpkg -i $VIRTUALBOX
}

install_virtualbox_apt() {
  echo "deb http://download.virtualbox.org/virtualbox/debian ${DISTRO} contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
  wget -c "http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc" -O- | sudo apt-key add -
  sudo apt-get update
  sudo apt-get install dkms linux-headers-$(uname -r)
  sudo apt-get install virtualbox-4.3
}

## Docker
install_docker_apt() {
  [ -e /usr/lib/apt/methods/https ] || {
    apt-get update
    apt-get install apt-transport-https
  }
  sudo sh -c "echo 'deb https://get.docker.io/ubuntu docker main' \
    > /etc/apt/sources.list.d/docker.list"
  sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
  sudo apt-get update
  sudo apt-get install lxc-docker
}


## Go
install_go_gvm() {
  # https://code.google.com/p/go/downloads/detail
  # https://github.com/moovweb/gvm
  sudo apt-get install curl git mercurial make \
      binutils bison gcc build-essential
  which gvm || bash < <(curl -s \
      https://raw.github.com/moovweb/gvm/master/binscripts/gvm-installer)
  source $HOME/.gvm/scripts/gvm
  # gvm update && gvm install 1.2.1 # https://github.com/moovweb/gvm/issues/37
  #gvm update && gvm install tip
  gvm update && gvm install 1.2  # packer requires == 1.2
  gvm use go1.2
}


## Packer
install_packer_from_source() {
  # https://github.com/mitchellh/packer/issues/1019
  go get -u github.com/mitchellh/gox
  cd $GOPATH/src
  mkdir -p github.com/mitchellh
  cd github.com/mitchellh
  git clone ssh://git@github.com/mitchellh/packer
  cd packer
  make
}

install_packer_binary() {
  # http://www.packer.io/downloads.html
  PACVER="0.5.2"
  PACARCH=$(echo $BUILD_ARCH | sed 's/i//')  # 386 || amd64
  PACKER="${PACVER}_linux_${PACARCH}.zip"
  PACSHA="${PACVER}_SHA256SUMS?direct"
  cd "${INSTALLDIR}"
  wget -c "https://dl.bintray.com/mitchellh/packer/${PACSHA}"
  wget -c "https://dl.bintray.com/mitchellh/packer/${PACKER}"
  sha256sum -c <(cat $PACSHA | grep "$PACKER")
  unzip -o "${PACKER}" -d "${_BIN}"
}


## Main
main() {
  install_main_apt
  install_vagrant_dpkg
  install_packer_binary
  install_docker_apt
  install_virtualbox_apt
}


if [[ "$BASH_SOURCE" == "$0" ]]; then
  main
fi
