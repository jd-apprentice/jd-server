## https://registry.terraform.io/providers/Telmate/proxmox/latest/docs
## https://github.com/Telmate/terraform-provider-proxmox/issues/860

terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.1-rc6"
    }
  }
}

provider "proxmox" {
  pm_api_url = var.pm_api_url
}
