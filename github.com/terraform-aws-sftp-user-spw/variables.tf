variable "sftp_server_id" {
  description = "SFTP server id"
}

variable "user_name" {
  description = "Bucket name to link to sftp service"
}

variable "tenant" {
  type       = string
  description = "Client name"
}

variable "sshkey" {
  description = "SFTP dns name ( will produce 'sftp.<var.name>.corvesta.net')"
}

variable "run_env" {
  description = "Run Rnvironment"
}

variable "bucket" {
  description = "Bucket to give user access to"
}
