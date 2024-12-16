# resource "docker_container" "dashdot" {
#   image         = "mauricenino/dashdot"
#   name          = "dashdot"
#   restart       = "always"
#   user          = "node:node"
#   privileged    = true
#   security_opts = ["no-new-privileges:true", "seccomp:~/security/default.json"]

#   ports {
#     internal = 3001
#     external = 3001
#   }

#   volumes {
#     host_path      = "/"
#     container_path = "/mnt/host:ro"
#     read_only      = true
#   }

#   ## https://github.com/hashicorp/terraform-provider-tfe/issues/476#issuecomment-1364164539
#   env = keys({
#     DASHDOT_ENABLE_CPU_TEMPS = "true"
#   })

# }

## https://stackoverflow.com/questions/60231309/terraform-conditional-creation-of-a-resource-based-on-a-variable-in-tfvars
resource "docker_container" "homepage" {
  count         = var.is_home ? 1 : 0
  image         = "ghcr.io/gethomepage/homepage:latest"
  user          = "node:node"
  security_opts = ["no-new-privileges:true"]
  name          = "homepage"
  restart       = "always"

  ports {
    internal = 3000
    external = 4000
  }

  volumes {
    host_path      = abspath("/volumes/homepage_data")
    container_path = "/app/config"
  }

}
