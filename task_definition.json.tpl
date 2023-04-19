[
  {
    "name": "${service_name}",
    "image": "${container_image}",
    "memory": ${container_memory},
    "memoryReservation": ${container_memory_reservation},
    "privileged": true,
    "portMappings": [
      {
        "containerPort": ${container_port},
        "hostPort": 0,
        "protocol": "tcp"
      }
    ],
    "essential": true,
    "environment": [
      { "name": "DOGSTATSD_PORT_8125_UDP_ADDR", "value": "172.17.0.1" },
      { "name": "CONSUL_HOST", "value": "${consul_host}" },
      { "name": "LOGSTASH_ADDRESS", "value": "${logstash_address}" },
      { "name": "LOGSTASH_TCP_PORT", "value": "${logstash_tcp_port}" },
      { "name": "LOGSTASH_UDP_PORT", "value": "${logstash_udp_port}" },
      { "name": "LOGSTASH_GELF_UDP_PORT", "value": "${logstash_gelf_udp_port}" },
      { "name": "SPRING_MAIN_BANNER-MODE", "value": "off" }
    ],
    "logConfiguration": {
      "logDriver": "gelf",
      "options": {
        "gelf-address": "udp://${logstash_address}:${logstash_gelf_udp_port}",
        "tag": "${service_name}",
        "labels": "${gelf_labels}"
      }
    }
  }
]
