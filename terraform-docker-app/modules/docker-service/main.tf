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

  networks_advanced {
    name = var.network_name
  }
}
