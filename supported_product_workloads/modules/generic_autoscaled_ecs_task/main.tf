module "service" {
  source                  = "../autoscaled_lb_service"
  name                    = var.service_name
  container_definitions   = data.template_file.task_definition.rendered
  cluster_id              = var.cluster_name
  desired_count           = var.desired_services
  lb_target_group_arn     = var.lb_target_group_arn
  lb_container_name       = var.service_name
  lb_container_port       = var.container_port
  ecs_task_execution_role = var.ecs_task_execution_role
  task_iam_role           = var.task_iam_role_arn
  minimum_healthy_percent = var.minimum_healthy_percent
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
    vault_host                   = var.vault_host
    vault_token                  = vault_token
    consul_token                 = consul_token
    service_name                 = var.service_name
    security_groups              = var.security_groups
    subnets                      = var.subnets
    keys_dir                     = var.keys_dir
    project_name                 = var.project_name
  }
}
