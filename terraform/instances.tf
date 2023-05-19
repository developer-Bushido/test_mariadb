provider "aws" {
  region  = "eu-north-1"
  profile = "default"
}

resource "aws_instance" "orchestrator" {
  count                  = 3
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  key_name               = "admin_kp"
  vpc_security_group_ids = [aws_security_group.orchestrator_security_group.id]
  tags = {
    Name = "Orchestrator"
  }
}

resource "aws_instance" "proxysql" {
  count                  = 2
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  key_name               = "admin_kp"
  vpc_security_group_ids = [aws_security_group.proxysql_security_group.id]
  tags = {
    Name = "ProxySQL"
  }
}

resource "aws_instance" "mariadb" {
  count                  = 3
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  key_name               = "admin_kp"
  vpc_security_group_ids = [aws_security_group.mariadb_security_group.id]
  tags = {
    Name = "MariaDB"
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
