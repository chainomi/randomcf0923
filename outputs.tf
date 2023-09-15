
output "ec2_private_ip" {
    value = aws_instance.windows.private_ip
    description = "Private IP of the EC2 instance"
}

output "rds_instance_endpoint" {
  description = "The connection endpoint"
  value       = aws_db_instance.application_db.db_instance_endpoint
}

output "lb_dns_name" {
  description = "The DNS name of the load balancer."
  value       = aws_lb.app_lb.dns_name
}

output "aws_vpc_endpoint_service_private_dns_name" {
  value       = aws_vpc_endpoint_service.app.private_dns_name
  description = "Name of the private DNS to access the service"
}