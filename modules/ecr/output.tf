# vim: filetype=terraform syntax=terraform softtabstop=2 tabstop=2 shiftwidth=2 fileencoding=utf-8 expandtab
# code: language=terraform insertSpaces=true tabSize=2

#
# ──── AWS_ECR_REPOSITORY OUTPUT ──────────────────────────────────────
#
output "arn" {
  depends_on = [aws_ecr_repository.this]
  value      = aws_ecr_repository.this.arn
  description = <<EOT
  Full ARN of the repository.
  EOT
}
output "registry_id" {
  depends_on = [aws_ecr_repository.this]
  value      = aws_ecr_repository.this.registry_id
  description = <<EOT
  The registry ID where the repository was created.
  EOT
}
output "url" {
  depends_on = [aws_ecr_repository.this]
  value      = aws_ecr_repository.this.repository_url
  description = <<EOT
  The URL of the repository in the form
  `<aws_account_id>.dkr.ecr.<region>.amazonaws.com/<repositoryName>`.
  EOT
}
output "tags_all" {
  depends_on = [aws_ecr_repository.this]
  value      = aws_ecr_repository.this.tags_all
  description = <<EOT
  A map of tags assigned to the resource, including those inherited
  from the provider `default_tags` configuration block
  EOT
}
output "kms_key_arn" {
  depends_on = [aws_kms_key.this]
  value      = aws_kms_key.this.arn
  description = <<EOT
  The Amazon Resource Name (ARN) of the key.
  EOT
}
output "kms_key_id" {
  depends_on = [aws_kms_key.this]
  value      = aws_kms_key.this.key_id
  description = <<EOT
  The globally unique identifier for the key.
  EOT
}
output "kms_key_tags_all" {
  depends_on = [aws_kms_key.this]
  value      = aws_kms_key.this.tags_all
  description = <<EOT
  A map of tags assigned to the resource, including those inherited
  from the provider `default_tags` configuration block
  EOT
}
#
# ──── AWS_KMS_ALIAS OUTPUT ──────────────────────────────────────────
#
output "kms_alias_arn" {
  depends_on = [aws_kms_key.this, aws_kms_alias.this]
  value      = aws_kms_alias.this.arn
  description = <<EOT
  The Amazon Resource Name (ARN) of the key alias.
  EOT
}
#
# ──── DOCKER_REGISTRY_IMAGE OUTPUT ──────────────────────────────────
#
output "images" {
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
    docker_registry_image.dest,
  ]
  value = sort(values(docker_registry_image.dest).*.name)
  description = <<EOT
  a list of docker image urls in the ERC repository
  EOT
}
output "digests" {
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
    docker_registry_image.dest,
  ]
  value = {
    for k, v in docker_registry_image.dest : k => v.sha256_digest
  }
  description = <<EOT
  a map of docker image to it's sha256 digest in the ECR repository
  EOT
}
