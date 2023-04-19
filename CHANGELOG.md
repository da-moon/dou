# Changelog

## [v0.4.0](https://github.com/DigitalOnUs/terraform-aws-snow-lz-ecs/compare/v0.3.0...v0.4.0) (2022-07-06)

### Features

* **ecs:** output `tags_all` declaration
 91d7f34
* **ecs:** output `name` declaration
 a604a8d
* **ecs:** output `id` declaration
 4488e98
* **ecs:** output `iam_role` declaration
 9847800
* **ecs:** output `desired_count` declaration
 cbb9e9f
* **ecs:** output `cluster` declaration
 931ccb3
* **ecs:** output `security_group_tags_all` declaration
 e31e323
* **ecs:** output `security_group_owner_id` declaration
 08161ae
* **ecs:** output `security_group_id` declaration
 78820ee
* **ecs:** output `security_group_arn` declaration
 cdfff36
* **ecs:** output `cluster_tags_all` declaration
 1dc12fd
* **ecs:** output `cluster_id` declaration
 efe7889
* **ecs:** output `cluster_arn` declaration
 f99f301
* **ecs:** output `task_definition_tags_all` declaration
 7f5edd2
* **ecs:** output `task_definition_revision` declaration
 a9cb1e4
* **ecs:** output `task_definition_arn` declaration
 b586b0a
* **ecs:** output `task_execution_iam_role_unique_id` declaration
 4ba6aa8
* **ecs:** output `task_execution_iam_role_tags_all` declaration
 18e7465
* **ecs:** output `task_execution_iam_role_name` declaration
 8508866
* **ecs:** output `task_execution_iam_role_id` declaration
 f0e224f
* **ecs:** output `task_execution_iam_role_create_date` declaration
 d6c315a
* **ecs:** output `task_execution_iam_role_arn` declaration
 056e700
* **ecs:** resource `aws_ecs_service.this` implementation
 18035f0
* **ecs:** resource `aws_security_group.this` implementation
 8982d6e
* **ecs:** resource `aws_ecs_cluster.this` implementation
 2bdf7b3
* **ecs:** resource `aws_ecs_task_definition.this` implementation
 0698cb8
* **ecs:** data `template_file.container_definitions` implementation
 41efdfb
* **ecs:** resource `aws_iam_role_policy_attachment.task_execution` implementation
 962c4b3
* **ecs:** resource `aws_iam_role.task_execution` implementation
 75bac1e
* **ecs:** data `aws_iam_policy_document.task_execution` implementation
 b456077
* **ecs:** `aws` provider init
 0ba5894
* **ecs:** variable `app_count` declaration
 f4ce490
* **ecs:** variable `app_port` declaration
 cb1d539
* **ecs:** variable `cpu_limit` declaration
 d808505
* **ecs:** variable `memory_limit` declaration
 6f9c6ec
* **ecs:** variable `docker_image_tag` declaration
 59c5282
* **ecs:** variable `docker_image` declaration
 0116cc7
* **ecs:** variable `private_subnet_ids` declaration
 2e74a8a
* **ecs:** variable `alb_target_group_id` declaration
 a59bc27
* **ecs:** variable `alb_sg_id` declaration
 cdcb664
* **ecs:** variable `vpc_id` declaration
 2011f88
* **ecs:** variable `project_name` declaration
 2e2ae9c

### Documentation

* **changelog:** `0.3.0` release
 3d75ab5
* **ecs:** module synopsis
 8b9730b
* **ecs:** output `tags_all` synopsis
 5e8a371
* **ecs:** output `name` synopsis
 edde6f3
* **ecs:** output `id` synopsis
 544ce06
* **ecs:** output `iam_role` synopsis
 c5eafd7
* **ecs:** output `desired_count` synopsis
 63843b3
* **ecs:** output `cluster` synopsis
 8989d2d
* **ecs:** output `security_group_tags_all` synopsis
 a51c9e9
* **ecs:** output `security_group_owner_id` synopsis
 63a6147
* **ecs:** output `security_group_id` synopsis
 af86fd3
* **ecs:** output `security_group_arn` synopsis
 0b7be13
