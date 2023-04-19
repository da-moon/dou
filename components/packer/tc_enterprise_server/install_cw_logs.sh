#!/bin/sh

set -ex

setup_fsc_logs() {
    sudo mv /tmp/fsc_logs.json /opt/aws/amazon-cloudwatch-agent/etc/fsc_logs.json
    sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a append-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/etc/fsc_logs.json
}

setup_poolmgr_logs() {
    sudo mv /tmp/poolmgr_logs.json /opt/aws/amazon-cloudwatch-agent/etc/poolmgr_logs.json
    sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a append-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/etc/poolmgr_logs.json
}

if [ "${install_fsc}" = "true" ] ; then
    setup_fsc_logs
fi

if [ "${install_poolmgr}" = "true" ] ; then
    setup_poolmgr_logs
fi

sudo systemctl stop amazon-cloudwatch-agent.service
sudo systemctl start amazon-cloudwatch-agent.service

