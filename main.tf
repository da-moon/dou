resource "aws_ecs_service" "service" {
  name                               = var.service_name
  task_definition                    = aws_ecs_task_definition.task_definition.arn
  desired_count                      = var.desired_count
  cluster                            = var.cluster_arn
  iam_role                           = var.service_iam_role
  deployment_maximum_percent         = 300
  deployment_minimum_healthy_percent = 100

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = var.service_name
    container_port   = var.container_port
  }

  lifecycle {
    ignore_changes = [desired_count]
  }
}

data "template_file" "task_definition" {
  template = file("${path.module}/task_definition.json.tpl")

  vars = {
    container_image              = "${var.container_image}:${var.container_version}"
    container_memory             = var.container_memory
    container_memory_reservation = var.container_memory_reservation
    container_port               = var.container_port
    aws_region                   = "us-east-1"
    consul_host                  = var.consul_host
    logging_host                 = var.logging_host
    service_name                 = var.service_name
    gelf_address                 = var.gelf_address
    gelf_port                    = var.gelf_port
    gelf_labels                  = var.gelf_labels
    logstash_address             = var.logstash_address
    logstash_tcp_port            = var.logstash_tcp_port
    logstash_udp_port            = var.logstash_udp_port
    logstash_gelf_udp_port       = var.gelf_port
    container_user               = var.container_user
  }
}

resource "aws_ecs_task_definition" "task_definition" {
  family                = var.task_definition_name
  container_definitions = data.template_file.task_definition.rendered
  task_role_arn         = var.task_role_arn
}

