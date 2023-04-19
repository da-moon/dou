# Terraform Lab 🏗

# 1. My first IaC

### Instructions:
Build a very basic infrastructure in your preferred provider.
1. You can create a repository for the project
2. Declare the provider and design a simple infrastructure (a single instance of a VM, a subnet and a virtual network, for example)
3. Create your file structure
4. Add the resources, providers and all objects that will compose the project
5. Validate, Plan, Apply, Destroy
6. Profit

Think of this as your hello world.

# 2. Working on teams and managing backends

### Instructions:

You will create the objects needed for a backend in Azure, using first a local backend, and then using a remote backend.

Part 1 - work by yourself

Use the code from activity 1, and change the path of the state file.
Document, with text and screenshots how you did it.

You can find some help here:
https://www.terraform.io/language/settings/backends

Part 2 - work in pairs

Create a storage account and a blob container in azure using az cli commands

```
#!/bin/bash

#variables
SUB_ID="replace this"
RG_NAME="replace this"
STORAGE_ACCOUNT_NAME="replace this"
CONTAINER_NAME="replace this"

# Create storage account

echo "Creating storage account and container! 🌚 " 

# Create storage account
az storage account create --resource-group $RG_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob
 
# Get storage account key
ACCOUNT_KEY=$(az storage account keys list --resource-group $RG_NAME --account-name $STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv)
 
# Create blob container
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME --account-key $ACCOUNT_KEY


echo "Done! your storage and container are successfully created! ✅ "

echo "Creating the service principal! 🌚 "

#create service principal
az ad sp create-for-rbac -n "replace this" --role Contributor --scopes /subscriptions/$SUB_ID/resourceGroups/$RG_NAME

echo "Done! your service principal is successfully created! ✅ save this output on a safe and local place"
```


Add the code to build another resource on the ```main.tf```	file:


Run ```terraform init, plan and apply```


Publish the code in a repo, and share the service principal credentials with your team.


The other person in the team must clone the repo, and modify something in the ```main.tf``` file
You could change:

The name of a resource
You could add tags
You could add another resource
Or all of the above!

By using the same credentials as env variables, you will be able to work on the configuration located in the Azure cloud, as a collaborative team.


Run ```terraform init, plan and apply```


Validate the remote state:



Take a screenshot of the details of the resources after step 6 and after step 8


Same trainee will run the init plan & apply

The other trainee will add another security group and run the same terraform cycle to deploy it.

# 3. Terraform Modules

### Instructions:

Use the code from activity 1

After you created the resources and confirmed that everything is working fine in Azure, we are going to proceed moduling these resources.

Use the concept of modules to separate the resources.

Include inputs and outputs in the modules.

Feel free to use the module structure that you would like to use.


