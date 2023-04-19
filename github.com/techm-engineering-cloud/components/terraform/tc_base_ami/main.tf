
data "aws_ssm_parameter" "software_repo" { name = "/teamcenter/shared/software_repo/ebs_snapshot_id" }

## CentOS 7 (x86_64) - with Updates HVM
data "aws_ami" "centos_base_ami" {
  most_recent = true
  owners      = ["aws-marketplace"]
  filter {
    name   = "name"
    values = ["CentOS-7-2111-20220825_1.x86_64-d9a3032a-921c-4c6d-b150-bde168105e42"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

data "aws_s3_object" "core_outputs" {
  bucket = var.artifacts_bucket_name
  key    = "stage_outputs/01_core_infra/outputs.json"
}

data "aws_ssm_parameters_by_path" "own_params" { 
  path      = "/teamcenter/shared/base_ami" 
  recursive = true
}

locals {
  changing_rebake_seed        = formatdate("YYYYMMDDhhmmss", timestamp())
  exists_previous_rebake_seed = contains(data.aws_ssm_parameters_by_path.own_params.names, "/teamcenter/shared/base_ami/rebake_seed")
  index_previous_rebake_seed  = local.exists_previous_rebake_seed ? index(data.aws_ssm_parameters_by_path.own_params.names, "/teamcenter/shared/base_ami/rebake_seed") : -1
  previous_rebake_seed        = local.exists_previous_rebake_seed ? nonsensitive(data.aws_ssm_parameters_by_path.own_params.values[local.index_previous_rebake_seed]) : local.changing_rebake_seed
  rebake_seed                 = var.force_rebake ? local.changing_rebake_seed : local.previous_rebake_seed
  packer_dir                  = "${path.module}/../../packer/tc_base_ami"
}

resource "null_resource" "packer" {
  # Rebake only if any of the input variables have changed, or the force_rebake flag is set
  triggers = {
    installation_prefix    = jsondecode(data.aws_s3_object.core_outputs.body).installation_prefix
    kms_key_id             = jsondecode(data.aws_s3_object.core_outputs.body).kms_key_id
    base_ami               = data.aws_ami.centos_base_ami.id
    software_repo_snapshot = nonsensitive(data.aws_ssm_parameter.software_repo.value)
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
  -var 'installation_prefix=${jsondecode(data.aws_s3_object.core_outputs.body).installation_prefix}' \
  -var 'vpc_id=${jsondecode(data.aws_s3_object.core_outputs.body).vpc_id}' \
  -var 'subnet_id=${jsondecode(data.aws_s3_object.core_outputs.body).public_subnet_ids[0]}' \
  -var 'instance_profile=software-repo' \
  -var 'region=${jsondecode(data.aws_s3_object.core_outputs.body).region}' \
  -var 'kms_key_id=${jsondecode(data.aws_s3_object.core_outputs.body).kms_key_id}' \
  -var 'base_ami=${data.aws_ami.centos_base_ami.id}' \
  -var 'software_repo_snapshot=${nonsensitive(data.aws_ssm_parameter.software_repo.value)}' \
  -var 'build_uuid=${local.rebake_seed}' \
  -debug \
  -machine-readable .

if [ ! $? -eq 0 ]; then
  echo "=== Packer Failed ==="
  exit 1
fi

EOF
  }
}

data "aws_ami" "base_ami" {
  depends_on = [
    null_resource.packer
  ]

  most_recent = true
  owners      = ["self"]

  filter {
     name   = "tag:BuildUUID-tc-base-ami"
     values = [local.rebake_seed]
  }
}

resource "aws_ssm_parameter" "base_ami" {
  name           = "/teamcenter/shared/base_ami/ami_id"
  type           = "String"
  insecure_value = data.aws_ami.base_ami.id
  overwrite      = true
}

resource "aws_ssm_parameter" "rebake_seed" {
  name           = "/teamcenter/shared/base_ami/rebake_seed"
  type           = "String"
  insecure_value = local.rebake_seed
  overwrite      = true
}

