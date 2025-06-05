variable "project_prefix" {
  description = "Präfix für alle Ressourcen, um Namenskollisionen zu vermeiden."
  type        = string
  default     = "webapp"
}

variable "network_name" {
  description = "Name des Docker-Netzwerks."
  type        = string
  default     = "app-network"
}

variable "nginx_image" {
  description = "Docker Image für den Nginx Webserver."
  type        = string
  default     = "nginx:latest"
}

variable "nginx_host_port" {
  description = "Der Host-Port, auf den Nginx gemappt wird."
  type        = number
  default     = 8081 # geändert von 8080
}

variable "node_app_image" {
  description = "Docker Image für die Node.js App (z.B. ein einfaches 'hello world')."
  type        = string
  # Dies ist ein Dummy-Image. Für eine echte App müsstest du dein eigenes Dockerfile bauen und pushen. Das Dummy-Image nutze ich hier nur für Demo-Zwecke und zum testen.
  # Beispiel: "node:14-alpine" oder dein eigenes Image "your-registry/your-node-app:latest"
  default = "alpine/git" # Ein einfaches Image für Demo-Zwecke. Du kannst es später durch deine App ersetzen.
}

variable "node_app_container_port" {
  description = "Der Container-Port, auf dem die Node.js App innerhalb des Containers lauscht."
  type        = number
  default     = 80 # Annahme, dass die Node.js App auf Port 80 im Container lauscht
}

variable "node_app_command" {
  description = "Der Befehl, der beim Start des Node.js Containers ausgeführt wird."
  type        = list(string)
  default     = ["sh", "-c", "echo 'Hello from Node.js app!' && sleep infinity"] # Dummy-Befehl
}