variable "account_a_name" {
  description = "Logical name for the first deployment target"
  type        = string
  default     = "dev"
}

variable "account_a_region" {
  description = "AWS region for the first deployment target"
  type        = string
  default     = "us-east-1"
}

variable "account_a_profile" {
  description = "AWS CLI profile for the first deployment target"
  type        = string
  default     = "default"
}

variable "account_a_key_name" {
  description = "SSH key pair name for the first deployment target"
  type        = string
}

variable "account_a_instance_type" {
  description = "EC2 instance type for the first deployment target"
  type        = string
  default     = "m7i-flex.large"
}

variable "account_a_root_volume_size" {
  description = "Root volume size in GB for the first deployment target"
  type        = number
  default     = 50
}

variable "account_a_instance_names" {
  description = "EC2 instance names for the first deployment target"
  type        = list(string)
  default     = ["control-plane"]
}

variable "account_a_ssh_cidr_blocks" {
  description = "CIDR blocks allowed to SSH into the first deployment target"
  type        = string
  default     = "0.0.0.0/0"
}

variable "account_b_name" {
  description = "Logical name for the second deployment target"
  type        = string
  default     = "prod"
}

variable "account_b_region" {
  description = "AWS region for the second deployment target"
  type        = string
  default     = "eu-west-1"
}

variable "account_b_profile" {
  description = "AWS CLI profile for the second deployment target"
  type        = string
  default     = "default"
}

variable "account_b_key_name" {
  description = "SSH key pair name for the second deployment target"
  type        = string
}

variable "account_b_instance_type" {
  description = "EC2 instance type for the second deployment target"
  type        = string
  default     = "m7i-flex.large"
}

variable "account_b_root_volume_size" {
  description = "Root volume size in GB for the second deployment target"
  type        = number
  default     = 50
}

variable "account_b_instance_names" {
  description = "EC2 instance names for the second deployment target"
  type        = list(string)
  default     = ["worker-node"]
}

variable "account_b_ssh_cidr_blocks" {
  description = "CIDR blocks allowed to SSH into the second deployment target"
  type        = string
  default     = "0.0.0.0/0"
}

variable "common_tags" {
  description = "Common tags shared by all deployment targets"
  type        = map(string)
  default = {
    managed-by = "terraform"
    project    = "aws-eks-microservices-deployment"
  }
}