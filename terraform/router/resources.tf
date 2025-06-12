resource "routeros_dns_record" "check" {
  name    = "check.${var.ROS_BASE_DOMAIN}"
  cname   = var.ROS_BASE_DOMAIN
  type    = "CNAME"
  comment = var.ROS_COMMENT_DEFAULT
}

resource "routeros_dns_record" "crypto" {
  name    = "crypto.${var.ROS_BASE_DOMAIN}"
  cname   = var.ROS_BASE_DOMAIN
  type    = "CNAME"
  comment = var.ROS_COMMENT_DEFAULT
}

resource "routeros_dns_record" "docs" {
  name    = "docs.${var.ROS_BASE_DOMAIN}"
  cname   = var.ROS_BASE_DOMAIN
  type    = "CNAME"
  comment = var.ROS_COMMENT_DEFAULT
}

resource "routeros_dns_record" "gitea" {
  name    = "gitea.${var.ROS_BASE_DOMAIN}"
  cname   = var.ROS_BASE_DOMAIN
  type    = "CNAME"
  comment = var.ROS_COMMENT_DEFAULT
}

resource "routeros_dns_record" "grafana" {
  name    = "grafana.${var.ROS_BASE_DOMAIN}"
  cname   = var.ROS_BASE_DOMAIN
  type    = "CNAME"
  comment = var.ROS_COMMENT_DEFAULT
}

resource "routeros_dns_record" "influx" {
  name    = "influx.${var.ROS_BASE_DOMAIN}"
  cname   = var.ROS_BASE_DOMAIN
  type    = "CNAME"
  comment = var.ROS_COMMENT_DEFAULT
}

resource "routeros_dns_record" "inventory" {
  name    = "inventory.${var.ROS_BASE_DOMAIN}"
  cname   = var.ROS_BASE_DOMAIN
  type    = "CNAME"
  comment = var.ROS_COMMENT_DEFAULT
}

resource "routeros_dns_record" "keycloak" {
  name    = "keycloak.${var.ROS_BASE_DOMAIN}"
  cname   = var.ROS_BASE_DOMAIN
  type    = "CNAME"
  comment = var.ROS_COMMENT_DEFAULT
}

resource "routeros_dns_record" "links" {
  name    = "links.${var.ROS_BASE_DOMAIN}"
  cname   = var.ROS_BASE_DOMAIN
  type    = "CNAME"
  comment = var.ROS_COMMENT_DEFAULT
}

resource "routeros_dns_record" "lldap" {
  name    = "lldap.${var.ROS_BASE_DOMAIN}"
  cname   = var.ROS_BASE_DOMAIN
  type    = "CNAME"
  comment = var.ROS_COMMENT_DEFAULT
}

resource "routeros_dns_record" "portainer" {
  name    = "portainer.${var.ROS_BASE_DOMAIN}"
  cname   = var.ROS_BASE_DOMAIN
  type    = "CNAME"
  comment = var.ROS_COMMENT_DEFAULT
}

resource "routeros_dns_record" "proxmox" {
  name    = "proxmox.${var.ROS_BASE_DOMAIN}"
  cname   = var.ROS_BASE_DOMAIN
  type    = "CNAME"
  comment = var.ROS_COMMENT_DEFAULT
}

resource "routeros_dns_record" "push" {
  name    = "push.${var.ROS_BASE_DOMAIN}"
  cname   = var.ROS_BASE_DOMAIN
  type    = "CNAME"
  comment = var.ROS_COMMENT_DEFAULT
}

resource "routeros_dns_record" "status" {
  name    = "status.${var.ROS_BASE_DOMAIN}"
  cname   = var.ROS_BASE_DOMAIN
  type    = "CNAME"
  comment = var.ROS_COMMENT_DEFAULT
}

resource "routeros_dns_record" "automation" {
  name    = "automation.${var.ROS_BASE_DOMAIN}"
  cname   = var.ROS_BASE_DOMAIN
  type    = "CNAME"
  comment = var.ROS_COMMENT_DEFAULT
}

resource "routeros_dns_record" "dashboard-ingress" {
  name    = "dashboard-ingress.${var.ROS_BASE_DOMAIN}"
  cname   = var.ROS_BASE_DOMAIN
  type    = "CNAME"
  comment = var.ROS_COMMENT_DEFAULT
}
