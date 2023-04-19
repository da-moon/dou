terraform {
  backend "s3" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
    tls = "4.0.4"
  }

  required_version = "~> 1.1.9"
}

provider "aws" {
  region = var.region
}

locals {
  teamcenter_s3_bucket_name = split("/", split("s3://", var.software_repo_s3_uri)[1])[0]
}

data "aws_caller_identity" "current" {}

data "aws_acm_certificate" "self_signed_cert" {
  domain      = "*.${var.zone}"
  types       = ["IMPORTED"]
  most_recent = true
  depends_on = [
    null_resource.self_signed_cert
  ]
}

module "vpc" {
  vpc_id                     = var.vpc_id != "" ? "${var.vpc_id}" : null
  cidr_public_subnets        = var.cidr_public_subnets != null ? "${var.cidr_public_subnets}" : null
  cidr_private_build_subnets = var.cidr_private_build_subnets != null ? "${var.cidr_private_build_subnets}" : null
  source                     = "../../../../components/terraform/vpc"
  env_name                   = var.installation_prefix != "" ? "${var.installation_prefix}-tc" : "tc"
}

module "security" {
  source                    = "../../../../components/terraform/security"
  env_name                  = var.installation_prefix != "" ? "${var.installation_prefix}-tc" : "tc"
  vpc_id                    = module.vpc.vpc_id
  trail_name                = var.installation_prefix != "" ? "${var.installation_prefix}-tc-cloudtrail" : "tc-cloudtrail"
  teamcenter_s3_bucket_name = local.teamcenter_s3_bucket_name

  artifacts_bucket_name = var.artifacts_bucket_name

  private_hosted_zone_arn = module.dns.private_hosted_zone_arn
}

module "bastion" {
  source       = "../../../../components/terraform/bastion"
  env_name     = var.installation_prefix != "" ? "${var.installation_prefix}-tc" : "tc"
  ssh_key_name = module.security.ssh_key_name
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = module.vpc.public_subnet_ids
  eip_allocid  = module.vpc.bastion_eip_allocid
}

module "dns" {
  source    = "../../../../components/terraform/dns"
  env_name  = var.installation_prefix != "" ? "${var.installation_prefix}-tc" : "tc"
  zone      = var.zone
  vpc_id    = module.vpc.vpc_id
  region    = var.region
}

module "cloudtrail" {
  source                        = "../../../../components/terraform/cloudtrail"
  trail_name                    = var.installation_prefix != "" ? "${var.installation_prefix}-tc-cloudtrail" : "tc-cloudtrail"
  is_multi_region_trail         = "false"
  include_global_service_events = "true"
  cloudwatch_log_group_name     = "/teamcenter/cloudtrail"
  log_retention_days            = 120
  enable_log_file_validation    = true
  enable_logging                = true
  bucket_prefix                 = var.installation_prefix != "" ? "${var.installation_prefix}-tc-cloudtrail-s3" : "tc-cloudtrail-s3"
  kms_key_id                    = module.security.kms_key_arn
  env_name                      = var.installation_prefix != "" ? "${var.installation_prefix}-tc" : "tc"
}

module "software_repo_ebs" {
  source               = "../../../../components/terraform/tc_software_repo_ebs"
  subnet_id            = module.vpc.public_subnet_ids[0]
  kms_key_id           = module.security.kms_key_id
  source_s3_uri        = var.software_repo_s3_uri
  force_rebake         = var.force_rebake
}

module "health_checker" {
  source              = "../../../../components/terraform/tc_health_checker"
  subnet_ids          = module.vpc.private_build_subnet_ids
  installation_prefix = var.installation_prefix
}

resource "aws_sns_topic" "alarms" {
  name = var.installation_prefix != "" ? "${var.installation_prefix}-tc-common-alarms" : "tc-common-alarms"
}

resource "aws_ecr_repository" "ecr_repo" {
  count                = length(var.ecr)
  name                 = var.ecr[count.index]
  image_tag_mutability = "IMMUTABLE"
}

resource "aws_ecr_repository_policy" "default" {
  count      = length(var.ecr)
  repository = aws_ecr_repository.ecr_repo[count.index].name

  policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "AllowPull",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        ]
      },
      "Action": [
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability"
      ]
    },
    {
      "Sid": "AllowWriteMgmt",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        ]
      },
      "Action": [
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability",
        "ecr:PutImage",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload"
      ]
    }
  ]
}
EOF
}



resource "aws_s3_object" "outputs" {
  bucket       = var.artifacts_bucket_name
  key          = "stage_outputs/01_core_infra/outputs.json"
  content_type = "application/json"
  content = jsonencode({
    vpc_id                   = module.vpc.vpc_id
    installation_prefix      = var.installation_prefix
    public_subnet_ids        = module.vpc.public_subnet_ids
    private_build_subnet_ids = module.vpc.private_build_subnet_ids
    availability_zone_names  = module.vpc.availability_zone_names
    kms_key_id               = module.security.kms_key_id
    kms_key_arn              = module.security.kms_key_arn
    ssh_key_name             = module.security.ssh_key_name
    ssh_private_key_arn      = module.security.ssh_private_key_arn
    ssh_private_key_name     = module.security.ssh_private_key_name
    rt_ngw_a                 = module.vpc.rt_ngw_a
    rt_ngw_b                 = module.vpc.rt_ngw_b
    region                   = var.region
    private_hosted_zone_id   = module.dns.private_hosted_zone_id
    private_hosted_zone_arn  = module.dns.private_hosted_zone_arn
    sns_arn                  = aws_sns_topic.alarms.arn
    ecr_registry             = split("/", aws_ecr_repository.ecr_repo[0].repository_url)[0]
    zone                     = var.zone
    self_signed_cert_arn     =  data.aws_acm_certificate.self_signed_cert.arn
  })
}

resource "null_resource" "self_signed_cert" {
  provisioner "local-exec" {
  command = <<EOF
chmod +x self-signed-ssl
./self-signed-ssl \
  --no-interaction \
  --country="${var.self_signed_cert.country}" \
  --state="${var.self_signed_cert.state}" \
  --locality="${var.self_signed_cert.locality}" \
  --organization="${var.self_signed_cert.organization}" \
  --unit="${var.self_signed_cert.unit}" \
  --common-name="*.${var.zone}" \
  --san="*.${var.zone}"
cat "${var.zone}.crt" | base64 > "${var.zone}.crt.b64"
cat "${var.zone}.key" | base64 > "${var.zone}.key.b64"
aws acm import-certificate \
  --certificate "file://${var.zone}.crt.b64" \
  --private-key "file://${var.zone}.key.b64"
EOF
  }
}
