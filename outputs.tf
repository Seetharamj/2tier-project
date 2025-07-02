output "web_tier_url" {
  description = "URL of the web application"
  value       = "http://${module.ec2.alb_dns_name}"
}

output "database_endpoint" {
  description = "RDS endpoint for application connection"
  value       = module.rds.rds_endpoint
  sensitive   = true
}

output "web_instance_security_group" {
  description = "Security group ID for web instances"
  value       = module.ec2.web_sg_id
}

output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnets
}
