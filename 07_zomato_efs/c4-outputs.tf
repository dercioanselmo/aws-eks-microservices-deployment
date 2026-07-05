output "efs_id" {
  description = "ID of the EFS file system"
  value       = aws_efs_file_system.zomato.id
}

output "efs_dns_name" {
  description = "DNS name of the EFS file system"
  value       = aws_efs_file_system.zomato.dns_name
}

output "mount_point" {
  description = "Mount point path to use for the EFS"
  value       = var.mount_point
}

output "mount_command" {
  description = "Example mount command using the EFS helper"
  value       = "sudo mkdir -p ${var.mount_point} && sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 ${aws_efs_file_system.zomato.dns_name}:/ ${var.mount_point}"
}
