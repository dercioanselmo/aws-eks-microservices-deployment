variable "bucket_name_prefix" {
  description = "Prefix used to build the S3 bucket name"
  type        = string
}

variable "environment_name" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "tags" {
  description = "Additional tags for the bucket"
  type        = map(string)
  default     = {}
}
