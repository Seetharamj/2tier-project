terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "seetharam-terraform-states"
    key    = "2tier/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = var.environment
      Project     = "2tier-architecture"
      Terraform   = "true"
    }
  }
}

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr           = var.vpc_cidr
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  availability_zones = var.availability_zones
  environment        = var.environment
}

module "ec2" {
  source = "./modules/ec2"

  vpc_id             = module.vpc.vpc_id
  public_subnets     = module.vpc.public_subnets
  ami_id             = var.ami_id
  instance_type      = var.instance_type
  key_name           = var.key_name
  environment        = var.environment
}

module "rds" {
  source          = "./modules/rds"
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  web_sg_id       = module.ec2.web_sg_id
  db_name         = var.db_name
  db_username     = var.db_username
  db_password     = var.db_password
  env_prefix      = var.environment
}
