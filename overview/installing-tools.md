# Hello buddy! ✋

## Let's start with the installation of the tools you need for your stay in the program! 👨‍💻 👩‍💻


> **Note:** The Linux distribution of this instructions is based on debian and the installation of the tools is done via apt.


## Git:
```bash
Mac:

brew install git

Linux:
sudo apt install git-all

```
## Vagrant:
```bash
Mac:
brew install vagrant

Linux:
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install vagrant

```
## Python: 
Python is pre-installed on MacOS and Linux.
if you want the last verion of python, you can visit: https://www.python.org/downloads/macos/

## Docker:
- Mac:
https://docs.docker.com/desktop/mac/install/

- Linux(beta):
https://docs.docker.com/desktop/linux/

## Cloud CLIs:
```bash
Azure:
 Mac:
	brew update && brew install azure-cli
 Linux:
	curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

AWS:
 Mac:
	curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
	sudo installer -pkg AWSCLIV2.pkg -target /
 Linux:
	curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
	unzip awscliv2.zip
	sudo ./aws/install

GCP:
 https://cloud.google.com/sdk/docs/install?hl=es-419

```

## Terraform:
```bash
Mac:
brew tap hashicorp/tap
brew install hashicorp/tap/terraform

Linux:
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform
```

## Ansible:
```bash
sudo python get-pip.py
sudo python -m pip install ansible
```

## Packer:
```bash
Mac:
brew tap hashicorp/tap
brew install hashicorp/tap/packer

Linux:
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install packer
```

## Kubernetes Manager (Kubectl):
- Mac:
https://kubernetes.io/docs/tasks/tools/install-kubectl-macos/
- Linux: https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/

## Helm:
```bash
Mac:
brew install helm

Linux:
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
sudo apt-get install apt-transport-https --yes
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm
```

## Vault:
```bash
Mac:
brew tap hashicorp/tap
brew install hashicorp/tap/vault

Linux:
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install vault
```

# Done! 🎉


