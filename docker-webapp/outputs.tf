output "nginx_name" {
  value = module.nginx.container_name
}

output "whoami_names" {
  value = [for mod in module.whoami : mod.container_name]
}
