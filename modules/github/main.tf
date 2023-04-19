#terraform 14+
terraform {
  required_providers {
    github = {
      source = "integrations/github"
    }
  }
}

resource "github_team" "team" {
  name        = var.github_team
  description = "Terraform provisioned Team: ${var.github_team}"
  privacy     = "closed"
}

resource "github_team_membership" "members" {
  for_each = toset(var.github_members)

  team_id  = github_team.team.id
  username = each.value
  role     = "member"
}

resource "github_team_membership" "maintainers" {
  for_each = toset(var.github_maintainers)

  team_id  = github_team.team.id
  username = each.value
  role     = "maintainer"
}
