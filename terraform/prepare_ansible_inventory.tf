resource "null_resource" "ansible_inventory" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "echo '${templatefile("${path.module}/../ansible/inventory.tpl", {
      web_ip     = aws_instance.my_WEB.public_ip,
      master_ips = aws_instance.my_DB_master.*.public_ip,
      slave_ips  = aws_instance.my_DB_slave.*.public_ip
      })
    }' > ../ansible/inventory.yml"
  }

  depends_on = [aws_instance.my_WEB, aws_instance.my_DB_master, aws_instance.my_DB_slave]
}
