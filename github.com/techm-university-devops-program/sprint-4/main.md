# Main Activity: Kubernetes, Helm, Terraform and GitHub	Actions

In this activity, you will create a Kubernetes cluster, create and deploy a Helm chart trough GitHub Actions, and use Terraform to create and your final infrastructure.

## Instructions:

1. Go to your demo-app repository.

2. On the terraform directory that you create on the previous activity, create the following new resources:
	- An Azure Container registry.
	- An Azure Kubernetes cluster with a minimum of 1 node and a maximum of 3 nodes, linked to the Azure Container registry.

3. Run a terraform plan to create the resources and connect the cluster to your `kubectl`	context and trough `kubectl`, check the status of the cluster.

4. Go to the pipeline that you created in the Python and Docker	activity	and add the following steps:

	- Docker login to your Azure Container registry.
	- Push all the Docker images of your microservices to your Azure Container registry.

5. Go to your ACR and check if the images are pushed correctly.

6. In the [kubernetes example folder](https://github.com/DigitalOnUs/tmuni-devops-demo-app/tree/main/docs/examples/Kubernetes) of your repository, you will find the separate k8s manifests and a release manifest with all the deployments in one file, you can use whatever you want of theses files.

7. Go to your demo-app repository and create a new directory called `helm-chart`.

8. Move the manifest files that you choose to the `helm-chart` directory.

9. Change the image links in the manifests to the images that you pushed to your ACR.

10. Create your Helm Chart in the `helm-chart` directory.

12. Go to your `.github/workflows` directory and create a new pipeline to deploy your Helm Chart with the following requisites:
	- The pipeline must be triggered by a successful pull request to the master branch.
	- Use Ubuntu 18.04 as the base image.
	- Use the `ACTIONS_ALLOW_UNSECURE_COMMANDS`	environment variable to allow the use of the `helm` command.
	- Login to the Azure CLI.
	- Login to the ACR
	- Login to the Cluster
	- Checking	the status of the cluster
	- Deploying the Helm Chart











