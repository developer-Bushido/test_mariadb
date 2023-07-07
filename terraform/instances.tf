provider "aws" {
  # region  = "eu-west-3"
  profile = "default"
}

resource "aws_instance" "orchestrator" {
  count                  = 1
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  key_name               = "admin_kp"
  vpc_security_group_ids = [aws_security_group.orchestrator_security_group.id]
  tags = {
    Name = "Orchestrator"
  }
}

resource "aws_instance" "proxysql" {
  count                  = 3
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

resource "aws_lb" "lb" {
  name                       = "my-lb"
  internal                   = false
  load_balancer_type         = "network"
  subnets                    = [for i in aws_instance.proxysql : i.subnet_id]
  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_target_group" "target_group" {
  name     = "tf-example"
  port     = 6033
  protocol = "TCP"
  vpc_id   = aws_security_group.proxysql_security_group.vpc_id

  health_check {
    interval            = 30
    port                = "traffic-port"
    protocol            = "TCP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "3306"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

resource "aws_lb_target_group_attachment" "target_group_attachment" {
  count            = length(aws_instance.proxysql)
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = aws_instance.proxysql[count.index].id
  port             = 6033
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
