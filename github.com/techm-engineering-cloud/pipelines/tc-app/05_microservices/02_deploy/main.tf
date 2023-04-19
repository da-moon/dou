
data "aws_ssm_parameter" "container_orchestration" { name = "/teamcenter/${var.env_name}/microservices/master/container_orchestration" }
data "aws_ssm_parameter" "master_hostname" { name = "/teamcenter/${var.env_name}/microservices/master/hostname" }
data "aws_ssm_parameter" "ms_port" { name = "/teamcenter/${var.env_name}/microservices/master/port" }
data "aws_ssm_parameter" "namespace" { 
  count = data.aws_ssm_parameter.container_orchestration.value == "Kubernetes"? 1 : 0
  name  = "/teamcenter/${var.env_name}/microservices/master/kubernetes_namespace" 
}

locals {
  prefix               = var.installation_prefix != "" ? "${var.installation_prefix}-${var.env_name}-" : "${var.env_name}-"
  ms_manager_ami       = data.aws_ssm_parameter.container_orchestration.value == "Docker Swarm" ? jsondecode(data.aws_s3_object.bake_outputs_swarm[0].body).swarm_ami_id : ""
  packer_dir           = "${path.module}/../../../../components/packer/tc_k8"
  changing_rebake_seed = formatdate("YYYYMMDDhhmmss", timestamp())
  previous_rebake_seed = length(data.aws_s3_objects.maybe_self_outputs.keys) > 0 ? jsondecode(data.aws_s3_object.self_outputs[0].body).rebake_seed : local.changing_rebake_seed
  rebake_seed          = var.force_rebake ? local.changing_rebake_seed : local.previous_rebake_seed
}

data "aws_ssm_parameter" "base_ami" { name = "/teamcenter/shared/base_ami/ami_id" }

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

data "aws_s3_objects" "maybe_self_outputs" {
  bucket = var.artifacts_bucket_name
  prefix = "stage_outputs/env-${var.env_name}/bake_ms/outputs.json"
}

data "aws_s3_object" "self_outputs" {
  count  = length(data.aws_s3_objects.maybe_self_outputs.keys)
  bucket = var.artifacts_bucket_name
  key    = "stage_outputs/env-${var.env_name}/bake_ms/outputs.json"
}

data "aws_s3_object" "install_scripts" {
  bucket = var.artifacts_bucket_name
  key    = "stage_outputs/03_generate_install_scripts/${var.env_name}/outputs.json"
}

data "aws_s3_object" "bake_outputs_swarm" {
  count  = data.aws_ssm_parameter.container_orchestration.value == "Docker Swarm" ? 1 : 0
  bucket = var.artifacts_bucket_name
  key    = "stage_outputs/env-${var.env_name}/bake_ms/outputs.json"
}

data "aws_s3_object" "bake_outputs_eks" {
  count  = data.aws_ssm_parameter.container_orchestration.value == "Kubernetes" ? 1 : 0
  bucket = var.artifacts_bucket_name
  key    = "stage_outputs/env-${var.env_name}/bake_ms_eks/outputs.json"
}

data "aws_s3_object" "core_outputs" {
  bucket = var.artifacts_bucket_name
  key    = "stage_outputs/01_core_infra/outputs.json"
}

data "aws_s3_object" "core_env_outputs" {
  bucket = var.artifacts_bucket_name
  key    = "stage_outputs/02_core_env/${var.env_name}/outputs.json"
}

data "aws_key_pair" "key" {
  key_name           = jsondecode(data.aws_s3_object.core_outputs.body).ssh_key_name
  include_public_key = true
}

data "aws_instance" "build_server" {
  filter {
    name   = "tag:Name"
    values = [var.installation_prefix != "" ? "${var.installation_prefix}-tc-${var.env_name}-build-server" : "tc-${var.env_name}-build-server"]
  }

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
}

module "docker-swarm" {
  count  = data.aws_ssm_parameter.container_orchestration.value == "Docker Swarm" ? 1 : 0
  source = "../../../../components/terraform/swarm"

  name                       = "${local.prefix}tc-microservices-${var.env_name}"
  vpc_id                     = jsondecode(data.aws_s3_object.core_outputs.body).vpc_id
  swarm_cidr_private_subnets = var.swarm_cidr_private_subnets != null ? "${var.swarm_cidr_private_subnets}" : null
  cloud_config_extra = templatefile("users.cloud-config", {
    ssh_public_key = data.aws_key_pair.key.public_key,
  })

  key_name              = jsondecode(data.aws_s3_object.core_outputs.body).ssh_key_name
  manager_base_ami_id   = local.ms_manager_ami
  worker_base_ami_id    = local.ms_manager_ami
  instance_type_manager = var.machines.ms_manager.instance_type
  instance_type_worker  = var.machines.ms_worker.instance_type
  managers              = var.machines.ms_manager.instances
  workers               = var.machines.ms_worker.instances
  volume_size           = 10
  target_group          = aws_lb_target_group.ms_tg[0].arn
  route_tables          = [jsondecode(data.aws_s3_object.core_outputs.body).rt_ngw_a, jsondecode(data.aws_s3_object.core_outputs.body).rt_ngw_b]
  sns_arn               = jsondecode(data.aws_s3_object.core_env_outputs.body).sns_env_arn

  additional_security_group_ids = [
    aws_security_group.swarm.id,
  ]
}

module "kubectl_apply" {
  count       = data.aws_ssm_parameter.container_orchestration.value == "Kubernetes" ? 1 : 0
  source      = "../../../../components/terraform/ssm_command"
  instance_id = data.aws_instance.build_server.id
  commands    = ["KUBECONFIG=$HOME/.kube/config /home/tc/kubernetes/deploy.sh"]
  region      = var.region
  triggers = {
    tc_efs_id   = jsondecode(data.aws_s3_object.core_env_outputs.body).tc_efs_id
    rebake_seed = jsondecode(data.aws_s3_object.bake_outputs_eks[0].body).rebake_seed
  }
}

