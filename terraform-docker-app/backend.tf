terraform {
  backend "s3" {
    bucket         = "my-terraform-remote-state-bucket-stephi"
    key            = "terraform/state/my-iac-project.tfstate"
    region         = "eu-central-1"    
  }
}