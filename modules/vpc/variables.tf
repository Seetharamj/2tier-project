variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnets"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnets"
  type        = list(string)
}

variable "database_subnets" {
  description = "List of database subnets"
  type        = list(string)
}

variable "admin_ips" {
  description = "List of admin IPs for SSH access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
