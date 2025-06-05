output "network_id" {
  description = "Die ID des erstellten Docker-Netzwerks."
  value       = docker_network.app_network.id
}

output "nginx_access_url" {
  description = "URL zum Zugriff auf die Nginx-Anwendung."
  value       = "http://localhost:${var.nginx_host_port}"
}