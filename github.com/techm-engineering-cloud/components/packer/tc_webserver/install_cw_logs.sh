#!/bin/sh

set -ex

setup_web_logs() {
    sudo mv /tmp/jboss_logs.json /opt/aws/amazon-cloudwatch-agent/etc/jboss_logs.json
    sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a append-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/etc/jboss_logs.json
}

setup_web_logs

sudo systemctl stop amazon-cloudwatch-agent.service
sudo systemctl start amazon-cloudwatch-agent.service

