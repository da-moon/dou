module "vault_namespaces" {
  source               = "app.terraform.io/DoU-TFE/hcp-vault-ns/vault"
  version              = "~>0.0.1"
  role_id              = var.role_id
  secret_id            = var.secret_id
  tfc_target_workspace = var.tfc_vault_workspace
  tfc_organization     = var.tfc_organization
  new_ns               = "snow"
  role_name            = "admin"
  providers = {
    vault.admin = vault.admin
  }
}
