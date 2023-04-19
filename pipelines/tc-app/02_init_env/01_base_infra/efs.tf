# EFS for Teamcenter
module "tc_efs" {
  source             = "../../../../components/terraform/efs"
  env_name           = var.env_name
  prefix_name        = var.installation_prefix != "" ? "${var.installation_prefix}-tc-${var.env_name}" : "tc-${var.env_name}"
  fs_service         = "tc_efs"
  vpc_id             = jsondecode(data.aws_s3_object.core_outputs.body).vpc_id
  private_subnet_ids = [aws_subnet.env_subnet_1.id, aws_subnet.env_subnet_2.id]
  public_subnet_ids  = jsondecode(data.aws_s3_object.core_outputs.body).public_subnet_ids
}

resource "aws_efs_mount_target" "tc_efs_mount_env1" {
  file_system_id  = module.tc_efs.efs_id
  subnet_id       = aws_subnet.env_subnet_1.id
  security_groups = [module.tc_efs.efs_security_group_id]
}

resource "aws_efs_mount_target" "tc_efs_mount_env2" {
  file_system_id  = module.tc_efs.efs_id
  subnet_id       = aws_subnet.env_subnet_2.id
  security_groups = [module.tc_efs.efs_security_group_id]
}
