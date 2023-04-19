# armory-terraform-aurora

Terraform scripts to deploy a **MySQL Aurora** cluster with **IAM Authentication enabled**.

# Terraform Cloud

The remote state backend is configured to run over [armory-aurora](https://app.terraform.io/app/dou-armory/workspaces/armory-aurora) workspace in PS DOU Terraform Cloud (TFC) account.

# GitHub Workflow

The GitHub repository has configured a workflow to execute a new `terraform plan` on each PR to `master` branch and validate mergeability; once the PR gets merged into `master` a `terraform apply` is auto-approved.

# Requirements

|Name      |Version     |
|----------|------------|
|terraform |>= 0.13     |
|aws       |>= 3.63     |

# Providers

|Name      |Version     |
|----------|------------|
|aws       |>= 3.63     |

# Modules

|Name      |Source                              |Version     |
|----------|------------------------------------|------------|
|aurora    |terraform-aws-modules/rds-aurora/aws|6.1.4       |

# Resources

|Name|Type|
|-|-|
|[aws_db_parameter_group.aurora](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group)|resource|
|[aws_rds_cluster_parameter_group.aurora](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_parameter_group)|resource|
|[random_password.master](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password)|resource|
|[aws_db_subnet_group.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/db_subnet_group)|data source|
|[aws_subnet.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet)|data source|
|[aws_subnets.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets)|data source|

# Inputs

|Name|Description|Type|Default|Required|
|----|-----------|----|-------|--------|
|region|AWS Region to deploy to|`string`|`us-west-2`|yes|

# Outputs

|Name|Description|
|----|-----------|
|additional_cluster_endpoints|A map of additional cluster endpoints and their attributes|
|cluster_arn|Amazon Resource Name (ARN) of cluster|
|cluster_id|The RDS Cluster Identifier|
|cluster_resource_id|The RDS Cluster Resource ID|
|cluster_members|List of RDS Instances that are a part of this cluster|
|cluster_endpoint|Writer endpoint for the cluster|
|cluster_reader_endpoint|A read-only endpoint for the cluster, automatically load-balanced across replicas|
|cluster_engine_version_actual|The running version of the cluster database|
|cluster_database_name|Name for an automatically created database on cluster creation|
|cluster_port|The database port|
|cluster_master_password|The database master password|
|cluster_master_username|The database master username|
|cluster_hosted_zone_id|The Route53 Hosted Zone ID of the endpoint|
|cluster_instances|A map of cluster instances and their attributes|
|cluster_role_associations|A map of IAM roles associated with the cluster and their attributes|
|db_subnet_group_name|The db subnet group name|
|enhanced_monitoring_iam_role_name|The name of the enhanced monitoring role|
|enhanced_monitoring_iam_role_arn|The Amazon Resource Name (ARN) specifying the enhanced monitoring role|
|enhanced_monitoring_iam_role_unique_id|Stable and unique string identifying the enhanced monitoring role|
|security_group_id|The security group ID of the cluster|