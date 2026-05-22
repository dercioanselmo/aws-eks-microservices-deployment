variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "instance_count" {
  description = "Number of EC2 instances to create"
  type        = number
  default     = 2
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

variable "instance_name_prefix" {
  description = "Prefix for instance names"
  type        = string
  default     = "dercio-ec2"
}