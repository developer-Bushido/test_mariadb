
output "webserver_ip" {
  value       = aws_instance.my_WEB.public_ip
  description = "Public IP of the Web server"
}

output "db_master_server_ips" {
  value       = aws_instance.my_DB_master.*.public_ip
  description = "Public IPs of the DB master servers"
}

output "db_slave_server_ips" {
  value       = aws_instance.my_DB_slave.*.public_ip
  description = "Public IPs of the DB slave servers"
}
