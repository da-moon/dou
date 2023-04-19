# hc-gcve-hcp-vault-admin-ns

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.2.0 |
| <a name="requirement_tfe"></a> [tfe](#requirement\_tfe) | >=0.26.1 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | >=2.22.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_vault"></a> [vault](#provider\_vault) | 3.7.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_approle_push"></a> [approle\_push](#module\_approle\_push) | kalenarndt/variable-push/tfe | >=0.0.3 |

## Resources

| Name | Type |
|------|------|
| [vault_approle_auth_backend_role.admin_approle](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/approle_auth_backend_role) | resource |
| [vault_approle_auth_backend_role_secret_id.admin_approle](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/approle_auth_backend_role_secret_id) | resource |
| [vault_auth_backend.admin_approle](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/auth_backend) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_approle_description"></a> [admin\_approle\_description](#input\_admin\_approle\_description) | Description for the admin approle that will be created | `string` | `"Used for subsequent Vault calls after initial setup"` | no |
| <a name="input_admin_approle_name"></a> [admin\_approle\_name](#input\_admin\_approle\_name) | Name of the admin approle that will be created | `string` | `"admin_approle"` | no |
| <a name="input_admin_approle_path"></a> [admin\_approle\_path](#input\_admin\_approle\_path) | Path where the approle will be created. Defaults to /approle | `string` | `"approle"` | no |
| <a name="input_admin_approle_policy"></a> [admin\_approle\_policy](#input\_admin\_approle\_policy) | Policy that will be assigned to the admin approle | `list(any)` | <pre>[<br>  "hcp-root"<br>]</pre> | no |
| <a name="input_tfc_organization"></a> [tfc\_organization](#input\_tfc\_organization) | TFC organization where we will retrieve remote state | `string` | n/a | yes |
| <a name="input_tfc_target_workspace"></a> [tfc\_target\_workspace](#input\_tfc\_target\_workspace) | (Required) Workspace where the Admin Approle role\_id and secret\_id will be pushed | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
