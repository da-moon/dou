#terraform 14
terraform {
  required_providers {
    gitlab = {
      source = "gitlabhq/gitlab"
    }
  }
}

data "gitlab_user" "user" {
  for_each = toset(var.gitlab_members)
  username = each.value
}

data "gitlab_group" "group" {
  full_path = var.gitlab_group_name
}

resource "gitlab_group_membership" "member" {
  for_each     = toset(var.gitlab_members)
  group_id     = data.gitlab_group.group.id
  user_id      = data.gitlab_user.user[each.key].id
  access_level = var.gitlab_access_level
}