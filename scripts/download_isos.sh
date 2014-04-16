#!/bin/bash
## Download Ubuntu ISOs
set -x
set -e

VERSION="12.04"
VERSIONPOINT="${VERSION}.4}"
SERVER="http://releases.ubuntu.com"
CODENAME="precise"

# http://releases.ubuntu.com/12.04/

download_ubuntu_iso_checksums() {
  wget ${SERVER}/${VERSION}/MD5SUMS
  wget ${SERVER}/${VERSION}/SHA1SUMS
  wget ${SERVER}/${VERSION}/SHA256SUMS
}

download_ubuntu_alternate_isos() {
  wget -c ${SERVER}/${VERSION}/ubuntu-${VERSIONPOINT}-alternate-amd64.iso
  wget -c ${SERVER}/${VERSION}/ubuntu-${VERSIONPOINT}-alternate-i386.iso
}

ISOSERVER="http://archive.ubuntu.com"
ARCH="i386"

download_ubuntu_mini_iso() {
  ARCH=$1
  URL="/ubuntu/dists/${CODENAME}/main/installer-${ARCH}/current/images/netboot/mini.iso"
  wget -c "${ISOSERVER}/${URL}" -O ubuntu-$VERSION-$ARCH.iso
}

main() {
  download_ubuntu_iso_checksums
  download_ubuntu_alternate_isos
  wget 'https://help.ubuntu.com/community/Installation/MinimalCD' -O minimal_isos.html
  download_ubuntu_mini_iso "i386"
  download_ubuntu_mini_iso "amd64"
}

if [[ "$BASH_SOURCE" == "$0" ]]; then
  DOWNLOAD_TO=${1:-'.'}
  cd $DOWNLOAD_TO
  main
fi
