terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "my-terraform-state-bucket"  # Replace with your bucket
    key            = "2tier-project/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"  # For state locking
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
  source     = "./modules/vpc"
  cidr_block = var.vpc_cidr
  env_prefix = var.environment
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

module "ec2" {
  source          = "./modules/ec2"
  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnets
  instance_type   = var.ec2_instance_type
  key_name        = var.key_name
  env_prefix      = var.environment
  ami_id          = var.ec2_ami_id
  db_endpoint     = module.rds.rds_endpoint
  db_name         = var.db_name
  db_username     = var.db_username
  db_password     = var.db_password
}
