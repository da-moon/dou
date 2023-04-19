
data "aws_ssm_parameter" "base_ami" { name = "/teamcenter/shared/base_ami/ami_id" }

data "aws_ssm_parameters_by_path" "own_params" { 
  path      = "/teamcenter/${var.env_name}/file_server" 
  recursive = true
}

resource "random_password" "samba_pass" {
  length           = 12
  special          = true
  override_special = "-"
}

resource "aws_secretsmanager_secret" "samba_pass" {
  name                    = "/teamcenter/${var.env_name}/file_server/samba_pass"
  description             = "samba password password for tc user"
  recovery_window_in_days = 0

  tags = {
    Name            = "/teamcenter/${var.env_name}/file_server/samba_pass"
    Env             = var.env_name
    Installation    = var.installation_prefix != "" ? var.installation_prefix : null
  }
}

resource "aws_secretsmanager_secret_version" "samba_pass" {
  secret_id     = aws_secretsmanager_secret.samba_pass.id
  secret_string = random_password.samba_pass.result
}

locals {
  changing_rebake_seed        = formatdate("YYYYMMDDhhmmss", timestamp())
  exists_previous_rebake_seed = contains(data.aws_ssm_parameters_by_path.own_params.names, "/teamcenter/${var.env_name}/file_server/rebake_seed")
  index_previous_rebake_seed  = local.exists_previous_rebake_seed ? index(data.aws_ssm_parameters_by_path.own_params.names, "/teamcenter/${var.env_name}/file_server/rebake_seed") : -1
  previous_rebake_seed        = local.exists_previous_rebake_seed ? nonsensitive(data.aws_ssm_parameters_by_path.own_params.values[local.index_previous_rebake_seed]) : local.changing_rebake_seed
  rebake_seed                 = var.force_rebake ? local.changing_rebake_seed : local.previous_rebake_seed
  secrets_prefix              = var.installation_prefix != "" ? "${var.installation_prefix}-tc-${var.env_name}" : "tc-${var.env_name}"
  packer_dir                  = "${path.module}/../../packer/tc_file_server"
  common_packer_dir           = "${path.module}/../../packer/tc_common/centos"
}


resource "null_resource" "packer" {
  # Rebake only if any of the input variables have changed, or the force_rebake flag is set
  triggers = {
    installation_prefix = jsondecode(data.aws_s3_object.core_outputs.body).installation_prefix
    instance_profile    = jsondecode(data.aws_s3_object.core_env_outputs.body).instance_profile_id
    region              = jsondecode(data.aws_s3_object.core_outputs.body).region
    kms_key_id          = jsondecode(data.aws_s3_object.core_outputs.body).kms_key_id
    base_ami            = data.aws_ssm_parameter.base_ami.value
    tc_efs_id           = jsondecode(data.aws_s3_object.core_env_outputs.body).tc_efs_id
    rebake_seed         = local.rebake_seed
    dir_sha1            = sha1(join("", [for f in fileset(local.packer_dir, "*") : filesha1(format("%s/%s", local.packer_dir, f))]))
    common_dir_sha1     = sha1(join("", [for f in fileset(local.common_packer_dir, "*") : filesha1(format("%s/%s", local.common_packer_dir, f))]))
  }
  
  provisioner "local-exec" {
    working_dir = local.packer_dir
    environment = {
      AWS_MAX_ATTEMPTS       = 180
      AWS_POLL_DELAY_SECONDS = 30
     }
    command = <<EOF
packer build \
  -var 'installation_prefix=${jsondecode(data.aws_s3_object.core_outputs.body).installation_prefix}' \
  -var 'vpc_id=${data.aws_vpc.main.id}' \
  -var 'subnet_id=${var.build_subnet_id}' \
  -var 'instance_profile=${jsondecode(data.aws_s3_object.core_env_outputs.body).instance_profile_id}' \
  -var 'region=${jsondecode(data.aws_s3_object.core_outputs.body).region}' \
  -var 'kms_key_id=${jsondecode(data.aws_s3_object.core_outputs.body).kms_key_id}' \
  -var 'base_ami=${nonsensitive(data.aws_ssm_parameter.base_ami.value)}' \
  -var 'machine_name=file_server' \
  -var 'tc_efs_id=${jsondecode(data.aws_s3_object.core_env_outputs.body).tc_efs_id}' \
  -var 'build_uuid=${local.rebake_seed}' \
  -var 'samba_pass=${aws_secretsmanager_secret.samba_pass.name}' \
  -debug \
  -machine-readable .

if [ ! $? -eq 0 ]; then
  echo "=== Packer Failed ==="
  exit 1
fi

EOF
  }
}

data "aws_ami" "file_server" {
  depends_on = [
    null_resource.packer
  ]

  most_recent = true
  owners      = ["self"]

  filter {
     name   = "tag:BuildUUID"
     values = [local.rebake_seed]
  }
}

resource "aws_ssm_parameter" "base_ami" {
  name           = "/teamcenter/${var.env_name}/file_server/ami_id"
  type           = "String"
  insecure_value = data.aws_ami.file_server.id
  overwrite      = true
}

resource "aws_ssm_parameter" "rebake_seed" {
  name           = "/teamcenter/${var.env_name}/file_server/rebake_seed"
  type           = "String"
  insecure_value = local.rebake_seed
  overwrite      = true
}