* **ecs:** output `cluster_tags_all` synopsis
 bfbb465
* **ecs:** output `cluster_id` synopsis
 41ee19f
* **ecs:** output `cluster_arn` synopsis
 c26cf17
* **ecs:** output `task_definition_tags_all` synopsis
 5cbba26
* **ecs:** output `task_definition_revision` synopsis
 cf3a1be
* **ecs:** output `task_definition_arn` synopsis
 1c553a3
* **ecs:** output `task_execution_iam_role_unique_id` synopsis
 a14c3b8
* **ecs:** output `task_execution_iam_role_tags_all` synopsis
 4bb7795
* **ecs:** output `task_execution_iam_role_name` synopsis
 994b6fd
* **ecs:** output `task_execution_iam_role_id` synopsis
 3197c08
* **ecs:** output `task_execution_iam_role_create_date` synopsis
 dba2057
* **ecs:** output `task_execution_iam_role_arn` synopsis
 cdcaf8e
* **ecs:** resource `aws_ecs_service.this` synopsis
 8467e4f
* **ecs:** resource `aws_security_group.this` synopsis
 2aa9bcc
* **ecs:** resource `aws_ecs_cluster.this` synopsis
 d815000
* **ecs:** resource `aws_ecs_task_definition.this` synopsis
 bfedfc8
* **ecs:** data `template_file.container_definitions` synopsis
 cc3b140
* **ecs:** resource `aws_iam_role_policy_attachment.task_execution` synopsis
 1c8e2da
* **ecs:** resource `aws_iam_role.task_execution` synopsis
 a6dfeb2
* **ecs:** data `aws_iam_policy_document.task_execution` synopsis
 bf7623d
* **ecs:** variable `app_count` synopsis
 18c246b
* **ecs:** variable `app_port` synopsis
 91089b1
* **ecs:** variable `cpu_limit` synopsis
 3756868
* **ecs:** variable `memory_limit` synopsis
 bdc7964
* **ecs:** variable `docker_image_tag` synopsis
 1a6b7c5
* **ecs:** variable `docker_image` synopsis
 5796cd4
* **ecs:** variable `private_subnet_ids` synopsis
 cd40bbe
* **ecs:** variable `alb_target_group_id` synopsis
 3c792a4
* **ecs:** variable `alb_sg_id` synopsis
 d8eefee
* **ecs:** variable `vpc_id` synopsis
 5e70baf
* **ecs:** variable `project_name` synopsis
 a411991

### Styling

* **ecs:** `outputs.tf` fmt
 5b65037

### Build System

* **ecs:** `Makefile` init
 f7a4c70

## [v0.3.0](https://github.com/DigitalOnUs/terraform-aws-snow-lz-ecs/compare/v0.2.0...v0.3.0) (2022-07-06)

### Features

* **alb:** output `listener_tags_all` declaration
 32df6c4, closes #3
* **alb:** output `listener_arn` declaration
 8b031c7, closes #3
* **alb:** output `target_group_tags_all` declaration
 d3f9054, closes #3
* **alb:** output `target_group_name` declaration
 14341d0, closes #3
* **alb:** output `target_group_id` declaration
 b859e07, closes #3
* **alb:** output `target_group_arn` declaration
 a7f3fa1, closes #3
* **alb:** output `target_group_arn` declaration
 706a86f, closes #3
* **alb:** output `target_group_arn_suffix` declaration
 c590932, closes #3
* **alb:** output `subnet_mappings_output_id` declaration
 b275130, closes #3
* **alb:** output `zone_id` declaration
 569036e, closes #3
* **alb:** output `tags_all` declaration
 59b6046, closes #3
* **alb:** output `dns_name` declaration
 659747e, closes #3
* **alb:** output `arn_suffix` declaration
 d1d61d5, closes #3
* **alb:** output `arn` declaration
 43e8d02, closes #3
* **alb:** output `id` declaration
 133fe48, closes #3
* **alb:** output `security_group_tags_all` declaration
 e0b05c6, closes #3
* **alb:** output `security_group_owner_id` declaration
 8172fcd, closes #3
