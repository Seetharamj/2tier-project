terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source     = "./modules/vpc"
  cidr_block = var.vpc_cidr
  env_prefix = var.environment
}

module "ec2" {
  source          = "./modules/ec2"
  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnets
  private_subnets = module.vpc.private_subnets
  instance_type   = var.ec2_instance_type
  key_name        = var.key_name
  env_prefix      = var.environment
  ami_id          = var.ec2_ami_id
}

module "rds" {
  source          = "./modules/rds"
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  db_name         = var.db_name
  db_username 
