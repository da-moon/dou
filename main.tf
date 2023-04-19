resource "aws_ecs_task_definition" "definition" {
  family                = var.name
  container_definitions = var.container_definitions
  task_role_arn         = var.task_iam_role
  network_mode          = "host"
}

resource "aws_ecs_service" "service" {
  name                               = var.name
  cluster                            = var.cluster_id
  task_definition                    = "${aws_ecs_task_definition.definition.family}:${aws_ecs_task_definition.definition.revision}"
  desired_count                      = var.desired_count
  iam_role                           = var.service_iam_role
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 300

  load_balancer {
    elb_name       = var.elb_name
    container_name = var.container_name
    container_port = var.container_port
  }
}

