#EC2 variables
variable "vpc_id" {}
variable "subnet_ids" {}
variable "vm_name_filter" {}
variable "vm_virtualization-type" {}
variable "ec2_volumes" {
    type = map(object({
        size = number
        type = string
    }))
}
variable "ec2_ingress_rules" {
  type = list(object({
    from = number
    to = number
    protocol = string
  })) 
}
variable "iam_instance_profile" {}

# RDS variables
variable "db_secret_manager_arn" {}
variable "rds_storage_size" {}
variable "rds_storage_type" {}
variable "rds_engine_version" {}
variable "rds_instance_class" {}
variable "rds_multi_az" {}
variable "rds_backup_retention_period" {}
variable "rds_ingress_port" {}

# ALB variables
variable "lb_certificate_arn" {}
variable "lb_ingress_rules" {
  type = list(object({
    from = number
    to = number
    protocol = string
  })) 
}
variable "listener_ports" {
  type    = map
}  
variable "lb_cross_zone_load_balancing" {}
variable "private_dns_name" {}