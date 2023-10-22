#ssh key for ansible

resource "local_sensitive_file" "private_key" {
  content = tls_private_key.key.private_key_pem
  filename          = format("%s/%s/%s", abspath(path.root), "ansible/.ssh", "ansible-ssh-key.pem")
  file_permission   = "0600"
}


#ansible inventory

resource "local_file" "ansible_inventory" {
  content = templatefile("inventory.tftpl", {
    ip_addrs = [for i in aws_instance.WebServer[*]:i.public_ip]
    ssh_keyfile = local_sensitive_file.private_key.filename
  })
  filename = format("%s/%s", abspath(path.root), "ansible/inventory.ini")
}

#ansible config file

resource "local_file" "ansible_cfg" {
  content = templatefile("ansible_cfg.tftpl", {
    inventory_file = format("%s/%s/%s", abspath(path.root), "ansible", "inventory.ini")
  })
  filename = format("%s/%s", abspath(path.root), "ansible/ansible.cfg")
}

# ansible global variables

resource "local_file" "ansible_variables" {
  content = templatefile("defaults-main.tftpl", {
    domain_name = var.domain_name
    repository_name = var.repository_name
  })
  filename = format("%s/%s", abspath(path.root), "ansible/defaults/main.yml")
}
