resource "docker_network" "nginx_net" {
  name = var.network_name
}

module "nginx" {
  source = "./modules/container_service"
  name   = local.nginx_container_name
  image  = var.nginx_image
  network = docker_network.nginx_net.name

  ports = [
    {
      internal = 80
      external = 8080
    }
  ]
}

# mehrere whoami-Instanzen
resource "random_pet" "whoami_suffixes" {
  count = var.app_count
}

module "whoami" {
  count  = var.app_count
  source = "./modules/container_service"

  name   = "${local.whoami_base_name}-${count.index}"
  image  = var.whoami_image
  network = docker_network.nginx_net.name
}
