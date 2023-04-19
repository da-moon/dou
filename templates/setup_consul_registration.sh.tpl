#!/bin/bash

# CREATE CONSUL DATA AND CONFIG DIRECTORIES
mkdir -p /consul/data /consul/config

# SET UP DOCKER DNS CONFIGURATION
echo "OPTIONS='--dns 172.17.42.1 --dns ${dns_ip} --dns-search service.consul'" > /etc/sysconfig/docker

# CREATE CONSUL AGENT CONFIGURATION
echo "{ 'leave_on_terminate': true, 'recursors': ['${dns_ip}'] }" > /consul/config/consul.json

# RESTART DOCKER AND ECS-AGENT
docker ps
/sbin/service docker restart
/bin/sleep 5
[[ $(/sbin/status ecs) =~ \"running\" ]] || /sbin/start ecs

# PULL CONSUL CONTAINER
docker pull consul:v0.7.1

# PULL REGISTRATOR CONTAINER
docker pull gliderlabs/registrator

METADATA_INSTANCE_ID=`curl http://169.254.169.254/2014-02-25/meta-data/instance-id`

# START CONSUL CONTAINER
docker run -d --restart always --net=host --name=consul-agent consul:${consul_agent_version} agent \
-bind=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4) \
-datacenter=${datacenter} \
-encrypt=${consul_client_key} \
-retry-join="provider=aws tag_key=consul_cluster tag_value=${run_env}" \
-node=$METADATA_INSTANCE_ID \

# START REGISTRATOR CONTAINER
docker run -d --restart=always -v /var/run/docker.sock:/tmp/docker.sock \
  -h $METADATA_INSTANCE_ID \
  --net=host --name registrator gliderlabs/registrator:latest \
  consul://localhost:8500
