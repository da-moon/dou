// Loop that creates multiple policies in Vault based on a map
resource "vault_policy" "policies" {
  for_each = fileset("${path.module}/policies", "*.hcl")
  name     = trimsuffix(each.value, ".hcl")
  policy   = file("${path.module}/policies/${each.value}")
}

// Creates an Approle Role ID
resource "vault_approle_auth_backend_role" "approle_id" {
  backend        = var.approle_path
  role_name      = var.approle_role_name
  token_policies = var.approle_role_policies
}


// Creates Approle Secret ID
resource "vault_approle_auth_backend_role_secret_id" "approle_secret" {
  backend   = var.approle_path
  role_name = vault_approle_auth_backend_role.approle_id.role_name
}
