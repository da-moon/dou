########
# Role #
########

resource "aws_iam_role" "role" {
  name               = var.name
  assume_role_policy = var.policy
  description        = var.description
  path               = var.path

  force_detach_policies = var.force_detach_policies
  managed_policy_arns   = var.managed_policy_arns
  max_session_duration  = var.max_session_duration
  permissions_boundary  = var.permissions_boundary

  dynamic "inline_policy" {
    for_each = var.inline_policy
    content {
      name   = inline_policy.name
      policy = inline_policy.policy
    }
  }

  tags = var.tags
}