resource "docker_network" "lan" {
  name = "lan"
  
  ipam_config {
    subnet  = "10.5.0.0/16"
    gateway = "10.5.0.1"
  }
}

resource "docker_container" "dashdot" {
  image = "mauricenino/dashdot"
  name  = "dashdot"
  restart = "always"
  privileged = true

  ports {
    internal = 3001
    external = 3001
  }

  volumes {
    host_path      = "/"
    container_path = "/mnt/host"
    read_only      = true
  }

  ## https://github.com/hashicorp/terraform-provider-tfe/issues/476#issuecomment-1364164539
  env = keys({
    DASHDOT_ENABLE_CPU_TEMPS = "true"
  })

  networks_advanced {
    name      = docker_network.lan.name
    ipv4_address = "10.5.0.11"
  }
}

resource "docker_container" "docker_socket_proxy" {
  image = "tecnativa/docker-socket-proxy"
  name  = "docker-socket-proxy"
  
  restart = "always"
  privileged = true

  ports {
    internal = 2375
    external = 2375
  }

  volumes {
    host_path      = "/var/run/docker.sock"
    container_path = "/var/run/docker.sock"
  }

  env = keys({
    CONTAINERS = 1
    INFO       = 1
  })
}

## https://stackoverflow.com/questions/60231309/terraform-conditional-creation-of-a-resource-based-on-a-variable-in-tfvars
resource "docker_container" "homepage" {
  count = var.create_homepage ? 1 : 0
  image = "ghcr.io/gethomepage/homepage:latest"
  name  = "homepage"
  restart = "always"

  ports {
    internal = 3000
    external = 4000
  }

  volumes {
    host_path = abspath("./links/config")
    container_path = "/app/config"
  }

  volumes {
    host_path = "/var/run/docker.sock"
    container_path = "/var/run/docker.sock"
  }

  networks_advanced {
    name = docker_network.lan.name
    ipv4_address = "10.5.0.9"
  }
}
