output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = aws_subnet.private[*].id
}

output "database_subnet_ids" {
  description = "List of database subnet IDs"
  value       = aws_subnet.database[*].id
}

output "web_sg_id" {
  description = "Web security group ID"
  value       = aws_security_group.web.id
}

output "app_sg_id" {
  description = "App security group ID"
  value       = aws_security_group.app.id
}

output "db_sg_id" {
  description = "Database security group ID"
  value       = aws_security_group.db.id
}

output "lb_dns_name" {
  description = "Load Balancer DNS name"
  value       = aws_lb.web.dns_name
}

output "lb_target_group_arn" {
  description = "Load Balancer Target Group ARN"
  value       = aws_lb_target_group.web.arn
}
