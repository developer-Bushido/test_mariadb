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

data "http" "current_ip" {
  url = "http://ipv4.icanhazip.com"
}
