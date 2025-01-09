variable "pm_api_url" {
  type      = string
  sensitive = false
  default   = "https://proxmox.local.jonathan.com.ar/api2/json"
}

variable "pm_api_token_id" {
  type      = string
  sensitive = true
  default   = ""
}

variable "pm_api_token_secret" {
  type      = string
  sensitive = true
  default   = ""
}

variable "num_workers" {
  type      = number
  sensitive = false
  default   = 1
}
