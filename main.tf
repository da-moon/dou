# Use this for ECS services that are autoscaled by cloudwatch alarms, this way new terraform pushes do not
# reset the desired count of services. This will disable the ability for engineers to manually scale their
# containers.

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
  deployment_minimum_healthy_percent = var.minimum_healthy_percent
  deployment_maximum_percent         = 200
  health_check_grace_period_seconds  = var.health_check_grace_period_seconds

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = var.alb_container_name
    container_port   = var.alb_container_port
  }

  ## Only 1 service can be deployed per ECS host
  placement_constraints {
    type = "distinctInstance"
  }

  lifecycle {
    ignore_changes = [desired_count]
  }
}

