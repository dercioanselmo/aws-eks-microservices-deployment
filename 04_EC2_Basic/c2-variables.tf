variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.xlarge"
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
}

variable "root_volume_size" {
  description = "Root volume size in GB"
  type        = number
  default     = 50
}

variable "instance_names" {
  description = "Names for the EC2 instances"
  type        = list(string)
  default     = ["Control_plane", "Worker_node"]
}