# Global Configuration
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name of the project (used for resource naming)"
  type        = string
  default     = "2tier-app"
}

variable "environment" {
  description = "Deployment environment (dev/stage/prod)"
  type        = string
  default     = "dev"
}

# Network Configuration
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "List of public subnet CIDRs"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  description = "List of private subnet CIDRs"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "database_subnets" {
  description = "List of database subnet CIDRs"
  type        = list(string)
  default     = ["10.0.5.0/24", "10.0.6.0/24"]
}

# Web Tier Configuration
variable "web_instance_count" {
  description = "Number of web tier instances"
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
  default     = "ami-0fc5d935ebf8bc3bc" # Amazon Linux 2023
}

# Application Tier Configuration
variable "app_instance_count" {
  description = "Number of application tier instances"
  type        = number
  default     = 2
}

variable "app_instance_type" {
  description = "Instance type for application servers"
  type        = string
  default     = "t3.micro"
}

variable "app_ami" {
  description = "AMI ID for application servers"
  type        = string
  default     = "ami-0fc5d935ebf8bc3bc" # Amazon Linux 2023
}

# Database Configuration
variable "db_name" {
  description = "RDS database name"
  type        = string
  default     = "mydb"
}

variable "db_username" {
  description = "RDS master username"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "RDS instance type"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "RDS storage size in GB"
  type        = number
  default     = 20
}

# Security Configuration
variable "key_name" {
  description = "Name of existing EC2 key pair for SSH access"
  type        = string
}

# Load Balancer Configuration
variable "lb_target_group_arn" {
  description = "ARN of the load balancer target group for web tier"
  type        = string
  default     = ""
}

variable "create_lb_attachment" {
  description = "Whether to create load balancer attachments for web tier"
  type        = bool
  default     = true
}

# Tags Configuration
variable "additional_tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
