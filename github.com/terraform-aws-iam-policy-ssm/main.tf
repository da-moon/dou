resource "aws_iam_policy" "policy" {
  name        = var.role_name
  description = local.description
  path        = var.policy_path
  policy      = var.policy

  tags = var.tags
}