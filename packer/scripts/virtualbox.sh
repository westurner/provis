if test -f .vbox_version ; then

  # Without libdbus virtualbox would not start automatically after compile
  apt-get -y install --no-install-recommends libdbus-1-3

  # The netboot installs the VirtualBox support (old) so we have to remove it
  if test -f /etc/init.d/virtualbox-ose-guest-utils ; then
    /etc/init.d/virtualbox-ose-guest-utils stop
  fi
  #Ubuntu: apt-get install -y --no-install-recommends virtualbox-guest-utils

  rmmod vboxguest
  aptitude -y purge virtualbox-ose-guest-x11 virtualbox-ose-guest-dkms virtualbox-ose-guest-utils
  apt-get install -y install dkms


  # Install the VirtualBox guest additions
  VBOX_ISO=VBoxGuestAdditions.iso
  mount -o loop $VBOX_ISO /mnt
  yes|sh /mnt/VBoxLinuxAdditions.run
  umount /mnt

  # https://github.com/mitchellh/vagrant/issues/3341#issuecomment-38887958
  # https://www.virtualbox.org/ticket/12879
  ln -s /opt/VBoxGuestAdditions-4.3.10/lib/VBoxGuestAdditions /usr/lib/VBoxGuestAdditions

  # Cleanup Virtualbox
  rm $VBOX_ISO
fi
