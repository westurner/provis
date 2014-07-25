#!/bin/bash

CHROOTPATH="/chroot"


mountchroot(){
    if [ "$1" != "" ]; then
        partition=$1  # /dev/mapper/pvname-lvname
        parttype=${2:-"btrfs"}  # btrfs
        mount $partition -t ${parttype} ${CHROOTPATH}
    fi
}

mountchrootdirs(){
    mount proc -t proc ${CHROOTPATH}/proc
    mount -o bind /dev ${CHROOTPATH}/dev
    mount sysfs -t sysfs ${CHROOTPATH}/sys
    mount -o bind /boot ${CHROOTPATH}/boot
}
umountchroot(){
    umount ${CHROOTPATH}/boot
    umount ${CHROOTPATH}/sys
    umount ${CHROOTPATH}/dev
    umount ${CHROOTPATH}/proc
    umount ${CHROOTPATH}
}
chrootchroot(){
    cmd=${@:-"/bin/bash"}
    LANG=C sudo chroot ${CHROOTPATH} ${cmd}
}

main() {
    if [ "$1" == "mount" ]; then
        partition=$2
        parttype=$3
        mountchroot $partition $parttype
        mountchrootdirs
    elif [ "$1" == "umount" ]; then
        umountchroot
    elif [ "$1" == "chroot" ]; then
        shift
        cmd=$@
        chrootchroot $cmd
    fi
}

main $@
