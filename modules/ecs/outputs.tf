# vim: filetype=terraform syntax=terraform softtabstop=2 tabstop=2 shiftwidth=2 fileencoding=utf-8 expandtab
# code: language=terraform insertSpaces=true tabSize=2

#
# ──── AWS_IAM_ROLE OUTPUT ────────────────────────────────────────────
#
output "task_execution_iam_role_arn" {
  depends_on = [
    data.aws_iam_policy_document.task_execution,
    aws_iam_role.task_execution,
  ]
  value       = aws_iam_role.task_execution.arn
  description = <<EOT
  Amazon Resource Name (ARN) specifying the role.
  EOT
}
output "task_execution_iam_role_create_date" {
  depends_on = [
    data.aws_iam_policy_document.task_execution,
    aws_iam_role.task_execution,
  ]
  value       = aws_iam_role.task_execution.create_date
  description = <<EOT
  Creation date of the IAM role.
  EOT
}
output "task_execution_iam_role_id" {
  depends_on = [
    data.aws_iam_policy_document.task_execution,
    aws_iam_role.task_execution,
  ]
  value       = aws_iam_role.task_execution.id
  description = <<EOT
  Name of the role.
  EOT
}
output "task_execution_iam_role_name" {
  depends_on = [
    data.aws_iam_policy_document.task_execution,
    aws_iam_role.task_execution,
  ]
  value       = aws_iam_role.task_execution.name
  description = <<EOT
  Name of the role.
  EOT
}
output "task_execution_iam_role_tags_all" {
  depends_on = [
    data.aws_iam_policy_document.task_execution,
    aws_iam_role.task_execution,
  ]
  value       = aws_iam_role.task_execution.tags_all
  description = <<EOT
  A map of tags assigned to the resource, including those inherited from the
  provider `default_tags` configuration block
  EOT
}
output "task_execution_iam_role_unique_id" {
  depends_on = [
    data.aws_iam_policy_document.task_execution,
    aws_iam_role.task_execution,
  ]
  value       = aws_iam_role.task_execution.unique_id
  description = <<EOT
  Stable and unique string identifying the role.
  EOT
}
#
# ──── AWS_ECS_TASK_DEFINITION OUTPUT ────────────────────────────────
#
output "task_definition_arn" {
  depends_on = [
    data.aws_iam_policy_document.task_execution,
    aws_iam_role.task_execution,
    data.template_file.container_definitions,
    aws_ecs_task_definition.this,
  ]
  value       = aws_ecs_task_definition.this.arn
  description = <<EOT
  Full ARN of the Task Definition (including both `family` and `revision`).
  EOT
}
output "task_definition_revision" {
  depends_on = [
    data.aws_iam_policy_document.task_execution,
    aws_iam_role.task_execution,
    data.template_file.container_definitions,
    aws_ecs_task_definition.this,
  ]
  value       = aws_ecs_task_definition.this.revision
  description = <<EOT
  Revision of the task in a particular family.
  EOT
}
output "task_definition_tags_all" {
  depends_on = [
    data.aws_iam_policy_document.task_execution,
    aws_iam_role.task_execution,
    data.template_file.container_definitions,
    aws_ecs_task_definition.this,
  ]
  value       = aws_ecs_task_definition.this.tags_all
  description = <<EOT
  A map of tags assigned to the resource, including those inherited from the
  provider `default_tags` configuration block
  EOT
}
#
# ──── AWS_ECS_CLUSTER OUTPUT ────────────────────────────────────────
#
output "cluster_arn" {
  depends_on  = [aws_ecs_cluster.this]
  value       = aws_ecs_cluster.this.arn
  description = <<EOT
  ARN that identifies the cluster.
  EOT
}
output "cluster_id" {
  depends_on  = [aws_ecs_cluster.this]
  value       = aws_ecs_cluster.this.id
  description = <<EOT
  unique string that identifies the cluster.
  EOT
}
output "cluster_tags_all" {
  depends_on  = [aws_ecs_cluster.this]
  value       = aws_ecs_cluster.this.tags_all
  description = <<EOT
  A map of tags assigned to the resource, including those inherited from the
  provider `default_tags` configuration block
  EOT
}
#
# ──── AWS_SECURITY_GROUP OUTPUT ──────────────────────────────────────
#
output "security_group_arn" {
  depends_on  = [aws_security_group.this]
  value       = aws_security_group.this.arn
  description = <<EOT
  ARN of the security group.
  EOT
}
output "security_group_id" {
  depends_on  = [aws_security_group.this]
  value       = aws_security_group.this.id
  description = <<EOT
  ID of the security group.
  EOT
}
output "security_group_owner_id" {
  depends_on  = [aws_security_group.this]
  value       = aws_security_group.this.owner_id
  description = <<EOT
  Owner ID.
  EOT
}
output "security_group_tags_all" {
  depends_on  = [aws_security_group.this]
  value       = aws_security_group.this.tags_all
  description = <<EOT
  A map of tags assigned to the resource, including those inherited from the
  provider `default_tags` configuration block
  EOT
}
#
# ──── AWS_ECS_SERVICE OUTPUT ────────────────────────────────────────
#
output "cluster" {
  depends_on = [
    data.aws_iam_policy_document.task_execution,
    aws_iam_role.task_execution,
    data.template_file.container_definitions,
    aws_ecs_cluster.this,
    aws_ecs_task_definition.this,
    aws_security_group.this,
    aws_ecs_service.this,
  ]
  value       = aws_ecs_service.this.cluster
  description = <<EOT
  Amazon Resource Name (ARN) of cluster which the service runs on.
  EOT
}
output "desired_count" {
  depends_on = [
    data.aws_iam_policy_document.task_execution,
    aws_iam_role.task_execution,
    data.template_file.container_definitions,
    aws_ecs_cluster.this,
    aws_ecs_task_definition.this,
    aws_security_group.this,
    aws_ecs_service.this,
  ]
  value       = aws_ecs_service.this.desired_count
  description = <<EOT
  Number of instances of the task definition.
  EOT
}
output "iam_role" {
  depends_on = [
    data.aws_iam_policy_document.task_execution,
    aws_iam_role.task_execution,
    data.template_file.container_definitions,
    aws_ecs_cluster.this,
    aws_ecs_task_definition.this,
    aws_security_group.this,
    aws_ecs_service.this,
  ]
  value       = aws_ecs_service.this.iam_role
  description = <<EOT
  ARN of IAM role used for ELB.
  EOT
}
output "id" {
  depends_on = [
    data.aws_iam_policy_document.task_execution,
    aws_iam_role.task_execution,
    data.template_file.container_definitions,
    aws_ecs_cluster.this,
    aws_ecs_task_definition.this,
    aws_security_group.this,
    aws_ecs_service.this,
  ]
  value       = aws_ecs_service.this.id
  description = <<EOT
  ARN that identifies the service.
  EOT
}
output "name" {
  depends_on = [
    data.aws_iam_policy_document.task_execution,
    aws_iam_role.task_execution,
    data.template_file.container_definitions,
    aws_ecs_cluster.this,
    aws_ecs_task_definition.this,
    aws_security_group.this,
    aws_ecs_service.this,
  ]
  value       = aws_ecs_service.this.name
  description = <<EOT
  Name of the service.
  EOT
}
output "tags_all" {
  depends_on = [
    data.aws_iam_policy_document.task_execution,
    aws_iam_role.task_execution,
    data.template_file.container_definitions,
    aws_ecs_cluster.this,
    aws_ecs_task_definition.this,
    aws_security_group.this,
    aws_ecs_service.this,
  ]
  value       = aws_ecs_service.this.tags_all
  description = <<EOT
  A map of tags assigned to the resource, including those inherited from the
  provider `default_tags` configuration block
  EOT
}
