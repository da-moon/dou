# terraform-vault-hcp-vault-ns

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_tfe"></a> [tfe](#requirement\_tfe) | >=0.26.1 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | >=2.22.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tfe"></a> [tfe](#provider\_tfe) | 0.32.1 |
| <a name="provider_vault.admin"></a> [vault.admin](#provider\_vault.admin) | 3.7.0 |
| <a name="provider_vault.new_ns"></a> [vault.new\_ns](#provider\_vault.new\_ns) | 3.7.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [tfe_variable.namespace](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable.role_id](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable.secret_id](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [vault_approle_auth_backend_role.role](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/approle_auth_backend_role) | resource |
| [vault_approle_auth_backend_role_secret_id.secret](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/approle_auth_backend_role_secret_id) | resource |
| [vault_auth_backend.auth](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/auth_backend) | resource |
| [vault_namespace.ns](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/namespace) | resource |
| [vault_policy.policy](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/policy) | resource |
| [tfe_workspace.target_workspace](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/data-sources/workspace) | data source |
| [vault_policy_document.admin_policy](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_namespace"></a> [admin\_namespace](#input\_admin\_namespace) | Name of the HCP Admin namespace to login to | `string` | `"admin"` | no |
| <a name="input_auth_desc"></a> [auth\_desc](#input\_auth\_desc) | (Optional) Description that will be used for the Vault Auth Backend | `string` | `"Admin Approle authentication method for machine based access"` | no |
| <a name="input_auth_path"></a> [auth\_path](#input\_auth\_path) | Path where the auth method will be mounted. Defaults to /approle. | `string` | `null` | no |
| <a name="input_auth_type"></a> [auth\_type](#input\_auth\_type) | (Optional) Authentication type that will be used for the Vault Auth Backend. Defaults to approle | `string` | `"approle"` | no |
| <a name="input_default_lease_ttl"></a> [default\_lease\_ttl](#input\_default\_lease\_ttl) | (Optional) Default lease TTL that will be assigned to tokens on the auth mount | `string` | `"3h"` | no |
| <a name="input_max_lease_ttl"></a> [max\_lease\_ttl](#input\_max\_lease\_ttl) | (Optional) Max lease TTL that will be assigned to tokens on the auth mount | `string` | `"6h"` | no |
| <a name="input_new_ns"></a> [new\_ns](#input\_new\_ns) | Name of the HCP Vault namespace to create | `string` | n/a | yes |
| <a name="input_role_id"></a> [role\_id](#input\_role\_id) | Admin Approle ID used to login to Vault and create the objects | `string` | n/a | yes |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | Name of the role that will be created for machine based access | `string` | `"admin_role"` | no |
| <a name="input_secret_id"></a> [secret\_id](#input\_secret\_id) | Admin Secret ID used to login to Vault and create objects | `string` | n/a | yes |
| <a name="input_tfc_organization"></a> [tfc\_organization](#input\_tfc\_organization) | Organization where the target workspace resides | `string` | n/a | yes |
| <a name="input_tfc_target_workspace"></a> [tfc\_target\_workspace](#input\_tfc\_target\_workspace) | Workspace where the role\_id and secret\_id variables are set | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
