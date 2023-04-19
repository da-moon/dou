terraform {
  backend "s3" {}

  required_version = "~> 1.1.9"
}

data "aws_ssm_parameter" "base_ami" { name = "/teamcenter/shared/base_ami/ami_id" }
data "aws_ssm_parameter" "dc_url" { name = "/teamcenter/shared/deployment_center/url" }
data "aws_ssm_parameter" "container_orchestration" { name = "/teamcenter/${var.env_name}/microservices/master/container_orchestration" }
data "aws_ssm_parameter" "master_hostname" { name = "/teamcenter/${var.env_name}/microservices/master/hostname" }
data "aws_ssm_parameter" "filerepo_path" { name = "/teamcenter/${var.env_name}/microservices/master/filerepo_storage_path" }
data "aws_ssm_parameter" "ms_port" { name = "/teamcenter/${var.env_name}/microservices/master/port" }
data "aws_ssm_parameter" "aw_gateway_port" { name = "/teamcenter/${var.env_name}/aw_gateway/port" }
data "aws_ssm_parameter" "aw_gateway_dns" { name = "/teamcenter/${var.env_name}/aw_gateway/dns" }
data "aws_ssm_parameter" "namespace" { 
  count = data.aws_ssm_parameter.container_orchestration.value == "Kubernetes"? 1 : 0
  name  = "/teamcenter/${var.env_name}/microservices/master/kubernetes_namespace" 
}

data "aws_iam_role" "codebuild_role" {
  name = var.installation_prefix != "" ? "${var.installation_prefix}-tc-${var.env_name}-codebuild-servicerole" : "tc-${var.env_name}-codebuild-servicerole"
}

data "aws_caller_identity" "current" {}

data "aws_s3_object" "core_outputs" {
  bucket = var.artifacts_bucket_name
  key    = "stage_outputs/01_core_infra/outputs.json"
}

data "aws_s3_object" "core_env_outputs" {
  bucket = var.artifacts_bucket_name
  key    = "stage_outputs/02_core_env/${var.env_name}/outputs.json"
}

data "aws_s3_object" "install_scripts" {
  bucket = var.artifacts_bucket_name
  key    = "stage_outputs/03_generate_install_scripts/${var.env_name}/outputs.json"
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
data "aws_s3_objects" "maybe_self_outputs_eks" {
  bucket = var.artifacts_bucket_name
  prefix = "stage_outputs/env-${var.env_name}/bake_ms_eks/outputs.json"
}

data "aws_s3_object" "self_outputs_eks" {
  count  = length(data.aws_s3_objects.maybe_self_outputs_eks.keys)
  bucket = var.artifacts_bucket_name
  key    = "stage_outputs/env-${var.env_name}/bake_ms_eks/outputs.json"
}


locals {
  changing_rebake_seed     = formatdate("YYYYMMDDhhmmss", timestamp())
  previous_rebake_seed     = length(data.aws_s3_objects.maybe_self_outputs.keys) > 0 ? jsondecode(data.aws_s3_object.self_outputs[0].body).rebake_seed : local.changing_rebake_seed
  previous_rebake_seed_eks = length(data.aws_s3_objects.maybe_self_outputs_eks.keys) > 0 ? jsondecode(data.aws_s3_object.self_outputs_eks[0].body).rebake_seed : local.changing_rebake_seed
  rebake_seed              = var.force_rebake ? local.changing_rebake_seed : local.previous_rebake_seed
  rebake_seed_eks          = var.force_rebake ? local.changing_rebake_seed : local.previous_rebake_seed_eks
  packer_dir               = "${path.module}/../../../../components/packer/tc_microservice_node"
  common_packer_dir        = "${path.module}/../../../../components/packer/tc_common/centos"
  swarm_node               = data.aws_ssm_parameter.container_orchestration.value == "Docker Swarm" ? [data.aws_ssm_parameter.master_hostname.value] : []
  cluster_name             = "tc-${var.env_name}-eks"
  host                     = data.aws_ssm_parameter.container_orchestration.value != "Docker Swarm" ? module.eks[0].cluster_endpoint : ""
  cert                     = data.aws_ssm_parameter.container_orchestration.value != "Docker Swarm" ? module.eks[0].cluster_certificate : ""
  service_account_name     = jsondecode(data.aws_s3_object.core_outputs.body).installation_prefix != "" ? "${jsondecode(data.aws_s3_object.core_outputs.body).installation_prefix}-${var.env_name}-efs-csi-controller-sa" : "${var.env_name}-efs-csi-controller-sa"
  storage_class_name       = jsondecode(data.aws_s3_object.core_outputs.body).installation_prefix != "" ? "${jsondecode(data.aws_s3_object.core_outputs.body).installation_prefix}-${var.env_name}-efs-sc" : "${var.env_name}-efs-sc"
  lb_ms_name               = var.installation_prefix != "" ? "${var.installation_prefix}-tc-${var.env_name}-awg" : "tc-${var.env_name}-awg"
  lb_sd_name               = var.installation_prefix != "" ? "${var.installation_prefix}-tc-${var.env_name}-ms" : "tc-${var.env_name}-ms"
  build_server_role        = var.installation_prefix != "" ? "${var.installation_prefix}-tc-${var.env_name}-build-server" : "tc-${var.env_name}-build-server"
}

provider "kubernetes" {
  host                   = local.host
  cluster_ca_certificate = base64decode(local.cert)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", local.cluster_name, "--region", var.region]
    command     = "aws"
  }
}

