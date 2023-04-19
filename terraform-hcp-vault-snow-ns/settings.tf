provider "vault" {
  auth_login {
    path      = "auth/approle/login"
    namespace = "admin/${var.namespace}"
    parameters = {
      role_id   = var.role_id
      secret_id = var.secret_id
    }
  }
}

provider "tfe" {
  # using env vars for authentication
}
