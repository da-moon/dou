# Remote Outputs for AWS Networking
data "tfe_outputs" "aws" {
  organization = var.tfc_organization
  workspace    = var.tfc_aws_networking_workspace
}

module "hcp" {
  source  = "kalenarndt/hcp/hcp"
  version = ">=0.0.6"

  region = var.hcp_region

  # Vault
  create_vault_cluster = true
  vault_tier           = "dev"
  generate_vault_token = true
  output_vault_token   = true

  # Networking
  single_hvn         = true
  transit_gateway    = true
  vpc_peering        = false
  hvn_cidr_block     = var.hvn_cidr_block
  destination_cidr   = data.tfe_outputs.aws.values.vpc_cidr
  resource_share_arn = data.tfe_outputs.aws.values.resource_share_arn
  transit_gw_id      = data.tfe_outputs.aws.values.transit_gw
}

### TFC Variable Pushes
data "tfe_workspace" "target_workspace" {
  name         = var.tfc_vault_admin_workspace
  organization = var.tfc_organization
}

resource "tfe_variable" "root_token" {
  key          = "VAULT_TOKEN"
  value        = module.hcp.vault_token
  category     = "env"
  workspace_id = data.tfe_workspace.target_workspace.id
  description  = "HCP Vault root token (expires every 6 hours)"
  sensitive    = true
}

## Module call for general variables
module "vault_general" {
  source              = "kalenarndt/variable-sets/tfe"
  version             = ">=0.0.5"
  organization        = var.tfc_organization
  create_variable_set = true
  variable_set_name   = "hcp-vault-general"
  tags                = ["vault"]
  variables = {
    VAULT_ADDR = {
      category    = "env"
      description = "(Required) HCP Vault Private Address"
      sensitive   = true
      hcl         = false
      value       = module.hcp.vault_private_endpoint_url
    },
  }
}
