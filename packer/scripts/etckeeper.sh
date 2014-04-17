#!/bin/sh
# Configure etckeeper

set -e
set -x

apt-get install -y -q etckeeper mercurial

etconf="/etc/etckeeper/etckeeper.conf"

sed -i 's/^VCS=/#VCS=/g' $etconf
sed -i 's/^#VCS="hg"/VCS="hg"/' $etconf

#sed -i 's/#AVOID_DAILY_AUTOCOMMITS/AVOID_DAILY_AUTOCOMMITS/' $etconf

sed -i 's/HG_COMMIT_OPTIONS=""/HG_COMMIT_OPTIONS="--config ui.username=etckeeper@ltop"/' $etconf

/usr/bin/etckeeper init > /dev/null
/usr/bin/etckeeper commit -q -y -m "Initial etckeeper commit"
