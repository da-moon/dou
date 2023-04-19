#!/bin/bash

# CREATE CONSUL DATA AND CONFIG DIRECTORIES
mkdir -p /consul/data /consul/config

# CREATE CONSUL AGENT CONFIGURATION
echo "{ 'leave_on_terminate': true, 'recursors': ['${dns_ip}'] }" > /consul/config/consul.json

# RESTART DOCKER AND ECS-AGENT
docker ps
/sbin/service docker restart
/bin/sleep 5
[[ $(/sbin/status ecs) =~ \"running\" ]] || /sbin/start ecs

# PULL CONSUL CONTAINER
docker pull consul:${consul_agent_version}

# PULL REGISTRATOR CONTAINER
docker pull gliderlabs/registrator

METADATA_INSTANCE_ID=`curl http://169.254.169.254/2014-02-25/meta-data/instance-id`

# START CONSUL CONTAINER
docker run -d --restart always --name=consul-agent \
-l com.datadoghq.ad.check_names='["consul"]' \
-l com.datadoghq.ad.instances="[{\"url\": \"http://$(curl http://169.254.169.254/2014-02-25/meta-data/local-ipv4):8500\"}]" \
-l com.datadoghq.ad.init_configs='[{}]' -l com.datadoghq.ad.logs='[{}]' \
-p 8500:8500/tcp \
consul:${consul_agent_version} agent \
-client=0.0.0.0 \
-datacenter=${datacenter} \
-encrypt=${consul_client_key} \
-retry-join="provider=aws tag_key=consul_cluster tag_value=${run_env}" \
-node=$METADATA_INSTANCE_ID

# START REGISTRATOR CONTAINER
docker run -d --restart=always -v /var/run/docker.sock:/tmp/docker.sock \
  -h $METADATA_INSTANCE_ID \
  --net=host --name registrator gliderlabs/registrator:latest \
  consul://localhost:8500
