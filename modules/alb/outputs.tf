# vim: filetype=terraform syntax=terraform softtabstop=2 tabstop=2 shiftwidth=2 fileencoding=utf-8 expandtab
# code: language=terraform insertSpaces=true tabSize=2

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
# ──── AWS_LB OUTPUT ──────────────────────────────────────────────────
#
output "id" {
  depends_on  = [aws_lb.this]
  value       = aws_lb.this.id
  description = <<EOT
  The ARN of the load balancer (matches `arn`).
  EOT
}
output "arn" {
  depends_on  = [aws_lb.this]
  value       = aws_lb.this.arn
  description = <<EOT
  The ARN of the load balancer (matches `id`).
  EOT
}
output "arn_suffix" {
  depends_on  = [aws_lb.this]
  value       = aws_lb.this.arn_suffix
  description = <<EOT
  The ARN suffix for use with CloudWatch Metrics.
  EOT
}
output "dns_name" {
  depends_on  = [aws_lb.this]
  value       = aws_lb.this.dns_name
  description = <<EOT
  The DNS name of the load balancer.
  EOT
}
output "tags_all" {
  depends_on  = [aws_lb.this]
  value       = aws_lb.this.tags_all
  description = <<EOT
  A map of tags assigned to the resource, including those inherited from the
  provider `default_tags` configuration block
  EOT
}
output "zone_id" {
  depends_on  = [aws_lb.this]
  value       = aws_lb.this.zone_id
  description = <<EOT
  The canonical hosted zone ID of the load balancer to be used in a Route 53
  Alias record.
  EOT
}
output "subnet_mappings_output_id" {
  depends_on  = [aws_lb.this]
  value       = aws_lb.this.subnet_mapping.*.outpost_id
  description = <<EOT
  ID of the Outpost containing the load balancer.
  EOT
}
#
# ──── AWS_LB_TARGET_GROUP OUTPUT ────────────────────────────────────
#
output "target_group_arn_suffix" {
  depends_on  = [aws_lb_target_group.this]
  value       = aws_lb_target_group.this.arn_suffix
  description = <<EOT
  ARN suffix for use with CloudWatch Metrics.
  EOT
}
output "target_group_arn" {
  depends_on  = [aws_lb_target_group.this]
  value       = aws_lb_target_group.this.arn
  description = <<EOT
  ARN of the Target Group (matches `id`).
  EOT
}
output "target_group_id" {
  depends_on  = [aws_lb_target_group.this]
  value       = aws_lb_target_group.this.id
  description = <<EOT
  ARN of the Target Group (matches `arn`).
  EOT
}
output "target_group_name" {
  depends_on  = [aws_lb_target_group.this]
  value       = aws_lb_target_group.this.name
  description = <<EOT
  Name of the Target Group.
  EOT
}
output "target_group_tags_all" {
  depends_on  = [aws_lb_target_group.this]
  value       = aws_lb_target_group.this.tags_all
  description = <<EOT
  A map of tags assigned to the resource, including those inherited from the
  provider `default_tags` configuration block
  EOT
}
#
# ──── AWS_LB_LISTENER OUTPUT ────────────────────────────────────────
#
output "listener_arn" {
  depends_on  = [aws_lb_listener.this]
  value       = aws_lb_listener.this.arn
  description = <<EOT
  ARN of the listener (matches `id`).
  EOT
}
output "listener_id" {
  depends_on  = [aws_lb_listener.this]
  value       = aws_lb_listener.this.id
  description = <<EOT
  ID of the listener (matches `arn`).
  EOT
}
output "listener_tags_all" {
  depends_on  = [aws_lb_listener.this]
  value       = aws_lb_listener.this.tags_all
  description = <<EOT
  from the provider `default_tags` configuration block
  EOT
}

