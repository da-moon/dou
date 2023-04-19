# elastic-kubernetes-service

- [elastic-kubernetes-service](#elastic-kubernetes-service)
  - [Overview](#overview)
  - [Terraform Modules](#terraform-modules)
    - [VPC](#vpc)
    - [Security Group](#security-group)
    - [IAM](#iam)
    - [EFS](#efs)
    - [Cluster](#cluster)
    - [Fargate](#fargate)

## Overview

Terraform module to create an Elastic Kubernetes (EKS) cluster and associated worker instances on AWS

## Terraform Modules

### VPC

- Purpose: Creates VPC in an availability zone with its subnets
- Deployment flow:
  - Creates VPC
  - Creates subnet
  - Allows private subnets to share a common NAT
  - Creates route table and its association for subnets

### Security Group

- Purpose: Used to determine the id of the VPC the security group belongs to
- Deployment flow:
  - Creates VPC if doesn't exist
  - Creates security group for envoy proxy that attaches to VPC
  - Creates security group for onprem access that attaches to VPC

### IAM

- Purpose: Creates IAM roles required for EKS
- Deployment flow:
  - Creates IAM role for EKS cluster
  - Creates IAM role for EKS Cluster Cloud Watch
  - Creates IAM role for EKS Cluster Policy
  - Creates IAM role for EKS Service Policy
  - Creates IAM role for EKS Fargate pod execution
  - Creates IAM role for EKS Fargate pod execution logging

### EFS

- Purpose: Provides Elastic File System
- Deployment flow:
  - Creates a security group to control EFS access
  - Creates a lifecycle policy
  - Creates a mount target for EFS

### Cluster

- Purpose: Manages EKS cluster
- Deployment flow:
  - Uses existing ARN role
  - Uses private subnets
  - Creates TLS certificate after EKS cluster is created
  - Associates TLS certivficate to IAM openid provider after TLS certificate creation

### Fargate

- Purpose: Manages an EKS Fargate Profile
- Deployment flow:
  - Takes name of the existing AWS EKS cluster
  - Takes the existing ARN of ther IAM Role that provides permissions for the EKS Fargate Profile
  - Takes private subnet identifiers and execution role ARN
  - Takes Configuration blocks for selecting Kuberenetes Pods to execute EKS Fargate Profile
  - Takes identifiers of private EC2 Subnets to associate with the EKS Fargate profile
