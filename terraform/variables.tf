variable "consul_tcp_ports" {
  description = "List of ports to open"
  type        = list(string)
  default     = ["8300", "8301", "8302", "8500", "8600"]
}

variable "consul_udp_ports" {
  description = "List of ports to open"
  type        = list(string)
  default     = ["8301", "8302"]
}

variable "proxysql_ports" {
  description = "List of ports to open"
  type        = list(string)
  default     = ["6033", "6034"]
}

data "http" "current_ip" {
  url = "http://ipv4.icanhazip.com"
}
