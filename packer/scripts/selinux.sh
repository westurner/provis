#!/bin/sh

sestatus -b

apt-get install -y \
  selinux \
  selinux-policy-default \
  sepol-utils \
  checkpolicy \
  python-selinux \
  ruby-selinux

# Requires X
#apt-get intall  setools

#selinux-config-enforcing

sestatus -b

check-selinux-installation
