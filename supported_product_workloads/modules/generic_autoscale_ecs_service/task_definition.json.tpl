[
  {
    "name": "${service_name}",
    "image": "${container_image}",
    "memory": ${container_memory},
    "memoryReservation": ${container_memory_reservation},
    "privileged": false,
    "portMappings": [
      {
        "containerPort": ${container_port},
        "hostPort": ${container_port},
        "protocol": "tcp"
      }
    ],
    "essential": true,
    "environment": [
      { "name": "VAULT_TOKEN", "value": "${vault_token}" },
      { "name": "CONSUL_TOKEN", "value": "${consul_token}" },
      { "name": "KEYS_DIR", "value": "${keys_dir}" },
      { "name": "VAULT_DEV_LISTEN_ADDRESS", "value": "${vault_host}" },
      { "name": "CONSUL_DEV_LISTEN_ADDRESS", "value": "${consul_host}" }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
          "awslogs-group": "${project_name}-ecs-logs",
          "awslogs-region": "${aws_region}",
          "awslogs-stream-prefix": "caas-ecs"
      }
  }
  }
]
