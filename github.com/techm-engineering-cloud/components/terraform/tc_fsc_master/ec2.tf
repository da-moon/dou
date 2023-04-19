
module "enterprise_server" {
  source                       = "../tc_enterprise_server_common"
  installation_prefix          = jsondecode(data.aws_s3_object.core_outputs.body).installation_prefix
  ami_id                       = data.aws_ami.fsc_master.id
  ssh_key_name                 = jsondecode(data.aws_s3_object.core_outputs.body).ssh_key_name
  iam_instance_profile         = jsondecode(data.aws_s3_object.core_env_outputs.body).instance_profile_id
  enterprise_security_group_id = jsondecode(data.aws_s3_object.core_env_outputs.body).enterprise_security_group_id
  active_subnet_id             = jsondecode(data.aws_s3_object.core_env_outputs.body).private_env_subnet_ids[0]
  standby_subnet_id            = jsondecode(data.aws_s3_object.core_env_outputs.body).private_env_subnet_ids[1]
  machine_name                 = nonsensitive(data.aws_ssm_parameter.fsc_master_hostname.value)
  instance_type                = var.instance_type
  sns_arn                      = jsondecode(data.aws_s3_object.core_env_outputs.body).sns_env_arn
}
