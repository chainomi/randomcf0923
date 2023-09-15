

resource "aws_vpc_endpoint_service" "app" {
  acceptance_required        = true
  allowed_principals         = var.allowed_principals
  network_load_balancer_arns = [aws_lb.app_lb.arn]
  private_dns_name           = var.private_dns_name

  tags = {
    "Name" = var.name
  }
}