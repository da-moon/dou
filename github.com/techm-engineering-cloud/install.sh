#!/bin/bash

#-----------------------------------------------------------------------------------------------------
# Initial installation of Engineering in Cloud.
# This script runs the terraform scripts of the bootstrap pipeline. After the initial run is
# successful, this script doesn't need to be run again.
#-----------------------------------------------------------------------------------------------------

OWN_DIR="$(
  cd "$(dirname "$0")" >/dev/null 2>&1 || exit 1
  pwd -P
)"

VARS_FILE="${OWN_DIR}/environments/bootstrap.tfvars"

check_prerequisites() {
    if [ ! -f "${VARS_FILE}" ] ; then
        echo "Variables file ${VARS_FILE} not found." && exit 1
    fi

    if ! terraform -version > /dev/null 2>&1 ; then
        echo "Dependency \"terraform\" version 1.1.x is needed but none was found. Please install it depending on your OS." && exit 1
    fi

    if ! terraform -version | grep '1.1' > /dev/null 2>&1 ; then
        echo "Dependency \"terraform\" version 1.1.x is needed but another version was found. Please install version 1.1.9." && exit 1
    fi

    if ! pip3 > /dev/null 2>&1 && ! pip > /dev/null 2>&1 ; then
        echo "Dependency \"pip3\" or \"pip\" for python 3 is needed but was not found. Please install it depending on your OS." && exit 1
    fi

    if ! git version > /dev/null 2>&1 ; then
        echo "Dependency \"git\" is needed but was not found. Please install it depending on your OS." && exit 1
    fi

    if pip3 > /dev/null 2>&1 ; then
        if ! pip3 --disable-pip-version-check list | grep "git-remote-codecommit" > /dev/null 2>&1 ; then
            pip3 install git-remote-codecommit
        fi
    elif pip > /dev/null 2>&1 ; then
        if ! pip --disable-pip-version-check list | grep "git-remote-codecommit" > /dev/null 2>&1 ; then
            pip install git-remote-codecommit
        fi
    fi
}

install() {
    cd "$OWN_DIR/pipelines/eng-cloud-bootstrap"
    ./run.sh
}

check_prerequisites
install

