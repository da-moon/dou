terraform {
  backend "s3" {
    bucket = "remotestatedou"
    key    = "remotestatedou/remote/jenkinsinstance.tfstate"
    region = "us-east-1"
  }
}
