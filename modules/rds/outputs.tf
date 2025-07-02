output "rds_endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.default.endpoint
}

output "rds_sg_id" {
  description = "Security group ID of RDS instance"
  value       = aws_security_group.rds_sg.id
}

output "db_name" {
  description = "Database name"
  value       = aws_db_instance.default.db_name
}

output "db_username" {
  description = "Database username"
  value       = aws_db_instance.default.username
  sensitive   = true
}
