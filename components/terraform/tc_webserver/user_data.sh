#!/bin/sh

set -x

echo "Initiating user_data.sh" 

set_hostname() {
    sudo hostnamectl set-hostname "${machine_name}"
    sed "s|127.0.0.1.*|127.0.0.1 localhost localhost.localdomain localhost6 localhost6.localdomain6 ${machine_name}|" /etc/hosts > /tmp/hosts
    sudo mv /tmp/hosts /etc/hosts
}

start_gateway() {
    echo ">> Starting gateway"
    if [ -d "/usr/Siemens/Teamcenter13/teamcenter_root/jwt_config_tool/signer_config" ] ; then
        mkdir -p /usr/Siemens/Teamcenter13/teamcenter_root/signer_config/
        cp /usr/Siemens/Teamcenter13/teamcenter_root/jwt_config_tool/signer_config/* /usr/Siemens/Teamcenter13/teamcenter_root/signer_config/
    fi
    GW_FILE=/usr/Siemens/Teamcenter13/teamcenter_root/container/gateway.yml
    if [ -f "$GW_FILE" ] ; then
        sudo -u tc docker swarm init --default-addr-pool 11.0.0.0/8
        sleep 5
        sudo -u tc docker stack deploy -c "$GW_FILE" tc-stack
    else
        echo ">> Not starting gateway, $GW_FILE not found"
    fi
}

set_hostname
if [ "${has_gateway}" = "true" ] ; then
    start_gateway
fi

echo "user_data.sh complete!"

