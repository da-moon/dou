
data "aws_ssm_parameter" "base_ami" { name = "/teamcenter/shared/base_ami/ami_id" }
data "aws_ssm_parameter" "software_repo_snapshot" { name = "/teamcenter/shared/software_repo/ebs_snapshot_id" }
data "aws_ssm_parameter" "dc_url" { name = "/teamcenter/shared/deployment_center/url" }
data "aws_ssm_parameter" "db_host" { name = "/teamcenter/${var.env_name}/db/hostname" }
data "aws_ssm_parameter" "db_sid" { name = "/teamcenter/${var.env_name}/db/oracle_sid" }
data "aws_ssm_parameter" "container_orchestration" { name = "/teamcenter/${var.env_name}/microservices/master/container_orchestration" }
data "aws_ssm_parameter" "namespace" { 
  count = data.aws_ssm_parameter.container_orchestration.value == "Kubernetes"? 1 : 0
  name  = "/teamcenter/${var.env_name}/microservices/master/kubernetes_namespace" 
}

data "aws_ssm_parameters_by_path" "own_params" { 
  path      = "/teamcenter/${var.env_name}/build_server" 
  recursive = true
}

locals {
  changing_rebake_seed        = formatdate("YYYYMMDDhhmmss", timestamp())
  exists_previous_rebake_seed = contains(data.aws_ssm_parameters_by_path.own_params.names, "/teamcenter/${var.env_name}/build_server/rebake_seed")
  index_previous_rebake_seed  = local.exists_previous_rebake_seed ? index(data.aws_ssm_parameters_by_path.own_params.names, "/teamcenter/${var.env_name}/build_server/rebake_seed") : -1
  previous_rebake_seed        = local.exists_previous_rebake_seed ? nonsensitive(data.aws_ssm_parameters_by_path.own_params.values[local.index_previous_rebake_seed]) : local.changing_rebake_seed
  rebake_seed                 = var.force_rebake ? local.changing_rebake_seed : local.previous_rebake_seed
  packer_dir                  = "${path.module}/../../packer/tc_env_build_server"
  machine_name                = var.installation_prefix != "" ? "${var.installation_prefix}-tc-${var.env_name}-build-server.${data.aws_route53_zone.private.name}" : "tc-${var.env_name}-build-server.${data.aws_route53_zone.private.name}"
  namespace                   = data.aws_ssm_parameter.container_orchestration.value == "Kubernetes" ? nonsensitive(data.aws_ssm_parameter.namespace[0].value) : ""
}

resource "null_resource" "packer" {
  triggers = {
    prefix                 = local.prefix
    kms_key_id             = var.kms_key_id
    base_ami               = nonsensitive(data.aws_ssm_parameter.base_ami.value)
    instance_type          = var.instance_type
    software_repo_snapshot = nonsensitive(data.aws_ssm_parameter.software_repo_snapshot.value)
    machine_name           = local.machine_name
    tc_efs_id              = var.tc_efs_id
    namespace              = local.namespace
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
  -var 'env_name=${var.env_name}' \
  -var 'instance_type=${var.instance_type}' \
  -var 'vpc_id=${data.aws_vpc.main.id}' \
  -var 'subnet_id=${var.build_subnet_id}' \
  -var 'instance_profile=${aws_iam_instance_profile.build_server.name}' \
  -var 'tc_efs_id=${var.tc_efs_id}' \
  -var 'region=${data.aws_region.current.name}' \
  -var 'kms_key_id=${var.kms_key_id}' \
  -var 'base_ami=${nonsensitive(data.aws_ssm_parameter.base_ami.value)}' \
  -var 'machine_name=${local.machine_name}' \
  -var 'deploy_scripts_s3_bucket=${var.artifacts_bucket_name}' \
  -var 'dc_url=${nonsensitive(data.aws_ssm_parameter.dc_url.value)}' \
  -var 'private_hosted_zone_name=${data.aws_route53_zone.private.name}' \
  -var 'private_hosted_zone_arn=${data.aws_route53_zone.private.arn}' \
  -var 'db_admin_user_name=/teamcenter/${var.env_name}/db/admin_user' \
  -var 'db_admin_pass_name=/teamcenter/${var.env_name}/db/admin_pass' \
  -var 'sm_db_user_name=/teamcenter/${var.env_name}/db/sm_user' \
  -var 'sm_db_pass_name=/teamcenter/${var.env_name}/db/sm_pass' \
  -var 'infodba_user_name=/teamcenter/${var.env_name}/db/infodba_user' \
  -var 'infodba_pass_name=/teamcenter/${var.env_name}/db/infodba_pass' \
  -var 'sm_db_name=${var.sm_db_name}' \
  -var 'db_host=${nonsensitive(data.aws_ssm_parameter.db_host.value)}' \
  -var 'db_sid=${nonsensitive(data.aws_ssm_parameter.db_sid.value)}' \
  -var 'keystore_secret_name=${var.keystore_secret_name}' \
  -var 'namespace=${local.namespace}' \
  -var 'build_uuid=${local.rebake_seed}' \
  -machine-readable .

if [ ! $? -eq 0 ]; then
  echo "=== Packer Failed ==="
  exit 1
fi

EOF
  }
}

data "aws_ami" "build_server" {
  depends_on = [
    null_resource.packer
  ]
  filter {
    name   = "tag:BuildUUID-build-server"
    values = [local.rebake_seed]
  }

  most_recent = true
  owners      = ["self"]
}

resource "aws_ssm_parameter" "base_ami" {
  name           = "/teamcenter/${var.env_name}/build_server/ami_id"
  type           = "String"
  insecure_value = data.aws_ami.build_server.id
  overwrite      = true
}

resource "aws_ssm_parameter" "rebake_seed" {
  name           = "/teamcenter/${var.env_name}/build_server/rebake_seed"
  type           = "String"
  insecure_value = local.rebake_seed
  overwrite      = true
}

