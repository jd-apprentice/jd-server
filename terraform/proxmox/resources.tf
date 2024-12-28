variable "base" {
  default = {
    arch         = "arm64"
    os_template  = "local:vztmpl/debian_arm64_buster.tar.xz"
    target_node  = "proxmox"
    network      = "eth0"
    bridge       = "vmbr0"
    storage      = "local"
    size         = "8G"
    manager_ip   = "192.168.88.251/24"
    worker_ip    = "192.168.88.241/24"
    manager_name = "RP4B-CT-MANAGER-01"
    worker_name  = "RP4B-CT-WORKER-01"
  }
}

variable "workers" {
  default = {
    RP4B-CT-WORKER-02 = {
      ip     = "192.168.88.242/24"
      cores  = 1
      memory = 256
    }
    RP4B-CT-WORKER-03 = {
      ip     = "192.168.88.243/24"
      cores  = 1
      memory = 256
    }
    RP4B-CT-WORKER-04 = {
      ip     = "192.168.88.244/24"
      cores  = 1
      memory = 256
    }
    RP4B-CT-WORKER-05 = {
      ip     = "192.168.88.245/24"
      cores  = 1
      memory = 256
    }
    RP4B-CT-WORKER-06 = {
      ip     = "192.168.88.246/24"
      cores  = 1
      memory = 256
    }
  }
}

variable "managers" {
  default = {
    RP4B-CT-MANAGER-02 = {
      ip     = "192.168.88.252/24"
      cores  = 1
      memory = 512
    }
    RP4B-CT-MANAGER-03 = {
      ip     = "192.168.88.253/24"
      cores  = 1
      memory = 512
    }
  }
}

resource "proxmox_lxc" "RP4B-CT-MANAGER-01" {
  arch         = var.base.arch
  hostname     = var.base.manager_name
  target_node  = var.base.target_node
  ostemplate   = var.base.os_template
  unprivileged = true
  rootfs {
    storage = var.base.storage
    size    = var.base.size
  }
  cores  = 1
  memory = 512
  swap   = 1024
  network {
    name   = var.base.network
    bridge = var.base.bridge
    ip     = var.base.manager_ip
  }
  vmid = 100
}

resource "proxmox_lxc" "RP4B-CT-WORKER-01" {
  arch         = var.base.arch
  hostname     = var.base.worker_name
  target_node  = var.base.target_node
  ostemplate   = var.base.os_template
  unprivileged = true
  rootfs {
    storage = var.base.storage
    size    = var.base.size
  }
  cores  = 1
  memory = 256
  swap   = 512
  network {
    name   = var.base.network
    bridge = var.base.bridge
    ip     = var.base.worker_ip
  }
  vmid = 101
}

resource "proxmox_lxc" "workers" {
  depends_on  = [proxmox_lxc.RP4B-CT-WORKER-01]
  ostemplate  = var.base.os_template
  arch        = var.base.arch
  cores       = each.value.cores
  memory      = each.value.memory
  for_each    = var.workers
  target_node = var.base.target_node
  hostname    = each.key

  network {
    name   = var.base.network
    bridge = var.base.bridge
    ip     = each.value.ip
  }
}

resource "proxmox_lxc" "managers" {
  depends_on  = [proxmox_lxc.RP4B-CT-MANAGER-01]
  ostemplate  = var.base.os_template
  arch        = var.base.arch
  cores       = each.value.cores
  memory      = each.value.memory
  for_each    = var.managers
  target_node = var.base.target_node
  hostname    = each.key

  network {
    name   = var.base.network
    bridge = var.base.bridge
    ip     = each.value.ip
  }
}
