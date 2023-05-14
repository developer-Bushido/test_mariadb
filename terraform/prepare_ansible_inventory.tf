
resource "null_resource" "ansible_inventory" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = <<EOF
    cat > ../ansible/inventory.yml <<'INV'
---
all:
  children:
    web:
      hosts:
        ${aws_instance.my_WEB.public_ip}:
    db:
      children:
        master_db:
          hosts:
${join("\n", formatlist("            %s:", aws_instance.my_DB_master.*.public_ip))}
        slave_db:
          hosts:
${join("\n", formatlist("            %s:", aws_instance.my_DB_slave.*.public_ip))}
INV
    EOF
  }

  depends_on = [aws_instance.my_WEB, aws_instance.my_DB_master, aws_instance.my_DB_slave]
}
