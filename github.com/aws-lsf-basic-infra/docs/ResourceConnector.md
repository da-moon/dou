# LSF : Resource Connector

## IBM Documentation Reference:

[Resource Connector](https://www.ibm.com/docs/en/spectrum-lsf/10.1.0?topic=connnector-lsf-resource-connector-overview)

The resource connector for LSF enables LSF clusters to borrow resources from supported resource providers.
In this project resource connector is being used to borrow hosts from aws provider.

Requirements:
- LSF Version 10.1 
- Fix Pack 12
- LSF Cluster up an running
- Java Runtime Environment (JRE) version 8

#### Required Files
Resource Connector needs 4 files to enable AWS as host provider. All the files will be required in the management host (Master).
- awsprov_template.json
- awsprov_config.json
- user_data.sh
- hostProviders.json

Each file belongs to a specific location for AWS to be enabled.

###### user_data.sh 
Should be placed in */<LSF_TOP>/<VERSION>/resource_connector/aws/scripts*
This is the user data the new instance will execute once created from resource connector. In here all the needed steps for the new instance to join the cluster should be added.
*Note that this script should contain the reference to LSF_TOP as shown in the line 1 of the following example*
e.g 
```sh
LSF_TOP="/usr/share/lsf"
echo "source /usr/share/lsf/conf/profile.lsf" | tee -a /etc/profile 
./hostsetup --top="/usr/share/lsf" --boot="y" 
lsadmin limstartup
```

###### hostProviders.json 
Should be placed in */<LSF_TOP>/conf/resource_connector*
This file will contain the definition of the provider. Where to find the configuration files and scripts and the time the provider will wait for the new worker to join the cluster if this time is reached and the instance is not yet in the cluster the instance will be terminated.
```sh
{
    "providers":[
        {
            "name": "aws",
            "type": "awsProv",
            "confPath": "resource_connector/aws",
            "scriptPath": "resource_connector/aws",
            "provTimeOut" : 20
        }
    ]
}
```

###### awsprov_config.json 
Should be placed in */<LSF_TOP>/conf/resource_connector/aws/conf*
This file will contain the parameters needed for resource connector to connect to AWS
| Variable | Value  |
|----------|--------|
| LogLevel | TRACE  DEBUG  INFO |
| AWS_CREDENTIAL_FILE | This is the path where your credentials of aws are placed in the instance. Usually under /home/your-user/aws/credentials  |
| AWS_REGION | The region where you are deploying your LSF cluster  | 
```sh
{   
    "LogLevel": "TRACE",
    "AWS_REGION": "_REGION_",
    "AWS_SPOT_TERMINATE_ON_RECLAIM": "true"

}
```


###### awsprov_template.json 
Should be placed in */<LSF_TOP>/conf/resource_connector/aws/conf*
This file will contain all the details of the instance that is going to be created through resource connector.
| Variable | Value  |
|----------|--------|
| Root key 'templates' | This is the main array, should be all lower case and never changes |
| templateId | Any name. You can have as many templates as you want  |
| attributes | This is the instance attributes modify the value accordingly | 
| awshost | This will tag this template to be used when aws provider is required | 
| zone | The region on aws where LSF cluster is deployed | 
| pricing | For AWS can be ondemand or spot and this will define along with other parameters if the instance will be an os spot instance or ondemand in AWS | 
| imageId | This is the image that will be used for the new instance created from resource connector. Use a custom image so the provisionin process is faster. See Packer.md for AMi creation details | 
| subnetId | The subnet on aws where the new instance will be deployed | 
| vmType | Can be any type e.g t2.micro, m5.large, etc. This value can have multiple vm types as long as in the pricing attribute is set as spot. If on demand is set then only one value is allowed  | 
| maxNumber | The number of VMs that will be deployed per request | 
| keyName | Existing AWS Key pair | 
| securityGroupIds | The region on aws where you are deploying LSF cluster | 
| instanceProfile | Exiting role id in AWS | 
| instanceTags | Any tag the instance will need | 
| userData | User data script to be executed in the new instance. Always under /<LSF_TOP>/<VERSION>/resource_connector/aws/scripts/user_data.sh | 
| fleetRole | The arn of a role with tagging permissions | 
| spotPrice | The price to get the instance. SHould be greater than 0 | 
| allocationStrategy | diversified or lowestPrice | 

e.g
```sh
{ 
    "templates": [
        {
            "templateId": "templateA",
            "attributes": {
                "type": ["String", "X86_64"],
                "ncpus": ["Numeric", "4"],
                "ncores": ["Numeric", "1"],
                "nram": ["Numeric", "512"],
                "awshost": ["Boolean", "1"],
                "zone": ["String", "_REGION_"],
                "pricing": ["String", "spot"]
            },
            "imageId": "_AMI_",
            "subnetId": "_SUBNET_",
            "vmType": "t2.micro, c5.2xlarge, c5.4xlarge, m5.large",
            "maxNumber": "1",
            "keyName": "_KEYPAIR_",
            "securityGroupIds": ["_SG_"],

            "instanceProfile" : "_PROFILE_",
            "instanceTags": "group=LSF;project=Amazon;Name=lsf_spot_host",
            "userData": "/usr/share/lsf/10.1/resource_connector/aws/scripts/user_data.sh",
            "fleetRole": "arn:aws:iam::237889007525:role/aws-ec2-spot-fleet-tagging-role",
            "spotPrice": "0.6",
            "allocationStrategy":"diversified"
        }
    ]
}
```

#### Enable AWS Host Provider

Once we have all the files in the right locations we need to add configuration changes to some files in the management host:

In */<LSF_TOP>/conf/lsf.conf*
To identify the external hosts when sending jobs
```sh
LSB_RC_EXTERNAL_HOST_FLAG="awshost"
```
To determine after how many time a host should be terminated. This value by default is in minutes so only the number is needed in the value.
```sh
LSB_RC_EXTERNAL_HOST_IDLE_TIME="5"
```

To determine after how many time a host that is unavailable should be deregistered ffrom the cluster. By defaultis in hours so if you want to change it to minutes you need to add the m after the number as shown below. Minimum allowed value is 10m, values lower that this will be set to 10m.
```sh
LSF_DYNAMIC_HOST_TIMEOUT="10m"
```

Go to */<LSF_TOP>/conf/lsf.shared* and add the following lines before the End Resources
```sh
pricing    String     ()       ()       (Pricing option: spot/ondemand)
awshost    Boolean    ()       ()       (instances from AWS)
```

Go to */<LSF_TOP>/conf/lsbatch/verification_cluster/configdir/lsb.modules* and add the following line before the End PluginModule
```sh
schmod_demand   ()      ()
```
Go to */<LSF_TOP>/conf/lsbatch/verification_cluster/configdir/lsb.queues* and add the following queue
```
Begin Queue
QUEUE_NAME   = awsexample
DESCRIPTION  = AWS queue
RC_HOSTS  = awshost
End Queue
```
Go to /<LSF_TOP>/conf/lsf.cluster.verification_cluster and replace the ```LSF_HOST_ADDR_RANGE``` with your subnet range.

After those changes execute
``` sh
./hostsetup --top="/usr/share/lsf" --boot="y"
```
Reboot the management host and wait until it comes up.

##### Validate AWS Host Provider is enable
- Check ebrokerd process to be up and running
- Validate ebrokerd logs. */<LSF_TOP>/logs/ebrokerd.log.dns*
- Go to */<LSF_TOP>/conf/lsf.shared* awshost resource should be present

#### Use AWS Host Provider
Submit a job.
You can specify the parameters resource connector will look in the template to spi up the instances.
If you are using ondemand use the following command. In here you are telling resource connector to look for an awshost template only
```sh
bsub -R "select[awshost]" -q awsexample your-job
```
If you are using on spot instances use the follwoing command. In here you are telling resource connector to look for an awshost template that is only on spor configured
```sh
bsub -R "awshost && pricing==spot" -q awsexample your-job
```

In case there is no erros it will take a few seconds for resource connector to create the resource and for you to be able to see them the AWS management console.
If you set ondemand the instance will be created immediatly, if you are using spot first a spot request will be created and the the instance.

Once the instance is up and running the user data set in the template will start and you can find the logs in */var/log/cloud-init-output.log*
The instance should have LSF up and running and join the cluster within the time window we set in hostProviders.json

Once the instance joined the cluster the job will be assigned to that instance and you can check that by running
```sh
bjobs -w -u all
```

##### Troubleshooting
First we need to check ebrokerd logs to look for any errors there.
```sh
cat */<LSF_TOP>/logs/ebrokerd.log.dns*
```
If ebrokerd logs are correct then look for aws specific logs
```sh
cat */<LSF_TOP>/logs/aws-provider.log.dns*
```
This is the place where you can find any errors on the aws connection. For example if the AMI or any other parameter in the template is not valid.

In case of any of the parameters is wrong or need to be changed. you have to:
- Kill the job 'bkill #job'
- If the instance was created, terminate the instance and cancel the spot request if exisiting
- Delete the active request or empty the file if you don't need the history 'touch /<LSF_TOP>/work/cluster/resource_connector/aws-db.json'
- Fix the parameter
- Reboot management host
- Send new job
