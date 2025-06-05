variable "container_name" {
  description = "Name des Docker-Containers."
  type        = string
}

variable "image" {
  description = "Docker Image für den Container."
  type        = string
}

variable "network_name" {
  description = "Name des Docker-Netzwerks, mit dem der Container verbunden werden soll."
  type        = string
}

variable "ports" {
  description = "Liste der Port-Mappings für den Container."
  type = list(object({
    internal = number
    external = optional(number)
    ip       = optional(string)
    protocol = optional(string)
  }))
  default = []
}

variable "command" {
  description = "Der Befehl, der beim Start des Containers ausgeführt wird."
  type        = list(string)
  default     = []
}

variable "volumes" {
  description = "Eine Liste von Volume-Mount-Definitionen für den Container."
  type = list(object({
    host_path      = string
    container_path = string
    read_only      = optional(bool, false)
  }))
  default = []
}