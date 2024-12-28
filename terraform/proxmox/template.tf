resource "proxmox_lxc" "RP4B-CT-MANAGER-TEMPLATE" {
  arch         = var.base.arch
  hostname     = var.base.manager_name
  target_node  = var.base.target_node
  ostemplate   = var.base.os_template
  unprivileged = true
  rootfs {
    storage = var.base.storage
    size    = var.base.size
  }
  cores  = var.base.cores
  memory = var.base.manager_ram
  swap   = var.base.manager_swap
  network {
    name     = var.base.network
    bridge   = var.base.bridge
    ip       = var.base.manager_ip
    ip6      = var.base.ip6
    gw       = var.base.gateway
    firewall = var.base.firewall
  }
  vmid = var.base.manager_id
}

resource "proxmox_lxc" "RP4B-CT-WORKER-TEMPLATE" {
  arch         = var.base.arch
  hostname     = var.base.worker_name
  target_node  = var.base.target_node
  ostemplate   = var.base.os_template
  unprivileged = true
  rootfs {
    storage = var.base.storage
    size    = var.base.size
  }
  cores  = var.base.cores
  memory = var.base.worker_ram
  swap   = var.base.worker_swap
  network {
    name     = var.base.network
    bridge   = var.base.bridge
    ip       = var.base.worker_ip
    ip6      = var.base.ip6
    gw       = var.base.gateway
    firewall = var.base.firewall
  }
  vmid = var.base.worker_id
}
