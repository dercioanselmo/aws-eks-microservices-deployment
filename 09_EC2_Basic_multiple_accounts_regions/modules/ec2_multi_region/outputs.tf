output "instance_private_ips" {
  description = "Private IPs of the EC2 instances"
  value       = aws_instance.ec2[*].private_ip
}

output "instance_public_ips" {
  description = "Public IPs of the EC2 instances"
  value       = aws_instance.ec2[*].public_ip
}
