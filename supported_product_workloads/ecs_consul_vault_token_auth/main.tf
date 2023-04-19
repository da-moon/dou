module "service" {
  source                       = "../modules/generic_autoscale_ecs_service"
  service_name                 = local.service_name
  desired_services             = var.min_services_desired
  container_memory             = local.container_memory
  cluster_name                 = local.cluster_name
  ecs_task_execution_role      = data.terraform_remote_state.landing_zone.outputs.ecs_service_role
  task_iam_role_arn            = local.task_iam_role
  container_image              = var.container_image
  container_port               = local.container_port
  container_version            = var.container_version
  container_memory_reservation = floor(local.container_memory * 0.90)
  minimum_healthy_percent      = var.min_healthy_percent
  vault_host                   = data.terraform_remote_state.landing_zone.outputs.vault_aws_elb_public_dns
  consul_host                  = data.terraform_remote_state.landing_zone.outputs.consul_aws_elb_public_dns
  vault_token                  = local.vault_token
  consul_token                 = local.consul_token
  keys_dir                     = local.keys_dir


  # ALB config
  lb_target_group_port              = local.lb_port
  target_group_protocol             = "HTTP"
  health_check_healthy_threshold    = local.health_check_healthy_threshold
  health_check_unhealthy_threshold  = local.health_check_unhealthy_threshold
  health_check_timeout              = local.health_check_timeout
  health_check_protocol             = "HTTP"
  health_check_path                 = local.health_check_path
  health_check_interval             = local.health_check_interval
  health_check_grace_period_seconds = local.health_check_grace_period_seconds
  lb_listener_port                  = local.lb_port
  lb_drain_duration                 = var.drain_duration
  lb_idle_timeout                   = var.idle_timeout
  project_name                      = data.terraform_remote_state.landing_zone.outputs.project_name
  lb_security_groups                = data.terraform_remote_state.landing_zone.outputs.caas_security_groups
  lb_subnet_ids                     = data.terraform_remote_state.landing_zone.outputs.public_subnet_id
  run_env                           = var.run_env
  vpc_id                            = data.terraform_remote_state.landing_zone.outputs.vpc_id
  hosted_zone_id                    = data.terraform_remote_state.landing_zone.outputs.hosted_zone_id
  aws_region                        = var.aws_region
  security_groups                   = data.terraform_remote_state.landing_zone.outputs.caas_security_groups
  subnets                           = join(",", data.terraform_remote_state.landing_zone.outputs.public_subnet_id)
}
