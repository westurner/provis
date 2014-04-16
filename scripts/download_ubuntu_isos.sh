#!/bin/bash
## Download Ubuntu ISOs
set -x
set -e
__THIS=$(readlink -e "$0")
__THISDIR=$(dirname "${__THIS}")


VERSION="12.04"
VERSIONPOINT="${VERSION}.4"
SERVER="http://releases.ubuntu.com"
MINIISOSERVER="http://archive.ubuntu.com"
CODENAME="precise"

# http://releases.ubuntu.com/12.04/

download_ubuntu_iso_checksums() {
  version=$1
  wget ${SERVER}/${version}/MD5SUMS -O MD5SUMS
  wget ${SERVER}/${version}/SHA1SUMS -O SHA1SUMS
  wget ${SERVER}/${version}/SHA256SUMS -O SHA256SUMS
}

download_ubuntu_iso() {
  version=$1       # 12.04
  versionpoint=$2  # 12.04.4
  edition=$3       # desktop | server | alternate
  arch=$4          # i386 | amd64
  filename="ubuntu-${versionpoint}-${edition}-${arch}.iso"
  wget -c "${SERVER}/${version}/${filename}"
  sha256sum -c <(cat SHA256SUMS | grep "${filename}")
}

download_ubuntu_minimal_cd_html() {
  filename=$1
  wget 'https://help.ubuntu.com/community/Installation/MinimalCD' \
    -O "${filename}"
  python $__THISDIR/parse_ubuntu_miniiso_checksums.py $filename
}


download_ubuntu_mini_iso() {
  codename=$1
  version=$2
  arch=$3
  __md5sums="miniiso-MD5SUMS"  # generated from parse_miniiso_checksums.py
  url="/ubuntu/dists/${codename}/main/installer-${arch}/current/images/netboot/mini.iso"
  filename="ubuntu-${version}-minimal-${arch}.iso"
  wget -c "${MINIISOSERVER}/${url}" -O ${filename}
  md5sum -c <(cat "${__md5sums}" | grep "${filename}")
}

main() {
  download_ubuntu_iso_checksums $VERSION
  download_ubuntu_iso $VERSION $VERSIONPOINT "alternate" "i386"
  download_ubuntu_iso $VERSION $VERSIONPOINT "alternate" "amd64"
  download_ubuntu_minimal_cd_html "MinimalCD.html"
  download_ubuntu_mini_iso $CODENAME $VERSION "i386"
  download_ubuntu_mini_iso $CODENAME $VERSION "amd64"
  ls -alh .
}

if [[ "$BASH_SOURCE" == "$0" ]]; then
  DOWNLOAD_TO=${1:-'.'}
  cd $DOWNLOAD_TO
  main
fi
