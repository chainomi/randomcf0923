environment = "development"
region      = "us-east-1"

# Networking
vpc_id = ""
subnet_ids = ["", ""]

# EC2 parameters
vm_name_filter         = "Windows_Server-2022-English-Full-Base-2023*"
vm_virtualization-type = "hvm"
ec2_volumes = {
    root = {
        size = "50"
        type = "gp2"
    },
    ebs = {
        size = "100"
        type = "gp2"
    }
}
ec2_ingress_rules = [
  {
    from = 443
    to = 443
    protocol = "tcp"
  },
  {
    from = 8001
    to = 8001
    protocol = "tcp"
  }
]
iam_instance_profile = "AmazonSSMRoleForInstancesQuickSetup" # use for Session Manager access to instance

# RDS parameters
db_secret_manager_arn = ""
rds_storage_size = 50
rds_storage_type = "gp2"
rds_engine_version = "5.7"
rds_instance_class = "db.t3.small"
rds_multi_az = false
rds_backup_retention_period = 1
rds_ingress_port = 3306

# ALB parameters
lb_certificate_arn = ""
lb_cross_zone_load_balancing = true
lb_ingress_rules = [
  {
    from = 443
    to = 443
    protocol = "tcp"
  },
  {
    from = 8001
    to = 8001
    protocol = "tcp"
  }
]
listener_ports = {
    app_port1  = {
        port = 7000
        protocol = "TCP"
        health_check_path = "/"
        health_check_timeout = 5
        health_check_interval = 10
        health_check_healthy_threshold = 2
        health_check_unhealthy_threshold = 2
    },    
    app_port2  = {
        port = 443
        protocol = "TCP"
        health_check_path = "/"
        health_check_timeout = 5
        health_check_interval = 10
        health_check_healthy_threshold = 2
        health_check_unhealthy_threshold = 2
    },
}

# VPC endpoint parameters
private_dns_name = ""



