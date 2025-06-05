resource "docker_network" "app_network" {
  name = "${var.project_prefix}-${var.network_name}"
}

locals {
  nginx_container_name    = "${var.project_prefix}-nginx"
  node_app_container_name = "${var.project_prefix}-node-app"
}

module "nginx_service" {
  source = "./modules/docker-service"

  container_name = local.nginx_container_name
  image          = var.nginx_image
  network_id     = docker_network.app_network.id

  ports = [{
    internal = 80 # Nginx lauscht standardmäßig auf Port 80 im Container
    external = var.nginx_host_port
  }]
}

module "node_app_service" {
  source = "./modules/docker-service"

  container_name = local.node_app_container_name
  image          = var.node_app_image
  network_id     = docker_network.app_network.id
  command        = var.node_app_command

  ports = [{
    internal = var.node_app_container_port
  }]
}