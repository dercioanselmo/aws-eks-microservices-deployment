variable "aws_region" {
  description = "AWS region for the EFS"
  type        = string
  default     = "us-east-1"
}

variable "environment_name" {
  description = "Environment name tag"
  type        = string
  default     = "dev"
}

variable "efs_name" {
  description = "Name of the EFS filesystem"
  type        = string
  default     = "zomato"
}

variable "mount_point" {
  description = "Mount point path for the EFS"
  type        = string
  default     = "/efs"
}

variable "subnet_ids" {
  description = "Subnet IDs where the EFS mount targets will be created"
  type        = list(string)
  default     = []
}
