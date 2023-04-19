# Full capabilities on the secret engines but nothing on the sys/ endpoints
path "element2/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "element3/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "element21/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "element4/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "element5/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "element67/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "kv/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "kv2/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
