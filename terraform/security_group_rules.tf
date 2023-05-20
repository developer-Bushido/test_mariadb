###########################################################################################
################################### ORCHESTRATOR SERVERS ##################################
###########################################################################################
resource "aws_security_group_rule" "SGR_orchestrator_interconnect" {
  count             = length(aws_instance.orchestrator.*.id)
  security_group_id = aws_security_group.orchestrator_security_group.id
  type              = "ingress"
  from_port         = 10008
  to_port           = 10008
  protocol          = "tcp"
  cidr_blocks       = [format("%s/32", element(aws_instance.orchestrator.*.public_ip, count.index))]
}

resource "aws_security_group_rule" "SGR_orchestrator_consul_TCP" {
  for_each          = toset(var.consul_tcp_ports)
  security_group_id = aws_security_group.orchestrator_security_group.id
  type              = "ingress"
  from_port         = tonumber(each.value)
  to_port           = tonumber(each.value)
  protocol          = "tcp"
  cidr_blocks       = [format("%s/32", element(aws_instance.orchestrator.*.public_ip, each.key))]
}

resource "aws_security_group_rule" "SGR_orchestrator_consul_UDP" {
  for_each          = toset(var.consul_udp_ports)
  security_group_id = aws_security_group.orchestrator_security_group.id
  type              = "ingress"
  from_port         = tonumber(each.value)
  to_port           = tonumber(each.value)
  protocol          = "udp"
  cidr_blocks       = [format("%s/32", element(aws_instance.orchestrator.*.public_ip, each.key))]
}

### PORTS FOR ADMIN ###
resource "aws_security_group_rule" "SGR_orchestrator_admin_SSH" {
  security_group_id = aws_security_group.orchestrator_security_group.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [format("%s/32", chomp(data.http.current_ip.body))]
}

resource "aws_security_group_rule" "SGR_orchestrator_admin_WEB_client" {
  security_group_id = aws_security_group.orchestrator_security_group.id
  type              = "ingress"
  from_port         = 3000
  to_port           = 3000
  protocol          = "tcp"
  cidr_blocks       = [format("%s/32", chomp(data.http.current_ip.body))]
}

resource "aws_security_group_rule" "SGR_orchestrator_consul_admin_WEB_client" {
  security_group_id = aws_security_group.orchestrator_security_group.id
  type              = "ingress"
  from_port         = 8500
  to_port           = 8500
  protocol          = "tcp"
  cidr_blocks       = [format("%s/32", chomp(data.http.current_ip.body))]
}

###########################################################################################
##################################### PROXYSQL SERVERS ####################################
###########################################################################################

resource "aws_security_group_rule" "SGR_proxysql_Settings" {
  count             = length(aws_instance.proxysql.*.id)
  security_group_id = aws_security_group.proxysql_security_group.id
  type              = "ingress"
  from_port         = 6032
  to_port           = 6032
  protocol          = "tcp"
  cidr_blocks       = [format("%s/32", element(aws_instance.proxysql.*.public_ip, count.index))]
}
resource "aws_security_group_rule" "SGR_proxysql_Input" {
  count             = length(aws_instance.proxysql.*.id)
  security_group_id = aws_security_group.proxysql_security_group.id
  type              = "ingress"
  from_port         = 6033
  to_port           = 6033
  protocol          = "tcp"
  cidr_blocks       = [format("%s/32", element(aws_instance.proxysql.*.public_ip, count.index))]
}
resource "aws_security_group_rule" "SGR_proxysql_Server_RPC" {
  count             = length(aws_instance.proxysql.*.id)
  security_group_id = aws_security_group.proxysql_security_group.id
  type              = "ingress"
  from_port         = 8300
  to_port           = 8300
  protocol          = "tcp"
  cidr_blocks       = [format("%s/32", element(aws_instance.proxysql.*.public_ip, count.index))]
}

resource "aws_security_group_rule" "SGR_proxysql_Serf_LAN" {
  count             = length(aws_instance.proxysql.*.id)
  security_group_id = aws_security_group.proxysql_security_group.id
  type              = "ingress"
  from_port         = 8301
  to_port           = 8301
  protocol          = "tcp"
  cidr_blocks       = [format("%s/32", element(aws_instance.proxysql.*.public_ip, count.index))]
}

resource "aws_security_group_rule" "SGR_proxysql_Serf_LAN_udp" {
  count             = length(aws_instance.proxysql.*.id)
  security_group_id = aws_security_group.proxysql_security_group.id
  type              = "ingress"
  from_port         = 8301
  to_port           = 8301
  protocol          = "udp"
  cidr_blocks       = [format("%s/32", element(aws_instance.proxysql.*.public_ip, count.index))]
}

resource "aws_security_group_rule" "SGR_proxysql_Serf_WAN" {
  count             = length(aws_instance.proxysql.*.id)
  security_group_id = aws_security_group.proxysql_security_group.id
  type              = "ingress"
  from_port         = 8302
  to_port           = 8302
  protocol          = "tcp"
  cidr_blocks       = [format("%s/32", element(aws_instance.proxysql.*.public_ip, count.index))]
}

