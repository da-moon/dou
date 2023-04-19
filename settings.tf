provider "vault" {
  # address   = var.vault_address
  alias     = "new_ns"
  namespace = "${var.admin_namespace}/${var.new_ns}"
  auth_login {
    path      = "auth/approle/login"
    namespace = var.admin_namespace
    parameters = {
      role_id   = var.role_id
      secret_id = var.secret_id
    }
  }
}
