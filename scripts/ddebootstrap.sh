#!/bin/sh

## ddebbootstrap.sh

## Objective: Bootstrap a physical host machine
#
#  * Debootstrap a chroot
#  * Configure chroot like host machine
#  * Shell script


_THISFILE=${0}

CHROOTPATH="/chroot"
APT_MIRROR_URL="http://apt.create.wrd.nu:23142"

## host

setup_debootstrap() {
    sudo apt-get install debootstrap
}

ddebootstrap(){
    dist=${1:-"trusty"}
    chrootpath=${2:-${CHROOTPATH}}
    mirror_url=${3:-"${APT_MIRROR_URL}/us.archive.ubuntu.com/ubuntu"}
    debootstrap $dist $chrootpath $mirror_url
}


cp_to_chroot() {
    src=$1
    dst=${2}
    if [ "$dst" == "" ]; then
        dst="${CHROOTPATH}/${src}"
    else
        dst="${CHROOTPATH}/${dst}"
    fi
    cp -v $src $dst
}


copy_machine_into_chroot() {
    cp_to_chroot /etc/hosts
    cp_to_chroot /etc/network/interfaces
    cp_to_chroot /etc/resolv.conf
    # TODO: /etc/network/interfaces.d


    cp_to_chroot /etc/fstab 
    # TODO: sed -i 's/<rootpartition>/<rootpartition>/g'

    cp_to_chroot /etc/crypttab
    # TODO: sed -i 's:/dev/dm-[n]//dev/mapper/vgname-lvname
}

buildcrypttab() {
    cat > /etc/crypttab << EOF
${sda1_crypt} ${sda1_luks_uuid} none luks
${cryptswap1} ${/dev/dm-1} ${/dev/urandom}
EOF

}

## guest
setup() {
    check_status
    setup_timezone
    setup_packages
}
check_status() {
    ## Check status
    set -x
    hostname -a
    lsb_release -a
    ip a
    ip r
    mount
    df
    ps aufx
    lsmod
    modinfo $(lsmod | cut -f1 -d' ') 2>/dev/null
    #  \ | egrep 'kernel/drivers/net|kernel/net' | sed 's/filename:       //g'
    set +x #
}
setup_timezone() {
    ## Set the timezone
    # ( dpkg-reconfigure tzdata )
    # TIMEZONE="Etc/UTC"
    TIMEZONE="US/Central"
    echo ${TIMEZONE} > /etc/timezone
}
setup_packages() {
    apt-get upgrade
    apt-get install lvm2 linux-image-generic cryptmount cryptsetup grub \
        language-pack-en \
        git \
        python2.7 \
        python-pip \
        apt-cacher-ng \
        openssh-server

    sshd_config="/etc/ssh/sshd_config"
    sed -i 's/UseDNS yes/UseDNS no/g' $sshd_config
    grep 'UseDNS' $sshd_config | echo 'UseDNS no' >> $sshd_config

    cp_to_chroot /etc/apt-cacher-ng/acng.conf
}

run_in_chroot() {
    # this=$(readlink -f $0)

    filename=${0:-${_THISFILE:-"ddebootstrap.sh"}}
    guest_script_path="/root/${filename}"
    dest_chroot="${CHROOTPATH}/${guest_script_path}"

    cp_to_chroot ${_THISFILE} ${dest_chroot}

    # run the script
    cchroot.sh cchroot /bin/bash ${guest_script_path} 
    
}

usage(){
    echo "$0 < help | setup | deboostrap | setupguest >"
    echo "-"
    echo "Host: $0 setup && $0 debootstrap && $0 setupguest"
}

main() {
    if [ "$1" == "help" ]; then
        usage

    elif [ "$1" == "setup" ]; then
        # install debootstrap
        setup_debootstrap

    elif [ "$1" == "debootstrap" ]; then
        ddebootstrap trusty /chroot

    elif [ "$1" == "setupguest" ]; then
        # ( within guest chroot )
        setup_things
        setup_language
    else
        usage
    fi
}

main $@
