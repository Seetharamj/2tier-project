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
  source = "./modules/vpc"

  project_name     = var.project_name
  vpc_cidr         = var.vpc_cidr
  public_subnets   = var.public_subnets
  private_subnets  = var.private_subnets
  database_subnets = var.database_subnets
}

module "web" {
  source = "./modules/ec2"

  instance_count    = var.web_instance_count
  instance_type    = var.web_instance_type
  subnet_ids       = module.vpc.public_subnet_ids
  security_group_ids = [module.vpc.web_sg_id]
  ami              = var.web_ami
  key_name         = var.key_name
  user_data        = file("${path.module}/user_data/web_user_data.sh")
  tags = {
    Name = "${var.project_name}-web"
    Tier = "web"
  }
}

module "app" {
  source = "./modules/ec2"

  instance_count    = var.app_instance_count
  instance_type    = var.app_instance_type
  subnet_ids       = module.vpc.private_subnet_ids
  security_group_ids = [module.vpc.app_sg_id]
  ami              = var.app_ami
  key_name         = var.key_name
  user_data        = file("${path.module}/user_data/app_user_data.sh")
  tags = {
    Name = "${var.project_name}-app"
    Tier = "app"
  }
}

module "db" {
  source = "./modules/rds"

  db_name           = var.db_name
  db_username       = var.db_username
  db_password       = var.db_password
  db_instance_class = var.db_instance_class
  subnet_ids        = module.vpc.database_subnet_ids
  security_group_id = module.vpc.db_sg_id
  allocated_storage = var.allocated_storage
}
