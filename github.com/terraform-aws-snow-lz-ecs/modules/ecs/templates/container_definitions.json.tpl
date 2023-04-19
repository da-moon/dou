[
  {
    "essential": true,
    "name": "${name}",
    "image": "${image}",
    "memory": ${memory},
    "cpu": ${cpu},
    "networkMode": "awsvpc",
    "executionRoleArn": "${execution_role_arn}",
    "portMappings": [
      {
        "containerPort": ${app_port},
        "hostPort": ${app_port},
        "protocol": "tcp"
      }
    ]
  }
]
