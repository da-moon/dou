## GCP Common Questions and answers

Please take this questions as a base for your interview, we can select basic or advance depending on the interviewee experience.

### Cheat Sheet

![GCP Cheat Sheet-1](https://github.com/DigitalOnUs/devops_interviews/blob/master/img/cheat-sheet/gcp-cheat-sheet-1.png)
![GCP Cheat Sheet-2](https://github.com/DigitalOnUs/devops_interviews/blob/master/img/cheat-sheet/gcp-cheat-sheet-2.png)
![GCP Cheat Sheet-3](https://github.com/DigitalOnUs/devops_interviews/blob/master/img/cheat-sheet/gcp-cheat-sheet-3.png)

### Questions

- **Basic questions**:
    - What are the various components of the Google Cloud Platform?
        + Google Compute Engine
        + Google Cloud Container Engine
        + Google Cloud Storage
        + Google Cloud App Engine
        + Google Cloud Dataflow
        + Google Cloud Machine Learning Engine
        + Google BigQuery Service
        + Google Cloud Job Discovery
        + Google Cloud Endpoints
        + Google Cloud Test Lab
    -  What are the main advantages of using Google Cloud Platform?
        + Google Cloud Platform is gaining popularity among cloud professionals as well as users for the advantages they offer over others:
            1. GCP offers competitive pricing.
            1. Google Cloud servers allow access to information from anywhere. 
            1. GCP has an overall better performance and service compared to other hosting cloud services.
            1. Google Cloud provides speedy and efficient server and security updates
            1. The security level of Google Cloud Platform is exemplary; the cloud platform and networks are secured and encrypted with various security measures.
    - What is Google Compute Engine?
        + Google Cloud Engine is the basic component of the Google Cloud Platform. It is an IaaS that provides flexible Windows and Linux-based virtual machines that are self-managed and hosted on the Google infrastructure. The virtual machines can run on local, durable storage options, and KVM.<br>For the purpose of control and configuration, Google Cloud Engine also includes REST-based API. It integrates with other GCP technologies (Google Cloud Storage, Google App Engine, Google BigQuery, etc.) that help extend its computational ability thus creating more complex and sophisticated applications.
    - What are the different methods for the authentication of Google Compute Engine API?
        + There are different methods for the authentication of Google Compute Engine API. They are:
            * Through client library
            * Using OAuth 2.0
            * Directly using an access token
    - What are the service accounts? How will you create one?
        + Service accounts are the special accounts related to a project. They are used for the authorization of Google Compute Engine in order to be able to perform on behalf of the user thus receiving access to non-sensitive data.<br>There are different service accounts offered by Google but mainly, users prefer to use Google Cloud Platform Console and Google Compute Engine service accounts.<br>The user doesn’t need to create a service account manually. It is automatically created by the Compute Engine whenever a new instance is created. Google Compute Engine also specifies the scope of the service account for that particular instance when it is created.
    - What are projects in the context of Google Cloud?
        + Projects are the containers that organize all the Google Compute resources. They comprise the world of compartments and are not meant for resource sharing. Projects may have different users and owners.
    - What do you know about Google Cloud SDK?
        + Google Cloud SDK (Software Development Kit) is a set of tools that are used in the management of applications and resources that are hosted on the Google Cloud Platform. It is comprised of the gcloud, gsutil, and bqcommand line tools.<br>Google Cloud SDK runs only on specific platforms like Windows, Linux, and macOS and requires Python 2.7.x. Other specific tools in the kit may have additional requirements as well.
    - How will you create a Project?
        + One needs to follow the below-mentioned steps for creating a Project:
            * Go to the Google Cloud Platform Console.
            * Once prompted, create a new project or select an existing project.
            * In order to set up billing, follow the prompts.
    - How will you differentiate a Project Id and Project Number?
        + There are two parameters to identify a project, one is the project id and another one is the project number. The two can be differentiated as follows:<br>Whenever a new project is created, the project number for that is created automatically whereas the project number is created by the user himself. The project number is compulsory and mandatory while the project id can be optional for may services (but it is a must for the Google Compute Engine).<br>Simple but one of the best Google Cloud interview questions, this question may be asked in the Google Cloud Engineer interview.
    - What are the different installation options for the Google Cloud SDK?
        + There are four different methods for the installation of the Google Cloud SDK. As per the requirement, the user can opt for any of the followings to install Google Cloud Software Development Kit:
            1. Using Cloud SDK with scripts or continuous integration or continuous deployment – in this case, the user can install google cloud SDK by downloading a versioned archive for a non-interactive installation of a specific version of Cloud SDK.
            1. By running Red Hat Enterprise Linux 7/CentOS 7 – YUM is used to get the latest released version of the Google Cloud SDK in the package format.
            1. Through running Ubuntu/Debian – APT-GET is used to get the latest released version of the Google Cloud SDK in the package format.
            1. For all the other use cases, the user can run the interactive installer to install the latest version of the Google Cloud SDK.

- **Advance questions**:
    - What are the libraries and tools for cloud storage on GCP?
        + JSON API and XML API are at the core level for the cloud storage on Google Cloud Platform. But along with these, Google also provides the following to interact with the cloud storage.
        1. Google Cloud Platform Console to perform basic operations on objects and buckets
        1. Cloud Storage Client Libraries that provides programming support for various languages.
        1. Gsutil Command-line Tool provides a CLI for the cloud storage.
        1. There are also a number of third-party libraries and tools like Boto Library.
    - Suppose you have deleted your instance by mistake. Will you be able to retrieve it back? If yes, how?
        + While It is a very simple question, it is based on a deep understanding of the Google cloud platform. The answer is no. It is not possible to retrieve the instances that have been deleted once. However, if it has been stopped, it can be retrieved by simply starting it again.
    - What are the Google Cloud APIs? How can you access them?
        + Google Cloud APIs are programmatic interfaces  that allow users to add the power of everything (from storage access to the image analysis based on machine learning) to Google Cloud-based applications.
        + Accessing Google Cloud APIs:
            * Cloud APIs can be easily accessed with the client libraries from the server applications. A number of programming languages can be used to access Google Cloud APIs. One can use mobile applications via Firebase SDKs or through third-party clients. Google Cloud Platform Console Web UI or Google SDK command-line tools can also be used to access the Google Cloud APIs.
    - What is Google BigQuery? What are the benefits of BigQuery for the data warehouse practitioners?
        + Google BigQuery is a replacement of the hardware setup for the traditional data warehouse. It is used as a data warehouse and thus, acts as a collective store for all the analytical data in an organization. Also, the BigQuery organizes the data table into the units that are known as datasets.<br>Using BigQuery proves very useful for the data warehouse practitioners, here are some of them:
            * BigQuery allocated query resources and storage resources dynamically on the basis of requirement and usage. Thus, it doesn’t require the provisioning of resources before usage.
            * BigQuery stores data in different formats such as proprietary format, proprietary columnar format, query access pattern, Google’s distributed file system and others for efficient storage management.
            * BigQuery is fully maintained and managed service. BigQuery engineers manage the updates and maintenance of the service fully without any downtime or hindrance to the performance.
            * BigQuery provides backup recovery and disaster recovery at a broader level. The users can easily undo the changes and revert to the previous state without making any request for the backup recovery.