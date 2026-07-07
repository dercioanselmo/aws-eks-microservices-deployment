output "account_a_instance_private_ips" {
  description = "Private IPs for the first deployment target"
  value       = module.deploy_account_a.instance_private_ips
}

output "account_a_instance_public_ips" {
  description = "Public IPs for the first deployment target"
  value       = module.deploy_account_a.instance_public_ips
}

output "account_b_instance_private_ips" {
  description = "Private IPs for the second deployment target"
  value       = module.deploy_account_b.instance_private_ips
}

output "account_b_instance_public_ips" {
  description = "Public IPs for the second deployment target"
  value       = module.deploy_account_b.instance_public_ips
}

output "ssh_commands" {
  description = "Ready-to-use SSH commands for both deployment targets"
  value = concat(
    [for ip in module.deploy_account_a.instance_public_ips : "ssh -i <YOUR_KEY>.pem ubuntu@${ip}"],
    [for ip in module.deploy_account_b.instance_public_ips : "ssh -i <YOUR_KEY>.pem ubuntu@${ip}"]
  )
}