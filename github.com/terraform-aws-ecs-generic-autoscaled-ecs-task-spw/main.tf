module "service" {
  source                  = "git::https://bitbucket.org/corvesta/devops.infra.modules.git//common/ecs/autoscaled_alb_service?ref=1.0.14"
  name                    = var.service_name
  container_definitions   = data.template_file.task_definition.rendered
  cluster_id              = var.cluster_name
  desired_count           = var.desired_services
  alb_target_group_arn    = var.alb_target_group_arn
  alb_container_name      = var.service_name
  alb_container_port      = var.container_port
  service_iam_role        = var.service_iam_role
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
    aws_region                   = "us-east-1"
    consul_host                  = var.consul_host
    service_name                 = var.service_name
    gelf_labels                  = var.gelf_labels
    logstash_address             = var.logstash_address
    logstash_tcp_port            = var.logstash_tcp_port
    logstash_udp_port            = var.logstash_udp_port
    logstash_gelf_udp_port       = var.logstash_gelf_udp_port
  }
}
