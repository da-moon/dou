resource "vault_auth_backend" "admin_approle" {
  type        = "approle"
  description = var.admin_approle_description
  path        = var.admin_approle_path
}

resource "vault_approle_auth_backend_role_secret_id" "admin_approle" {
  backend   = vault_auth_backend.admin_approle.path
  role_name = vault_approle_auth_backend_role.admin_approle.role_name
}

resource "vault_approle_auth_backend_role" "admin_approle" {
  backend        = vault_auth_backend.admin_approle.path
  role_name      = var.admin_approle_name
  token_policies = var.admin_approle_policy
}


# Creates the variables in the target workspace and pushes the values for the approle secret and role id
module "approle_push" {
  source       = "kalenarndt/variable-push/tfe"
  version      = ">=0.0.3"
  organization = var.tfc_organization
  workspace    = var.tfc_target_workspace
  variables = {
    secret_id = {
      category    = "terraform"
      description = "(Required) HCP Vault Namespace Admin Secret Role ID"
      sensitive   = true
      hcl         = false
      value       = vault_approle_auth_backend_role_secret_id.admin_approle.secret_id
    },
    role_id = {
      category    = "terraform"
      description = "(Required) HCP Vault Namespace Admin Role ID"
      sensitive   = true
      hcl         = false
      value       = vault_approle_auth_backend_role.admin_approle.role_id
    },
  }
}
