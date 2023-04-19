# This docker container is used to run codebuild projects that depend on terraform or packer
FROM debian:11-slim

RUN apt-get update && apt-get -yq install curl unzip jq git

# Install aws-cli
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip -qq -o awscliv2.zip
RUN ./aws/install

# Install terraform
RUN curl https://releases.hashicorp.com/terraform/1.1.9/terraform_1.1.9_linux_amd64.zip --output terraform.zip
RUN unzip terraform.zip
RUN cp terraform /usr/bin
RUN terraform -version

# Install packer
RUN curl https://releases.hashicorp.com/packer/1.8.5/packer_1.8.5_linux_amd64.zip --output packer.zip
RUN unzip packer.zip
RUN cp packer /usr/bin
RUN packer -version

# Download packer plugins
RUN echo ' \n\
packer { \n\
  required_plugins { \n\
    amazon = { \n\
      version = ">= 0.0.2" \n\
      source  = "github.com/hashicorp/amazon" \n\
    } \n\
  } \n\
}' > /tmp/main.pkr.hcl
RUN packer init /tmp


