output "network_id" {
  description = "Die ID des erstellten Docker-Netzwerks."
  value       = docker_network.app_network.id
}

output "frontend_access_url" {
  description = "URL zum Zugriff auf die Frontend-Anwendung."
  value       = "http://localhost:${var.frontend_host_port}"
}

output "backend_url_internal" {
  description = "Interne URL zum Zugriff auf die Backend-Anwendung innerhalb des Docker-Netzwerks."
  # Das Backend ist nicht direkt von außen erreichbar, nur vom Frontend im gleichen Netzwerk.
  value = "http://${local.backend_container_name}:${var.backend_container_port}"
}

output "postgres_url_internal" {
  description = "Interne URL zum Zugriff auf die PostgreSQL-Datenbank innerhalb des Docker-Netzwerks."
  value       = "postgres://${var.postgres_user}:${var.postgres_password}@${local.postgres_container_name}:5432/${var.postgres_db}"
  sensitive   = true # Auch dies sollte sensibel sein, da es das Passwort enthält
}