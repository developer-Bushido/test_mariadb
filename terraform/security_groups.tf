resource "aws_security_group" "orchestrator_security_group" {
  name        = "orchestrator_security_group"
  description = "Security group for Orchestrator servers"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "orchestrator_security_group"
    description = "Orchestrator Interconnect access (10008), Consul access: Server RPC (8300), Serf LAN (8301), Serf WAN (8302), DNS Interface (8600), Admin access: SSH (22), Orchestrator (3000), Consul HTTP API (8500)"
  }
}

resource "aws_security_group" "proxysql_security_group" {
  name        = "proxysql_security_group"
  description = "Security group for ProxySQL servers"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "proxysql_security_group"
    description = "Orchestrator Interconnect access (10008), Consul access: Server RPC (8300), Serf LAN (8301), Serf WAN (8302), DNS Interface (8600), Admin access: SSH (22), Orchestrator (3000), Consul HTTP API (8500)"
  }
}

resource "aws_security_group" "mariadb_security_group" {
  name        = "mariadb_security_group"
  description = "Security group for MariaDB servers"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "mariadb_security_group"
    description = "MariaDB access (3306), Admin access: SSH (22), MariaDB (3306)"
  }
}
