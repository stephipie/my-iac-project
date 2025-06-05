resource "docker_container" "service" {
  name    = var.container_name
  image   = var.image
  restart = "on-failure"

  dynamic "ports" {
    for_each = var.ports
    content {
      internal = ports.value.internal
      external = ports.value.external
      ip       = ports.value.ip
      protocol = ports.value.protocol
    }
  }

  command = var.command

  # Umgebungsvariablen als Liste von Strings
  env = [for k, v in var.environment : "${k}=${v}"]

  dynamic "volumes" {
    for_each = var.volumes
    content {
      host_path      = volumes.value.host_path
      container_path = volumes.value.container_path
      read_only      = try(volumes.value.read_only, false)
    }
  }

  networks_advanced {
    name = var.network_name
  }
}