* **alb:** output `security_group_id` declaration
 5c078c3, closes #3
* **alb:** output `security_group_arn` declaration
 fcd3f01, closes #3
* **alb:** resource `aws_lb_listener.this` implementation
 4af6507, closes #3
* **alb:** resource `aws_lb_target_group.this` implementation
 50be98a, closes #3
* **alb:** resource `aws_lb.this` implementation
 c7ac16d, closes #3
* **alb:** resource `aws_security_group.this` implementation
 eb9d1d5, closes #3
* **alb:** `aws` provider init
 375de0f, closes #3
* **alb:** variable `health_check_path` declaration
 3a018ee, closes #3
* **alb:** variable `public_subnet_ids` declaration
 4782650, closes #3
* **alb:** variable `ingress_cidr` declaration
 3bae81b, closes #3
* **alb:** variable `vpc_id` declaration
 f347422, closes #3
* **alb:** variable `project_name` declaration
 634d762, closes #3

### Documentation

* **changelog:** `0.2.0` release
 4c496f5
* **alb:** module synopsis
 9a868e7, closes #3
* **alb:** output `listener_tags_all` synopsis
 0834e68, closes #3
* **alb:** output `listener_id` synopsis
 e536018, closes #3
* **alb:** output `listener_arn` synopsis
 b9904a4, closes #3
* **alb:** output `listener_arn` synopsis
 72493bf, closes #3
* **alb:** output `target_group_tags_all` synopsis
 d028532, closes #3
* **alb:** output `target_group_name` synopsis
 7460c67, closes #3
* **alb:** output `target_group_id` synopsis
 a0d8a0a, closes #3
* **alb:** output `target_group_arn_suffix` synopsis
 d540988, closes #3
* **alb:** output `subnet_mappings_output_id` synopsis
 51959af, closes #3
* **alb:** output `zone_id` synopsis
 77d0973, closes #3
* **alb:** output `tags_all` synopsis
 53ea9ac, closes #3
* **alb:** output `dns_name` synopsis
 2c169de, closes #3
* **alb:** output `arn_suffix` synopsis
 223b532, closes #3
* **alb:** output `arn` synopsis
 189d545, closes #3
* **alb:** output `id` synopsis
 c8029ef, closes #3
* **alb:** output `security_group_tags_all` synopsis
 96fb9e8, closes #3
* **alb:** output `security_group_owner_id` synopsis
 717b30c, closes #3
* **alb:** output `security_group_id` synopsis
 a3e9e75, closes #3
* **alb:** output `security_group_arn` synopsis
 98d43b4, closes #3
* **alb:** resource `aws_lb_listener.this` synopsis
 76fd1f0, closes #3
* **alb:** resource `aws_lb_target_group.this` synopsis
 b60c20c, closes #3
* **alb:** resource `aws_lb.this` synopsis
 0a530c9, closes #3
* **alb:** resource `aws_security_group.this` synopsis
 08890f9, closes #3
* **alb:** variable `health_check_path` synopsis
 e2e87d3, closes #3
* **alb:** variable `public_subnet_ids` synopsis
 e407535, closes #3
* **alb:** variable `ingress_cidr` synopsis
 6e7bfcf, closes #3
* **alb:** variable `vpc_id` synopsis
 32b5bb1, closes #3
* **alb:** variable `project_name` synopsis
 c5e4509, closes #3

### Styling

* **alb:** `outputs.tf` fmt
 311e46b

### Build System

* **alb:** `Makefile` init
 95c09ce

## [v0.2.0](https://github.com/DigitalOnUs/terraform-aws-snow-lz-ecs/compare/v0.1.0...v0.2.0) (2022-07-06)

### Features

* **vpc:** output `route_table_association_id` declaration
 998d1b8
* **vpc:** output `route_table_tags_all` declaration
 19a9926
* **vpc:** output `route_table_arn` declaration
 7e1126e
* **vpc:** output `route_table_id` declaration
 f0334c0
* **vpc:** output `nat_gateway_tags_all` declaration
 a2f8317
* **vpc:** output `nat_gateway_public_ip` declaration
 2e86681
