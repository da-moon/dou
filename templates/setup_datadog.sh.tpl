#!/bin/bash

docker run \
  -d --name datadog-agent \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  -v /proc/:/host/proc/:ro \
  -v /cgroup/:/host/sys/fs/cgroup:ro \
  -e DD_API_KEY=${datadog_api_key} \
  -p 8125:8125/udp \
  -e DD_APM_ENABLED=true \
  -e DD_LOGS_ENABLED=true \
  -e DD_PROCESS_AGENT_ENABLED=true \
  -p 8126:8126/tcp \
  datadog/agent:latest
