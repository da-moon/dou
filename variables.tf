variable "user_name" {
  description = "The user's name. The name must consist of upper and lowercase alphanumeric characters with no spaces. You can also include any of the following characters: =,.@-_.."
  type        = string
}

variable "path" {
  description = "Path in which to create the user."
  type        = string
  default     = "/"
}

variable "user_destroy" {
  description = "When destroying this user, destroy."
  type        = bool
  default     = false
}

variable "permissions_boundary" {
  description = "The ARN of the policy that is used to set the permissions boundary for the user."
  type        = string
  default     = null
}

variable "pgp_key" {
  description = "Either a base-64 encoded PGP public key, or a keybase username in the form keybase:some_person_that_exists, for use in the encrypted_secret output attribute."
  type        = string
  default     = null
}

variable "key_status" {
  description = "Access key status to apply. Options: Active and Inactive."
  type        = string
  default     = "Active"
}

variable "tags" {
  description = "A mapping of custom tags"
  type        = map(any)
  default     = {}
}