# vim: filetype=terraform syntax=terraform softtabstop=2 tabstop=2 shiftwidth=2 fileencoding=utf-8 commentstring=#%s expandtab
# code: language=terraform insertSpaces=true tabSize=2

# ─── NOTE ───────────────────────────────────────────────────────────────────────
# Enable OpenLDAP
# ────────────────────────────────────────────────────────────────────────────────
resource "vault_mount" "this" {
  type        = "openldap"
  path        = var.mount_point
  description = var.description
}

# ─── NOTES ──────────────────────────────────────────────────────────────────────
# setup a password policy for attaching it to server configurations
# ─── REFERENCES ─────────────────────────────────────────────────────────────────
# https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/password_policy
# https://www.vaultproject.io/docs/concepts/password-policies
# ────────────────────────────────────────────────────────────────────────────────
resource "vault_password_policy" "this" {
  name = local.password_policy
  policy = templatefile("${path.module}/templates/password-policy.hcl", {
    password_length = var.password_length
  })
}
# ─── NOTES ──────────────────────────────────────────────────────────────────────
# ─── REFERENCES ─────────────────────────────────────────────────────────────────
# Configure OpenLDAP secret engine
# https://www.vaultproject.io/api-docs/secret/openldap#parameters
# ────────────────────────────────────────────────────────────────────────────────
resource "vault_generic_endpoint" "config" {
  depends_on = [
    vault_mount.this,
    vault_password_policy.this,
  ]
  path                 = "${var.mount_point}/config"
  ignore_absent_fields = true
  disable_read         = true
  disable_delete       = true
  data_json = templatefile("${path.module}/templates/configure.json", {
    binddn          = var.binddn
    bindpass        = var.bindpass
    url             = local.url
   password_policy = vault_password_policy.this.name
    schema          = var.schema
    request_timeout = var.request_timeout
    starttls        = var.starttls
    insecure_tls    = local.insecure_tls
    certificate     = var.certificate
    client_tls_cert = var.client_tls_cert
    client_tls_key  = var.client_tls_key
  })
}