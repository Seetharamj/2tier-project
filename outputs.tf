output "web_public_ips" {
  description = "Public IP addresses of web instances"
  value       = module.web.instance_public_ips
}

output "app_private_ips" {
  description = "Private IP addresses of app instances"
  value       = module.app.instance_private_ips
}

output "db_endpoint" {
  description = "RDS endpoint"
  value       = module.db.db_endpoint
}

output "lb_dns_name" {
  description = "Load Balancer DNS name"
  value       = module.vpc.lb_dns_name
}
