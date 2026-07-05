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
  default     = ""
}

variable "buildspec_path" {
  description = "Path to the buildspec file inside the repo"
  type        = string
  default     = "buildspec.yml"
}

variable "code_connection_arn" {
  description = "ARN of the AWS CodeConnections connection for GitHub"
  type        = string
  default     = "arn:aws:codeconnections:us-east-1:652978908369:connection/b9f56633-9327-435c-b7c6-254572966bda"
}
