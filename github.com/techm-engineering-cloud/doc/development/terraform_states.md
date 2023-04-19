# Terraform states and passing variables

Each individual pipeline stage has its own terraform state stored in the S3 CI/CD bucket, where the key is determined by the stage name in the `run.sh` scripts.

The way that variables are passed between stages is that each stage stores its output in a json file in the CI/CD S3 bucket, and then the next stages read these files to extract from that json document the variables they need. Terraform scripts use these files to share information instead of terraform `variables` and `outputs`.

Terraform stages can also define their own `variables` if the data they need is not available from other stages. There are two ways for passing in the values:

1. Using environment variables in the `run.sh` file, which are populated from environment variables defined in its corresponding CodeBuild project.
2. Values are defined in the individual environment tfvars file.

