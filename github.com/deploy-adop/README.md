# Deploy ADOP

We provide one command for deploying
[adop-docker-compose](https://github.com/Accenture/adop-docker-compose)
to an EC2 spot instance and one for destroying.

## Requirements

- Docker 17.03
- Bash 3.2
- Git 2.11

## Deploy


1. Set your AWS credentials in `params.sh`.
2. Set a VPC id in `params.sh`.
3. Pick an AWS instance name and run `./deploy.sh <AWS instance name>`.

## Destroy

1. Run `./destroy.sh`.
