# Docker Image Module
<!-- vim-markdown-toc GFM -->

- [Overview](#overview)
- [Outputs](#outputs)

<!-- vim-markdown-toc -->
## Overview

this module :

- Creates an ECR Repository
- creates a KMS managed key for usage with ECR repository.
- sets up policies for the ECR repository

## Outputs

- `aws_ecr_repository` : includes information for identifying the ECR
repository.
- `aws_kms_key` : includes information for identifying the created KMS key
- `aws_kms_alias` : includes information for identifying KMS Key alias.

