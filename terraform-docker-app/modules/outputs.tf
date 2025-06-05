output "container_id" {
  description = "Die ID des erstellten Docker-Containers."
  value       = docker_container.service.id
}

output "container_name" {
  description = "Der Name des erstellten Docker-Containers."
  value       = docker_container.service.name
}