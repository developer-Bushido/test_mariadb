resource "null_resource" "ansible_inventory" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "echo '${templatefile("${path.module}/../ansible/inventory.tpl", {
      orchestrator_ips = aws_instance.orchestrator.*.public_ip,
      proxysql_ips     = aws_instance.proxysql.*.public_ip,
      mariadb_ips      = aws_instance.mariadb.*.public_ip
      })
    }' > ../ansible/inventory.yml"
  }

  depends_on = [aws_instance.orchestrator, aws_instance.proxysql, aws_instance.mariadb]
}
