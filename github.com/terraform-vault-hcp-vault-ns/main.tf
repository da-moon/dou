resource "vault_namespace" "ns" {
  provider = vault.admin

  path = var.new_ns
}

resource "vault_auth_backend" "auth" {
  provider = vault.new_ns

  type        = var.auth_type
  description = var.auth_desc
  path        = var.auth_path
  tune {
    default_lease_ttl = var.default_lease_ttl
    max_lease_ttl     = var.max_lease_ttl
  }
  depends_on = [
    vault_namespace.ns
  ]
}

data "vault_policy_document" "admin_policy" {
  provider = vault.new_ns

  rule {
    path         = "*"
    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
    description  = "Policy that allows everything. When given to a token in a namespace, will be like a namespace-root token"
  }
}

resource "vault_policy" "policy" {
  provider = vault.new_ns

  name   = "${var.new_ns}-admin-policy"
  policy = data.vault_policy_document.admin_policy.hcl
  depends_on = [
    vault_auth_backend.auth
  ]
}

resource "vault_approle_auth_backend_role" "role" {
  provider = vault.new_ns

  backend        = vault_auth_backend.auth.path
  role_name      = var.role_name
  token_policies = [vault_policy.policy.name]
  depends_on = [
    vault_auth_backend.auth
  ]
}

resource "vault_approle_auth_backend_role_secret_id" "secret" {
  provider = vault.new_ns

  backend   = vault_auth_backend.auth.path
  role_name = vault_approle_auth_backend_role.role.role_name
  depends_on = [
    vault_auth_backend.auth
  ]
}

// looks up the workspace where we are going to push the role / secret id
data "tfe_workspace" "target_workspace" {
  name         = var.tfc_target_workspace
  organization = var.tfc_organization
}

// sets the role_id variable on the destination workspace
resource "tfe_variable" "role_id" {
  key          = "role_id"
  value        = vault_approle_auth_backend_role.role.role_id
  category     = "terraform"
  workspace_id = data.tfe_workspace.target_workspace.id
  description  = "HCP Vault Namespace Admin Role ID"
  sensitive    = true
}

// sets the secret_id variable on the destination workspace
resource "tfe_variable" "secret_id" {
  key          = "secret_id"
  value        = vault_approle_auth_backend_role_secret_id.secret.secret_id
  category     = "terraform"
  workspace_id = data.tfe_workspace.target_workspace.id
  description  = "HCP Vault Namespace Admin Secret Role ID"
  sensitive    = true
}

// sets the namespace variable on the destination workspace
resource "tfe_variable" "namespace" {
  key          = "namespace"
  value        = vault_namespace.ns.path
  category     = "terraform"
  workspace_id = data.tfe_workspace.target_workspace.id
  description  = "HCP Vault Namespace"
  sensitive    = false
}
