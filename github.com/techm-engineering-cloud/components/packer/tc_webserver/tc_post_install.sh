#!/bin/bash

set -ex

add_dns_suffix() {
    CONTAINERS_HOME="/usr/Siemens/Teamcenter13/teamcenter_root/container"
    sudo -u tc mv "$CONTAINERS_HOME/gateway.yml" "$CONTAINERS_HOME/gateway.yml.bkp"
    sudo -u tc sed 's|/${ms_lb}:|/${ms_lb}.${dns_suffix}:|g' "$CONTAINERS_HOME/gateway.yml.bkp"  | sudo -u tc tee "$CONTAINERS_HOME/gateway.yml" > /dev/null

    CONFIG_HOME=$(find /usr/Siemens/Teamcenter13/teamcenter_root/microservices -type d -name "gateway*")
    sudo -u tc cp "$CONFIG_HOME/config.json" "$CONFIG_HOME/config.json.bkp"
    for server in ${fsc_servers} ; do
        sudo -u tc sed "s|/$server:|/$server.${dns_suffix}:|g" "$CONFIG_HOME/config.json" | sudo -u tc tee "$CONFIG_HOME/config.json.new" > /dev/null
        sudo -u tc mv "$CONFIG_HOME/config.json.new" "$CONFIG_HOME/config.json"
    done
    sudo -u tc sed "s|/${web_internal_dns}:|/${web_internal_dns}.${dns_suffix}:|g" "$CONFIG_HOME/config.json" | sudo -u tc tee "$CONFIG_HOME/config.json.new" > /dev/null
    sudo -u tc mv "$CONFIG_HOME/config.json.new" "$CONFIG_HOME/config.json"
}

if [ -f "/usr/Siemens/Teamcenter13/teamcenter_root/web/Teamcenter1/deployment/tc.war" ] ; then
    sudo -u wildfly cp /usr/Siemens/Teamcenter13/teamcenter_root/web/Teamcenter1/deployment/tc.war /opt/wildfly/standalone/deployments/
fi

#if [ "${has_gateway}" = "true" ] ; then
#    add_dns_suffix
#fi

