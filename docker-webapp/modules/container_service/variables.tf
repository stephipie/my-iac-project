variable "name" {
  type = string
}

variable "image" {
  type = string
}

variable "ports" {
  type    = list(object({
    internal = number
    external = number
  }))
  default = []
}

variable "network" {
  type = string
}
