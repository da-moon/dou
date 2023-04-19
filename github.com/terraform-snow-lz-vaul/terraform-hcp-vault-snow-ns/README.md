# hc-gcve-hcp-vault-gcve
Repository for the HCP Vault GCVE Namespace
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.0 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | >=2.22.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_vault"></a> [vault](#provider\_vault) | 3.7.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [vault_approle_auth_backend_role.approle_id](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/approle_auth_backend_role) | resource |
| [vault_approle_auth_backend_role_secret_id.approle_secret](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/approle_auth_backend_role_secret_id) | resource |
| [vault_policy.policies](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_approle_description"></a> [approle\_description](#input\_approle\_description) | Description for the Approle auth method | `string` | `"Approle authentication method for machine based access"` | no |
| <a name="input_approle_path"></a> [approle\_path](#input\_approle\_path) | Path where the Approle auth method will be mounted. Defaults to /approle. | `string` | `"/approle"` | no |
| <a name="input_approle_role_name"></a> [approle\_role\_name](#input\_approle\_role\_name) | Name of the role id that will be created for machine based access | `string` | `"snow"` | no |
| <a name="input_approle_role_policies"></a> [approle\_role\_policies](#input\_approle\_role\_policies) | Vault policies that will be associated with the token generated via the role id | `list(any)` | <pre>[<br>  "ops"<br>]</pre> | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace that will be configured | `string` | n/a | yes |
| <a name="input_role_id"></a> [role\_id](#input\_role\_id) | Approle Role ID used to authenticate to Vault for this namespace. Generated from antoher workspace and pushed to tfvars | `string` | n/a | yes |
| <a name="input_secret_id"></a> [secret\_id](#input\_secret\_id) | Approle Secret ID used to authenticate to Vault for this namespace. Generated from another workspace and pushed to tfvars | `string` | n/a | yes |
| <a name="input_tfc_approle_workspaces"></a> [tfc\_approle\_workspaces](#input\_tfc\_approle\_workspaces) | (Required) List of target workspaces where the approle will be pushed for GCE secret retrieval | `string` | n/a | yes |
| <a name="input_tfc_organization"></a> [tfc\_organization](#input\_tfc\_organization) | TFC organization where we will retrieve remote state | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
