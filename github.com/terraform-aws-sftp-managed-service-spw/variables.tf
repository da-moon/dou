variable "run_env" {
  description = "Run Environment"
}

variable "bucket" {
  description = "Bucket name to link to sftp service"
}

variable "name" {
  description = "SFTP dns name ( will produce 'sftp.<var.name>.corvesta.net')"
}

variable "hostedzone_id" {
  description = "hosted zone id for DNS"
}
