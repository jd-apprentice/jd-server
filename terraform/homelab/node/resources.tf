resource "docker_container" "dashdot" {
  image = "mauricenino/dashdot"
  name  = "dashdot"
  restart = "always"
  user = "node:node"
  privileged = true
  security_opts = ["no-new-privileges:true", "seccomp:~/security/default.json"]

  ports {
    internal = 3001
    external = 3001
  }

  volumes {
    host_path      = "/"
    container_path = "/mnt/host:ro"
    read_only      = true
  }

  ## https://github.com/hashicorp/terraform-provider-tfe/issues/476#issuecomment-1364164539
  env = keys({
    DASHDOT_ENABLE_CPU_TEMPS = "true"
  })

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
    container_path = "/var/run/docker.sock:ro"
  }

  env = keys({
    CONTAINERS = 1
    INFO       = 1
    TASKS      = 1
    POSTS      = 0
  })
}

## https://stackoverflow.com/questions/60231309/terraform-conditional-creation-of-a-resource-based-on-a-variable-in-tfvars
resource "docker_container" "homepage" {
  count = var.is_home ? 1 : 0
  image = "ghcr.io/gethomepage/homepage:latest"
  user = "node:node"
  security_opts = ["no-new-privileges:true", "seccomp:~/security/default.json"]
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

}

resource "docker_container" "dozzle" {
  count = var.is_home ? 1 : 0
  image = "amir20/dozzle:latest"
  name  = "dozzle"
  restart = "always"
  user = "node:node"
  security_opts = ["no-new-privileges:true", "seccomp:~/security/default.json"]
  ports {
    internal = 8888
    external = 8080
  }

  env = keys({
    DOZZLE_HOSTNAME = "localhost"
    DOZZLE_REMOTE_HOST = "tcp://192.168.0.251:2375|node01.local,tcp://192.168.0.253:2375|node00.local,tcp://192.168.0.150:2375|node02.local,tcp://192.168.0.242:2375|node03.local"
  })
}