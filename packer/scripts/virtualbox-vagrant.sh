
if test -f .vbox_version ; then
    # Create the user vagrant with password vagrant
    useradd -G sudo -p $(perl -e'print crypt("vagrant", "vagrant")') -m -s /bin/bash -N vagrant

    # Set up sudo
    echo 'vagrant ALL=NOPASSWD:ALL' > /etc/sudoers.d/vagrant
    chmod 0440 /etc/sudoers.d/vagrant

    # Install vagrant keys
    mkdir -pm 700 /home/vagrant/.ssh
    curl -kLo /home/vagrant/.ssh/authorized_keys \
      'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub'
    chmod 0600 /home/vagrant/.ssh/authorized_keys
    chown -R vagrant /home/vagrant/.ssh


    # Remove error message when running vagrant provisioner
    # @see https://github.com/mitchellh/vagrant/issues/1673
    sed -i 's/^mesg n$/tty -s \&\& mesg n/g' /root/.profile

    # Install NFS client
    apt-get -y install nfs-common
fi
