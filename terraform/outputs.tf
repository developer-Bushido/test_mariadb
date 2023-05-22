
output "orchestrators_ips" {
  value       = aws_instance.orchestrator.*.public_ip
  description = "Public IPs of the Orchestrator servers"
}

output "proxysql_ips" {
  value       = aws_instance.proxysql.*.public_ip
  description = "Public IPs of the ProxySQL servers"
}
output "mariadb_ips" {
  value       = aws_instance.mariadb.*.public_ip
  description = "Public IPs of the MariaDB servers"
}

output "load_balancer_ip" {
  value       = aws_lb.lb.dns_name
  description = "The DNS address of the load balancer"
}
