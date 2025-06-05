variable "nginx_image" {
  type        = string
  default     = "nginx:alpine"
  description = "Docker Image für Nginx"
}

variable "whoami_image" {
  type        = string
  default     = "traefik/whoami"
  description = "Docker Image für die whoami-App"
}

variable "network_name" {
  type        = string
  default     = "nginx_whoami_net"
  description = "Name des Docker-Netzwerks"
}

variable "app_count" {
  type        = number
  default     = 2
  description = "Anzahl der whoami-Container (Skalierung)"
}
