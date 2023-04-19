# vim: filetype=terraform syntax=terraform softtabstop=2 tabstop=2 shiftwidth=2 fileencoding=utf-8 expandtab
# code: language=terraform insertSpaces=true tabSize=2

#
# ──── SOURCE DOCKER IMAGE ────────────────────────────────────────────
#

# ──── NOTE ──────────────────────────────────────────────────────────
# this resource provides required information for the Docker image
# in source repository
#
# https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs/data-sources/image
# ─────────────────────────────────────────────────────────────────────
data "docker_registry_image" "src" {
  for_each = toset(var.docker_image_tags)
  provider = docker.docker-src
  name     = "${var.docker_image_name}:${each.key}"
}

# ──── NOTE ──────────────────────────────────────────────────────────
# this resource is used for pulling the source Docker image
# from it's repository.
#
# https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs/resources/image
# ─────────────────────────────────────────────────────────────────────
resource "docker_image" "src" {
  provider      = docker.docker-src
  depends_on    = [data.docker_registry_image.src]
  for_each      = data.docker_registry_image.src
  name          = each.value.name
  pull_triggers = [each.value.sha256_digest]
  force_remove  = true
}

#
# ──── AWS ECR ────────────────────────────────────────────────────────
#

# ──── NOTE ──────────────────────────────────────────────────────────
# creates a KMS key to encrypt the repository
#
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key
# ─────────────────────────────────────────────────────────────────────
resource "aws_kms_key" "this" {
  description         = "KMS key used with '${var.project_name}' ECR repository"
  enable_key_rotation = true
  tags = {
    Name = "${var.project_name}-ecr-kms-key"
  }
}
# ──── NOTE ──────────────────────────────────────────────────────────
# sets up an alias for KMS key to make it more human-friendly
#
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias
# ─────────────────────────────────────────────────────────────────────
resource "aws_kms_alias" "this" {
  depends_on = [
    aws_kms_key.this,
  ]
  name          = "alias/${var.project_name}"
  target_key_id = aws_kms_key.this.key_id
}

# ──── NOTE ──────────────────────────────────────────────────────────
# create an encrypted ECR repository
#
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository
# ─────────────────────────────────────────────────────────────────────
resource "aws_ecr_repository" "this" {
  depends_on = [
    aws_kms_key.this,
  ]
  name                 = var.project_name
  image_tag_mutability = "IMMUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
  encryption_configuration {
    encryption_type = "KMS"
    kms_key         = aws_kms_key.this.key_id
  }
  tags = {
    Name = "${var.project_name}-ecr-repository"
  }
}
# ──── NOTE ──────────────────────────────────────────────────────────
# reads ECR repository policy from a JSON file on disk
# ─────────────────────────────────────────────────────────────────────
data "local_file" "aws_ecr_repository_policy" {
  filename = "${path.module}/files/aws/ecr_repository_policy.json"
}
# ──── NOTE ──────────────────────────────────────────────────────────
# applies a policy to a repository in Elastic Container Registry
#
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository_policy
# ─────────────────────────────────────────────────────────────────────
resource "aws_ecr_repository_policy" "this" {
  depends_on = [
    aws_ecr_repository.this,
    data.local_file.aws_ecr_repository_policy,
  ]
  repository = aws_ecr_repository.this.name
  policy     = data.local_file.aws_ecr_repository_policy.content
}

# ──── NOTE ──────────────────────────────────────────────────────────
# Renders lifecycle policy template of Elastic Container Registry
# repository
# ─────────────────────────────────────────────────────────────────────
data "template_file" "ecr_lifecyle_policy" {
  template = file("${path.module}/templates/aws/ecr_lifecycle_policy.json.tpl")
  vars = {
    countNumber = var.lifecyle_policy_image_count
  }
}
# ──── NOTE ──────────────────────────────────────────────────────────
# sets a policy to control lifecycle of images in the repository
#
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_lifecycle_policy
# ─────────────────────────────────────────────────────────────────────
resource "aws_ecr_lifecycle_policy" "this" {
  depends_on = [
    aws_ecr_repository.this,
    data.template_file.ecr_lifecyle_policy,
  ]
  repository = aws_ecr_repository.this.name
  policy     = data.template_file.ecr_lifecyle_policy.rendered
}
# ──── NOTE ──────────────────────────────────────────────────────────
# This resource pushes source image to destination
# repository, i.e ECR repository.
#
# the Dockerfile is used by this resource
# is essentialy an alias, used for mirroring
# the source image to ECR as Terraform's Docker provider
# is not able to rename and push an existing image but it can build
# and push an image
#
# https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs/resources/registry_image
# ─────────────────────────────────────────────────────────────────────
resource "docker_registry_image" "dest" {
  depends_on = [
    data.local_file.aws_ecr_repository_policy,
    data.template_file.ecr_lifecyle_policy,
    data.docker_registry_image.src,
    aws_kms_key.this,
    aws_kms_alias.this,
    aws_ecr_repository.this,
    aws_ecr_lifecycle_policy.this,
    aws_ecr_repository_policy.this,
    docker_image.src,
  ]
  for_each = data.docker_registry_image.src
  provider = docker.docker-dest
  name     = "${aws_ecr_repository.this.repository_url}:${each.key}"
  build {
    context    = abspath("${path.module}/files/docker")
    dockerfile = "Dockerfile"
    build_args = {
      "DOCKER_IMAGE" = var.docker_image_name
      "TAG"          = each.key
    }
  }
}
