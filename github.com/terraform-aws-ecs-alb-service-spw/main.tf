#################
#  ECS Service  #
#################

resource "aws_ecs_task_definition" "definition" {
  family                = var.name
  container_definitions = var.container_definitions
  task_role_arn         = var.task_iam_role
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
    target_group_arn = var.alb_target_group_arn
    container_name   = var.alb_container_name
    container_port   = var.alb_container_port
  }
}

