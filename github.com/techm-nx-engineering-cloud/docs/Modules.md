# NX Modules
## Name Convention
### Module
- TechM::NX::resource::MODULE

### Parameters 
- Parameter+name
e.g ParameterVpcName

### Resource Module
- Resource+name
e.g ResourceVpcNx

### Resource Main
- ResourceName+identifier
e.g VpcNx
e.g NatGWNxShared

## Regions
Juan - Sao Paulo
Elizabeth - London
Sangeeta - 

## VPC Modules - Juan
- Resource VPC
- Resource IGW
- Resource IGWAttach

## Subnet Module - Elizabeth
- Resource Subnet
- Resource NATGW

## EIP Module - Juan
- Resource EIPNATGW

## RouteTable Module - Juan
- Resource RouteTable
- Resource RouteTableAssociation

## Security Group Module - Eli
- Resource Security Group

## IAM Module - Sangeeta
- Roles Resource
- ManagedPolicy Resource

## Managed AD Module - Eli
- Resource Managed AD

## EC2 Module
- EC2 Resource

## Appstream Module - Elizabeth
- Directory Configs
- Fleet
- Stack
- Fleet Association

## FSX Module - Juan
FSX Resource

## Module Workspace - Sangeeta
AD Connector Resource
- Workspace Resource

## Secrets Module - Sangeeta
- Secrets Resource