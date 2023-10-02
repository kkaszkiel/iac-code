resource "local_sensitive_file" "private_key" {
  content = tls_private_key.key.private_key_pem
  filename          = format("%s/%s/%s", abspath(path.root), "ansible/.ssh", "ansible-ssh-key.pem")
  file_permission   = "0600"
}




resource "local_file" "ansible_inventory" {
  content = templatefile("inventory.tftpl", {
    ip_addrs = [for i in aws_instance.WebServer[*]:i.public_ip]
    ssh_keyfile = local_sensitive_file.private_key.filename
  })
  filename = format("%s/%s", abspath(path.root), "ansible/inventory.ini")
}

resource "local_file" "ansible_cfg" {
  content = templatefile("ansible_cfg.tftpl", {
    inventory_file = format("%s/%s/%s", abspath(path.root), "ansible", "inventory.ini")
  })
  filename = format("%s/%s", abspath(path.root), "ansible/ansible.cfg")
}
