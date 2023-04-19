
data "aws_ssm_parameter" "software_repo_snapshot" { name = "/teamcenter/shared/software_repo/ebs_snapshot_id" }
data "aws_secretsmanager_secret" "dc_user" { name = var.dc_user_secret_name }
data "aws_secretsmanager_secret_version" "dc_user" { secret_id = data.aws_secretsmanager_secret.dc_user.id }

data "aws_ssm_parameters_by_path" "own_params" { 
  path      = "/teamcenter/shared/deployment_center" 
  recursive = true
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20220420"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

locals {
  changing_rebake_seed        = formatdate("YYYYMMDDhhmmss", timestamp())
  exists_previous_rebake_seed = contains(data.aws_ssm_parameters_by_path.own_params.names, "/teamcenter/shared/deployment_center/rebake_seed")
  index_previous_rebake_seed  = local.exists_previous_rebake_seed ? index(data.aws_ssm_parameters_by_path.own_params.names, "/teamcenter/shared/deployment_center/rebake_seed") : -1
  previous_rebake_seed        = local.exists_previous_rebake_seed ? nonsensitive(data.aws_ssm_parameters_by_path.own_params.values[local.index_previous_rebake_seed]) : local.changing_rebake_seed
  rebake_seed                 = var.force_rebake ? local.changing_rebake_seed : local.previous_rebake_seed
  packer_dir                  = "${path.module}/../../packer/tc_deployment_center"
}

resource "null_resource" "packer" {
  # Rebake only if any of the input variables have changed, or the force_rebake flag is set
  triggers = {
    installation_prefix    = var.installation_prefix
    vpc_id                 = data.aws_vpc.main.id
    subnet_ids             = var.lb_subnets[0]
    instance_profile       = aws_iam_instance_profile.deployment_center.name
    dc_efs_id              = aws_efs_file_system.deployment_center.id
    region                 = jsondecode(data.aws_s3_object.core_outputs.body).region
    kms_key_id             = var.kms_key_id
    base_ami               = data.aws_ami.ubuntu.id
    dc_admin_user          = nonsensitive(data.aws_secretsmanager_secret_version.dc_user.secret_string)
    dc_admin_pass_name     = var.dc_pass_secret_name
    instance_type          = var.instance_type
    software_repo_snapshot = nonsensitive(data.aws_ssm_parameter.software_repo_snapshot.value)
    rebake_seed            = local.rebake_seed
    dir_sha1               = sha1(join("", [for f in fileset(local.packer_dir, "*"): filesha1(format("%s/%s", local.packer_dir, f))]))
  }
  
  provisioner "local-exec" {
    working_dir = local.packer_dir
    environment = {
      AWS_MAX_ATTEMPTS       = 180
      AWS_POLL_DELAY_SECONDS = 30
     }
    command = <<EOF
packer build \
  -var 'installation_prefix=${var.installation_prefix}' \
  -var 'vpc_id=${data.aws_vpc.main.id}' \
  -var 'subnet_id=${var.lb_subnets[0]}' \
  -var 'instance_profile=${aws_iam_instance_profile.deployment_center.name}' \
  -var 'dc_efs_id=${aws_efs_file_system.deployment_center.id}' \
  -var 'region=${jsondecode(data.aws_s3_object.core_outputs.body).region}' \
  -var 'kms_key_id=${var.kms_key_id}' \
  -var 'base_ami=${data.aws_ami.ubuntu.id}' \
  -var 'dc_admin_user=${nonsensitive(data.aws_secretsmanager_secret_version.dc_user.secret_string)}' \
  -var 'dc_admin_pass_name=${var.dc_pass_secret_name}' \
  -var 'machine_name=deployment-center' \
  -var 'software_repo_snapshot=${nonsensitive(data.aws_ssm_parameter.software_repo_snapshot.value)}' \
  -var 'delete_data=${var.delete_data}' \
  -var 'build_uuid=${local.rebake_seed}' \
  -var 'dc_folder_to_install=${var.dc_folder_to_install}' \
  -var 'artifacts_bucket=${var.artifacts_bucket_name}' \
  -var 'instance_type=${var.instance_type}' \
  -machine-readable .

if [ ! $? -eq 0 ]; then
  echo "=== Packer Failed ==="
  exit 1
fi

EOF
  }
}

data "aws_ami" "deployment_center" {
  depends_on = [
    null_resource.packer
  ]
  filter {
    name   = "tag:BuildUUID-dc"
    values = [local.rebake_seed]
  }

  most_recent = true
  owners      = ["self"]
}

resource "aws_ssm_parameter" "base_ami" {
  name           = "/teamcenter/shared/deployment_center/ami_id"
  type           = "String"
  insecure_value = data.aws_ami.deployment_center.id
  overwrite      = true
}

resource "aws_ssm_parameter" "rebake_seed" {
  name           = "/teamcenter/shared/deployment_center/rebake_seed"
  type           = "String"
  insecure_value = local.rebake_seed
  overwrite      = true
}
