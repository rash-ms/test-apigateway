terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~>3.0"
    }
}

required_version = ">=v0.14.7"

backend "s3" {}
}

# provider "aws" {
#   alias  = "aws-us-east-1"
#   region = "us-east-1"
# }

# terraform {
#   required_version = ">=v0.14.7"
#   backend "s3" {
#     bucket         = "byt-infra-resources-backend"
#     key            = "terraform.tfstate"
#     region         = "us-east-1"                
#   }
# }