* **vpc:** output `nat_gateway_private_ip` declaration
 6922b82
* **vpc:** output `nat_gateway_network_interface_id` declaration
 6554086
* **vpc:** output `nat_gateway_subnet_id` declaration
 cb3782e
* **vpc:** output `nat_gateway_allocation_id` declaration
 93c0ea3
* **vpc:** output `nat_gateway_id` declaration
 5e1a54e
* **vpc:** output `nat_gateway_eip_tags_all` declaration
 7b3342a
* **vpc:** output `nat_gateway_eip_public_ip` declaration
 85286f5
* **vpc:** output `nat_gateway_eip_public_dns` declaration
 4cba46f
* **vpc:** output `nat_gateway_eip_private_ip` declaration
 c649d44
* **vpc:** output `nat_gateway_eip_private_dns` declaration
 3b8c784
* **vpc:** output `nat_gateway_eip_id` declaration
 6fb3e53
* **vpc:** output `nat_gateway_eip_domain` declaration
 5ca56d2
* **vpc:** output `nat_gateway_eip_customer_owned_ip` declaration
 2a173d5
* **vpc:** output `nat_gateway_eip_carrier_ip` declaration
 b9a9aee
* **vpc:** output `nat_gateway_eip_association_id` declaration
 ec3f7be
* **vpc:** output `nat_gateway_eip_association_id` declaration
 98c1252
* **vpc:** output `nat_gateway_eip_allocation_id` declaration
 0862b82
* **vpc:** output `public_route_state` declaration
 1f52499
* **vpc:** output `public_route_origin` declaration
 64566c7
* **vpc:** output `public_route_instance_owner_id` declaration
 58a44cb
* **vpc:** output `public_route_id` declaration
 e2957d0
* **vpc:** output `internet_gateway_tags_all` declaration
 d82a31d
* **vpc:** output `internet_gateway_owner_id` declaration
 058bb56
* **vpc:** output `internet_gateway_arn` declaration
 2dfe57e
* **vpc:** output `internet_gateway_id` declaration
 a79dd91
* **vpc:** output `private_subnet_tags_all` declaration
 c69e1c2
* **vpc:** output `private_subnet_owner_id` declaration
 6b82a5f
* **vpc:** output `private_subnet_ipv6_cidr_block_association_id` declaration
 4b13799
* **vpc:** output `private_subnet_arn` declaration
 7992127
* **vpc:** output `private_subnet_id` declaration
 0592f9e
* **vpc:** output `public_subnet_tags_all` declaration
 bcc0887
* **vpc:** output `public_subnet_owner_id` declaration
 a9a3e15
* **vpc:** output `public_subnet_ipv6_cidr_block_association_id` declaration
 5142743
* **vpc:** output `public_subnet_arn` declaration
 c133aea
* **vpc:** output `public_subnet_id` declaration
 537cc48
* **vpc:** output `tags_all` declaration
 2cf88d0
* **vpc:** output `owner_id` declaration
 3ed5e7f
* **vpc:** output `ipv6_cidr_block` declaration
 bb4908f
* **vpc:** output `ipv6_association_id` declaration
 d429891
* **vpc:** output `default_route_table_id` declaration
 39765eb
* **vpc:** output `default_security_group_id` declaration
 25763dd
* **vpc:** output `default_network_acl_id` declaration
 a34c1e0
* **vpc:** output `main_route_table_id` declaration
 bcfad51
* **vpc:** output `enable_classiclink` declaration
 0b504c2
* **vpc:** output `enable_dns_hostnames` declaration
 79f8359
* **vpc:** output `enable_dns_support` declaration
 f779f92
* **vpc:** output `instance_tenancy` declaration
 58d2cae
* **vpc:** output `cidr_block` declaration
 f45e8e8
* **vpc:** output `id` declaration
 5953cc4
* **vpc:** output `arn` declaration
 cbaee80
* **vpc:** `aws` provider init
 a1ba357
* **vpc:** resource `aws_route_table_association.private` implementation
 761eb24
* **vpc:** resource `aws_route_table.private` implementation
 b7d2f03
