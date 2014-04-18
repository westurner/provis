#!/bin/sh

#ufw allow SSH
ufw allow proto tcp from any to any port 22
ufw default reject
ufw logging medium
ufw --force enable

