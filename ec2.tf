# EC2 for windows

## get ami id
data "aws_ami" "windows" {
    most_recent = true
   filter {
    name   = "name"
    values = [var.vm_name_filter]
   }
    filter {
        name   = "virtualization-type"
        values = [var.vm_virtualization-type]
    }
}

## user data template
data "template_file" "windows_user_data" {
  template = file("${path.module}/user-data.ps1")
}

## instance
resource "aws_instance" "windows" {
    ami                     = data.aws_ami.windows.id
    instance_type           = var.instance_type
    subnet_id               = var.subnet_id
    vpc_security_group_ids  = [aws_security_group.windows.id]
    iam_instance_profile    = var.iam_instance_profile_name
    user_data               = data.template_file.windows_user_data.rendered

    # root disk
    root_block_device {
      volume_size = var.ec2_volumes.root.size
      volume_type = var.ec2_volumes.root.type
      delete_on_termination = true
    }

    # data disk
    ebs_block_device {
      device_name = "/dev/sdb"
      volume_size = var.ec2_volumes.ebs.size
      volume_type = var.ec2_volumes.ebs.type
      delete_on_termination = true
    }

    tags = {
      Name = "${environment}-windows-instance"
      Environment = var.environment
    }  
}

## instance security group
resource "aws_security_group" "windows" {
  name        = "${environment}-windows-instance-security-group"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.ec2_ingress_rules

    content {
      from_port  = ingress.value.from
      to_port = ingress.value.to
      protocol = ingress.value.protocol
      security_groups = ["${aws_security_group.alb.id}"]
    }
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