* **vpc:** resource `aws_nat_gateway.private` implementation
 2609565
* **vpc:** resource `aws_eip.private` implementation
 a788524
* **vpc:** resource `aws_subnet.private` implementation
 a95ec6c
* **vpc:** resource `aws_route.public` implementation
 2f2c696
* **vpc:** resource `aws_internet_gateway.public` implementation
 603d0b5
* **vpc:** resource `aws_subnet.public` implementation
 d9789a4
* **vpc:** resource `aws_vpc.this` implementation
 e97bfad
* **vpc:** data provider `aws_availability_zones.this` implementation
 275d347
* **vpc:** variable `cidr_block` declaration
 97158b5
* **vpc:** variable `project_name` declaration
 a24510b
* **vpc:** variable `project_name` declaration
 62908a8
* **vpc:** variable `availablity_zone_count` declaration
 ecc805a

### Documentation

* **changelog:** `0.1.0` release
 8b53a21
* **vpc:** module synopsis
 9ad2a6f
* **vpc:** output `route_table_association_id` synopsis
 81eb6b4
* **vpc:** output `route_table_tags_all` synopsis
 f728428
* **vpc:** output `route_table_arn` synopsis
 7dd906f
* **vpc:** output `route_table_id` synopsis
 03f649e
* **vpc:** output `nat_gateway_tags_all` synopsis
 c77af44
* **vpc:** output `nat_gateway_public_ip` synopsis
 691a75b
* **vpc:** output `nat_gateway_private_ip` synopsis
 6101f21
* **vpc:** output `nat_gateway_network_interface_id` synopsis
 a06273d
* **vpc:** output `nat_gateway_subnet_id` synopsis
 e49d1c5
* **vpc:** output `nat_gateway_allocation_id` synopsis
 3dfb98d
* **vpc:** output `nat_gateway_id` synopsis
 0f49d88
* **vpc:** output `nat_gateway_eip_tags_all` synopsis
 0ca64ab
* **vpc:** output `nat_gateway_eip_public_ip` synopsis
 1bfe4f6
* **vpc:** output `nat_gateway_eip_public_dns` synopsis
 2c1d461
* **vpc:** output `nat_gateway_eip_private_ip` synopsis
 7c16675
* **vpc:** output `nat_gateway_eip_private_dns` synopsis
 da95655
* **vpc:** output `nat_gateway_eip_id` synopsis
 2596e9e
* **vpc:** output `nat_gateway_eip_domain` synopsis
 f3925c1
* **vpc:** output `nat_gateway_eip_customer_owned_ip` synopsis
 953a910
* **vpc:** output `nat_gateway_eip_carrier_ip` synopsis
 8cb8be6
* **vpc:** output `nat_gateway_eip_association_id` synopsis
 354fb14
* **vpc:** output `nat_gateway_eip_allocation_id` synopsis
 9342e59
* **vpc:** output `public_route_state` synopsis
 7c7bb2e
* **vpc:** output `public_route_origin` synopsis
 e4f78df
* **vpc:** output `public_route_instance_owner_id` synopsis
 5011aa3
* **vpc:** output `public_route_id` synopsis
 ed43744
* **vpc:** output `internet_gateway_tags_all` synopsis
 65ff68d
* **vpc:** output `internet_gateway_owner_id` synopsis
 8a131e4
* **vpc:** output `internet_gateway_arn` synopsis
 9b4ee97
* **vpc:** output `internet_gateway_id` synopsis
 00d241c
* **vpc:** output `private_subnet_tags_all` synopsis
 8d5fc0d
* **vpc:** output `private_subnet_owner_id` synopsis
 02f84a8
* **vpc:** output `private_subnet_ipv6_cidr_block_association_id` synopsis
 da2c080
* **vpc:** output `private_subnet_arn` synopsis
 a158aaa
* **vpc:** output `private_subnet_id` synopsis
 d60f04f
* **vpc:** output `public_subnet_tags_all` synopsis
 9ee8d6c
* **vpc:** output `public_subnet_owner_id` synopsis
 610b3f6
