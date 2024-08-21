## https://stackoverflow.com/questions/66117583/how-to-select-correct-docker-provider-in-terraform-0-14
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {
  host     = "ssh://${var.ssh_user}@${var.node_host}"
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null"]
}