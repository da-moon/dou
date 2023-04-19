## Cloud interview questions
#### Description:
In this document, you will find basic, intermediate and advanced questions related to Google Cloud Platform and also general questions about cloud computing to understand if the candidate has a solid base depending on the position that is applying for.

### Cheat Sheet
![Cloud Cheat Sheet-1](https://github.com/DigitalOnUs/devops_interviews/blob/master/img/cheat-sheet/cloud-cheat-sheet.png)

#### Role Definition:
A cloud engineer is an IT professional responsible for the technological work concerning Cloud Computing such as application deployments, monitors operations, and manages enterprise solutions.


| Activities | Task |
|------------|------|
| **Operation** | - Support infrastructure.<br>- Support applications.<br>- Sometimes design cloud solutions.<br>- Manage IAM services.<br>- Backups strategies.<br>- API’s management. |
| **Monitor** | - Setup monitoring alerts.<br>- Create operation metrics.<br>- Analyze audit logs.<br>- Create and analyze performance dashboards. |
| **Deployment** | - Repository maintenance.<br>- Container registry maintenance.<br>- Application deployment strategies.<br>- CI-CD implementations. |

### Cloud questions

| Question | Answer |
|----------|--------|
| Could you please mention the difference between the private cloud and on-premise? | **Private Cloud**: A private cloud consists of computing resources used exclusively by one business or organization.<br>**On-premise**: On-premise means that a company keeps all of this IT environment onsite either managed by themselves or a third-party.<br><br>**Summary**<br>**Private:**<br>1. It is owned by you or a 3rd party.<br>2. It is managed by you or a 3rd party.<br>3. Dedicated services only for your organization.<br><br>**On-premise:**<br>1. You are the infrastructure owner.<br>2. It is managed by you or a 3rd party.<br>3. Dedicated services only for your organization. |
| Could you please mention some public cloud providers? | 1. Amazon Web Services.<br>2. Microsoft Azure.<br>3. Google Cloud Platform.<br>4. IBM Cloud.<br>5. Oracle.<br>6. Digital Ocean.<br>7. Alibaba Cloud.<br>8. Triara. |
| Do you know some of the benefits of Cloud computing? | 1. Cost reduction.<br>2. Elasticity.<br>3. Modernization.<br>4. High Availability.<br>5. Mobility.<br>6. Disaster Recovery.<br>7. Insight.<br>8. Quality Control.<br>9. Ready for automation. |
| Do you know what the cloud service model is? | 1. Infrastructure as a service.<br>2. Platform as a service.<br>3. Software as a service.<br> 4. Data as a Service (DaaS). |
| Do you know what is IAM? | **Identity and Access Management** lets administrators authorize who can take action on specific resources, giving you full control and visibility to manage cloud resources centrally. |
|  Do you know the differences between private and public clouds? | **Public Cloud:** A public cloud, all hardware, software, and other supporting infrastructure is owned and managed by the third-party cloud service provider, you share the same hardware, storage, and network devices with other organizations or cloud “tenants.”<br><br>**Private Cloud:** A private cloud consists of computing resources used exclusively by one business or organization. The private cloud can be physically located at your organization’s on-site datacenter, or it can be hosted by a third-party service provider. But in a private cloud, the services and infrastructure are always maintained on a private network and the hardware and software are dedicated solely to your organization. |
| Do you know deployment strategies? | 1. Canary deployment.<br>2. Blue-Green deployment (red-black).<br>3. Rolling update deployment (Ramped).<br> 4. A-B deployment.<br>5. Shadow deployment. |
| Differences between a hybrid environment and a multi-cloud environment? | **Hybrid:** the term hybrid cloud describes a setup in which common or interconnected workloads are deployed across multiple computing environments, one based in the public cloud, and at least one being private.<br><br>**Multi-Cloud:** The term multi-cloud describes setups that combine at least two public cloud providers, also might include private computing environments. |
| Could you please explain what an operational log is? | It is a record of events related to the operation of the environment, this means app performance logs, hardware performance logs, network logs, etc. |
| Could you please explain what a security log is? | It is a record of events related to tracking the behavior and actions of the users inside a system to evaluate “who” did “what” activity and “how” the system behaved. |
| Do you know what is an alert inside the cloud? | Alert is a message or notification that gives timely awareness of a problem inside your cloud applications or environment. |
| What is load balancing? | A way for distributing incoming network traffic across a group of backend servers, also known as a server farm or server pool. |
| What types of load balancers do you know? | **L4 (Network Load Balancer):** It makes routing decisions at the transport layer (TCP/SSL).<br><br>**L7 (Application Load Balancer):** It makes routing decisions at the application layer (HTTP/HTTPS), supports path-based routing, and can route requests to one or more ports on each container instance in your cluster. |

The below questions are related to the most common services inside the popular clouds out in the market and the answer will be different depending on the managed cloud by the candidate.

#### Multicloud services

| Question | GCP | AWS | AZURE |
|----------|-----|-----|-------|
| What service provides virtual machines inside GCP/AWS/AZURE? | Google Compute Engine (GCE) | Amazon Elastic Compute Cloud (EC2) | Azure VM (VM) |
| What service provides object storage inside GCP/AWS/AZURE? | Google Cloud Storage (GCS) | Amazon Simple Storage Service (S3) | Azure Blob |
| What service is considered as PaaS for computing inside GCP/AWS/AZURE? | Google App Engine (GAE) | Elastic beanstalk | Azure App service |
| Which monitoring tool is inside GCP/AWS/AZURE? | Stack driver | Cloud Watch | Azure Monitor |
| What is the Infrastructure as a code tool inside GCP/AWS/AZURE? | Deployment Manager | Cloud Formation | Azure Resource Manager |
| What is the managed service for the Kubernetes cluster inside GCP/AWS/AZURE? | Google Kubernetes Engine (GKE) | Amazon Elastic Kubernetes Service (EKS) | Azure Kubernetes Service (AKS) |
| What event-driven service is inside GCP/AWS/AZURE? | Cloud Functions | AWS Lambda | Azure Functions |
| What is the Virtual Network service inside GCP/AWS/AZURE? | Cloud Virtual Network | Amazon VPC | Azure Net |
| What is the relational database service inside GCP/AWS/AZURE? | Cloud SQL | Amazon RDS Amazon Aurora | Azure SQL Database Azure Database for PostgresSQL Azure Database for MySQL |

