output "container_id" {
  value = docker_container.service.id
}

output "container_name" {
  value = docker_container.service.name
}
