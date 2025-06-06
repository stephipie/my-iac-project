terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.6.0"
    }
    aws = { # Neuer AWS Provider Block
      source  = "hashicorp/aws"
      version = "~> 5.0" # Oder die von dir gewünschte Version
    }
  }
}

# AWS Provider Konfiguration
provider "aws" {
  region = "eu-central-1" # Ersetze dies mit deiner gewünschten AWS Region
}