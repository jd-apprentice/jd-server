module "cloudflare" {
  source = "./cloudflare"
}

module "aws" {
  source = "./aws"
}

variable "nodes" {
  type = map(object({
    ssh_user = string
    node_host = string
    create_homepage = bool
  }))
}

module "node00" {
    source = "./homelab/node"
    
    ssh_user = var.nodes["node00"].ssh_user
    node_host = var.nodes["node00"].node_host
    create_homepage = var.nodes["node00"].create_homepage
}

module "node01" {
    source = "./homelab/node"
    
    ssh_user = var.nodes["node01"].ssh_user
    node_host = var.nodes["node01"].node_host
    create_homepage = var.nodes["node01"].create_homepage
}

module "node02" {
    source = "./homelab/node"
    
    ssh_user = var.nodes["node02"].ssh_user
    node_host = var.nodes["node02"].node_host
    create_homepage = var.nodes["node02"].create_homepage
}