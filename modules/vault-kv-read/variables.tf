# vim: filetype=terraform syntax=terraform softtabstop=2 tabstop=2 shiftwidth=2 fileencoding=utf-8 commentstring=#%s expandtab
# code: language=terraform insertSpaces=true tabSize=2

variable "entry_path" {
  type        = string
  description = "The full logical path from which to request data"
  default     = ""
}