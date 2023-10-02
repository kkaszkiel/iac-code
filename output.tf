# output.tf

output "server-data" {
  value       = [for vm in aws_instance.WebServer[*] : {
    ip_address  = vm.public_ip
  }]
  description = "The public IP of the servers"
}