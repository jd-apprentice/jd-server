terraform {
  required_providers {
    routeros = {
      source = "terraform-routeros/routeros"
    }
  }
}

provider "routeros" {
  hosturl  = var.ROS_HOSTURL
  username = var.ROS_USERNAME
  password = var.ROS_PASSWORD
  insecure = true # this is needed because routeros is using self-signed certificates
}
