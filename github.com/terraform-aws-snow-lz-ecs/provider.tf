# vim: filetype=terraform syntax=terraform softtabstop=2 tabstop=2 shiftwidth=2 fileencoding=utf-8 expandtab
# code: language=terraform insertSpaces=true tabSize=2
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.15"
    }
  }
}
#
# ──── AWS PROVIDER ──────────────────────────────────────────────────
#
provider "aws" {
  region     = var.aws_region
  access_key = local.aws_access_key
  secret_key = local.aws_secret_key
  token      = local.aws_token
  default_tags {
    tags = {
      Terraform   = "true"
      Environment = var.environment
      Project     = var.project_name
    }
  }
}

#
# ──── DOCKER PROVIDER ────────────────────────────────────────────────
#

# ─────────────────────────────────────────────────────────────────────
provider "docker" {
  alias = "docker-src"
  host  = var.docker_host
  registry_auth {
    address  = var.src_registry_url
    username = var.src_registry_username
    password = var.src_registry_password
  }
}

# ──── NOTE ──────────────────────────────────────────────────────────
# authenticates against ECR. it is used for pushing aliased Docker
# Image and is used for passing required information to
# configure destination Docker repository, i.e ECR repository
#
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ecr_authorization_token
# ─────────────────────────────────────────────────────────────────────
data "aws_ecr_authorization_token" "this" {}
provider "docker" {
  alias = "docker-dest"
  host  = var.docker_host
  registry_auth {
    address  = data.aws_ecr_authorization_token.this.proxy_endpoint
    username = data.aws_ecr_authorization_token.this.user_name
    password = data.aws_ecr_authorization_token.this.password
  }
}
