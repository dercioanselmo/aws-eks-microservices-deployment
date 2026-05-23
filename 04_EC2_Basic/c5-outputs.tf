output "instance_private_ips" {
  value = aws_instance.ec2[*].private_ip
}

output "instance_public_ips" {
  value = aws_instance.ec2[*].public_ip
}

output "ssh_commands" {
  description = "Ready-to-use SSH commands"
  value = [
    for i in range(length(var.instance_names)) :
    "ssh -i dercio-key.pem ubuntu@${aws_instance.ec2[i].public_ip}   # ${var.instance_names[i]}"
  ]
}