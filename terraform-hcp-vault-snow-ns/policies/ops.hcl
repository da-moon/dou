# Generate GCP Secrets
path "aws/*" {
  capabilities = ["read"]
}

path "kv/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# Manage tokens in the namespace
path "auth/token/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
