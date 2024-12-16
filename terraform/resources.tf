# module "cloudflare" {
#   source = "./cloudflare"
# }

# variable "aws_lambda_function_arn" {}
# variable "aws_lambda_function_name" {}

# module "aws" {
#   source = "./aws"
# }

# variable "nodes" {
#   type = map(object({
#     ssh_user  = string
#     node_host = string
#     is_home   = bool
#   }))
# }

# module "node00" {
#     source = "./homelab/node"

#     ssh_user = var.nodes["node00"].ssh_user
#     node_host = var.nodes["node00"].node_host
#     is_home = var.nodes["node00"].is_home
# }

# module "node01" {
#     source = "./homelab/node"

#     ssh_user = var.nodes["node01"].ssh_user
#     node_host = var.nodes["node01"].node_host
#     is_home = var.nodes["node01"].is_home
# }

# module "node02" {
#     source = "./homelab/node"

#     ssh_user = var.nodes["node02"].ssh_user
#     node_host = var.nodes["node02"].node_host
#     is_home = var.nodes["node02"].is_home
# }
