#!/bin/bash -e
# Setup salt-minion on OSX

git_status2() {
    repo=$1
    (set -x;
    git -C "${repo}" log -n3 --stat --decorate=full; \
    git -C "${repo}" status; \
    git -C "${repo}" diff; \
    )
}

bootstrap_salt_osx() {
    PIPOPTIONS="-v" # --user "
    PIP_SALT_URL='https://github.com/saltstack/salt@v2014.7.3#egg=salt'
    _SRC=${_SRC:-${VIRTUAL_ENV:+"${VIRTUAL_ENV}/src"}}
    _SRC=${_SRC:-'./src'}
    _WRD="${_SRC}/salt"

    cd ${_SRC}

    # git clone and install or just install
    if [ -d ${_WRD} ]; then
        echo "${_WRD} exists. Not cloning"
        git_status2 "${_WRD}"
        (set -x; pip install -e ${_WRD})
    else
        (set -x; pip install ${PIPOPTIONS} -e "${PIP_SALT_URI}")
        if [ ! -d ${_WRD} ]; then
            echo "Failed to clone salt (2)"
            exit 2
        else
            git_status2 "${_WRD}"
        fi
    fi

    # Install zeromq-requirements.txt
    (set -x; pip install ${PIPOPTIONS} -r "${_WRD}/zeromq-requirements.txt")

    # Copy the default salt minion config into /etc/salt/minion
    if [ ! -f /etc/salt/minion ]; then
        (set -x; sudo cp "${_WRD}/conf/minion" /etc/salt/minion)
    fi

    echo 'On OSX, append ${local_bash} to /etc/shells (e.g. for brew bash)'
    __UNAME=$(uname -s)
    if [ "${__UNAME}" == "Darwin" ]; then
        local_bash="/usr/local/bin/bash"
        if [ -x $local_bash ]; then
            (cat /etc/shells | grep $local_bash) \
                || echo "${local_bash}" | sudo tee /etc/shells
        fi
    fi

    echo '# Check DNS for salt master (see /etc/salt/minion)'
    (set -x; nslookup salt)

    echo '# Check the minion hostname'
    echo "hostname=\"$(hostname -f)\""
    fqdn=$(set -x; python -c 'import socket; print socket.getfqdn()')
    echo "minion_id=\"${fqdn}\"   # default: socket.getfqdn()"
    echo '# Manually set the minion id in /etc/salt/minion_id'
    echo 'python -c "import socket; print socket.getfqdn()" | sudo tee /etc/salt/minion_id'
    echo ''
    echo '# minion_key'
    (set -x; sudo salt-call --local key.finger)
    # sudo salt-call --local key.finger --out txt | sed 's/^local: //g'
    # cat /etc/salt/pki/minion/minion.pub | grep -v BEGIN | grep -v END | md5sum
    echo ''
    echo '# From the minion, '
    echo '# you must manually review and accept or reject the minion key'
    echo 'salt-key -L'
    echo 'salt-key -p $minion_id'
    echo '# compare with minion_key'
    echo 'salt-key -a $minion_id'

    (set -x; sudo salt-call test.ping)
    (set -x; sudo salt-call state.highstate test=true) 

}

main() {
    bootstrap_salt_osx
}

# TODO: bash main check
main
