output "instance_ids" {
  value = aws_instance.ec2[*].id
}

output "instance_public_ips" {
  value = aws_instance.ec2[*].public_ip
}

output "ssh_commands" {
  description = "Ready-to-use SSH commands"
  value = [
    for i in range(length(var.instance_names)) :
    "ssh -i ~/.ssh/dercio-key.pem ubuntu@${aws_instance.ec2[i].public_ip}   # ${var.instance_names[i]}"
  ]
}