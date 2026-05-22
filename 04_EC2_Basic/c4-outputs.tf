output "instance_ids" {
  description = "IDs of the created EC2 instances"
  value       = aws_instance.ec2[*].id
}

output "instance_public_ips" {
  description = "Public IP addresses of the EC2 instances"
  value       = aws_instance.ec2[*].public_ip
}

output "instance_private_ips" {
  description = "Private IP addresses of the EC2 instances"
  value       = aws_instance.ec2[*].private_ip
}

output "ssh_command" {
  description = "Example SSH command"
  value       = "ssh -i ~/.ssh/${var.key_name}.pem ec2-user@<public-ip>"
}