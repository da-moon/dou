# Use this for ECS services that are autoscaled by cloudwatch alarms, this way new terraform pushes do not
# reset the desired count of services. This will disable the ability for engineers to manually scale their
# containers.

resource "aws_ecs_task_definition" "definition" {
  family                   = var.lb_container_name
  requires_compatibilities = ["FARGATE"]
  container_definitions    = var.container_definitions
  task_role_arn            = var.task_iam_role
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = var.ecs_task_execution_role
  network_mode             = "awsvpc"
}



# ########################
# #     ECS SERVICE      #
# ########################

resource "aws_ecs_service" "service" {
  name                               = var.name
  cluster                            = var.cluster_id
  task_definition                    = "${aws_ecs_task_definition.definition.family}:${aws_ecs_task_definition.definition.revision}"
  desired_count                      = var.desired_count
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"
  deployment_minimum_healthy_percent = var.minimum_healthy_percent
  deployment_maximum_percent         = 300
  health_check_grace_period_seconds  = var.health_check_grace_period_seconds

  network_configuration {
    security_groups  = [var.service_security_group]
    subnets          = var.service_subnets
    assign_public_ip = "true"
  }

  load_balancer {
    target_group_arn = var.lb_target_group_arn
    container_name   = var.lb_container_name
    container_port   = var.lb_container_port
  }
  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }
}
