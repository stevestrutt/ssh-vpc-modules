output "bastion_host_ip_addresses" {
  value = module.bastion.bastion_ip_addresses
}

output "frontend_server_host_ip_addresses" {
  value = [module.frontend.primary_ipv4_address]
}

output "backend_server_host_ip_addresses" {
  value = [module.backend.primary_ipv4_address]
}
