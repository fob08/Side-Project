terraform {
  required_version = ">=1.0.1, <2.0.0"
  required_providers {
    aws = {
        source = "hashicorp/aws"
    #version = "~> 4.0"
    version = "3.74.0"
    }
    
  }
}

#This determine the region in which the application will be hosted
provider "aws"{
  region = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}