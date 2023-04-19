# FIS

## How to start

### Pre-requisites

1. Install terraform, follow this [steps](https://learn.hashicorp.com/tutorials/terraform/install-cli)

2. Install ansible, follow this [steps](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

3. Install azure-cli, follow this [steps](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)

4. Install JQ, follow this [steps](https://stedolan.github.io/jq/download/)

5. Sign in with Azure CLI following this steps [steps](https://learn.microsoft.com/en-us/cli/azure/authenticate-azure-cli)

6. Install azure-cli extension with the following command `az extension add --name azure-iot`

## Deployment

### Terraform - Create cloud resources

1. Run `terraform init` to initialize and download terraform modules.

2. Run `terraform plan` to check if have changes.

3. Run `terraform apply` to create resources if something is missing.

### Ansible - Digital Twin -> Add Models and Twins

1. The config for digital twins and models are located in the file `ansible_config.yml`, the keys are:
    - *directory* Folder where models are located
    - *twins* List of twins to be created
    - *models* List of models to be created

2. Run `ansible-playbook ansible_digitaltwins.yml --extra-vars "$(terraform output --json | jq 'with_entries(.value |= .value)')"`