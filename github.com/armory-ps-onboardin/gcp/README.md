
# GCP Login Setup Guide

## Prerequisites

Have gcloud sdk installed, follow installation guide [HERE](https://cloud.google.com/sdk/docs/install)

Check installation is correct by using the following command:

`gcloud info`

Install auth plugin to be able to download kubeconfig to your local computer
```bash
gcloud components install gke-gcloud-auth-plugin
```

# Login To GCP to and download kubeconfig

After use the following commands to login, configure gcloud to use PS Team project and generate kubeconfig
```bash
# login into GCP
gcloud auth login

# set project id that your cluster belongs to
gcloud config set project <project-name>
gcloud config set project ps-dev-361018			#PS team project
# gcloud config set project cloud-armory		#Armory project

# login to kubectl
gcloud auth application-default login

# download kubeconfig to local computer from a cluster by name
gcloud container clusters get-credentials <your-cluster-name> --zone <your-cluster-zone>
gcloud container clusters get-credentials armory-ps --zone us-central1-c					#PS team k8s cluster
```

Up to this point you are able to create a spinnaker instance and use the PS team k8s environment in GCP.

Use the following steps if you want to autenticate spinnaker against GCE, if you only want to run spinnaker don't use the folliwng steps.


# How to get your GCP Service Account

Spinnaker needs a service account to authenticate as against GCE, if you don’t already have such a service account with the corresponding JSON key downloaded, you can run the following commands to do so:

```bash
SERVICE_ACCOUNT_NAME=spin-sa-ps-gce
SERVICE_ACCOUNT_DEST=~/.gcp/gce-account.json

mkdir -p $(dirname $SERVICE_ACCOUNT_DEST)

SA_EMAIL=$(gcloud iam service-accounts list --filter="displayName:$SERVICE_ACCOUNT_NAME" --format='value(email)')

gcloud iam service-accounts keys create $SERVICE_ACCOUNT_DEST --iam-account $SA_EMAIL
```


# First Time Setup

If your PS Team have a running spinnaker that uses a service account you won't need to do the following.

Here are the steps to generate the service account and download the corresponding JSON key

```bash
# SERVICE_ACCOUNT_NAME=spinnaker-gce-account
SERVICE_ACCOUNT_NAME=spin-sa-ps-gce
SERVICE_ACCOUNT_DEST=~/.gcp/gce-account.json

gcloud iam service-accounts create $SERVICE_ACCOUNT_NAME --display-name $SERVICE_ACCOUNT_NAME

SA_EMAIL=$(gcloud iam service-accounts list --filter="displayName:$SERVICE_ACCOUNT_NAME" --format='value(email)')

PROJECT=$(gcloud config get-value project)

# permission to create/modify instances in your project
gcloud projects add-iam-policy-binding $PROJECT --member serviceAccount:$SA_EMAIL --role roles/compute.instanceAdmin

# permission to create/modify network settings in your project
gcloud projects add-iam-policy-binding $PROJECT --member serviceAccount:$SA_EMAIL --role roles/compute.networkAdmin

# permission to create/modify firewall rules in your project
gcloud projects add-iam-policy-binding $PROJECT --member serviceAccount:$SA_EMAIL --role roles/compute.securityAdmin

# permission to create/modify images & disks in your project
gcloud projects add-iam-policy-binding $PROJECT --member serviceAccount:$SA_EMAIL --role roles/compute.storageAdmin

# permission to download service account keys in your project
# this is needed by packer to bake GCE images remotely
gcloud projects add-iam-policy-binding $PROJECT --member serviceAccount:$SA_EMAIL --role roles/iam.serviceAccountActor

mkdir -p $(dirname $SERVICE_ACCOUNT_DEST)

gcloud iam service-accounts keys create $SERVICE_ACCOUNT_DEST --iam-account $SA_EMAIL
```