* **vpc:** output `public_subnet_ipv6_cidr_block_association_id` synopsis
 e2b6fe1
* **vpc:** output `public_subnet_arn` synopsis
 8acda0d
* **vpc:** output `public_subnet_id` synopsis
 cd7503e
* **vpc:** output `tags_all` synopsis
 09806f9
* **vpc:** output `owner_id` synopsis
 76ff754
* **vpc:** output `ipv6_cidr_block` synopsis
 47dd416
* **vpc:** output `ipv6_association_id` synopsis
 c2fe30f
* **vpc:** output `default_route_table_id` synopsis
 0564811
* **vpc:** output `default_security_group_id` synopsis
 5f2ffcf
* **vpc:** output `default_network_acl_id` synopsis
 27f57f7
* **vpc:** output `main_route_table_id` synopsis
 a4b2d0e
* **vpc:** output `enable_classiclink` synopsis
 200037d
* **vpc:** output `enable_dns_hostnames` synopsis
 6a7072f
* **vpc:** output `enable_dns_support` synopsis
 74bfa2e
* **vpc:** output `instance_tenancy` synopsis
 fb42ebb
* **vpc:** output `cidr_block` synopsis
 458f5d4
* **vpc:** output `id` synopsis
 a2d34ed
* **vpc:** output `arn` synopsis
 1aee05f
* **vpc:** resource `aws_route_table_association.private` synopsis
 8f60b04
* **vpc:** resource `aws_route_table.private` synopsis
 718edf5
* **vpc:** resource `aws_nat_gateway.private` synopsis
 fb6214b
* **vpc:** resource `aws_eip.private` synopsis
 594164a
* **vpc:** resource `aws_subnet.private` synopsis
 9f55b50
* **vpc:** resource `aws_route.public` synopsis
 9406784
* **vpc:** resource `aws_internet_gateway.public` synopsis
 b8ee4da
* **vpc:** resource `aws_subnet.public` synopsis
 54c8290
* **vpc:** resource `aws_vpc.this` synopsis
 0cc4ea0
* **vpc:** data provider `aws_availability_zones.this` synopsis
 5520835
* **vpc:** variable `cidr_block` synopsis
 f0a10d0
* **vpc:** variable `availablity_zone_count` synopsis
 df607b2

### Styling

* **vpc:** `outputs.tf` fmt
 6083d04

### Build System

* **vpc:** `Makefile` init
 65f2ef4

## v0.1.0 (2022-07-06)

### Features

* **ecr:** output `digests` declaration
 feb8cff
* **ecr:** output `images` declaration
 4d02999
* **ecr:** output `kms_alias_arn` declaration
 abb05f1
* **ecr:** output `kms_key_tags_all` declaration
 b7c1369
* **ecr:** output `kms_key_id` declaration
 df76914
* **ecr:** output `kms_key_arn` declaration
 e64bed7
* **ecr:** output `tags_all` declaration
 2a6721e
* **ecr:** output `url` declaration
 c3b0020
* **ecr:** output `registry_id` declaration
 0c372c0
* **ecr:** output `arn` declaration
 ff0b126
* **ecr:** resource `docker_registry_image.dest` implementation
 2006c47
* **ecr:** resource `aws_ecr_lifecycle_policy.this` implementation
 96e718d
* **ecr:** data provider `template_file.ecr_lifecyle_policy` implementation
 f9e29d9
* **ecr:** resource `aws_ecr_repository_policy.this` implementation
 b8fa143
* **ecr:** data provider `local_file.aws_ecr_repository_policy` implementation
 cc2a5a3
* **ecr:** resource `aws_ecr_repository.this` implementation
 1fca228
* **ecr:** resource `aws_kms_alias.this` implementation
 6a5766f
* **ecr:** resource `aws_kms_key.this` implementation
 07319a4
* **ecr:** resource `docker_image.src` implementation
 6b17b89
* **ecr:** data provider `docker_registry_image.src` implementation
 199a930
* **ecr:** `docker` provider declaration
 bd4e917
* **ecr:** `aws` provider declaration
 80a0dd4
