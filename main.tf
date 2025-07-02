provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  azs = var.azs
}

module "ec2" {
  source = "./modules/ec2"
  vpc_id = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  ami_id = var.ami_id
  instance_type = var.instance_type
  key_name = var.key_name
  project = var.project
}

module "rds" {
  source = "./modules/rds"
  vpc_id = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  db_username = var.db_username
  db_password = var.db_password
  instance_class = var.rds_instance_class
  engine = var.rds_engine
  engine_version = var.rds_engine_version
  allocated_storage = var.rds_storage
  project = var.project
}
