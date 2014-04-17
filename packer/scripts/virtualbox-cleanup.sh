if test -f .vbox_version ; then

  apt-get clean -y
  apt-get autoclean -y

    # NOP: Expanding disks
    # Zero out the free space to save space in the final image:
    #dd if=/dev/zero of=/EMPTY bs=1M
    #rm -f /EMPTY
fi
