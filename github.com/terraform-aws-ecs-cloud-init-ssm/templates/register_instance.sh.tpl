#!/bin/bash

### Configure ECS Agent Options
echo "ECS_CLUSTER=${cluster_name}" >> /etc/ecs/ecs.config
echo "ECS_AVAILABLE_LOGGING_DRIVERS=[\"gelf\",\"syslog\",\"awslogs\"]" >> /etc/ecs/ecs.config