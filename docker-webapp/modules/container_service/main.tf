resource "docker_container" "service" {
  name  = var.name
  image = var.image

  dynamic "ports" {
    for_each = var.ports
    content {
      internal = ports.value.internal
      external = ports.value.external
    }
  }

  networks_advanced {
    name = var.network
  }
}
