# Main Activity: Terraform and Ansible

In this activity, you will learn how to use Terraform and Ansible to create and manage infrastructure.

You will create a Terraform workflow to create some test infrastructure and also deploy part of your final infrastructure, and configure it with Ansible.

You can use the cloud provider of your choice to create your infrastructure, but we recommend using Azure.

# Terraform

## Instructions:
- Go to your demo-app repository.
- Create a new directory called `terraform`.
- Create new files called `main.tf`, `variables.tf`, `provider.tf`, `backend.tf` in the `terraform` directory.
- Create the necessary configuration files in the `terraform` directory.
- Create the `.gitignore` file to avoid	committing your Terraform configuration files.
- Create the modules directory to store your Terraform modules and resources.
- If you are using Azure, you can create a new resource group or use an existing one.
- Create the following resources (you can separate in many modules that you want):
	- A virtual machine called (myTestVM), with CentOS 7 as the operating system.
	- A virtual machine called (VautVM), with Ubuntu 18.04 as the operating system.

Create the corresponding resources for the virtual machines, in case you use	Azure, you can create the following for each machine:
- subnet
- virtual network
- network interface
- public IP
- network security group (with rules to allow SSH, HTTP and 8200 port)
- nsg - interface association
- ssh key

If you're using other cloud providers, you can investigate the necessary resources to create your infrastructure.

- Run `terraform init`.
- Run `terraform plan`.
- Run `terraform apply`.

Go to the Azure portal and check if your infrastructure is created.

# Ansible

Instructions:
- Go to your demo-app repository.
- Create a new directory called `ansible`.
- create a playbook called `main.yml` in the `ansible` directory.
- Run the Ansible ping command to check if Ansible is able to connect to your infrastructure.

For the two instances, create the following:
- A user called 'Vault'
- update the package manager of each distro
- install VIM
- update Python

For the test instance, create the following:
- An ansible role called 'apache' or  'nginx' (you can follow the instructions in the `ansible_lab.md` file)
- Install the apache or the nginx web server on the VM with the role and check	if it is running.

Once you have your playbook ready, run it and check if its working.

# Automating the Deployment (Optional)
If you want to automate the deployment of your final infrastructure, you can use Terraform with Github Actions to create a workflow that will deploy your infrastructure.

If you want to automate your configuration management, you can use Ansible with Github Actions to create a workflow that will configure your infrastructure or use Ansible with Packer to create a OS image and use it with Terraform.

Both solutions are documented in the [labs folder](/sprint-3/labs/)

Once you finish	the activity, delete the test VM and their corresponding resources, and run a terraform plan again.





