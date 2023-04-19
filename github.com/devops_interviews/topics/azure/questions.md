## AWS Common Questions and answers

Please take this questions as a base for your interview, we can select basic or advance depending on the interviewee experience.

### Cheat Sheet

![Azure Cheat Sheet](https://github.com/DigitalOnUs/devops_interviews/blob/master/img/cheat-sheet/azure-cheat-sheet.png)

### Questions

- **Basic questions**:
    - What are Azure resources?
        + Any entity managed by Azure can be referred to as an Azure resource. The following are some examples of Azure resources: Storage accounts, virtual networks, virtual machines, etc.
    - Provide few Advantages of Resource Group:
        + In Resource Manager, we could easily maintain all the services which have been created under a single resource group which could be segregated by application wise if required. If we required deleting the services, instead of deleting one by one, we can able to delete all the services in a single click by deleting the resource group. To provide a permission of individual service, we could provide a permission to the resource group, whereas provided permission will be implemented to all the services.
    - What are the differences between Azure Service Manager and Azure Resource Manager?
        + ASM uses XML REST API and ARM uses JSON REST API. In ASM, it is difficult to delete the resources which have been created and in ARM we can easily group to delete the resources. ASM supports only specific PaaS workloads and in ARM it supports all workloads of PaaS.
    - What is the best feature for monitoring an Azure environment?
        + Using OMS / Log Analytics, we could monitor the Virtual Machines which are running in Azure.
    - With respect to monitoring an Application, what is the best feature?
        + Using Application Insights, we could monitor application transactions and performance.
    - What is Azure Data Lake?
        + Azure Data Lake is a cloud platform that supports Big Data Analytics through its unlimited storage for structured, semi-structured, or unstructured data of all types and sizes.
    - Define role instance in Azure:
        + A role instance is nothing but a virtual machine where the application code runs with the help of running role configurations. There can also be multiple instances of a role as per the definition in the cloud service configuration files.

    - How many cloud service roles are provided by Azure?
        + Cloud service roles comprise a set of application and configuration files. There are 2 kinds of roles provided by Azure:
            * Web role: This provides a dedicated web server belonging to IIS (Internet Information Services) that is used for automatic deployment and hosting of front-end websites.
            * Worker role: These roles help the applications hosted within them to run asynchronously for longer durations and are independent of the user interactions and generally do not use IIS. They are also ideal for performing background processes. The applications are run in a standalone manner.
    - Define Azure Service Level Agreement (SLA):
        + The Azure SLA is a contract that ensures or guarantees that when two or more role instances of a role are deployed on Azure, access to that cloud service is guaranteed for at least 99.95% of the time.
        + It also states that if the role instance process is not in the running state, then the detection of such processes and corrective action for the same will be taken 99.9% percent of the time.
        + If the mentioned guarantees are not satisfied at any point in time, then Azure credits a percentage of monthly fees to us depending on the pricing model of the respective Azure services.
    - What is NSG?
        + NSG stands for Network Security Group that has a list of ACL (Access Control List) rules which either allows/denies network traffic to subnets or NICs (Network Interface Card) connected to a subnet or both. When NSG is linked with a subnet, then the ACL rules are applied to all the Virtual Machines in that subnet.<br>Restrictions of traffic to individual NIC can be done by associating NSG directly to that NIC.


- **Advance questions**:
    - Define Azure virtual machine scale sets:
        + These are the Azure computation resources that can be used to deploy and manage sets of identical Virtual Machines (VMs).
        + These scale sets are configured in the same manner and are designed to support the autoscaling of the applications without the need for pre-provisioning of the VMs.
        + They help to build large-scale applications targeting big data and containerized workloads in an easier manner.
    - What do you understand about the "Availability Set"?
        + Availability Set is nothing but a logical grouping of VMs (Virtual Machines) that allows Azure cloud to understand how the application was developed for providing availability and redundancy.
        + Each VM in the availability set is assigned 2 kinds of domains by Azure:
            * Fault Domain: These define the grouping of VMs that would share a common power source and common network switch. The VMs within availability sets are separated across up to 3 fault domains by default. This separation of VMs in fault domains helps our applications to be available by reducing impacts of network outages, power interruptions, and certain hardware failures.
            * Update Domain: These indicate the grouping of VMs and underlying hardware which are eligible to be rebooted at the same time. Only one update domain can be rebooted at a time, however, the order of reboot does not proceed in a sequential manner. Before the maintenance of another update domain, the previously rebooted domain is given a recovery time of 30 minutes to ensure that the domain is up.
        + Azure provides flexibility to configure up to 3 fault domains and 20 update domains for an availability set.
    - What are the available options for deployment environments provided by Azure?
        + Azure provides two deployment environments, they are:
            * Staging Environment: This environment is used for validating the changes of our application before making them live into the main environment.<br>Here, the application is identified by means of GUID (Globally Unique Identifier) of Azure which has the URL as: `GUID.cloudapp.net`
            * Production Environment: This is the main environment where our application goes live and can be accessed by the target audience which can be accessed by means of DNS friendly URL: `appName.cloudapp.net`
    - Define azure storage key:
        + Azure storage key is used for authentication for validating access for the azure storage service to control access of data based on the project requirements.
        + 2 types of storage keys are given for the authentication purpose -
            * Primary Access Key
            * Secondary Access Key
        + The main purpose of the secondary access key is for avoiding downtime of the website or application.
    -  What do you understand by Azure Scheduler?
        + Azure Scheduler helps us to invoke certain background trigger events or activities like calling HTTP/S endpoints or to present a message on the queue on any schedule.<br>By using this Azure Schedule, the jobs present in the cloud call services present within and outside of the Azure to execute those jobs on-demand that are routinely on a repeated regular schedule or start those jobs at a future specified date.
    - What would happen when the maximum failed attempts are reached during the process of Azure ID Authentication?
        + In case of maximum failed attempts, the azure account would get locked and the method of locking is dependent on the protocol that analyzes the entered password and the IP addresses of the login requests.
    - What would be the best feature recommended by Azure for having a common file sharing system between multiple virtual machines?
        + Azure provides a service called Azure File System which is used as a common repository system for sharing the data across the Virtual Machines configured by making use of protocols like SMB, FTPS, NFS, etc.
    -  What is Azure Blob Storage?
        + Azure Blob storage is the object storage solution provided by Microsoft for the cloud. Blob stands for “Binary Large Object”. Blob-based storage is used to store massive unstructured data in terms of text or binary format. It is ideal for serving documents/images/audio/video/text directly to browser.
        + The data stored in the blob storage is accessible from anywhere in the world. The blobs are tied to user accounts by grouping them into containers. The Azure Blob Service has 3 components:
            * Storage Account: This can be a General Storage Account or Blob Storage Account registered in Microsoft Azure.
            * Container: Container is used for grouping blobs. We can store an unlimited number of blobs in a container. The name of the container should start in lowercase.
            * Blob: A blob is a Binary Large Object like a file or document of any type and size. There are 3 kinds of Blobs supported by Azure:
                * Block blobs: These are intended for text and binary files and can support up to 195GB, i.e up to 50k blocks of up to 4MB each.
                * Append blobs: These are used for appending operations like logging data in log files.
                * Page blobs: These are meant for frequent read/write operations.
    - What are the possible causes of the client application to be disconnected from the cache?
        + Client-side causes:
            * The application might have been redeployed.
            * The application might have just performed a scaling operation.
            * The client-side networking layer has been changed.
            * There might be transient errors in the client or the network between the client and the server.
            * Another possible reason could be the bandwidth threshold limits have been crossed.
        + Server-side causes:
            * It might occur if the Azure Redis Cache service itself might undergo a failover from the primary to the secondary node.
            * The server instance where the cache was deployed might have undergone patching or maintenance.
    - How can a VM be created by means of Azure CLI?
        ```
        az vm create `   
        --resource-group myResourceGroupName `   
        --name myVM --image win2016datacenter `   
        --admin-username AzureuserNAME `   
        --admin-password AzurePASSWORD
        ```
