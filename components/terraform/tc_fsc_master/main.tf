
data "aws_s3_object" "core_outputs" {
  bucket = var.artifacts_bucket_name
  key    = "stage_outputs/01_core_infra/outputs.json"
}

data "aws_s3_object" "core_env_outputs" {
  bucket = var.artifacts_bucket_name
  key    = "stage_outputs/02_core_env/${var.env_name}/outputs.json"
}

data "aws_ssm_parameter" "fsc_master_hostname" { name = "/teamcenter/${var.env_name}/enterprise_tier/fsc/master/hostname" }
data "aws_ssm_parameter" "svr_mgr_all" { name = "/teamcenter/${var.env_name}/enterprise_tier/server_manager/all" }
