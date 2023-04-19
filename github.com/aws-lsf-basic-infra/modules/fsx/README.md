# FSX for OpenZFS
## AWS Documentation Reference:
[FSX](https://aws.amazon.com/blogs/aws/new-amazon-fsx-for-openzfs/) - AWS for OpenZFS

#### Considerations
Regions  is available in the US East (N. Virginia), US East (Ohio), US West (Oregon), Europe (Ireland), Canada (Central), Asia Pacific (Tokyo), and Europe (Frankfurt) Regions.
Filesystem cannot be resized once created.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.50.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_fsx_openzfs_file_system.fs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/fsx_openzfs_file_system) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_fsx_name"></a> [fsx\_name](#input\_fsx\_name) | namo for fsx file system | `string` | `"EDA file system"` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | A list of IDs for the security groups that apply to the specified network interfaces created for file system access. These security groups will apply to all network interfaces. | `list(string)` | `[]` | no |
| <a name="input_storage_capacity"></a> [storage\_capacity](#input\_storage\_capacity) | The storage capacity (GiB) of the file system. Valid values between 64 and 524288 | `number` | `1024` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | An IDs for the subnet that the file system will be accessible from. Exactly 1 subnet need to be provided | `list(string)` | `[]` | no |
| <a name="input_throughput_capacity"></a> [throughput\_capacity](#input\_throughput\_capacity) | Throughput (megabytes per second) of the file system in power of 2 increments. Minimum of 64 and maximum of 4096 | `number` | `64` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_fsx_openzfs_dns_name"></a> [fsx\_openzfs\_dns\_name](#output\_fsx\_openzfs\_dns\_name) | DNS name for the file system, e.g., fs-12345678.fsx.us-west-2.amazonaws.com |
| <a name="output_fsx_openzfs_id"></a> [fsx\_openzfs\_id](#output\_fsx\_openzfs\_id) | The key of FXS OpenZFS |
<!-- END_TF_DOCS -->