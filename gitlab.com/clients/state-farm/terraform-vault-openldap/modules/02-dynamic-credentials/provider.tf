# vim: filetype=terraform syntax=terraform softtabstop=2 tabstop=2 shiftwidth=2 fileencoding=utf-8 commentstring=#%s expandtab
# code: language=terraform insertSpaces=true tabSize=2
terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "3.1.1"
    }
  }
}