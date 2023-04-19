#!/bin/bash

sudo sysctl -w net.core.somaxconn=${so_max_conn}
sudo echo 'net.core.somaxconn = ${so_max_conn}' | sudo tee -a /etc/sysctl.conf

cat <<EOF >> /etc/ecs/ecs.config
ECS_CLUSTER=${name}
ECS_RESERVED_MEMORY=256
ECS_AVAILABLE_LOGGING_DRIVERS=[\"gelf\",\"syslog\",\"awslogs\"]
ECS_ENGINE_AUTH_TYPE=${ecs_engine_auth_type}
ECS_ENGINE_AUTH_DATA=${ecs_engine_auth_data}
EOF

stop ecs
start ecs
