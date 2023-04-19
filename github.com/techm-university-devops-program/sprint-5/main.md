# Main Activity: Final

In this activity you will set up your DevSecOps environment with HashiCorp Vault, trough Terraform, Ansible, and integrating it to secure your CI/CD with GitHub Actions.

Also you will prepare your final presentation and your extra materials (speech, slides, etc.) to be shared with the community.

## Instructions:

### Ansible:
- Go to your `ansible` directory
- You can use the previous playbook from the past activity or create a new one.
- Create a role called `vault` to configure your Vault instance.
- Your role needs to have the following requeriments:
	- all hosts
	- become = true
	- update the linux packages
	- install jq
	- install unzip
	- install vault binary
	- configure Vault
	- initialize Vault
- The Vault configuration needs to have the following parameters:
	- UI enabled and reachable from the web
	- File or remote storage for the secrets
	- tcp listener for the web UI
	- TLS certificate disabled
	- vault.service file to start the daemon
	- mlock disabled

### Packer / Github	Actions:

In this part, you will automate your ansible playbook with packer or github actions.

If you are using packer, create a snapshot of your Ansible role and upload it to Azure, then	you can use it to replace the OS image of your Terraform VM with the one created by you.

if you are using GitHub Actions, create a new pipeline you will use to automate your ansible playbook and configure your VM instance created in Terraform.


### Vault:
Go to your VM instance to check the status of your Vault instance
`yourVmIp:8200`

### Terraform:
- Go to your `terraform` directory.
- Add the `vault` provider to your Terraform configuration.

Create a new Terraform configuration file called `vault.tf` to create the following:
- Enable KV secret engine.
- Create an access policy to allow the CI/CD manage the secrets.
- Enable a token based authentication for GitHub Actions.
- Put all of the secrets in the KV secret engine.

Run Terraform apply to provision the Vault instance.

### GitHub Actions:
- Go to your `.github/workflows` directory.
- Change all of the secrets from GitHub Actions to Vault.
- Add the Vault Plugin to all of your pipelines.
- Replace the secrets	in the GitHub Actions with the ones stored in Vault.
-	Run the pipeline to ensure that the secrets are pulled from Vault.

### Final Presentation:
You need to prepare a final presentation to be shared with the community.

- Include a README.md with all the explanation of your solution.
- Prepare a Speech in english.
- Create diagrams to show the flow of your solution.
- Prepare a slides with all the information you need to share.


### Let's go! you already finished the program! :) 🥳 🎉




