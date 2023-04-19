# Azure Windows Virtual Desktop 

Azure windows virtual Desktop with packer and ansible 

--------------------------------------------------------------------------------

## Description

This project creates a windows custom image from packer and uses ansible as provisioner to install software required and deploys with terraform.

## Prerequisites

- Azure Account with permissions to create resources.
- Software packages saved in Azure Artifacts
  - Telit DeviceWise Workbench
  - Asset Gateway for Windows

- On your MacBook:

  - `brew install terraform`
  - `brew install packer`
  - `brew install ansible`



--------------------------------------------------------------------------------

## Supported Cloud Platforms

<img src="./_docs/azure_logo.png" width="50" />

## Installation 

There are two steps for installation, building the custom image from packer then terraform deployment.

### Building the custom image

1. Navigate to `build/server/`
2. Create a file called `variables.pkrvars.hcl` 
3. Set the variables in `variables.pkrvars.hcl` from the variables of `/build/server/variables.pkr.hcl`
4. Run the command `packer build -var-file="variables.pkrvars.hcl" .`

Once is built and save in azure it will output like this 

```bash
==> Builds finished. The artifacts of successful builds are:
--> azure-arm.avd: Azure.ResourceManagement.VMImage:

OSType: Windows
ManagedImageResourceGroupName: fis
ManagedImageName: windows-packer-devicewise
ManagedImageId: /subscriptions/<sensitive>/resourceGroups/fis/providers/Microsoft.Compute/images/windows-packer-devicewise
ManagedImageLocation: westcentralus
```


Then go to step [deployment](#Deployment)

### Deployment 

1. Set the variables in `/variables.tf`
2. Initialize to terraform `terraform init`
3. Save the plan `terraform plan -out=tfplan`
4. Run the plan `terraform apply tfplan`

Once is deployed it will output like this 

```
Apply complete! Resources: 24 added, 0 changed, 0 destroyed.

Outputs:

avd_local_admin_passwords = <sensitive>
avd_vm_public_ips = [
  "13.78.208.205",
]
```

## Usage

After the Windows Virtual Desktop is deployed, you can connect to AVD with an [RDP Client](https://docs.microsoft.com/en-us/windows-server/remote/remote-desktop-services/clients/remote-desktop-clients).

Preferably update the values in `/avd-fis.rdp` with the `ip address` generated in terraform and your `email` and then import it in the RDP client

## Maintainers

- Edgar Lopez edgar.lopez@techmahindra.com