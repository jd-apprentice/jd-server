terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

resource "docker_container" "dashdot" {
  image = "mauricenino/dashdot"
  name  = "dashdot"
  restart = "always"
  user = "node:node"
  privileged = true
  security_opts = ["no-new-privileges:true"]

  ports {
    internal = 3001
    external = 3001
  }

  volumes {
    host_path      = abspath("/")
    container_path = abspath("/mnt/host")
    read_only      = true
  }

  ## https://github.com/hashicorp/terraform-provider-tfe/issues/476#issuecomment-1364164539
  env = keys({
    DASHDOT_ENABLE_CPU_TEMPS = "true"
  })

}