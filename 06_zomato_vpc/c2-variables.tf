variable "aws_region" {
  description = "AWS region for the VPC"
  type        = string
  default     = "us-east-1"
}

variable "environment_name" {
  description = "Environment name tag"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for the Zomato VPC"
  type        = string
  default     = "10.20.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the public subnets"
  type        = list(string)
  default     = ["10.20.1.0/24", "10.20.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for the private subnets"
  type        = list(string)
  default     = ["10.20.101.0/24", "10.20.102.0/24"]
}
