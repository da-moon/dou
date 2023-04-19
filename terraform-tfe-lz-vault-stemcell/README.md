# terraform-tfe-lz-vault-stemcell

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.0.0 |
| <a name="requirement_tfe"></a> [tfe](#requirement\_tfe) | >=0.26.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tfe"></a> [tfe](#provider\_tfe) | 0.32.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_credentials"></a> [aws\_credentials](#module\_aws\_credentials) | kalenarndt/variable-sets/tfe | 0.0.7 |
| <a name="module_aws_general"></a> [aws\_general](#module\_aws\_general) | kalenarndt/variable-sets/tfe | 0.0.7 |
| <a name="module_cloud_networking"></a> [cloud\_networking](#module\_cloud\_networking) | kalenarndt/variable-sets/tfe | 0.0.7 |
| <a name="module_hcp-vault-admin-workspace"></a> [hcp-vault-admin-workspace](#module\_hcp-vault-admin-workspace) | app.terraform.io/DoU-TFE/onboarding-module/tfe | >=0.0.1 |
| <a name="module_hcp-vault-nsaas-workspace"></a> [hcp-vault-nsaas-workspace](#module\_hcp-vault-nsaas-workspace) | app.terraform.io/DoU-TFE/onboarding-module/tfe | >=0.0.1 |
| <a name="module_hcp-vault-tenant-workspace"></a> [hcp-vault-tenant-workspace](#module\_hcp-vault-tenant-workspace) | app.terraform.io/DoU-TFE/onboarding-module/tfe | >=0.0.1 |
| <a name="module_hcp_credentials"></a> [hcp\_credentials](#module\_hcp\_credentials) | kalenarndt/variable-sets/tfe | 0.0.7 |
| <a name="module_terraform-hcp-aws-lz-snow"></a> [terraform-hcp-aws-lz-snow](#module\_terraform-hcp-aws-lz-snow) | app.terraform.io/DoU-TFE/onboarding-module/tfe | >=0.0.1 |
| <a name="module_terraform-snow-hcp-vault"></a> [terraform-snow-hcp-vault](#module\_terraform-snow-hcp-vault) | app.terraform.io/DoU-TFE/onboarding-module/tfe | >=0.0.1 |
| <a name="module_tfc_general"></a> [tfc\_general](#module\_tfc\_general) | kalenarndt/variable-sets/tfe | 0.0.7 |

## Resources

| Name | Type |
|------|------|
| [tfe_agent_pool.ec2_tfcb_agents](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/agent_pool) | resource |
| [tfe_agent_token.ec2_tfcb_agents](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/agent_token) | resource |
| [tfe_team.hcp](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/team) | resource |
| [tfe_team_token.hcp_team_token](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/team_token) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_access_key"></a> [aws\_access\_key](#input\_aws\_access\_key) | (Required) AWS Access Key that will be used for initial authentication during HCP cluster instantiation | `string` | n/a | yes |
| <a name="input_aws_secret_key"></a> [aws\_secret\_key](#input\_aws\_secret\_key) | (Required) AWS Secret Key that will be used for initial authentication during HCP cluster instantiation | `string` | n/a | yes |
| <a name="input_hcp_client_id"></a> [hcp\_client\_id](#input\_hcp\_client\_id) | (Required) Username used to connect and authenticate with HashiCorp Cloud Platform | `string` | n/a | yes |
| <a name="input_hcp_region"></a> [hcp\_region](#input\_hcp\_region) | (Required) Region where the HCP Vault cluster will be deployed | `string` | n/a | yes |
| <a name="input_hcp_secret_id"></a> [hcp\_secret\_id](#input\_hcp\_secret\_id) | (Required) Password used to connect and authenticate with HashiCorp Cloud Platform | `string` | n/a | yes |
| <a name="input_oauth_token_id"></a> [oauth\_token\_id](#input\_oauth\_token\_id) | (Required) Oauth Token ID used for the VCS integration | `string` | n/a | yes |
| <a name="input_tfc_ec2_agent_description"></a> [tfc\_ec2\_agent\_description](#input\_tfc\_ec2\_agent\_description) | (Optional) Description for the TFC Agent Pool that will be created | `string` | `"TFC Agent Pool for Terraform execution with the AWS environment."` | no |
| <a name="input_tfc_ec2_agent_name"></a> [tfc\_ec2\_agent\_name](#input\_tfc\_ec2\_agent\_name) | (Optional) Name of the Agent Pool that will be created. | `string` | `"ec2-tfc-agents"` | no |
| <a name="input_tfc_organization"></a> [tfc\_organization](#input\_tfc\_organization) | (Required) Name of the TFC Organization where the workspaces reside | `string` | `"DoU-TFE"` | no |
| <a name="input_tfc_team_name"></a> [tfc\_team\_name](#input\_tfc\_team\_name) | (Optional) Name of the TFC team that will be created | `string` | `"hcp_team_output"` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
