resource "aws_ecs_service" "service" {
  name                               = var.name
  cluster                            = var.cluster_id
  task_definition                    = "${aws_ecs_task_definition.definition.family}:${aws_ecs_task_definition.definition.revision}"
  desired_count                      = var.desired_count
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 300
}

resource "aws_ecs_task_definition" "definition" {
  family                = var.name
  container_definitions = var.container_definitions
  task_role_arn         = var.task_iam_role
}

