output "db_endpoint" {
  description = "Database endpoint"
  value       = aws_db_instance.db.endpoint
}

output "db_arn" {
  description = "Database ARN"
  value       = aws_db_instance.db.arn
}
