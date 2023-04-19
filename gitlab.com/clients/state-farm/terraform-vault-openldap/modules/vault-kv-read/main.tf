# vim: filetype=terraform syntax=terraform softtabstop=2 tabstop=2 shiftwidth=2 fileencoding=utf-8 commentstring=#%s expandtab
# code: language=terraform insertSpaces=true tabSize=2
data "vault_generic_secret" "this" {
  count = length(var.entry_path) > 0 ? 1 : 0
  path  = var.entry_path
}
output "test" {
  value = (
    length(data.vault_generic_secret.this) > 0 ?
    (
      length(data.vault_generic_secret.this[0].data) > 0 ?
      data.vault_generic_secret.this[0].data["binddn"] :
      ""
    ) :
    ""
  )
}
locals {
  binddn = (
    length(data.vault_generic_secret.this) > 0 ?
    (
      length(data.vault_generic_secret.this[0].data) > 0 ?
      data.vault_generic_secret.this[0].data["binddn"] :
      ""
    ) :
    ""
  )
  bindpass = (
    length(data.vault_generic_secret.this) > 0 ?
    (
      length(data.vault_generic_secret.this[0].data) > 0 ?
      data.vault_generic_secret.this[0].data["bindpass"] :
      ""
    ) :
    ""
  )
  certificate = (
    length(data.vault_generic_secret.this) > 0 ?
    (
      length(data.vault_generic_secret.this[0].data) > 0 ?
      data.vault_generic_secret.this[0].data["certificate"] :
      ""
    ) :
    ""
  )
  client_tls_cert = (
    length(data.vault_generic_secret.this) > 0 ?
    (
      length(data.vault_generic_secret.this[0].data) > 0 ?
      data.vault_generic_secret.this[0].data["client_tls_cert"] :
      ""
    ) :
    ""
  )
  client_tls_key = (
    length(data.vault_generic_secret.this) > 0 ?
    (
      length(data.vault_generic_secret.this[0].data) > 0 ?
      data.vault_generic_secret.this[0].data["client_tls_key"] :
      ""
    ) :
    ""
  )
}