provider "helm" {
  kubernetes {
    host                   = local.host
    cluster_ca_certificate = base64decode(local.cert)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", local.cluster_name, "--region", var.region]
      command     = "aws"
    }
  }
}

resource "null_resource" "swarm_packer" {
  count = data.aws_ssm_parameter.container_orchestration.value == "Docker Swarm"? 1 : 0
  # Rebake only if any of the input variables have changed, or the force_rebake flag is set
  triggers = {
    installation_prefix  = jsondecode(data.aws_s3_object.core_outputs.body).installation_prefix
    vpc_id               = jsondecode(data.aws_s3_object.core_outputs.body).vpc_id
    subnet_id            = jsondecode(data.aws_s3_object.core_outputs.body).public_subnet_ids[0]
    region               = jsondecode(data.aws_s3_object.core_outputs.body).region
    kms_key_id           = jsondecode(data.aws_s3_object.core_outputs.body).kms_key_id
    install_scripts_path = jsondecode(data.aws_s3_object.install_scripts.body).scripts_s3_path
    base_ami             = nonsensitive(data.aws_ssm_parameter.base_ami.value)
    rebake_seed          = local.rebake_seed
    dir_sha1             = sha1(join("", [for f in fileset(local.packer_dir, "*") : filesha1(format("%s/%s", local.packer_dir, f))]))
    common_dir_sha1      = sha1(join("", [for f in fileset(local.common_packer_dir, "*") : filesha1(format("%s/%s", local.common_packer_dir, f))]))
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
  -var 'instance_profile=${var.installation_prefix != "" ? "${var.installation_prefix}-tc-${var.env_name}-build-server" : "tc-${var.env_name}-build-server"}' \
  -var 'ecr_registry=${jsondecode(data.aws_s3_object.core_outputs.body).ecr_registry}' \
  -var 'tc_efs_id=${jsondecode(data.aws_s3_object.core_env_outputs.body).tc_efs_id}' \
  -var 'region=${jsondecode(data.aws_s3_object.core_outputs.body).region}' \
  -var 'base_ami=${nonsensitive(data.aws_ssm_parameter.base_ami.value)}' \
  -var 'machine_name=${nonsensitive(data.aws_ssm_parameter.master_hostname.value)}' \
  -var 'install_scripts_path=${jsondecode(data.aws_s3_object.install_scripts.body).scripts_s3_path}' \
  -var 'dc_user_secret_name=/teamcenter/shared/deployment_center/username' \
  -var 'dc_pass_secret_name=/teamcenter/shared/deployment_center/password' \
  -var 'dc_url=${nonsensitive(data.aws_ssm_parameter.dc_url.value)}' \
  -var 'ignore_tc_errors=${var.ignore_tc_errors}' \
  -var 'keystore_secret_name=${jsondecode(data.aws_s3_object.core_env_outputs.body).ms_keystore_secret_name}' \
  -var 'stage_name=bake_ms' \
  -var 'file_repo_path=${nonsensitive(data.aws_ssm_parameter.filerepo_path.value)}' \
  -var 'is_manager=${true}' \
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


/* =============================== Packer EKS ===========================================*/


 resource "null_resource" "eks_packer" {
  count = data.aws_ssm_parameter.container_orchestration.value == "Kubernetes"? 1 : 0
  # Rebake only if any of the input variables have changed, or the force_rebake flag is set
  triggers = {
    installation_prefix  = jsondecode(data.aws_s3_object.core_outputs.body).installation_prefix
    region               = jsondecode(data.aws_s3_object.core_outputs.body).region
    kms_key_id           = jsondecode(data.aws_s3_object.core_outputs.body).kms_key_id
    install_scripts_path = jsondecode(data.aws_s3_object.install_scripts.body).scripts_s3_path
    base_ami             = nonsensitive(data.aws_ssm_parameter.base_ami.value)
    rebake_seed          = local.rebake_seed_eks
    dir_sha1             = sha1(join("", [for f in fileset(local.packer_dir, "*"): filesha1(format("%s/%s", local.packer_dir, f))]))
    common_dir_sha1      = sha1(join("", [for f in fileset(local.common_packer_dir, "*"): filesha1(format("%s/%s", local.common_packer_dir, f))]))
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
  -var 'instance_profile=${var.installation_prefix != "" ? "${var.installation_prefix}-tc-${var.env_name}-build-server" : "tc-${var.env_name}-build-server"}' \
  -var 'ecr_registry=${jsondecode(data.aws_s3_object.core_outputs.body).ecr_registry}' \
  -var 'tc_efs_id=${jsondecode(data.aws_s3_object.core_env_outputs.body).tc_efs_id}' \
  -var 'region=${jsondecode(data.aws_s3_object.core_outputs.body).region}' \
  -var 'base_ami=${nonsensitive(data.aws_ssm_parameter.base_ami.value)}' \
  -var 'machine_name=${nonsensitive(data.aws_ssm_parameter.master_hostname.value)}' \
  -var 'install_scripts_path=${jsondecode(data.aws_s3_object.install_scripts.body).scripts_s3_path}' \
  -var 'dc_user_secret_name=/teamcenter/shared/deployment_center/username' \
  -var 'dc_pass_secret_name=/teamcenter/shared/deployment_center/password' \
  -var 'dc_url=${nonsensitive(data.aws_ssm_parameter.dc_url.value)}' \
  -var 'file_repo_path=${nonsensitive(data.aws_ssm_parameter.filerepo_path.value)}' \
  -var 'ignore_tc_errors=${var.ignore_tc_errors}' \
  -var 'keystore_secret_name=${jsondecode(data.aws_s3_object.core_env_outputs.body).ms_keystore_secret_name}' \
  -var 'stage_name=bake_ms_eks' \
  -var 'is_manager=true' \
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

module "eks" {
  count                   = data.aws_ssm_parameter.container_orchestration.value == "Kubernetes"? 1 : 0
  source                  = "../../../../components/terraform/eks"
  cluster_name            = local.cluster_name
  vpc_id                  = jsondecode(data.aws_s3_object.core_outputs.body).vpc_id
  namespace_kube          = nonsensitive(data.aws_ssm_parameter.namespace[0].value)
  private_env_subnet_ids  = ["${jsondecode(data.aws_s3_object.core_env_outputs.body).private_env_subnet_ids[0]}", "${jsondecode(data.aws_s3_object.core_env_outputs.body).private_env_subnet_ids[1]}"]
  instance_type           = [var.eks_instances.instance_type]
  min_size                = var.eks_instances.min_instances
  max_size                = var.eks_instances.max_instances
  desired_size            = var.eks_instances.desired_instances
  region                  = var.region
  installation_prefix     = jsondecode(data.aws_s3_object.core_outputs.body).installation_prefix
  env_name                = var.env_name
  service_account_name    = local.service_account_name
  storage_class_name      = local.storage_class_name
  create_storage_class    = true
  create_namespace        = true
  namespace               = "kube-system"
  helm_chart_name         = "aws-efs-csi-driver"
  helm_chart_release_name = "aws-efs-csi-driver"
  settings                = {}
  mod_dependency          = null
  access_roles = [
    {
      rolearn  = jsondecode(data.aws_s3_object.core_env_outputs.body).core_env_role_arn
      username = "tc"
      groups   = ["system:masters"]
    },
    {
      rolearn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.build_server_role}"
      username = "build-server"
      groups   = ["system:masters"]
    },
    {
      rolearn  = data.aws_iam_role.codebuild_role.arn
      username = "build"
      groups   = ["system:masters"]
    },
    {
      rolearn  = var.extra_kube_admin_role
      username = "admins"
      groups   = ["system:masters"]
    }
  ]

}
resource "kubernetes_ingress_v1" "ms_ingress" {
  count = data.aws_ssm_parameter.container_orchestration.value == "Kubernetes"? 1 : 0
  metadata {
    name = var.installation_prefix != "" ? "${var.installation_prefix}-tc-${var.env_name}-service-dispatcher" : "tc-${var.env_name}-service-dispatcher"
    namespace= nonsensitive(data.aws_ssm_parameter.namespace[0].value)
    annotations = {
    "alb.ingress.kubernetes.io/scheme"= "internal"
    "alb.ingress.kubernetes.io/target-type"= "ip"
    "alb.ingress.kubernetes.io/subnets"= "${jsondecode(data.aws_s3_object.core_env_outputs.body).private_env_subnet_ids[0]},${jsondecode(data.aws_s3_object.core_env_outputs.body).private_env_subnet_ids[1]}"
    "alb.ingress.kubernetes.io/load-balancer-name"= local.lb_sd_name
    "alb.ingress.kubernetes.io/security-groups"= jsondecode(data.aws_s3_object.core_env_outputs.body).awg_security_group_id
    "alb.ingress.kubernetes.io/listen-ports"= "[{\"HTTP\": ${nonsensitive(data.aws_ssm_parameter.ms_port.value)}}]"
    "alb.ingress.kubernetes.io/success-codes"= "200-299,300-399,400-499"
    "alb.ingress.kubernetes.io/load-balancer-attributes" = "idle_timeout.timeout_seconds=3600"
    }
  }
  spec {
    ingress_class_name = "alb"
    rule {
      http {
        path {
          path = "/*"
          backend {
            service {
              name = "service-dispatcher"
              port {
                number = 9090
              }
            }
          }
        }
      }
    }
}
}

resource "kubernetes_ingress_v1" "gateway_ingress" {
  count = data.aws_ssm_parameter.container_orchestration.value == "Kubernetes"? 1 : 0
  metadata {
    name = var.installation_prefix != "" ? "${var.installation_prefix}-tc-${var.env_name}-aw-gateway" : "tc-${var.env_name}-aw-gateway"
    namespace= nonsensitive(data.aws_ssm_parameter.namespace[0].value)
    annotations = {
    "alb.ingress.kubernetes.io/scheme"= "internet-facing"
    "alb.ingress.kubernetes.io/target-type"= "ip"
    "alb.ingress.kubernetes.io/subnets"= "${jsondecode(data.aws_s3_object.core_outputs.body).public_subnet_ids[0]},${jsondecode(data.aws_s3_object.core_outputs.body).public_subnet_ids[1]}"
    "alb.ingress.kubernetes.io/load-balancer-name"= local.lb_ms_name
    "alb.ingress.kubernetes.io/security-groups"= jsondecode(data.aws_s3_object.core_env_outputs.body).awg_security_group_id
    "alb.ingress.kubernetes.io/listen-ports"= "[{\"HTTP\": ${nonsensitive(data.aws_ssm_parameter.aw_gateway_port.value)}}]"
    "alb.ingress.kubernetes.io/success-codes"= "200-299,300-399,400-499"
    "alb.ingress.kubernetes.io/healthcheck-protocol" =  "HTTP"
    "alb.ingress.kubernetes.io/healthcheck-port" = "traffic-port"
    "alb.ingress.kubernetes.io/healthcheck-path" = "/ping"
    "alb.ingress.kubernetes.io/load-balancer-attributes" = "idle_timeout.timeout_seconds=3600"
    }
  }
  spec {
    ingress_class_name = "alb"
    rule {
      http {
        path {
          path = "/*"
          backend {
            service {
              name = "gateway"
              port {
                number = 3000
              }
            }
          }
        }
      }
    }
}
}


resource "aws_route53_record" "ms_record" {
  count   = data.aws_ssm_parameter.container_orchestration.value == "Kubernetes"? 1 : 0
  zone_id = jsondecode(data.aws_s3_object.core_outputs.body).private_hosted_zone_id
  name    = nonsensitive(data.aws_ssm_parameter.master_hostname.value)
  type    = "CNAME"
  ttl     = "300"
  records = [kubernetes_ingress_v1.ms_ingress[0].status.0.load_balancer.0.ingress.0.hostname]
}

resource "aws_route53_record" "gateway_ingress" {
  count   = data.aws_ssm_parameter.container_orchestration.value == "Kubernetes"? 1 : 0
  zone_id = jsondecode(data.aws_s3_object.core_outputs.body).private_hosted_zone_id
  name    = nonsensitive(data.aws_ssm_parameter.aw_gateway_dns.value)
  type    = "CNAME"
  ttl     = "300"
  records = [kubernetes_ingress_v1.gateway_ingress[0].status.0.load_balancer.0.ingress.0.hostname]
}


data "aws_ami" "swarm_ami_id" {
  count = data.aws_ssm_parameter.container_orchestration.value == "Docker Swarm"? 1 : 0
  depends_on = [
    null_resource.swarm_packer
  ]

  most_recent = true
  owners      = ["self"]

  filter {
    name   = "tag:BuildUUID-tc-${nonsensitive(data.aws_ssm_parameter.master_hostname.value)}"
    values = [local.rebake_seed]
  }
} 

resource "aws_s3_object" "outputs_eks" {
  count        = data.aws_ssm_parameter.container_orchestration.value == "Kubernetes"? 1 : 0
  bucket       = var.artifacts_bucket_name
  key          = "stage_outputs/env-${var.env_name}/bake_ms_eks/outputs.json"
  content_type = "application/json"
  content = jsonencode({
    cluster_name     = local.cluster_name
    cluster_id       = module.eks[*].cluster_id
    cluster_endpoint = module.eks[*].cluster_endpoint
    rebake_seed      = local.rebake_seed_eks
  })
}

resource "aws_s3_object" "outputs" {
  count        = data.aws_ssm_parameter.container_orchestration.value == "Docker Swarm" ? 1 : 0
  bucket       = var.artifacts_bucket_name
  key          = "stage_outputs/env-${var.env_name}/bake_ms/outputs.json"
  content_type = "application/json"
  content = jsonencode({
    swarm_ami_id = data.aws_ami.swarm_ami_id[0].id
    rebake_seed  = local.rebake_seed
  })
} 
