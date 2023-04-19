# Cloud Lab ☁️

For this lab, you will be using the cloud provider of your choice. (we recommend use Azure, because you will be learning Azure in this program)

# 1. Mindmap

###	Instructions
Create **1 mindmap**, you can choose to do it by hand and take a picture, or use a digital tool like draw.io, lucidchart, miro and so on; the mindmap needs to synthesize, abstract, and overall display your own understanding of the concepts and the necessary resources to be able to deploy a VM in your own cloud infrastructure.

* Favor clear keywords over long definitions
* You may use images, icons, or symbols (optional)
* Challenge yourself to **not copy-paste**, but to understand and write what you understand about the concepts

# 2. UI vs CLI

### Instructions
Create a free account in your cloud provider and install the CLI (command line interface) of that provider on your computer.

Create a simple Linux VM in your cloud provider using the UI (user interface) and the CLI of that provider.

Login to your new VM via SSH and install Nginx.
```
sudo apt-get -y update
sudo apt-get -y install nginx
```

Document the steps you took to deploy a VM in your cloud provider.


# 3. Load Balancer

### Instructions
* To complete this activity, you should create two linux virtual machines, and both are them should be connected with a Load Balancer.

* You need to create all the resources with the CLI of your cloud provider.

* Furthermore, the virtual machines must have an installation of one of the next tools:
    - NGINX
    - Apache

For this, you can choose to install manually or with a script after creation, or include it with custom-data script in the creation process.

The activity must create an infrastructure that looks like the following diagram:

![miniInfra](/sprint-2/labs/img/activity2.png)

### Useful links:
- [Load Balancer](https://docs.microsoft.com/en-us/azure/load-balancer/load-balancer-overview)
- [Tutorial (Azure)](https://docs.microsoft.com/en-us/azure/load-balancer/quickstart-load-balancer-standard-public-portal?tabs=option-1-create-load-balancer-standard)
- [Tutorial (AWS)](https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-getting-started.html)
- [Tutorial (GCP)](https://cloud.google.com/community/tutorials/https-load-balancing-nginx)







