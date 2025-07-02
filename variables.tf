variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "2tier-app"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "List of public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  description = "List of private subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "database_subnets" {
  description = "List of database subnets"
  type        = list(string)
  default     = ["10.0.5.0/24", "10.0.6.0/24"]
}

variable "web_instance_count" {
  description = "Number of web instances"
  type        = number
  default     = 2
}

variable "web_instance_type" {
  description = "Instance type for web servers"
  type        = string
  default     = "t3.micro"
}

variable "web_ami" {
  description = "AMI ID for web servers"
  type        = string
  default     = "ami-0fc5d935ebf8bc3bc"
}

variable "app_instance_count" {
  description = "Number of app instances"
  type        = number
  default     = 2
}

variable "app_instance_type" {
  description = "Instance type for app servers"
  type        = string
  default     = "t3.micro"
}

variable "app_ami" {
  description = "AMI ID for app servers"
  type        = string
  default     = "ami-0fc5d935ebf8bc3bc"
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "mydb"
}

variable "db_username" {
  description = "Database username"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "Database instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Allocated storage for database in GB"
  type        = number
  default     = 20
}
