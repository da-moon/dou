terraform {
  backend "s3" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = "~> 1.1.9"
}

provider "aws" {
  region = var.region
}

data "aws_ssm_parameter" "aw_gateway_dns" { name = "/teamcenter/${var.env_name}/aw_gateway/dns" }
data "aws_ssm_parameter" "aw_gateway_machine" { name = "/teamcenter/${var.env_name}/aw_gateway/hostname" }
data "aws_ssm_parameter" "aw_gateway_port" { name = "/teamcenter/${var.env_name}/aw_gateway/port" }
data "aws_ssm_parameter" "db_server" { name = "/teamcenter/${var.env_name}/db/hostname" }
data "aws_ssm_parameter" "fsc_machines" { name = "/teamcenter/${var.env_name}/enterprise_tier/fsc/all" }
data "aws_ssm_parameter" "indexing_hostname" { name = "/teamcenter/${var.env_name}/indexing_engine/hostname" }
data "aws_ssm_parameter" "indexing_dns" { name = "/teamcenter/${var.env_name}/indexing_engine/dns" }
data "aws_ssm_parameter" "license_server" { name = "/teamcenter/${var.env_name}/license_server/hostname" }
data "aws_ssm_parameter" "ms_port" { name = "/teamcenter/${var.env_name}/microservices/master/port" }
data "aws_ssm_parameter" "ms_hostname" { name = "/teamcenter/${var.env_name}/microservices/master/hostname" }
data "aws_ssm_parameter" "ms_orchestration" { name = "/teamcenter/${var.env_name}/microservices/master/container_orchestration" }
data "aws_ssm_parameter" "svr_mgr" { name = "/teamcenter/${var.env_name}/enterprise_tier/server_manager/all" }
data "aws_ssm_parameter" "web_url" { name = "/teamcenter/${var.env_name}/web_tier/url" }
data "aws_ssm_parameter" "web_dns" { name = "/teamcenter/${var.env_name}/web_tier/dns" }
data "aws_ssm_parameter" "web_machine" { name = "/teamcenter/${var.env_name}/web_tier/hostname" }
data "aws_ssm_parameter" "web_port" { name = "/teamcenter/${var.env_name}/web_tier/port" }
data "aws_ssm_parameter" "web_protocol" { name = "/teamcenter/${var.env_name}/web_tier/protocol" }

data "aws_s3_object" "core_outputs" {
  bucket = var.artifacts_bucket_name
  key    = "stage_outputs/01_core_infra/outputs.json"
}

resource "aws_sns_topic" "alarms_env" {
  name = var.installation_prefix != "" ? "${var.installation_prefix}-tc-${var.env_name}-alarms" : "tc-${var.env_name}-alarms"
}

resource "aws_s3_object" "core_env_outputs" {
  bucket       = var.artifacts_bucket_name
  key          = "stage_outputs/02_core_env/${var.env_name}/outputs.json"
  content_type = "application/json"
  content = jsonencode({
    private_env_subnet_ids    = [aws_subnet.env_subnet_1.id, aws_subnet.env_subnet_2.id]
    db_identifier             = aws_db_instance.base_rds.identifier
    db_admin_user_secret_name = aws_secretsmanager_secret.db_user.name
    db_admin_pass_secret_name = aws_secretsmanager_secret.db_pass.name
    db_sm_user_secret_name    = aws_secretsmanager_secret.db_sm_user.name
    db_sm_pass_secret_name    = aws_secretsmanager_secret.db_sm_pass.name
    ms_keystore_secret_name   = aws_secretsmanager_secret.ms_keystore_pass.name

    #common instance profile id for all servers
    instance_profile_id = aws_iam_instance_profile.tc_instance_profile.id

    #Solrindexing
    sl_lb_target_group_arns = aws_lb_target_group.solr_indexing_lb_tg.arn
    sl_security_group_id    = aws_security_group.solr_indexing.id

    infodba_user_secret_name = aws_secretsmanager_secret.infodba_user.name
    infodba_pass_secret_name = aws_secretsmanager_secret.infodba_pass.name

    ## webserver
    wb_lb_target_group_arns = aws_lb_target_group.webserver_lb_tg.arn
    wb_security_group_id    = aws_security_group.webserver.id
    wb_public_dns           = aws_lb.webserver_lb_main.dns_name

    ## enterprise
    enterprise_security_group_id = aws_security_group.enterprise.id
    tc_efs_id                    = module.tc_efs.efs_id

    awg_target_group = !local.is_web_aw_same_dns && data.aws_ssm_parameter.ms_orchestration.value == "Docker Swarm" ?  aws_lb_target_group.awg[0].arn : aws_lb_target_group.webserver_lb_tg.arn
    awg_security_group_id = local.is_web_aw_same_dns ? aws_security_group.webserver_lb.id : aws_security_group.awg[0].id

    sns_env_arn       = aws_sns_topic.alarms_env.arn
    core_env_role_arn = aws_iam_role.tc_server_role.arn
  })
}

resource aws_ssm_parameter "rds_dns" {
  name           = "/teamcenter/${var.env_name}/db/rds_dns"
  type           = "String"
  insecure_value = aws_db_instance.base_rds.address
}

module "cloudwatch" {
  source              = "../../../../components/terraform/cloudwatch"
  dashboard_name      = var.installation_prefix != "" ? "${var.installation_prefix}-tc-${var.env_name}-dashboard" : "tc-${var.env_name}-dashboard"
  region              = var.region
  env_name            = var.env_name
  sns_arn             = aws_sns_topic.alarms_env.arn
  installation_prefix = var.installation_prefix
  web_hostname        = nonsensitive(data.aws_ssm_parameter.web_dns.value)
  fsc_servers         = split(",", nonsensitive(data.aws_ssm_parameter.fsc_machines.value))
  poolmgr_servers     = split(",", nonsensitive(data.aws_ssm_parameter.svr_mgr.value))
  license_server      = nonsensitive(data.aws_ssm_parameter.license_server.value)
  db_server           = nonsensitive(data.aws_ssm_parameter.db_server.value)
  awg_server          = nonsensitive(data.aws_ssm_parameter.aw_gateway_dns.value)
  ms_server           = nonsensitive(data.aws_ssm_parameter.ms_hostname.value)
  indexing_server     = nonsensitive(data.aws_ssm_parameter.indexing_dns.value)
}

