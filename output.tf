output "cluster_name" {
  value = aws_ecs_cluster.cluster.name
}

output "asg_name" {
  value = aws_autoscaling_group.ecs.name
}

output "cluster_arn" {
  value = aws_ecs_cluster.cluster.id
}

