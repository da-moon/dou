output "cluster_name" {
  value = aws_ecs_cluster.cluster.name
}

output "cluster_arn" {
  value = aws_ecs_cluster.cluster.id
}

