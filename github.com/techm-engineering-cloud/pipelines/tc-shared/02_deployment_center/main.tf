
terraform {
  backend "s3" {}

  required_version = "~> 1.1.9"
}

data "aws_s3_object" "core_outputs" {
  bucket = var.artifacts_bucket_name
  key    = "stage_outputs/01_core_infra/outputs.json"
}

module "deployment_center" {
  source                = "../../../components/terraform/tc_deployment_center"
  artifacts_bucket_name = var.artifacts_bucket_name
  force_rebake          = var.force_rebake
  delete_data           = var.delete_data
  dc_user_secret_name   = "/teamcenter/shared/deployment_center/username"
  dc_pass_secret_name   = "/teamcenter/shared/deployment_center/password"
  dc_folder_to_install  = var.deployment_center.folder_to_install
  instance_type         = var.deployment_center.instance_type
  hosted_zone_id        = jsondecode(data.aws_s3_object.core_outputs.body).private_hosted_zone_id
  installation_prefix   = var.installation_prefix
  ssh_key_name          = jsondecode(data.aws_s3_object.core_outputs.body).ssh_key_name
  backup_config         = var.deployment_center.backup_config
  instance_subnets      = jsondecode(data.aws_s3_object.core_outputs.body).private_build_subnet_ids
  lb_subnets            = jsondecode(data.aws_s3_object.core_outputs.body).public_subnet_ids
  certificate_arn       = var.certificate_arn
  kms_key_id            = jsondecode(data.aws_s3_object.core_outputs.body).kms_key_id
}

