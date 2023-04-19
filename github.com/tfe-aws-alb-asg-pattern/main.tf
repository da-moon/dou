module "datasource-module" {
  source             = "terraform-cldsvc-prod.corp.internal.companyA.com/cfg-cloud-services/datasource-helper-module/aws"
  version            = "1.0.5"
  tfe_vpc_workspace  = var.tfe_vpc_workspace
  os                 = var.os
  subnet_name        = var.subnet_name
  account_name       = var.account_name
  ingress            = var.ingress
  app_subnet_count   = var.app_subnet_count
  web_subnet_count   = var.web_subnet_count
  fsx_sg_name_search = var.fsx_sg_name_search
  ec2_sg_name_search = var.ec2_sg_name_search
  alb_sg_name_search = var.alb_sg_name_search
  fsx_kms_key_alias  = var.fsx_kms_key_alias
  ebs_kms_key_alias  = var.ebs_kms_key_alias
  ami_name_tag       = var.ami_name_tag
  keypair_name       = var.keypair_name
}

module "label-module-alb" {
  source  = "terraform-cldsvc-prod.corp.internal.companyA.com/cfg-cloud-services/label-module/cfg"
  version = "2.1.8"

  name            = "${var.name}-${var.mandatory_tags.ApplicationID}-${data.aws_region.current.name}-alb"
  environment     = var.environment
  mandatory_tags  = var.mandatory_tags
  attributes      = var.attributes
  additional_tags = var.additional_tags
}

module "label-module-tg" {
  source  = "terraform-cldsvc-prod.corp.internal.companyA.com/cfg-cloud-services/label-module/cfg"
  version = "2.1.8"

  name            = "${var.name}-${var.mandatory_tags.ApplicationID}-${data.aws_region.current.name}-tg"
  environment     = var.environment
  mandatory_tags  = var.mandatory_tags
  attributes      = var.attributes
  additional_tags = var.additional_tags
}

module "label-module-asg" {
  source  = "terraform-cldsvc-prod.corp.internal.companyA.com/cfg-cloud-services/label-module/cfg"
  version = "2.1.8"

  name            = "${var.name}-${var.mandatory_tags.ApplicationID}-${data.aws_region.current.name}-${var.subnet_name}"
  environment     = var.environment
  mandatory_tags  = var.mandatory_tags
  attributes      = var.attributes
  additional_tags = var.additional_tags
}

module "label-module-fsx" {
  source  = "terraform-cldsvc-prod.corp.internal.companyA.com/cfg-cloud-services/label-module/cfg"
  version = "2.1.8"

  name            = "${var.name}-${var.mandatory_tags.ApplicationID}-${data.aws_region.current.name}-fsx"
  environment     = var.environment
  mandatory_tags  = var.mandatory_tags
  attributes      = var.attributes
  additional_tags = var.additional_tags
}

module "alb-module" {
  source                      = "terraform-cldsvc-prod.corp.internal.companyA.com/cfg-cloud-services/alb-module/aws"
  version                     = "2.0.11"
  create_lb                   = var.create_lb
  drop_invalid_header_fields  = var.drop_invalid_header_fields
  enable_deletion_protection  = var.enable_deletion_protection
  enable_http2                = var.enable_http2
  extra_ssl_certs             = var.extra_ssl_certs
  http_tcp_listeners          = var.http_tcp_listeners
  https_listener_rules        = var.https_listener_rules
  https_listeners             = var.https_listeners
  idle_timeout                = var.idle_timeout
  internal                    = var.internal
  ip_address_type             = var.ip_address_type
  listener_ssl_policy_default = var.listener_ssl_policy_default
  load_balancer_type          = "application"
  name                        = module.label-module-alb.name
  security_groups             = module.datasource-module.data.alb_security_groups
  subnets                     = slice(module.datasource-module.data.athena_subnet_ids, 0, var.lb_subnet_count)
  target_groups               = local.target_groups_revised
  tags                        = merge(module.label-module-alb.tags, { "created_by_pattern" = "tfe-aws-alb-asg-pattern", "pattern_version" = local.pattern_version })
  vpc_id                      = module.datasource-module.data.vpc_id
}

module "autoscaling-module" {
  source  = "terraform-cldsvc-prod.corp.internal.companyA.com/cfg-cloud-services/autoscaling-module/aws"
  version = "2.0.11"

  associate_public_ip_address = var.associate_public_ip_address
  block_device_mappings       = local.block_device_mappings_revised
  capacity_rebalance          = var.capacity_rebalance
  create_asg                  = var.create_asg
  create_lt                   = var.create_lt
  credit_specification        = var.credit_specification
  desired_capacity            = var.desired_capacity
  disable_api_termination     = var.disable_api_termination
  ebs_optimized               = var.ebs_optimized
  health_check_type           = var.health_check_type
  iam_instance_profile        = var.iam_instance_profile
  image_id                    = module.datasource-module.data.ami_id
  instance_type               = var.instance_type
  key_name                    = data.aws_region.current.name == "us-east-2" ? module.datasource-module.data.key_name_use2 : module.datasource-module.data.key_name_use1
  launch_template_version     = var.launch_template_version
  max_size                    = var.max_size
  min_elb_capacity            = var.min_elb_capacity
  min_size                    = var.min_size
  mixed_instances_policy      = var.mixed_instances_policy
  name                        = module.label-module-asg.name
  placement                   = var.placement
  root_block_device           = var.root_block_device
  security_groups             = module.datasource-module.data.ec2_security_groups
  tags_as_map                 = merge(module.label-module-asg.tags, { "created_by_pattern" = "tfe-aws-alb-asg-pattern", "pattern_version" = local.pattern_version })
  target_group_arns           = module.alb-module.target_group_arns
  user_data_base64            = base64encode(data.template_file.init.rendered)
  vpc_zone_identifier         = slice(module.datasource-module.data.athena_subnet_ids, 0, var.asg_subnet_count)
}

## FSx Module reference
module "fsx" {
  source                                 = "terraform-cldsvc-prod.corp.internal.companyA.com/cfg-cloud-services/fsx-module/aws"
  version                                = "0.2.7"
  count                                  = var.create_fsx ? 1 : 0
  automatic_backup_retention_days        = var.automatic_backup_retention_days
  deployment_type                        = var.deployment_type
  dns_ips                                = var.dns_ips
  domain_name                            = var.domain_name
  file_system_administrators_group       = var.file_system_administrators_group
  kms_key_id                             = module.datasource-module.data.fsx_kms.arn_alias
  organizational_unit_distinguished_name = var.organizational_unit_distinguished_name
  password                               = var.password
  preferred_subnet_id                    = module.datasource-module.data.athena_subnet_ids[0]
  storage_type                           = var.storage_type
  security_group_ids                     = module.datasource-module.data.fsx_security_groups
  storage_capacity                       = var.storage_capacity
  subnet_ids                             = slice(module.datasource-module.data.athena_subnet_ids, 0, var.fsx_subnet_count)
  throughput_capacity                    = var.throughput_capacity
  tags                                   = merge(module.label-module-fsx.tags, { "created_by_pattern" = "tfe-aws-alb-asg-pattern", "pattern_version" = local.pattern_version })
  username                               = var.username
}
