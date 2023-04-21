resource "null_resource" "ansible_local_provisioner" {
  count      = var.vm_count
  depends_on = [
    azurerm_linux_virtual_machine.linux_vm
  ]
  provisioner "remote-exec" {
    inline = [
      "hostname"
    ]
    connection {
      type = "ssh"
      user = var.linux_admin_uname
      # password = var.linux_admin_paswd
      private_key = file("~/.ssh/auto")
      host = element(azurerm_linux_virtual_machine.linux_vm[*].public_ip_address, count.index + 1)
    }
  }
    provisioner "local-exec" {
  command = "ssh-keyscan ${azurerm_public_ip.public_ip[count.index].ip_address} >> ~/.ssh/known_hosts"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i '${azurerm_public_ip.public_ip[count.index].ip_address},' -u ${var.linux_admin_uname} --private-key=${var.private_key} ./ansible/groupX-playbook.yml"

  }

}