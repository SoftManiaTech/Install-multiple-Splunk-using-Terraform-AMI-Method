terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.region
}

# Create a Security Group for Splunk
resource "aws_security_group" "splunk_sg" {
  name        = "splunk-security-group"
  description = "Allow necessary Splunk ports"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8000
    to_port     = 9999
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create multiple instances dynamically
resource "aws_instance" "splunk_server" {
  count = var.instance_count  # Creates as many instances as defined in 'instance_count'

  ami                  = var.ami_id
  instance_type        = "t2.medium"
  key_name             = var.key_name
  vpc_security_group_ids = [aws_security_group.splunk_sg.id]
  associate_public_ip_address = true

  root_block_device {
    volume_size = 30
  }

  tags = {
    Name = "Splunk-Server-${count.index + 1}"
  }
}

# Output the public IPs of all instances
output "public_ips" {
  value = aws_instance.splunk_server[*].public_ip
}