* **ecr:** variable `lifecyle_policy_image_count` declaration
 f06a60d
* **ecr:** variable `docker_image_tags` declaration
 dfb4c46
* **ecr:** variable `docker_image_name` declaration
 c6a63d4
* **ecr:** variable `project_name` declaration
 ed73401

### Bug Fixes

* **editor:** `nvim` in Dockerfile
 f1ae7fb
* **editor:** docker-from-docker script in DevContainer docker file
 5b5fb1d
* **pre-commit:** `gitleaks` hook
 532cf31
* **pre-commit:** add config file
 ebf2529
* **pre-commit:** add `.github/ISSUE_TEMPLATE` to `markdownlintignore` dotfile
 cd30271

### Documentation

* **ecr:** module synopsis
 1ae0f93
* **ecr:** output `digests` synopsis
 9ce1899
* **ecr:** output `images` synopsis
 b64ce25
* **ecr:** output `kms_alias_arn` synopsis
 0c243f3
* **ecr:** output `kms_key_tags_all` synopsis
 a5b8831
* **ecr:** output `kms_key_id` synopsis
 71ee85b
* **ecr:** output `kms_key_arn` synopsis
 d3d558c
* **ecr:** output `tags_all` synopsis
 f729c24
* **ecr:** output `url` synopsis
 a3372f4
* **ecr:** output `registry_id` synopsis
 93df287
* **ecr:** output `arn` synopsis
 88abb35
* **ecr:** resource `docker_registry_image.dest` synopsis
 5a01503
* **ecr:** resource `aws_ecr_lifecycle_policy.this` synopsis
 f336417
* **ecr:** data provider `template_file.ecr_lifecyle_policy` synopsis
 d2a9f55
* **ecr:** resource `aws_ecr_repository_policy.this` synopsis
 aaac401
* **ecr:** data provider `local_file.aws_ecr_repository_policy` synopsis
 7963ba1
* **ecr:** resource `aws_ecr_repository.this` synopsis
 75d6c85
* **ecr:** resource `aws_kms_alias.this` synopsis
 9072a51
* **ecr:** resource `aws_kms_key.this` synopsis
 766153d
* **ecr:** resource `docker_image.src` synopsis
 b06e4af
* **ecr:** data provider `docker_registry_image.src` synopsis
 9028c29
* **ecr:** variable `lifecyle_policy_image_count` synopsis
 5a5b4d1
* **ecr:** variable `docker_image_tags` synopsis
 11447de
* **ecr:** variable `docker_image_name` synopsis
 760979a
* **ecr:** variable `project_name` synopsis
 efa7181
* **repository-management:** fix repo name
 48d75d0
* **changelog:** `v0.0.1`
 ecc4f4d
* **repository-management:** initial commit
 6bdc05b
* **github:** `feature-request` issue template
 a4f9ea2
* **github:** `bug-report` issue template
 65131be
* **github:** `task` issue template
 b6e5889

### Build System

* **ecr:** `Makefile` init
 3d6d927
* **docker:** fix default image name variable
 315693e
* **editor:** `docker-bake.hcl` build spec file
 277343b
* initial `Makefile`
 4b23058

### Chore

* **ecr:** `.gitignore` file
 410fb30
* **gitignore:** add `.gitignore` file in modules directories
 c41221d
* allow module specific README files to be committed
 8027c76
* allow terraform files under `modules` to be commited to the repo
 052aa0e
* **editor:** fix `DevContainer` image name
 67bbc51
* **editor:** `devcontainer` configuration
 bdbc100
* **editor:** `dockerfile` for development environment
 ab11033
* `gitignore` dotfile
 2e62610
* `stignore` dotfile
 3d97848
* `versionrc` dotfile
 cad1c03
* `editorconfig` dotfile
 45312dd
* **pre-commit:** `commitlint` config file
 d749b54
* **pre-commit:** `markdownlintignore` dot file
 9faf2dd
* **pre-commit:** `cspell` config file
 9491327
* **cspell:** `generic` dictionary file
 0e24200
* **github:** `CODEOWNERS` file
 3261fd8
* `github-labels` config file
 5fae8ba
