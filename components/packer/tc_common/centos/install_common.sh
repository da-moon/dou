#!/bin/sh

#-----------------------------------------------------------------------------------------------------------
# Common setup for all Teamcenter servers in CentOS.
#-----------------------------------------------------------------------------------------------------------

set_hostname() {
    sudo hostnamectl set-hostname ${MACHINE_NAME}
    sed "s|127.0.0.1.*|127.0.0.1 localhost localhost.localdomain localhost6 localhost6.localdomain6 ${MACHINE_NAME}|" /etc/hosts > /tmp/hosts
    sudo mv /tmp/hosts /etc/hosts
}

if [ "${MACHINE_NAME}" != "" ] ; then
    set_hostname
fi

