variable "instance_names" {
  description = "Names for the EC2 instances"
  type        = list(string)
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
}

variable "root_volume_size" {
  description = "Root volume size in GB"
  type        = number
}

variable "security_group_name" {
  description = "Name of the EC2 security group"
  type        = string
  default     = "dercio-ec2-ssh"
}

variable "ssh_cidr_blocks" {
  description = "CIDR blocks allowed to SSH"
  type        = string
  default     = "0.0.0.0/0"
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
