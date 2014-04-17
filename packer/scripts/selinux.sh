#!/bin/sh

sestatus -b

apt-get install -y selinux
apt-get install -y selinux-policy
apt-get install -y sepol-utils
apt-get install -y checkpolicy
apt-get install -y python-selinux
apt-get install -y ruby-selinux

# Requires X
#apt-get intall  setools

#selinux-config-enforcing

sestatus -b

check-selinux-installation
