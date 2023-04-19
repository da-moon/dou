## AWS Common Questions and answers

Please take this questions as a base for your interview, we can select basic or advance depending on the interviewee experience.

### Cheat Sheet

![AWS Cheat Sheet-1](https://github.com/DigitalOnUs/devops_interviews/blob/master/img/cheat-sheet/aws-cheat-sheet.png)

### Questions

- **Basic questions**:
    - What is Amazon EC2?
        + EC2 is short for Elastic Compute Cloud, and it provides scalable computing capacity. Using Amazon EC2 eliminates the need to invest in hardware, leading to faster development and deployment of applications. You can use Amazon EC2 to launch as many or as few virtual servers as needed, configure security and networking, and manage storage. It can scale up or down to handle changes in requirements, reducing the need to forecast traffic. EC2 provides virtual computing environments called "instances".
    - Enlist few best Security practices for Amazon EC2.
        + Following are the best security practices for secure Amazon EC2:
            * To control access to your AWS resources using AWS identity and access management.
            * Limit the access to ports of instance by allowing only trusted hosts or networks.
            * Analyze the rules regularly in your security groups.
            * Open the permissions based on the requirement only.
            * Disable password-based login.
    - What is identity and access management (IAM) and how is it used?
        + Identity and Access Management (IAM) is a web service for securely controlling access to AWS services. IAM lets you manage users, security credentials such as access keys, and permissions that control which AWS resources users and applications can access.
    - What is amazon virtual private cloud (VPC) and why is it used?
        + A VPC is the best way of connecting to your cloud resources from your own data center. Once you connect your datacenter to the VPC in which your instances are present, each instance is assigned a private IP address that can be accessed from your data center. That way, you can access your public cloud resources as if they were on your own private network.
        ![VPC example](https://github.com/DigitalOnUs/devops_interviews/blob/master/topics/aws/vpc.png)
    - What is Route 53 and how you use it?
        + Amazon Route 53 is a highly available and scalable Domain Name System (DNS) web service. You can use Route 53 to perform three main functions in any combination: domain registration, DNS routing, and health checking.
    - What is S3 and what are the storage classes it has?
        + Amazon Simple Storage Service (Amazon S3) is an object storage service that offers industry-leading scalability, data availability, security, and performance. Customers of all sizes and industries can use Amazon S3 to store and protect any amount of data for a range of use cases, such as data lakes, websites, mobile applications, backup and restore, archive, enterprise applications, IoT devices, and big data analytics.
        + Storage Classes available with Amazon S3 are:
            * Amazon S3 Standard
            * Amazon S3 Standard-Infrequent Access
            * Amazon S3 Reduced Redundancy Storage
            * Amazon Glacier
    - What is a subnet and why do you make subnets?
        + A subnet is a range of IP addresses in your VPC and you make them to efficiently utilize networks that have a large no. of hosts.
    - What do you understand by the roles?
        + In AWS, Roles are providing permissions to the entities which you can trust within your account. Roles and users are similar to each other. However, while working with the resources it does not require creating the username and password, unlike users.
    - Define AWS Lambda:
        + An Amazon computes service which permits you to run code in the AWS Cloud without controlling servers is AWS Lambda.
    - What is EBS?
        + Amazon Elastic Block Store (Amazon EBS) is an easy-to-use, scalable, high-performance block-storage service designed for Amazon Elastic Compute Cloud (Amazon EC2).
    - Specify the types of Load Balancer in AWS services:
        + AWS Services uses two types of load balancers:
            * Classic Load Balancer
            * Application Load Balancer
    - What is a security group and what is the benefit to assign a security group to an instance?
        + A Security group is just like a firewall, it controls the traffic in and out of your instance. In AWS terms, the inbound and outbound traffic.
    - Can I connect my corporate datacenter to the Amazon Cloud?
        + Yes, you can do this by establishing a VPN(Virtual Private Network) connection between your company’s network and your VPC (Virtual Private Cloud), this will allow you to interact with your EC2 instances as if they were within your existing network.
    - What is the difference between Scalability and Elasticity?
    + Scalability is the ability of a system to increase its hardware resources to handle the increase in demand. It can be done by increasing the hardware specifications or increasing the processing nodes.

    + Elasticity is the ability of a system to handle increase in the workload by adding additional hardware resources when the demand increases(same as scaling) but also rolling back the scaled resources, when the resources are no longer needed. This is particularly helpful in Cloud environments, where a pay per use model is followed.


- **Advance questions**:
    - How does Amazon Route 53 provide high availability and low latency?
        + Amazon Route 53 uses the following to provide high availability and low latency:
            * Globally Distributed Servers - Amazon is a global service and consequently has DNS Servers globally. Any customer creating a query from any part of the world gets to reach a DNS Server local to them that provides low latency.
            * Dependency - Route 53 provides a high level of dependability required by critical applications.
            * Optimal Locations - Route 53 serves the requests from the nearest data center to the client sending the request. AWS has data-centers across the world. The data can be cached on different data-centers located in different regions of the world depending on the requirements and the configuration chosen. Route 53 enables any server in any data-center which has the required data to respond. This way, it enables the nearest server to serve the client request, thus reducing the time taken to serve.
    - How can you send a request to Amazon S3?
        + Amazon S3 is a REST Service, and you can send a request by using the REST API or the AWS SDK wrapper libraries that wrap the underlying Amazon S3 REST API.
    - What is the relation between the Availability Zone and Region?
        + An AWS Availability Zone is a physical location where an Amazon data center is located. On the other hand, an AWS Region is a collection or group of Availability Zones or Data Centers.<br>This setup helps your services to be more available as you can place your VMs in different data centers within an AWS Region. If one of the data centers fails in a Region, the client requests still get served from the other data centers located in the same Region. This arrangement, thus, helps your service to be available even if a Data Center goes down.
    - What are the different types of EC2 instances based on their costs?
        + The three types of EC2 instances based on the costs are:
            * On-Demand Instance - These instances are prepared as and when needed. Whenever you feel the need for a new EC2 instance, you can go ahead and create an on-demand instance. It is cheap for the short-time but not when taken for the long term.
            * Spot Instance - These types of instances can be bought through the bidding model. These are comparatively cheaper than On-Demand Instances.
            * Reserved Instance - On AWS, you can create instances that you can reserve for a year or so. These types of instances are especially useful when you know in advance that you will be needing an instance for the long term. In such cases, you can create a reserved instance and save heavily on costs.
    - Describe the relationship between an instance and AMI:
        + You can launch multiple types of instances from a single AMI. An instance type defines the host computer hardware which is used for your instance. Different computer and memory capabilities are provided by each instance type. Once an instance is launched, it resembles a traditional host, which is used for interaction as done with any computer.
    - Explain the process to vertically scale on Amazon Instance?
        + The steps to vertically scale on Amazon instance are:
            * Upgrade from the current instance to a new larger instance.
            * Pause the previous instance and discard it by detaching the root web volumes from the servers.
            * Now stop the live instance and also detach its root volume.
            * Attach the root volume to the new server after you note the unique device ID.
            * And finally, restart it.
    - Among the private and public subnets in VPC, which subnet should be preferred ideally for launching database servers and why?
        + Private subnet should be preferred ideally for launching the database servers.
    - Define Amazon ElasticCache:
        + A web service that is easy to deploy, scale, and store data in the cloud is Amazon ElasticCache.
    - Is it possible to connect the EBS volume to multiple instances?
        + It is not possible to connect the EBS volume to multiple instances. In fact, it is possible to connect numerous EBS Volumes to a single instance.
    - You have a distributed application that periodically processes large volumes of data across multiple Amazon EC2 Instances. The application is designed to recover gracefully from Amazon EC2 instance failures. You are required to accomplish this task in the most cost effective way.<br>Which of the following will meet your requirements?
        + **A. Spot Instances**(Correct one)
        + B. Reserved instances
        + C. Dedicated instances
        + D. On-Demand instances
    - How is stopping and terminating an instance different from each other?
        + Stopping and Starting an instance: When an instance is stopped, the instance performs a normal shutdown and then transitions to a stopped state. All of its Amazon EBS volumes remain attached, and you can start the instance again at a later time. You are not charged for additional instance hours while the instance is in a stopped state.
        + Terminating an instance: When an instance is terminated, the instance performs a normal shutdown, then the attached Amazon EBS volumes are deleted unless the volume’s deleteOnTermination attribute is set to false. The instance itself is also deleted, and you can’t start the instance again at a later time.
    - How is a Spot instance different from an On-Demand instance or Reserved Instance?
        + First of all, let’s understand that Spot Instance, On-Demand instance and Reserved Instances are all models for pricing. Moving along, spot instances provide the ability for customers to purchase compute capacity with no upfront commitment, at hourly rates usually lower than the On-Demand rate in each region. Spot instances are just like bidding, the bidding price is called Spot Price. The Spot Price fluctuates based on supply and demand for instances, but customers will never pay more than the maximum price they have specified. If the Spot Price moves higher than a customer’s maximum price, the customer’s EC2 instance will be shut down automatically. But the reverse is not true, if the Spot prices come down again, your EC2 instance will not be launched automatically, one has to do that manually.  In Spot and On demand instance, there is no commitment for the duration from the user side, however in reserved instances one has to stick to the time period that he has chosen.
    - If you want to launch Amazon Elastic Compute Cloud (EC2) instances and assign each instance a predetermined private IP address you should:
        + A. Launch the instance from a private Amazon Machine Image (AMI).
        + B. Assign a group of sequential Elastic IP address to the instances.
        + **C. Launch the instances in the Amazon Virtual Private Cloud (VPC).** (correct one)
        + D. Launch the instances in a Placement Group.
    - When should I use a Classic Load Balancer and when should I use an Application load balancer?
        + A Classic Load Balancer is ideal for simple load balancing of traffic across multiple EC2 instances, while an Application Load Balancer is ideal for microservices or container-based architectures where there is a need to route traffic to multiple services or load balance across multiple ports on the same EC2 instance.
    - When an instance is unhealthy, it is terminated and replaced with a new one, which of the  services does that?
        + When ELB detects that an instance is unhealthy, it starts routing incoming traffic to other healthy instances in the region. If all the instances in a region becomes unhealthy, and if you have instances in some other availability zone/region, your traffic is directed to them. Once your instances become healthy again, they are re routed back to the original instances.

