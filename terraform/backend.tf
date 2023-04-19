// terraform {
//   backend "remote" {
//     organization = "DoU-TFE"

//     workspaces {
//       name = "lsf-workload"
//     }
//   }
//   required_version = ">= 0.13.0"
// }
terraform {
  backend "s3" {
    bucket = "lsf-s3-sample"
    key    = "terraform.tfstate"
    region = "us-west-2"
  }
}
