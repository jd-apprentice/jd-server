## https://github.com/Telmate/terraform-provider-proxmox/issues/1201

variable "base" {
  default = {
    arch        = "amd64"
    os_template = "local:vztmpl/ubuntu-24.04-standard_24.04-2_amd64.tar.zst"
    target_node = "proxmox"
    network     = "eth0"
    bridge      = "vmbr0"
    storage     = "local"
    size        = "10G"
    firewall    = true
    cores       = 1
    worker_ram  = 512
    worker_swap = 1024
    worker_ip   = "192.168.88.230/24"
    worker_id   = 200
    worker_name = "PC-CT-WORKER-TEMPLATE"
    ip6         = "dhcp"
  }
}

locals {
  workers = { for i in range(1, var.num_workers + 1) : "PC-CT-WORKER-${i}" => "PC-CT-WORKER-${i}" }
}

resource "proxmox_lxc" "workers" {
  for_each     = local.workers
  arch         = var.base.arch
  clone        = var.base.worker_id
  memory       = var.base.worker_ram
  cores        = var.base.cores
  swap         = var.base.worker_swap
  target_node  = var.base.target_node
  unprivileged = true
  hostname     = each.key
  full         = true

  rootfs {
    storage = var.base.storage
    size    = var.base.size
  }
  network {
    ip       = "dhcp"
    ip6      = var.base.ip6
    firewall = var.base.firewall
    name     = var.base.network
    bridge   = var.base.bridge
    tag      = 222
  }
}
