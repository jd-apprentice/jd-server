variable "ssh_user" {
    description = "The ssh user"
    type        = string
    sensitive = true
}

variable "node_host" {
    description = "The host"
    type        = string
    sensitive = true
}

variable "create_homepage" {
  description = "Whether to create the homepage"
  type        = bool
  default = true
  sensitive = false
}