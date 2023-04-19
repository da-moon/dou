# The deployment of the AaaS application

testing
test danny 
## Description

This should be sufficient for 90% of docker app server deployments. This configuration will build an ECS service for your container and will route traffic to the following internal DNS name SERVICE_NAME.api.ENV.corvesta.net where SERVICE_NAME is value of the "service_name" parameter configured in your locals.tf and ENV is dev/qa/uat/prod based on the environment.

### Testing enpoint:
- Test elastic search: /people/person_search/
- Test RabbitMQ: /rabbitmq/read_write/
- Test database: /people/write_write_db/

### Important

All services using the "default_service" should be scaled with some version of autoscaling. Currently only cpu and memory based autoscaling can be configured. I recommend CPU autoscaling for almost all configurations unless there are special requirements for your service. You will not be able to scale your service through Terraform Enterprise manually anymore.

--------------------------------------------------------------------------------

This service will configure logging and ship all log messages sent to your docker container's STDOUT/STDERR to logstash and will tag those messages with service_name. To see your log messages, visit kibana and search for tag:"service_name"

I.E. Search kibana.dev.corvestacloud.com for: tag:"hello-world"

--------------------------------------------------------------------------------

This service exports the following environment variables to your docker container for consumption configuration of application logging / initialization:

- **DOGSTATSD_PORT_8125_UDP_ADDR** - The IP address to send messages to the datadog agent over
- **CONSUL_HOST** - Path & Port of consul: I.E: <http://consul.{env}.corvestacloud.com:8500>
- **LOGSTASH_ADDRESS** - The address of logstash you may use to for centralized logging configuration
- **LOGSTASH_TCP_PORT** - TCP port to send logs to logstash for JSON TCP logstash logging
- **LOGSTASH_UDP_PORT** - UDP port to send logs to logstash for JSON UDP logstash logging
- **LOGSTASH_GELF_UDP_PORT** - UDP Port to send logs to for GELF formatted logstash logs

## Prerequisites

1. If you're deploying to the cloud, then you must have your cloud infrastructure up already, currently we have AWS available. If you haven't done so already, go to<br>
  <https://gitlab.com/DigitalOnUs/singularity/waas/terraform_waas_aws> and follow the instructions there to stand up your AWS infrastructure.

2. If you're deploying to localhost, then go to <https://gitlab.com/DigitalOnUs/singularity/waas/local-dev-services/-/tree/master><br>
  and follow the instructions there to set up your localhost docker containers for vault, consul, and postgres.

## Installation

````
If deploying to AWS:  

    1\. Open up `dwarf.config` and uncomment the `LANDING_ZONE=` line if not uncommented already, and give it the EXACT value of your Terraform Enterprise workspace that your infrastructure is in - https://app.terraform.io/app/DoU-TFE/workspaces/.  Ensure that TERRAFORM_DESTROY is set to FALSE  
    2\. In `local.tf`, ensure that your vault_token and consul_token are correct.  
         a. These can be retrieved as follows(replace your <project_name> in the urls):  

                ```
                aws s3 cp s3://<project_name>-bucket-dev/consul_credentials.txt /dev/stdout | grep acl_master_token | sed 's/^.*: //'

                aws s3 cp s3://<project_name>-bucket-dev/vault_credentials.txt /dev/stdout | grep root_token | sed 's/^.*: //'
                ```
    3\. git add, commit, and push your changes.  This will kick off a circleci build, watch it here:  
       https://app.circleci.com/pipelines/github/DigitalOnUs  
    4\. Once the build is finished, it will take a few minutes for ECS/Fargate to come up.  Click on your cluster at   
       https://us-west-2.console.aws.amazon.com/ecs/home?region=us-west-2#/clusters and watch the `Services` and `Tasks`  
       tabs.  Once the `Task` shows up as `RUNNING`, then go to http://waas.<project_name>.douterraform.com/#about to view the
       app.  


If deploying to localhost:  
    1\. In `dwarf.config`, Comment out the `LANDING_ZONE=` line.  Ensure that TERRAFORM_DESTROY is set to FALSE   
    2\. In `local.tf`, ensure that your vault_token and consul_token are correct.  
        i. These can be retrieved as follows(replace your <project_name> in the urls):  

              ```
              aws s3 cp s3://<project_name>-bucket-dev/consul_credentials.txt /dev/stdout | grep acl_master_token | sed 's/^.*: //'

              aws s3 cp s3://<project_name>-bucket-dev/vault_credentials.txt /dev/stdout | grep root_token | sed 's/^.*: //'
              ```
    B. `docker-compose build`  
    C. `docker-compose up -d`  
    D. View your app at localhost:8000
````

## Cleanup

Change this from `FALSE` to `TRUE` in your `dwarf.config`, then add, commit, and push: `TERRAFORM_DESTROY=TRUE`

## Maintainers

- Sam Flint sam.flint@digitalonus.com

## Contributors

- Brian Conner brian.conner@digitalonus.com
