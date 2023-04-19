Contributing to the Module
This repository contains the necessary Terraform code for managing the module. The below sections describe the pull request process.

How to Contribute
Clone the repository
Ensure you have the latest branch of master pulled down
Create a new branch from master, ensuring you include the JIRA ticket number in the branch name so it links back to it
Commit new change(s) and push them up in the repository. Ensure that you update the README documentation accordingly with the input/output variables using terraform-docs
Create the pull request from the feature branch to master, ensuring you add someone from the Cloud team.
On successful review, merge the pull request into master. Ensure that the person who merges the branch they put in the commit message what the change does at a summary level and include the following in order to automatically bump the git tag:
#patch
#minor
#major
You can also include if it's a feature, test, or update.

Below is an example of the commit:

#patch update: Changing the default argument of the input variable
#minor feat: Adding in new argument into the module
#major feat: Refactored entire module
Getting your Pull Request Merged Faster
There are several things to be able to merge the pull request in a timely manner:

Documentation: Explain what the change does inside the pull request description. This should be tied back to a JIRA ticket. It also may be valuable to update the README with a better description on what the module does or if there are new input/output variables.
Size of changes: Try and make the changes as small as possible. This makes it easier for the reviewers to actually review the code without having to go back and forth.
Test the changes: It's extremely helpful if you have tested the changes prior to creating the pull request. It's also helpful if you have example code/tests within the code so that others may see what you have done.
