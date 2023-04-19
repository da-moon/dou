variable "resource_group_terratest" {
    type    = string
    default = "assurant-terratest"
}

variable "prefix" {
    type    = string
    default = "app-terratest"
}

variable "environment" {
    type    = string
    default = "qa"
}