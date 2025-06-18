locals {
  ros_subdomains = [
    "check",
    "crypto",
    "docs",
    "gitea",
    "grafana",
    "influx",
    "inventory",
    "keycloak",
    "links",
    "lldap",
    "portainer",
    "proxmox",
    "status",
    "automation",
    "zabbix",
    "dashboard-ingress"
  ]
}

resource "routeros_dns_record" "subdomains" {
  for_each = toset(local.ros_subdomains)
  name     = "${each.key}.${var.ROS_BASE_DOMAIN}"
  cname    = var.ROS_BASE_DOMAIN
  type     = "CNAME"
  comment  = var.ROS_COMMENT_DEFAULT
}
