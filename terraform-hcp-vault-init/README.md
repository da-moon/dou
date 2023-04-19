# terraform-hcp-vault-init

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=3.51.0 |
| <a name="requirement_hcp"></a> [hcp](#requirement\_hcp) | >=0.10.0 |
| <a name="requirement_tfe"></a> [tfe](#requirement\_tfe) | >=0.26.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tfe"></a> [tfe](#provider\_tfe) | 0.32.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_hcp"></a> [hcp](#module\_hcp) | kalenarndt/hcp/hcp | >=0.0.6 |
| <a name="module_vault_general"></a> [vault\_general](#module\_vault\_general) | kalenarndt/variable-sets/tfe | >=0.0.5 |

## Resources

| Name | Type |
|------|------|
| [tfe_variable.root_token](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_outputs.aws](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/data-sources/outputs) | data source |
| [tfe_workspace.target_workspace](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/data-sources/workspace) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloud_provider"></a> [cloud\_provider](#input\_cloud\_provider) | The cloud provider of the HCP HVN, HCP Vault, or HCP Consul cluster. | `string` | `"aws"` | no |
| <a name="input_generate_vault_token"></a> [generate\_vault\_token](#input\_generate\_vault\_token) | Flag to generate HCP Vault admin token | `bool` | `true` | no |
| <a name="input_hcp_region"></a> [hcp\_region](#input\_hcp\_region) | (Required) Region where the HCP Vault cluster will be deployed | `string` | n/a | yes |
| <a name="input_hvn_cidr_block"></a> [hvn\_cidr\_block](#input\_hvn\_cidr\_block) | CIDR block for the Hashicorp Virtual Network in HCP | `string` | `"172.25.16.0/20"` | no |
| <a name="input_hvn_vault_id"></a> [hvn\_vault\_id](#input\_hvn\_vault\_id) | The ID of the HCP Vault HVN. | `string` | `"hcp-vault-hvn"` | no |
| <a name="input_min_vault_version"></a> [min\_vault\_version](#input\_min\_vault\_version) | Minimum Vault version to use when creating the cluster. If null, defaults to HCP recommended version | `string` | `""` | no |
| <a name="input_tfc_aws_networking_workspace"></a> [tfc\_aws\_networking\_workspace](#input\_tfc\_aws\_networking\_workspace) | Name of the Workspace where the AWS networking configuration has been generated | `string` | n/a | yes |
| <a name="input_tfc_organization"></a> [tfc\_organization](#input\_tfc\_organization) | TFC organization where we will retrieve remote state | `string` | n/a | yes |
| <a name="input_tfc_vault_admin_workspace"></a> [tfc\_vault\_admin\_workspace](#input\_tfc\_vault\_admin\_workspace) | Name of the Workspace where the root token will be pushed for the initial configuration | `string` | n/a | yes |
| <a name="input_vault_cluster_name"></a> [vault\_cluster\_name](#input\_vault\_cluster\_name) | The name (id) of the HCP Vault cluster. | `string` | `"hcp-vault-cluster"` | no |
| <a name="input_vault_tier"></a> [vault\_tier](#input\_vault\_tier) | Tier to provision in HCP Vault - dev, standard\_small, standard\_medium, standard\_large | `string` | `"dev"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vault_private_endpoint"></a> [vault\_private\_endpoint](#output\_vault\_private\_endpoint) | Private endpoint URL for the HCP Vault cluster |
| <a name="output_vault_tier"></a> [vault\_tier](#output\_vault\_tier) | Tier of Vault that was deployed in HCP |
| <a name="output_vault_version"></a> [vault\_version](#output\_vault\_version) | Version of Vault that was deployed in HCP |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
