// Make sure the resource group exists
variable "resource_group_terratest" {
    type    = string
    default = "terratest_example"
}

variable "prefix" {
    type    = string
    default = "app-terratest"
}

variable "environment" {
    type    = string
    default = "qa"
}