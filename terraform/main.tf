provider "aws" {
  region  = "eu-north-1"
  profile = "default"
}

# DB SERVERS

resource "aws_security_group" "db_security_group" {
  name        = "db_security_group"
  description = "Security group for MariaDB servers"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "db_security_group"
  }
}

resource "aws_instance" "my_DB" {
  count                  = 2
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  key_name               = "admin_kp"
  vpc_security_group_ids = [aws_security_group.db_security_group.id]
  tags = {
    Name = "DB Server"
  }
}

resource "aws_security_group_rule" "db_security_group_ssh_access" {
  security_group_id = aws_security_group.db_security_group.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = [format("%s/32", chomp(data.http.current_ip.body))]
}

resource "aws_security_group_rule" "db_security_group_db_access" {
  security_group_id = aws_security_group.db_security_group.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 3306
  to_port           = 3306
  cidr_blocks       = [format("%s/32", aws_instance.my_WEB.private_ip)]
}

resource "aws_security_group_rule" "db_security_group_replication_access" {
  count             = length(aws_instance.my_DB.*.id)
  security_group_id = aws_security_group.db_security_group.id
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = [format("%s/32", element(aws_instance.my_DB.*.private_ip, count.index))]
}


# WEB SERVERS
resource "aws_security_group" "web_server" {
  name        = "web_security_group"
  description = "Security group for WEB servers"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web_security_group"
  }
}

resource "aws_instance" "my_WEB" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  key_name               = "admin_kp"
  vpc_security_group_ids = [aws_security_group.web_server.id]
  tags = {
    Name = "Web and Monitoring"
  }
}

resource "aws_security_group_rule" "web_security_group_ssh_access" {
  security_group_id = aws_security_group.web_server.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = [format("%s/32", chomp(data.http.current_ip.body))]
}

resource "aws_security_group_rule" "web_security_group_http_access" {
  security_group_id = aws_security_group.web_server.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "web_security_group_https_access" {
  security_group_id = aws_security_group.web_server.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
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

data "http" "current_ip" {
  url = "http://ipv4.icanhazip.com"
}
