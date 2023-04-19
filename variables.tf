variable "attributes" {
    type = any
    default = [
        { 
            name = "testUserId"
            type = "S"
        }
    ]
}
variable "name" {
    description = "Table name"
}
variable "run_env" {
  
}
variable "source_region" {
  default = "us-east-1"
}
variable "replica_region" {
  default = "us-west-2"
}

variable "hash_key" {
  description = "Primary Hash Key"
}
variable "read_capacity" {
  default = 1
}
variable "write_capacity" {
  default = 1
}
variable "stream_enabled" {
    default = true
}
variable "stream_view_type" {
  default = "NEW_AND_OLD_IMAGES"
  description = "Stream view type"
}
variable "enable_replica" {
  default = true
  description = "Toggle for replication"
}
variable "recovery_point_flag" {
  default = true
  description = "Point in Time recovery flag"
}




