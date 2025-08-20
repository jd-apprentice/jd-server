locals {
  ros_subdomains = [
    "auth",
    "automation",
    "argo",
    "check",
    "crypto",
    "dashboard-ingress",
    "docs",
    "gitea",
    "grafana",
    "influx",
    "inventory",
    "keycloak",
    "links",
    "lldap",
    "portainer",
    "pdf",
    "proxmox",
    "pbs",
    "retropie",
    "status",
    "switch",
    "owncloud",
    "zabbix",
    "zoraxy",
  ]
}

resource "routeros_dns_record" "subdomains" {
  for_each = toset(local.ros_subdomains)
  name     = "${each.key}.${var.ROS_BASE_DOMAIN}"
  cname    = var.ROS_BASE_DOMAIN
  type     = "CNAME"
  comment  = var.ROS_COMMENT_DEFAULT
}
