# AWS RDS


##retrieve db password from secret manager
data "aws_secretsmanager_secret" "db_secrets" {
  arn = var.db_secret_manager_arn
}

##retrieve current version of db password secret
data "aws_secretsmanager_secret_version" "current" {
  secret_id = data.aws_secretsmanager_secret.db_secrets.id
}

## db instance
resource "aws_db_instance" "application_db" {
  allocated_storage    = var.rds_storage_size
  storage_type         = var.rds_storage_type
  engine               = "mysql"
  engine_version       = var.rds_engine_version
  instance_class       = var.rds_instance_class
  name                 = "${environment}-application-db"
  username             = "db-${environment}"
  password             = data.aws_secretsmanager_secret_version.current.secret_string["${var.environment}-db-password"]
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  multi_az             = var.rds_multi_az
  vpc_security_group_ids = [
    "${aws_security_group.application_db_security_group.id}"
  ]
  db_subnet_group_name = "${aws_db_subnet_group.application_db.name}" #check this name

  backup_retention_period   = var.rds_backup_retention_period
  tags {
    Environment = var.environment
  }
}

# db subnet group
resource "aws_db_subnet_group" "application_db" {
  name       = "${environment}-application-db-subnet_group"
  subnet_ids = var.subnet_ids
  tags = {
        Environment = var.environment
    }
}

# security group
resource "aws_security_group" "application_db_security_group" {
  name        = "${environment}-application-db-security-group"
  vpc_id      = var.vpc_id
  ingress {
    from_port   = var.rds_ingress_port
    to_port     = var.rds_ingress_port
    protocol    = "tcp"
    security_groups = ["${aws_security_group.windows.id}"]
  }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
            Environment = var.environment
        }
}


