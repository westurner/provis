#!/bin/bash -e -x

# Configure salt.renderers.gpg
# See:
# https://docs.saltstack.com/en/latest/ref/renderers/all/salt.renderers.gpg.html

GPG_HOMEDIR="/etc/salt/gpgkeys"
DEFAULT_KEY_NAME="provis-salt"
DEFAULT_KEY_PATH="exported_pubkey.gpg"

install_python_gnupg() {
    pip install -v python-gnupg
}

generate_keypair() {
    sudo gpg --gen-key --homedir "${GPG_HOMEDIR}"
}

get_public_key() {
    KEY_NAME=${1:-${DEFAULT_KEY_NAME}}
    KEY_PATH=${2:-${DEFAULT_KEY_PATH}}
    sudo gpg --armor --homedir "${GPG_HOMEDIR}" --export "${KEY_NAME}" > "${KEY_PATH}"
}

gpg_import_key() {
    KEY_PATH=${2:-${DEFAULT_KEY_PATH}}
    gpg --import "${KEY_PATH}"
}

gpgcrypt() {
    KEY_NAME=${1:-${DEFAULT_KEY_NAME}}
    _GPG_HOMEDIR="~/.gnupg"
    cat - | gpg --homedir "${_GPG_HOMEDIR}" --armor --encrypt -r "${KEY_NAME}"
}

setup_master() {
    _KEY_NAME=${1:-${DEFAULT_KEY_NAME}}
    _KEY_PATH=${2:-${DEFAULT_KEY_PATH}}
    install_python_gnupg
    generate_keypair
    get_public_key "${_KEY_NAME}" "${_KEY_PATH}"
}

setup_local() {
    _KEY_NAME=${1:-${DEFAULT_KEY_NAME}}
    _KEY_PATH=${2:-${DEFAULT_KEY_PATH}}
    install_python_gnupg
    gpg_import_key "${KEY_PATH}"
    echo "test" | gpgcrypt "${KEY_NAME}"
}

main() {
    case $1 in
        'master')
            setup_master ;;
        'local')
            setup_local ;;
        'encode')
            gpgcrypt ;;
        *)
            echo "master|local|encode" ;;
    esac
}

main $@
