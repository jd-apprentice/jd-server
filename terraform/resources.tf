variable "ROS_HOSTURL" {}
variable "ROS_USERNAME" {}
variable "ROS_PASSWORD" {}
module "router" {
  source       = "./router"
  ROS_HOSTURL  = var.ROS_HOSTURL
  ROS_USERNAME = var.ROS_USERNAME
  ROS_PASSWORD = var.ROS_PASSWORD
}
