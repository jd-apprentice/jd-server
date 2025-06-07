variable "ROS_HOSTURL" {
  description = "RouterOS host URL"
  type        = string
  default     = "http://192.168.88.1"
}

variable "ROS_USERNAME" {
  description = "RouterOS username"
  type        = string
  default     = ""
  sensitive   = true
}

variable "ROS_PASSWORD" {
  description = "RouterOS password"
  type        = string
  default     = ""
  sensitive   = true
}

variable "ROS_BASE_DOMAIN" {
  description = "Base domain for DNS records"
  type        = string
  default     = "internal.jonathan.com.ar"
}

variable "ROS_COMMENT_DEFAULT" {
  description = "Default comment for RouterOS resources"
  type        = string
  default     = "Managed by Terraform"
}
