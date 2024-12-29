variable "base" {
  default = {
    arch         = "arm64"
    os_template  = "local:vztmpl/ubuntu_focal_arm64.tar.xz"
    target_node  = "proxmox"
    network      = "eth0"
    bridge       = "vmbr0"
    storage      = "local"
    size         = "8G"
    firewall     = true
    cores        = 1
    manager_id   = 100
    manager_ram  = 512
    manager_swap = 1024
    manager_name = "RP4B-CT-MANAGER-TEMPLATE"
    manager_ip   = "192.168.88.220/24"
    worker_ram   = 256
    worker_swap  = 512
    worker_ip    = "192.168.88.230/24"
    worker_id    = 200
    worker_name  = "RP4B-CT-WORKER-TEMPLATE"
    gateway      = "192.168.88.1"
    ip6          = "dhcp"
  }
}

variable "workers" {
  default = {
    RP4B-CT-WORKER-01 = {
      ip = "192.168.88.231/24"
    }
    RP4B-CT-WORKER-02 = {
      ip = "192.168.88.232/24"
    }
    RP4B-CT-WORKER-03 = {
      ip = "192.168.88.233/24"
    }
    RP4B-CT-WORKER-04 = {
      ip = "192.168.88.234/24"
    }
    RP4B-CT-WORKER-05 = {
      ip = "192.168.88.235/24"
    }
    RP4B-CT-WORKER-06 = {
      ip = "192.168.88.236/24"
    }
  }
}

variable "managers" {
  default = {
    RP4B-CT-MANAGER-01 = {
      ip = "192.168.88.221/24"
    }
    RP4B-CT-MANAGER-02 = {
      ip = "192.168.88.222/24"
    }
    RP4B-CT-MANAGER-03 = {
      ip = "192.168.88.223/24"
    }
  }
}

resource "proxmox_lxc" "workers" {
  for_each     = var.workers
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
    ip       = each.value.ip
    ip6      = var.base.ip6
    gw       = var.base.gateway
    firewall = var.base.firewall
    name     = var.base.network
    bridge   = var.base.bridge
  }
}

resource "proxmox_lxc" "managers" {
  for_each     = var.managers
  arch         = var.base.arch
  clone        = var.base.manager_id
  cores        = var.base.cores
  memory       = var.base.manager_ram
  swap         = var.base.manager_swap
  target_node  = var.base.target_node
  unprivileged = true
  hostname     = each.key
  full         = true

  rootfs {
    storage = var.base.storage
    size    = var.base.size
  }
  network {
    ip       = each.value.ip
    ip6      = var.base.ip6
    gw       = var.base.gateway
    firewall = var.base.firewall
    name     = var.base.network
    bridge   = var.base.bridge
  }
}
