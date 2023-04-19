provider "vault" {
  alias = "admin"
  auth_login {
    path      = "auth/approle/login"
    namespace = "admin"
    parameters = {
      role_id   = var.role_id
      secret_id = var.secret_id
    }
  }
}
