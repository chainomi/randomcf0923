# load balancing 

## load balancer security group
resource "aws_security_group" "alb" {
  name        = "${environment}-alb-security-group"
  vpc_id      = var.vpc_id
  
  dynamic "ingress" {
    for_each = var.lb_ingress_rules

    content {
      from_port   = ingress.value.from
      to_port     = ingress.value.to
      protocol    = ingress.value.protocol
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = [""]
    }
    tags = {
            Environment = var.environment
        }
}


## load balancer 
resource "aws_lb" "app_lb" {
  name                       = "${environment}-app-alb"
  internal                   = true
  load_balancer_type         = "network"
  security_groups            = [aws_security_group.alb.id] 
  subnets                    = var.subnet_ids
  enable_deletion_protection = false
  enable_cross_zone_load_balancing = var.lb_cross_zone_load_balancing
  tags = {
    Environment = var.environment
  }
}

## target groups

resource "aws_lb_target_group" "app" {
  for_each = var.listener_ports

  name     = "${environment}-${each.key}-target-group"
  port     = each.value.port
  protocol = "TCP"
  vpc_id   = var.vpc_id
  health_check {
    path = each.value.health_check_path
    port = "${each.value.port}"
    protocol = each.value.protocol
    timeout = each.value.health_check_timeout
    interval = each.value.health_check_interval
    healthy_threshold = each.value.health_check_healthy_threshold
    unhealthy_threshold = each.value.health_check_unhealthy_threshold
  }
  tags = {
    Environment = var.environment
  }
}


## target group attachment
resource "aws_lb_target_group_attachment" "app" {
  for_each = var.listener_ports

  target_group_arn = aws_lb_target_group.app[each.key].arn
  target_id        = aws_instance.windows.id
  port             = each.value.port
}


## listener rules
resource "aws_lb_listener" "lb_listener" {
   for_each = var.listener_ports

   load_balancer_arn    = aws_lb.app_lb.arn
   port                 = each.value.port
   protocol             = each.value.protocol

   default_action {
    target_group_arn = aws_lb_target_group.app[each.key].arn
    type             = "forward"
  }
}

# resource "aws_lb_listener" "lb_listener_https" {
#    load_balancer_arn    = aws_lb.app_lb.arn
#    port                 = "443"
#    protocol             = "HTTPS"
#    ssl_policy           = "ELBSecurityPolicy-2016-08"
#    certificate_arn      = var.certificate_arn

#    default_action {
#     target_group_arn   = aws_lb_target_group.windows-443.arn
#     type               = "forward"
#   }
# }

