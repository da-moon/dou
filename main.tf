terraform {
  backend "s3" {
    bucket = "german-techm-bucket"
    key    = "tf-states/german-playground-plm"
    region = "us-west-2"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = "~> 1.1.9"
}

provider aws {
  region = "us-west-2"
}

module "build_server" {
  source           = "./modules/build_server"
  vpc_id           = aws_vpc.main.id
  key_name         = aws_key_pair.generated_key.key_name
  ami_id           = var.ami_id_build_server
  subnet_cidr_1    = "10.0.10.0/24"
  subnet_cidr_2    = "10.0.11.0/24"
  nat_gateway_id_1 = aws_nat_gateway.ngw_a.id
  nat_gateway_id_2 = aws_nat_gateway.ngw_b.id
  subnet_id        = ""
}

