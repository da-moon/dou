output "lb_id" {
  description = "The ID and ARN of the load balancer we created."
  value       = module.alb-module.lb_id
}

output "lb_arn" {
  description = "The ID and ARN of the load balancer we created."
  value       = module.alb-module.lb_arn
}

output "autoscaling_group_name" {
  description = "The autoscaling group name"
  value       = module.autoscaling-module.autoscaling_group_name
}

output "autoscaling_group_arn" {
  description = "The ARN for this AutoScaling Group"
  value       = module.autoscaling-module.autoscaling_group_arn
}

output "build_data" {
  value       = module.datasource-module.data
  description = "VPC related data retrieved by names. Ex: AMI Ids, KMS Key Ids, SGs."
}

output "identity_arn" {
  description = "The ARN for this current identity"
  value       = data.aws_caller_identity.current.arn
}
