# Data lookups
## Organization name
data "tfe_organization" "this_org" {
  name = var.organization
}

data "tfe_agent_pool" "this_pool" {
  count        = var.workspace_agents ? 1 : 0
  name         = var.agent_pool_name
  organization = data.tfe_organization.this_org.name
}

###################################################
# Resources
## Workspace setup
resource "tfe_workspace" "this_ws" {
  name                      = var.workspace_name
  organization              = data.tfe_organization.this_org.name
  description               = var.workspace_description
  tag_names                 = var.workspace_tags
  terraform_version         = (var.workspace_terraform_version == "latest" ? null : var.workspace_terraform_version)
  working_directory         = (var.workspace_vcs_directory == "root_directory" ? null : var.workspace_vcs_directory)
  queue_all_runs            = false
  auto_apply                = var.workspace_auto_apply
  agent_pool_id             = var.workspace_agents == true ? data.tfe_agent_pool.this_pool[0].id : null
  execution_mode            = var.workspace_agents == true ? "agent" : "remote"
  remote_state_consumer_ids = var.remote_state == true ? var.remote_state_consumers : null

  dynamic "vcs_repo" {
    for_each = lookup(var.vcs_repo, "identifier", null) == null ? [] : [var.vcs_repo]

    content {
      identifier         = lookup(vcs_repo.value, "identifier", null)
      branch             = lookup(vcs_repo.value, "branch", null)
      ingress_submodules = lookup(vcs_repo.value, "ingress_submodules", null)
      oauth_token_id     = lookup(vcs_repo.value, "oauth_token_id", null)
    }
  }
}

## Variables
resource "tfe_variable" "variables" {
  for_each     = var.variables
  workspace_id = tfe_workspace.this_ws.id
  key          = each.key
  value        = each.value["value"]
  description  = lookup(each.value, "description", null)
  category     = lookup(each.value, "category", "terraform")
  sensitive    = lookup(each.value, "sensitive", false)
  hcl          = lookup(each.value, "hcl", false)
}
