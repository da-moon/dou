#!/bin/sh 

# Enable the AWS secrets engine
vault secrets enable -path=aws aws

# Write the AWS credentials into Vault
vault write aws/config/root \
    access_key=$AWS_AK \
    secret_key=$AWS_SK \
    region=us-west-1

# Create a role for the AWS IAM user
vault write aws/roles/my-role \
        credential_type=iam_user \
        policy_document=-<<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1426528957000",
      "Effect": "Allow",
      "Action": [
        "ec2:*"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
