# Data PoC Infrastructure 🏗️

### This repo is used by Data PoC team to deploy infrastructure with Terraform code. 👷

> This repo uses an Azure Storage Account to store and track the terraform state in the "data-poc" rg. DON'T DELETE IT! 😄

## This code deploy the following resources: ✅
 - Azure Cognitive Services
 - Storage Account with Data Lake V2 filesystem
 - Data Factory
 - Data Factory Pipeline
 - Cosmosdb Account

## How to use it: 👀

You need Terraform 1.4.4 to use this repo, you can download here:
https://developer.hashicorp.com/terraform/downloads

also, you need the Azure CLI installed in your terminal:
https://learn.microsoft.com/en-us/cli/azure/install-azure-cli

> Resource group access is needed to create or delete any resource in the future, ask @MarioRoblesDOU to request access.

If you need to create, modify, or delete any resource of this repo, clone it and create a new branch:

```
git checkout -b newbranch
```

Once you have your changes done, open a PR and add @MarioRoblesDOU as the approver.

If your PR is approved, run the following commands to apply the insfrastructure:

> You just need to run the first command the first time and/or if the backend configuration change

```
terraform init
```

```
terraform fmt
```

```
terraform validate
```

```
terraform plan
```

```
terraform apply
```




