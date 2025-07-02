output "web_sg_id" {
  description = "Security group ID of web instances"
  value       = aws_security_group.web_sg.id
}

output "alb_dns_name" {
  description = "DNS name of the ALB"

  value       = aws_lb.web.dns_name
}

output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.web.name
}
