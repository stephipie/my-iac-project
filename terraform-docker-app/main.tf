resource "docker_network" "app_network" {
  name = "${var.project_prefix}-${var.network_name}"
}

# NEU: Docker Volume für PostgreSQL
resource "docker_volume" "postgres_data" {
  name = "${var.project_prefix}-${var.postgres_data_volume_name}"
}

locals {
  postgres_container_name = "${var.project_prefix}-postgres"
  backend_container_name  = "${var.project_prefix}-backend"
  frontend_container_name = "${var.project_prefix}-frontend"
}

# Module für PostgreSQL-Service
module "postgres_service" {
  source = "./modules/docker-service"

  container_name = local.postgres_container_name
  image          = var.postgres_image
  network_name   = docker_network.app_network.name

  # Umgebungsvariablen für PostgreSQL
  environment = {
    "POSTGRES_DB"       = var.postgres_db
    "POSTGRES_USER"     = var.postgres_user
    "POSTGRES_PASSWORD" = var.postgres_password
  }

  # Volume Mount für persistente Daten
  volumes = [{
    volume_name    = docker_volume.postgres_data.name
    container_path = "/var/lib/postgresql/data"
  }]
}


module "backend_service" {
  source = "./modules/docker-service"

  container_name = local.backend_container_name
  image          = var.backend_image
  network_name   = docker_network.app_network.name

  environment = {
    "DB_HOST"     = local.postgres_container_name
    "DB_PORT"     = "5432"
    "DB_USER"     = var.postgres_user
    "DB_PASSWORD" = var.postgres_password
    "DB_NAME"     = var.postgres_db
    "APP_PORT"    = tostring(var.backend_container_port)
  }

  ports = [{
    internal = var.backend_container_port
  }]
}


module "frontend_service" {
  source = "./modules/docker-service"

  container_name = local.frontend_container_name
  image          = var.frontend_image
  network_name   = docker_network.app_network.name

  ports = [{
    internal = 80 # Annahme: Frontend-App lauscht auf Port 80 im Container
    external = var.frontend_host_port
  }]
}