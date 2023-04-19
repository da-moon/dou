# vim: filetype=terraform syntax=terraform softtabstop=2 tabstop=2 shiftwidth=2 fileencoding=utf-8 commentstring=#%s expandtab
# code: language=terraform insertSpaces=true tabSize=2

# ─── NOTE ───────────────────────────────────────────────────────────────────────
# configure OpenLDAP dynamic role
# ─── REFRENCES ──────────────────────────────────────────────────────────────────
# https://www.vaultproject.io/api-docs/secret/openldap#create-delete-dynamic-role-configuration
# https://www.vaultproject.io/api-docs/secret/openldap#sample-payload-2
# ────────────────────────────────────────────────────────────────────────────────
resource "vault_generic_endpoint" "role" {
  path                 = "${var.mount_point}/role/${local.role_name}"
  ignore_absent_fields = true
  disable_read         = true
  data_json = templatefile(local.role_template_file_path, {
    creation_ldif     = filebase64(local.creation_ldif_path)
    deletion_ldif     = filebase64(local.deletion_ldif_path)
    rollback_ldif     = filebase64(local.rollback_ldif_path)
    username_template = var.username_template
    default_ttl       = var.default_ttl
    max_ttl           = var.max_ttl
  })
}