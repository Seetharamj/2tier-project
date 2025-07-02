output "instance_ids" {
  description = "List of instance IDs"
  value       = aws_instance.instance[*].id
}

output "instance_public_ips" {
  description = "List of public IP addresses"
  value       = aws_instance.instance[*].public_ip
}

output "instance_private_ips" {
  description = "List of private IP addresses"
  value       = aws_instance.instance[*].private_ip
}