resource "aws_security_group_rule" "SGR_proxysql_Serf_WAN_udp" {
  count             = length(aws_instance.proxysql.*.id)
  security_group_id = aws_security_group.proxysql_security_group.id
  type              = "ingress"
  from_port         = 8302
  to_port           = 8302
  protocol          = "udp"
  cidr_blocks       = [format("%s/32", element(aws_instance.proxysql.*.public_ip, count.index))]
}

resource "aws_security_group_rule" "SGR_proxysql_DNS_Interface" {
  count             = length(aws_instance.proxysql.*.id)
  security_group_id = aws_security_group.proxysql_security_group.id
  type              = "ingress"
  from_port         = 8600
  to_port           = 8600
  protocol          = "tcp"
  cidr_blocks       = [format("%s/32", element(aws_instance.proxysql.*.public_ip, count.index))]
}
resource "aws_security_group_rule" "SGR_proxysql_Server_RPC_ext" {
  count             = length(aws_instance.orchestrator.*.id)
  security_group_id = aws_security_group.proxysql_security_group.id
  type              = "ingress"
  from_port         = 8300
  to_port           = 8300
  protocol          = "tcp"
  cidr_blocks       = [format("%s/32", element(aws_instance.orchestrator.*.public_ip, count.index))]
}

resource "aws_security_group_rule" "SGR_proxysql_Serf_LAN_ext" {
  count             = length(aws_instance.orchestrator.*.id)
  security_group_id = aws_security_group.proxysql_security_group.id
  type              = "ingress"
  from_port         = 8301
  to_port           = 8301
  protocol          = "tcp"
  cidr_blocks       = [format("%s/32", element(aws_instance.orchestrator.*.public_ip, count.index))]
}

resource "aws_security_group_rule" "SGR_proxysql_Serf_LAN_udp_ext" {
  count             = length(aws_instance.orchestrator.*.id)
  security_group_id = aws_security_group.proxysql_security_group.id
  type              = "ingress"
  from_port         = 8301
  to_port           = 8301
  protocol          = "udp"
  cidr_blocks       = [format("%s/32", element(aws_instance.orchestrator.*.public_ip, count.index))]
}

resource "aws_security_group_rule" "SGR_proxysql_Serf_WAN_ext" {
  count             = length(aws_instance.orchestrator.*.id)
  security_group_id = aws_security_group.proxysql_security_group.id
  type              = "ingress"
  from_port         = 8302
  to_port           = 8302
  protocol          = "tcp"
  cidr_blocks       = [format("%s/32", element(aws_instance.orchestrator.*.public_ip, count.index))]
}

resource "aws_security_group_rule" "SGR_proxysql_Serf_WAN_udp_ext" {
  count             = length(aws_instance.orchestrator.*.id)
  security_group_id = aws_security_group.proxysql_security_group.id
  type              = "ingress"
  from_port         = 8302
  to_port           = 8302
  protocol          = "udp"
  cidr_blocks       = [format("%s/32", element(aws_instance.orchestrator.*.public_ip, count.index))]
}

resource "aws_security_group_rule" "SGR_proxysql_DNS_Interface_ext" {
  count             = length(aws_instance.orchestrator.*.id)
  security_group_id = aws_security_group.proxysql_security_group.id
  type              = "ingress"
  from_port         = 8600
  to_port           = 8600
  protocol          = "tcp"
  cidr_blocks       = [format("%s/32", element(aws_instance.orchestrator.*.public_ip, count.index))]
}

### PORTS FOR ADMIN ###
resource "aws_security_group_rule" "SGR_proxysql_admin_SSH" {
  security_group_id = aws_security_group.proxysql_security_group.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [format("%s/32", chomp(data.http.current_ip.body))]
}

resource "aws_security_group_rule" "SGR_proxysql_proxysql_admin_WEB_client" {
  security_group_id = aws_security_group.proxysql_security_group.id
  type              = "ingress"
  from_port         = 6032
  to_port           = 6032
  protocol          = "tcp"
  cidr_blocks       = [format("%s/32", chomp(data.http.current_ip.body))]
}

###########################################################################################
###################################### MARIADB SERVERS ####################################
###########################################################################################
resource "aws_security_group_rule" "SGR_mariadb" {
  count             = length(aws_instance.mariadb.*.id)
  security_group_id = aws_security_group.mariadb_security_group.id
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = [format("%s/32", element(aws_instance.mariadb.*.public_ip, count.index))]
}
resource "aws_security_group_rule" "SGR_mariadb_ext" {
  count             = length(aws_instance.proxysql.*.id)
  security_group_id = aws_security_group.mariadb_security_group.id
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = [format("%s/32", element(aws_instance.proxysql.*.public_ip, count.index))]
}

### PORTS FOR ADMIN ###
resource "aws_security_group_rule" "SGR_mariadb_admin_SSH" {
  security_group_id = aws_security_group.mariadb_security_group.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [format("%s/32", chomp(data.http.current_ip.body))]
}

resource "aws_security_group_rule" "SGR_mariadb_admin" {
  security_group_id = aws_security_group.mariadb_security_group.id
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = [format("%s/32", chomp(data.http.current_ip.body))]
}
