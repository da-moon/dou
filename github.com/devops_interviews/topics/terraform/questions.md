## Terraform Common Questions and answers

Please take this questions as a base for your interview, we can select basic or advance depending on the interviewee experience.

### Cheat Sheet

![Terraform Cheat Sheet-1](https://github.com/DigitalOnUs/devops_interviews/blob/master/img/cheat-sheet/terraform-cheat-sheet-1.png)
![Terraform Cheat Sheet-2](https://github.com/DigitalOnUs/devops_interviews/blob/master/img/cheat-sheet/terraform-cheat-sheet-2.png)

- **Basic questions**:
	- Explain what IaC is:
		+ Is a tool that allows you to build, change, and version infrastructure safely and efficiently.
		  With terraform you describe your infrastructure using Terraform's high-level configuration language in human-readable, declarative configuration files.

	- Explain some terraform advantages:
		+ Cloud agnostic
		  Human readable
		  Terraform state allows you to track all the resources
		  Remote state file help yoou to work with many people
		  Commit your changes to a version control software 
		  Automate all the infrastructure we used to do manually
		  IaC Makes Infrastructure More Reliable
		  IaC Makes Infrastructure More Manageable

	- What is the terraform state file?
		+ This state is used by Terraform to map real world resources to your configuration, keep track of metadata, and to improve performance for large infrastructures. This state is stored by default in a local file named `terraform. tfstate`, but it can also be stored remotely, which works better in a team environment.

	- How do terraform handle simultaneus changes? 
		+ State locking

	- What is the core Terraform workflow (3 steps):
		+ Write, Plan, Apply.

	- Explain the basic terraform flow with commands?
		+ terraform init: Download all the neccesary plug-ins to start working and initialize the configurations files.
		+ terraform plan: Creates an execution plan, which lets you preview the changes that Terraform plans to make to your infrastructure.
		+ terraform apply: Executes the actions proposed in a Terraform plan to create, update, or destroy infrastructure.
		+ terraform destroy: Is a convenient way to destroy all remote objects managed by a particular Terraform configuration. Is an alias for `terraform apply -destroy`.

	- What is `terraform taint`?
		+ Informs Terraform that a particular object has become degraded or damaged. Terraform represents this by marking the object as "tainted" in the Terraform state, in which case Terraform will propose to replace it in the next plan you create.

	- What is a terraform provider?
		+ Are plug ins that interact with remote systems (like AWS, GCP, Azure, etc) that belong to the root tf file. It uses a provider block that has 2 meta arguments:
			+ Version (which is not longer recommended, better use provider requirements)
			+ alias: When you want to use the same provider but with different configuration. Without it it uses the default configuration

	- What is a terraform workspace?
		+ Workspaces are technically equivalent to renaming your state file. 
		Terraform stores the workspace states in a directory called terraform.tfstate.d
		A common use for multiple workspaces is to create a parallel, distinct copy of a set of infrastructure in order to test a set of changes before modifying the main production infrastructure
		Terraform starts with a single workspace named "default". This workspace is special both because it is the default and also because it cannot ever be deleted.

	- What is a terraform resource?
		+ Resources are the most important element in the Terraform language. Each resource block describes one or more infrastructure objects, such as virtual networks, compute instances, or higher-level components such as DNS records.

	- What is a terraform module?
		+ A module is a container for multiple resources that are used together. Every Terraform configuration has at least one module, known as its root module, which consists of the resources defined in the . tf files in the main working directory.

	- What is terraform backend?
		+ Backends define where Terraform's state snapshots are stored.

	- What is the command: `terraform ftm`?
		+ fmt is used to rewrite Terraform configuration files to a canonical format and style.
		it is always recommended when you are working on TF to.


- **Advance questions**:
	- Name the 2 alternative terraform planning modes:
		 + Destroy mode: Creates a plan whose goal is to destroy all remote objects that currently exist, leaving an empty Terraform state: `-destroy`
		 + Refresh-only mode: Creates a plan whose goal is only to update the Terraform state and any root module output values to match changes made to remote objects outside of Terraform: `-refresh-only`.

	- After Terraform v0.15.2  what should we use instead of terraform taint?
		+ `terraform apply -replace="aws_instance.example[0]"`

	- Explain what is a provisioner, what is the difference between local-exec or remote-exec?
		+ Provisioners are used to execute scripts on a local or remote machine as part of resource creation or destruction. Provisioners can be used to bootstrap a resource, cleanup before destroy, run configuration management, etc.
		Provisioners can be used to model specific actions on the local machine (local-exec) or on a remote machine (remote exec) in order to prepare servers or other infrastructure objects for service.

	-  Why provisioners should be your last resort?
		+ Because there will always be certain behaviors that can't be directly represented in Terraform's declarative model, adding complexity and uncertanty to Terraform.

	- What is the difference between a `count` and a `Dynamic block`?
		+ Dynamic block: It is a way in which you can create a recusrive process (Like an if) in which you can change the internal values of the resource (and the count cannot change the values).
        + Count: Create a quantity of exact instances or modules that you already defined with the same values.

    - What is the command: `terraform state`?
    	+ The terraform state command is used for advanced state management. (modify state file)
		it works with remote state as we normally do.

	- What is the command: `terraform import`?
		+ The terraform import command is used to import existing resources into Terraform. 
		Import will find the existing resource from ID and import it into your Terraform state at the given ADDRESS.
			+ ADDRESS: ADDRESS must be a valid resource address ([module path][resource spec])
			+ ID: is dependent on the resource type being imported. For example, for AWS instances it is the instance ID (i-abcd1234) but for AWS Route53 zones it is the zone ID (Z12ABC4UGMOZ2N).

	- Explain how you can handle different Environments (Production, staging, Development, etc)?
		+ Terraform Workspaces or with a good folder strategy within gitops (explain this).

	- Best way to handle secrets with terraform?
		+ Vault provider

