terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.4.2"
}

provider "aws" {
  region  = "us-east-1"
}

terraform {
    backend "s3" {
    bucket = "projetodevopstf"
    key = "terraformecs.tfstate"
    region = "us-east-1"
    encrypt = true
    }
}

module "vpc" {
  source = "./vpc"  
  name = var.name
  environment = var.environment
  cidr = var.cidr
  public_subnet = var.public_subnet
  private_subnet = var.private_subnet
  availabilty_zone = var.availabilty_zone
}

module "sec_group" {
  source = "./sec_group"
  name = var.name
  environment = var.environment
  vpc_id = module.vpc.vpc_id
}

module "ecs" {
  source = "./ecs"
  name = var.name
  environment = var.environment
  sec_group_id = module.sec_group.sg_id
  public_subnet_id = module.vpc.public_subnet_id
}