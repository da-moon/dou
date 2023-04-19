# hc-gcve-hcp-vault-nsaas<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.0 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | >=2.22.1 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vault_namespaces"></a> [vault\_namespaces](#module\_vault\_namespaces) | app.terraform.io/DoU-TFE/hcp-vault-ns/vault | ~>0.0.1 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_role_id"></a> [role\_id](#input\_role\_id) | Admin Approle ID used to login to Vault and create the objects | `string` | n/a | yes |
| <a name="input_secret_id"></a> [secret\_id](#input\_secret\_id) | Admin Secret ID used to login to Vault and create objects | `string` | n/a | yes |
| <a name="input_tfc_organization"></a> [tfc\_organization](#input\_tfc\_organization) | Organization where the target workspace resides | `string` | n/a | yes |
| <a name="input_tfc_vault_workspace"></a> [tfc\_vault\_workspace](#input\_tfc\_vault\_workspace) | Workspace where the role\_id and secret\_id variables are set | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
