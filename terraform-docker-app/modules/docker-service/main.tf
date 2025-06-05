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
}

resource "docker_network_attachment" "service_network_attachment" {
  container_id = docker_container.service.id
  network_id   = var.network_id
}