variable "project_prefix" {
  description = "Präfix für alle Ressourcen, um Namenskollisionen zu vermeiden."
  type        = string
  default     = "stephipie-app"
}

variable "network_name" {
  description = "Name des Docker-Netzwerks."
  type        = string
  default     = "app-network"
}

variable "postgres_image" {
  description = "Docker Image für PostgreSQL."
  type        = string
  default     = "stephipie/postgres:latest"
}

variable "postgres_data_volume_name" {
  description = "Name des Docker Volumes für persistente PostgreSQL-Daten."
  type        = string
  default     = "postgres-data"
}

variable "postgres_db" {
  description = "Name der Datenbank in PostgreSQL."
  type        = string
  default     = "mydatabase"
}

variable "postgres_user" {
  description = "Benutzername für die PostgreSQL-Datenbank."
  type        = string
  default     = "myuser"
}

variable "postgres_password" {
  description = "Passwort für die PostgreSQL-Datenbank."
  type        = string
  sensitive   = true # Markiert das Passwort als sensibel, damit es nicht im Plan/Output angezeigt wird
  default     = "mypassword"
}

variable "backend_image" {
  description = "Docker Image für die Backend-Anwendung."
  type        = string
  default     = "stephipie/backend-app:latest"
}

variable "backend_container_port" {
  description = "Der interne Port, auf dem die Backend-App im Container lauscht."
  type        = number
  default     = 3000
}

variable "frontend_image" {
  description = "Docker Image für die Frontend-Anwendung."
  type        = string
  default     = "stephipie/frontend-app:latest"
}

variable "frontend_host_port" {
  description = "Der Host-Port, auf den die Frontend-App gemappt wird."
  type        = number
  default     = 8080
}



variable "nginx_image" {
  description = "Docker Image für den Nginx Webserver."
  type        = string
  default     = "nginx:latest"
}
