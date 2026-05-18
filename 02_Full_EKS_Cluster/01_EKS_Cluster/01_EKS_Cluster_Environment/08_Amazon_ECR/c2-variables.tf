variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "github_repo" {
  description = "GitHub repository (owner/repo)"
  type        = string
  default     = "dercioanselmo/retail_microservices"
}

variable "role_name" {
  description = "IAM Role name for GitHub Actions"
  type        = string
  default     = "github-actions-oidc-role-ui"
}

variable "environment_name" {
  description = "Environment tag"
  type        = string
  default     = "dev"
}

variable "tags" {
  description = "Global tags to apply to all resources"
  type        = map(string)
  default     = {
    Terraform = "true"
  }
}

# List of all ECR repositories to create
variable "ecr_repositories" {
  description = "List of ECR repositories to create"
  type        = list(string)
  default = [
    "retail-store/ui",
    "retail-store/cart",
    "retail-store/catalog",
    "retail-store/checkout",
    "retail-store/orders"
  ]
}