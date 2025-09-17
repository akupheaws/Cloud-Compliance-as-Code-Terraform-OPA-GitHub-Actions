########################################
# Data sources
########################################
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-20.04-amd64-server-*"]
  }
}

########################################
# Security group (demo – tighten for prod)
########################################
resource "aws_security_group" "vm_sg" {
  name        = "opa-demo-sg"
  description = "Minimal SG for demo"
  # If you manage VPCs explicitly, set vpc_id here

  ingress {
    description = "Allow SSH (adjust/remove in prod)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.default_tags, { Name = "opa-demo-sg" })
}

########################################
# Define 8 instances with names/env/size
########################################
locals {
  instances = {
    vm01 = { name = "opa-vm-01", env = "dev", type = "t3.micro" }
    vm02 = { name = "opa-vm-02", env = "dev", type = "t3.micro" }
    vm03 = { name = "opa-vm-03", env = "qa", type = "t3.micro" }
    vm04 = { name = "opa-vm-04", env = "qa", type = "t3.micro" }
    vm05 = { name = "opa-vm-05", env = "stage", type = "t3.small" }
    vm06 = { name = "opa-vm-06", env = "stage", type = "t3.small" }
    vm07 = { name = "opa-vm-07", env = "prod", type = "t3.small" }
    vm08 = { name = "opa-vm-08", env = "prod", type = "t3.small" }
  }
}

########################################
# 8 EC2 instances
########################################
resource "aws_instance" "vm" {
  for_each               = local.instances
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = each.value.type
  vpc_security_group_ids = [aws_security_group.vm_sg.id]

  tags = merge(
    var.default_tags,
    {
      Name        = each.value.name
      Environment = each.value.env
    }
  )
}
