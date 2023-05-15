provider "aws" {
  region  = "eu-north-1"
  profile = "default"
}

# DB SERVERS

resource "aws_instance" "my_DB_master" {
  count                  = 1
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  key_name               = "admin_kp"
  vpc_security_group_ids = [aws_security_group.db_security_group.id]
  tags = {
    Name = "DB Master Server"
  }
}

resource "aws_instance" "my_DB_slave" {
  count                  = 3
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  key_name               = "admin_kp"
  vpc_security_group_ids = [aws_security_group.db_security_group.id]
  tags = {
    Name = "DB Slave Server"
  }
}

# WEB SERVERS

resource "aws_instance" "my_WEB" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  key_name               = "admin_kp"
  vpc_security_group_ids = [aws_security_group.web_server.id]
  tags = {
    Name = "Web and Monitoring"
  }
}


data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}
