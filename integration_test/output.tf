output "region" {
  value = data.aws_region.current.name
}

output "lb_id" {
  description = "The ID and ARN of the load balancer we created."
  value       = module.alb-asg-pattern.lb_id
}

output "lb_arn" {
  description = "The ID and ARN of the load balancer we created."
  value       = module.alb-asg-pattern.lb_arn
}

output "autoscaling_group_name" {
  description = "The autoscaling group name"
  value       = module.alb-asg-pattern.autoscaling_group_name
}

output "autoscaling_group_arn" {
  description = "The ARN for this AutoScaling Group"
  value       = module.alb-asg-pattern.autoscaling_group_arn
}

output "desired_capacity" {
  value = data.aws_autoscaling_group.current.desired_capacity
}

output "max_size" {
  value = data.aws_autoscaling_group.current.max_size
}

output "min_size" {
  value = data.aws_autoscaling_group.current.min_size
}

output "target_group_arns" {
  value = data.aws_autoscaling_group.current.target_group_arns
}
