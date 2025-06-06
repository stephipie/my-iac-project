terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Using the latest stable version instead of beta
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-central-1" # Replace with your desired AWS region
}

module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.15.1" # Using the latest patch version

  bucket = "my-sp-research-bucket"
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = true
  }
}

output "s3_bucket_id" {
  description = "The name of the bucket."
  value       = module.s3_bucket.s3_bucket_id
}

output "s3_bucket_arn" {
  description = "The ARN of the bucket. Will be of format arn:aws:s3:::bucketname."
  value       = module.s3_bucket.s3_bucket_arn
}

output "s3_bucket_bucket_domain_name" {
  description = "The bucket domain name. Will be of format bucketname.s3.amazonaws.com."
  value       = module.s3_bucket.s3_bucket_bucket_domain_name
}

