module "gitlab_owners" {
  source              = "./modules/gitlab"
  gitlab_access_level = "owner"
  gitlab_members      = sort(lookup(var.owner, "members"))
  gitlab_group_name   = "DigitalOnUs"
}

module "gitlab_maintainers" {
  source              = "./modules/gitlab"
  gitlab_access_level = "maintainer"
  gitlab_members      = sort(lookup(var.maintainer, "members"))
  gitlab_group_name   = var.gitlab_group_name
}

module "gitlab_developers" {
  source              = "./modules/gitlab"
  gitlab_access_level = "developer"
  gitlab_members      = sort(lookup(var.developer, "members"))
  gitlab_group_name   = var.gitlab_group_name
}

module "gitlab_reporters" {
  source              = "./modules/gitlab"
  gitlab_access_level = "reporter"
  gitlab_members      = sort(lookup(var.reporter, "members"))
  gitlab_group_name   = var.gitlab_group_name
}

module "gitlab_guests" {
  source              = "./modules/gitlab"
  gitlab_access_level = "guest"
  gitlab_members      = sort(lookup(var.guest, "members"))
  gitlab_group_name   = var.gitlab_group_name
}

data "gitlab_group" "gitlab_singularity_pega" {
  group_id = 13742413
}

data "gitlab_user" "gitlab_singularity_pega" {
  for_each = toset(sort(lookup(var.gitlab_solutions, "members")))
  username = each.key
}

resource "gitlab_group_membership" "gitlab_singularity_pega" {
  for_each     = toset(sort(lookup(var.gitlab_solutions, "members")))
  group_id     = data.gitlab_group.gitlab_singularity_pega.id
  user_id      = data.gitlab_user.gitlab_singularity_pega[each.key].id
  access_level = "maintainer"
}
