variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "CodeBuild project name"
  type        = string
  default     = "Zomato-CI"
}

variable "github_owner" {
  description = "GitHub account or organization name"
  type        = string
  default     = "dercioanselmo"
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
  default     = "aws-eks-microservices-deployment"
}

variable "buildspec_path" {
  description = "Path to the buildspec file to use for the build"
  type        = string
  default     = "buildspec.yaml"
}

variable "code_connection_arn" {
  description = "ARN of the AWS CodeConnections connection for GitHub"
  type        = string
  default     = "arn:aws:codeconnections:us-east-1:652978908369:connection/b9f56633-9327-435c-b7c6-254572966bda"
}

variable "service_role_name" {
  description = "Name of the CodeBuild service role"
  type        = string
  default     = "codebuild-zomato-CI-service-role"
}

variable "artifact_bucket_name" {
  description = "S3 bucket used for CodeBuild artifacts"
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "VPC ID for the build environment"
  type        = string
  default     = ""
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for the build environment"
  type        = list(string)
  default     = []
}

variable "security_group_id" {
  description = "Security group ID for the build environment"
  type        = string
  default     = ""
}

variable "efs_identifier" {
  description = "Identifier for the EFS mount in CodeBuild"
  type        = string
  default     = "zomato-efs"
}

variable "efs_dns_name" {
  description = "DNS name of the EFS file system"
  type        = string
  default     = ""
}

variable "efs_mount_point" {
  description = "Mount point for the EFS file system inside the build container"
  type        = string
  default     = "/efs"
}
