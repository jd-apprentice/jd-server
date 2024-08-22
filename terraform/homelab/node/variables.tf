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

variable "is_home" {
  description = "Is this a home node?"
  type        = bool
  default = false
  sensitive = false
}