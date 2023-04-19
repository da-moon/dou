# techm-nx-engineering-cloud

## Usage
Run nx_base_infra.yaml first. Once all resources are created you will need to create 2 resources manually as Cloudformation does not have an existing resource for it.
ImageBuilder for Appstream
Image
AD Connector

Once you created the resoures proceed to execute stream_resources.yaml
That will create Appstream Stack and Fleet and Workspace.

## Modules nx_base_infra

### VPC
TechM::NX::VPC::MODULE

Creates following resources:
- VPC
- InternetGateway
- InternetGatewayAttachment

Outputs:
- VpcId
- CidrBlock
- InternetGatewayId

### Subnets
TechM::NX::VPC::MODULE
Creates following resources:
- Subnet

Outputs:
- SubnetId

### NatGW
TechM::NX::NATGW::MODULE
Creates following resources:
- ElasticIP
- NatGateway

### Security Group
TechM::NX::SecGroup::MODULE
Creates following resources:
- SecurityGroup

### Security Group Rule
TechM::NX::SGRule::MODULE
Creates following resources:
- Inbound Rule

### Route Table
TechM::NX::RouteTable::MODULE
Creates following resources:
- RouteTable
- Route VPC
- Route IGW or NatGW
- Subnet association
*Any additional routes or subnet associations have to be done explicitly with the AWS type*

### IAM
TechM::NX::IAM::MODULE
Creates following resources:
- IAM Role
- IAM Policy

### Secrets Manager
TechM::NX::SM::MODULE
Creates following resources:
- SecretPasssword or Secret

### Managed AD
TechM::NX::ManagedAD::MODULE
Creates following resources:
- Managed Active Directory
Outputs:
- PrimaryDNS
- SecondaryDNS

### FSX
TechM::NX::FSx::MODULE
Creates following resources:
- FSX for Windows

### EC2
TechM::NX::EC2::MODULE
Creates following resources:
- Ec2 Instance

### ADFS
TechM::NX::ADFS::MODULE
Creates following resources:
- Ec2 Instance for Root CA
- Ec2 Instance for Sub CA
- Ec2 Instance for ADFS

### PeeringConnection
Creates peering connection between 2 VPCs


## Modules stream_resources.yaml

### Appstream
TechM::NX::AppStream::MODULE
Creates following resources:
- Fleet
- Stack

### Workspace
TechM::NX::WORKSPACE::MODULE
Creates following resources:
- Workspace
