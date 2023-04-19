output "vault_private_endpoint" {
  value       = module.hcp.vault_private_endpoint_url
  description = "Private endpoint URL for the HCP Vault cluster"
}

output "vault_version" {
  value       = module.hcp.vault_version
  description = "Version of Vault that was deployed in HCP"
}

output "vault_tier" {
  value       = module.hcp.vault_tier
  description = "Tier of Vault that was deployed in HCP"
}
