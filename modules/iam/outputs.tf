output "eks_cluster_iam_role_name" {
  description = "EKS cluster role name IAM policy"
  value       = aws_iam_role.eks_cluster_iam_role.name
}

output "eks_cluster_iam_role_arn" {
  description = "EKS cluster role ARN IAM policy"
  value       = aws_iam_role.eks_cluster_iam_role.arn
}

output "eks_fargate_pod_execution_iam_role_name" {
  description = "EKS fargate role name IAM policy"
  value       = aws_iam_role.eks_fargate_pod_execution_iam_role.name
}

output "eks_fargate_pod_execution_iam_role_arn" {
  description = "EKS fargate arn IAM policy"
  value       = aws_iam_role.eks_fargate_pod_execution_iam_role.arn
}