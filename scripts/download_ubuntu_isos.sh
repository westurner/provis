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
  filename="ubuntu-${version}"
  for file in MD5SUMS SHA1SUMS SHA256SUMS; do
    for file2 in "${file}" "${file}.gpg"; do
      wget "${SERVER}/${version}/${file2}" -O "${filename}.${file2}"
    done
    echo "gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 0x<keyid>"
    gpg --verify "${filename}.${file}.gpg" "${filename}.${file}"
  done
}

download_ubuntu_iso() {
  version=$1       # 12.04
  versionpoint=$2  # 12.04.4
  edition=$3       # desktop | server | alternate
  arch=$4          # i386 | amd64
  filename="ubuntu-${versionpoint}-${edition}-${arch}.iso"
  checksums="ubuntu-${version}.SHA256SUMS"
  wget -c "${SERVER}/${version}/${filename}"
  sha256sum -c <(cat "${checksums}" | grep "${filename}")
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
  md5sum -c <(cat "${__md5sums}" | grep "${filename}").
}


download_ubuntu_images_checksums() {
  version=$1
  codename=$2
  arch=$3
  filename="ubuntu-${version}-updates-${arch}-images"
  url="ubuntu/dists/${codename}-updates/main/installer-${arch}/current/images"

  for file in MD5SUMS SHA1SUMS SHA256SUMS; do
    for file2 in "${file}" "${file}.gpg"; do
      wget "${MINIISOSERVER}/${url}/${file2}" -O "${filename}.${file2}"
    done
    echo "gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 0x<keyid>"
    gpg --verify "${filename}.${file}.gpg" "${filename}.${file}"
  done
}


download_ubuntu_mini_iso_updates() {
  codename=$1
  version=$2
  arch=$3
  checksums="ubuntu-${version}-updates-${arch}-images.SHA256SUMS"
  filename="ubuntu-${version}-minimal-${arch}.updates.iso"
  url="ubuntu/dists/${codename}-updates/main/installer-${arch}/current/images"

  checksum=$(cat "${checksums}" | grep "./netboot/mini.iso" | cut -f1 -d' ')
  checksumfile="${filename}.SHA256SUM"
  echo -e "${checksum}  ./${filename}" > "${checksumfile}"

  wget -c "${MINIISOSERVER}/${url}/netboot/mini.iso" -O "${filename}"
  sha256sum -c ${checksumfile}
}

main() {
  download_ubuntu_iso_checksums $VERSION
  download_ubuntu_iso $VERSION $VERSIONPOINT "alternate" "i386"
  download_ubuntu_iso $VERSION $VERSIONPOINT "alternate" "amd64"

  # Download mini (netboot) ISOs
  #download_ubuntu_minimal_cd_html "MinimalCD.html"
  #download_ubuntu_mini_iso $CODENAME $VERSION "i386"
  #download_ubuntu_mini_iso $CODENAME $VERSION "amd64"

  # Download mini (netboot) ISOs from ${CODENAME}-updates instead
  # see: https://bugs.launchpad.net/ubuntu/+source/net-retriever/+bug/1067934

  download_ubuntu_images_checksums $VERSION $CODENAME "i386"
  download_ubuntu_images_checksums $VERSION $CODENAME "amd64"
  download_ubuntu_mini_iso_updates $CODENAME $VERSION "i386"
  download_ubuntu_mini_iso_updates $CODENAME $VERSION "amd64"

  ls -alh .
}

if [[ "$BASH_SOURCE" == "$0" ]]; then
  DOWNLOAD_TO=${1:-'.'}
  cd $DOWNLOAD_TO
  main
fi
