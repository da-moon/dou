module "service" {
  source                            = "../autoscaled_lb_service"
  name                              = var.service_name
  container_definitions             = data.template_file.task_definition.rendered
  cluster_id                        = var.cluster_name
  desired_count                     = var.desired_services
  lb_target_group_arn               = module.lb.target_group_arn
  lb_container_name                 = data.template_file.task_definition.vars.service_name
  lb_container_port                 = var.container_port
  ecs_task_execution_role           = var.ecs_task_execution_role
  task_iam_role                     = var.task_iam_role_arn
  minimum_healthy_percent           = var.minimum_healthy_percent
  health_check_grace_period_seconds = var.health_check_grace_period_seconds
  service_subnets                   = var.lb_subnet_ids
  service_security_group            = var.lb_security_groups
}

module "lb" {
  source                           = "../lb_with_single_target_group"
  service_name                     = var.service_name
  security_groups                  = var.lb_security_groups
  subnets                          = var.lb_subnet_ids
  run_env                          = var.run_env
  lb_target_group_port             = var.lb_target_group_port
  target_group_protocol            = var.target_group_protocol
  vpc_id                           = var.vpc_id
  target_group_drain_duration      = var.lb_drain_duration
  health_check_healthy_threshold   = var.health_check_healthy_threshold
  health_check_unhealthy_threshold = var.health_check_unhealthy_threshold
  health_check_timeout             = var.health_check_timeout
  health_check_protocol            = var.health_check_protocol
  health_check_path                = var.health_check_path
  health_check_interval            = var.health_check_interval
  health_check_matcher             = var.health_check_matcher
  lb_listener_port                 = var.lb_listener_port
  lb_idle_timeout                  = var.lb_idle_timeout
  hosted_zone_id                   = var.hosted_zone_id
  optional_subdomain               = element(split("-", var.cluster_name), 1)
  project_name                     = var.project_name
}

data "template_file" "task_definition" {
  template = file("${path.module}/task_definition.json.tpl")

  vars = {
    container_image              = "${var.container_image}:${var.container_version}"
    container_memory             = var.container_memory
    container_memory_reservation = var.container_memory_reservation
    container_port               = var.container_port
    aws_region                   = var.aws_region
    consul_host                  = var.consul_host
    service_name                 = "${var.run_env}-${var.service_name}"
    vault_host                   = var.vault_host
    run_env                      = var.run_env
    vault_token                  = var.vault_token
    consul_token                 = var.consul_token
    security_groups              = var.security_groups
    subnets                      = var.subnets
    keys_dir                     = var.keys_dir
    project_name                 = var.project_name
  }
}
