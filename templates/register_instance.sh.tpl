#!/bin/bash

echo ECS_CLUSTER=${name} >> /etc/ecs/ecs.config
echo ECS_RESERVED_MEMORY=256 >> /etc/ecs/ecs.config
