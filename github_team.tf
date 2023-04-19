locals {
  digitalonus_team = sort(setunion(
    lookup(var.devops_team, "maintainers"),
    lookup(var.devops_team, "members"),
    lookup(var.development_team, "members"),
    lookup(var.development_team, "maintainers"),
    lookup(var.qe_team, "members"),
    lookup(var.qe_team, "maintainers"),
    lookup(var.innovation_team, "members"),
    lookup(var.innovation_team, "maintainers"),
    lookup(var.caas_team, "members"),
    lookup(var.caas_team, "maintainers")
  ))
}

module "devops" {
  source             = "./modules/github"
  github_team        = "devops"
  github_members     = sort(lookup(var.devops_team, "members"))
  github_maintainers = sort(lookup(var.devops_team, "maintainers"))
}

module "development" {
  source             = "./modules/github"
  github_team        = "development"
  github_members     = sort(lookup(var.development_team, "members"))
  github_maintainers = sort(lookup(var.development_team, "maintainers"))
}

module "qe" {
  source             = "./modules/github"
  github_team        = "qe"
  github_members     = sort(lookup(var.qe_team, "members"))
  github_maintainers = sort(lookup(var.qe_team, "maintainers"))
}

module "innovation" {
  source             = "./modules/github"
  github_team        = "innovation"
  github_members     = sort(lookup(var.innovation_team, "members"))
  github_maintainers = sort(lookup(var.innovation_team, "maintainers"))
}

module "caas" {
  source             = "./modules/github"
  github_team        = "caas"
  github_members     = sort(lookup(var.caas_team, "members"))
  github_maintainers = sort(lookup(var.caas_team, "maintainers"))
}

module "digitalonus" {
  source             = "./modules/github"
  github_team        = "digitalonus"
  github_members     = local.digitalonus_team
  github_maintainers = var.admin_team
}

resource "github_membership" "admin" {
  for_each = toset(var.admin_team)
  username = each.key
  role     = "admin"
}

#resource "github_repository" "example" {
#  name        = "example"
#  description = "My awesome codebase"
#
#  private = false
#}
