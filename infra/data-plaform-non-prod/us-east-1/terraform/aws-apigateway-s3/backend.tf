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