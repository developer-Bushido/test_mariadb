

# DB SERVERS

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

resource "aws_security_group_rule" "db_security_group_replication_access_from_master" {
  count             = length(aws_instance.my_DB_master.*.id)
  security_group_id = aws_security_group.db_security_group.id
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = [format("%s/32", element(aws_instance.my_DB_master.*.private_ip, count.index))]
}

resource "aws_security_group_rule" "db_security_group_replication_access_from_slave" {
  count             = length(aws_instance.my_DB_slave.*.id)
  security_group_id = aws_security_group.db_security_group.id
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = [format("%s/32", element(aws_instance.my_DB_slave.*.private_ip, count.index))]
}

resource "aws_security_group_rule" "db_security_group_db_control_access" {
  security_group_id = aws_security_group.db_security_group.id
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = [format("%s/32", chomp(data.http.current_ip.body))]
}


# WEB SERVERS

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
