# README

# armory-terraform-smtp

In this repository you will find the way to configure the Amazon SES in order to use the SMTP server and deploy a Amazon S3 bucket with a spinnaker secrets file then you will be able to get the secrets from your own spinnaker application. 

## Requirements:

- Git installed on your compter.
- Terraform installed on your computer.
- Access to AWS console.

## Instructions:

- First clone the repo with the following command:
    
    ```bash
    git clone git@github.com:DigitalOnUs/armory-terraform-smtp.git
    ```
    
- Run the next command:
    
    ```bash
    terraform init
    ```
    
- Go to the file variables.ft, you must add your customized variables by creating the `terraform.tfvars` file in the root folder, it follow the next structure:
    
    ```bash
    aws_credentials_location = "/route/to/.aws/credentials"
    aws_profile_name = "default"
    region = "aws_region"
    mail_identity = "email@example.com"
    smtp_user = "smtp_user"
    policy_arn = "arn:aws:iam::aws:policy/examplePolicy"
    smtp_endpoint = "host_example.amazonaws.com"
    ss_file_name = "spinnaker-secrets.yml"
    ss_file_location = "/Route/to/spinnaker/secrets/file/spinnaker-secrets.yml"
    bucket_name = "bucket-example"
    ```
    
    **Variables description:**
    
    - **aws_credentials_location**: Is the location of your own AWS credentials file.
    - **aws_profile_name**: Is the profile name that you are going to use to sign in into AWS.
    - **region**: Select the AWS region that you are going to work at.
    - **mail_identity**: Is a mail where you must have access. With this mail AWS SES verified your identity.
    - **smtp_user**: Is a name of the new IAM user for the SMTP server.
    - **policy_arn**: Is the policy’s arn to give the smtp_user access to the S3 bucket.
    - **smtp_endpoint**: Is the name of the SMTP endpointon the AWS SES
    - **ss_file_name**: Is the name of the spinnaker secrets file.
    - **ss_file_location**: Is the location where terraform going to allocate the spinnaker secrets file on your computer
    - **bucket_name**: The name of the bucket where terraform will upload the spinnaker secrets file.
- Run the following commands:
    
    ```bash
    terraform plan
    terraform apply
    ```
    
    You must received a mail to verified your **mail_identity,** click on the link, if you don’t click on it, the smtp server will not send emails.
    
    Now you have already deploy and configure the SMTP server.
    
    In your app you only have to access with these variables:
    
    - mail form
    - seshost
    - sesusername
    - sespassword
    
    Access to the S3 bucket on the spinnaker secrets file by using the following code:
    
    ```bash
    encrypted:s3!r:aws_region!b:bucket-example!f:spinnaker-secrets.yml!k:sesaws.mailfrom
    encrypted:s3!r:aws_region!b:bucket-example!f:spinnaker-secrets.yml!k:sesaws.seshost
    encrypted:s3!r:aws_region!b:bucket-example!f:spinnaker-secrets.yml!k:sesaws.sesusername
    encrypted:s3!r:aws_region!b:bucket-example!f:spinnaker-secrets.yml!k:sesaws.sespassword
    ```
    
- To delete the infrastructure run:
    
    ```bash
    terraform destroy
    ```