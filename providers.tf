provider "aws" {
  region = "us-west-2"
}

data "aws_region" "current" {
}

data "aws_availability_zones" "available" {
}

provider "http" {
}

provider "local" {
  version = "~> 1.4"
}

provider "tls" {
  version = "~> 2.1"
}