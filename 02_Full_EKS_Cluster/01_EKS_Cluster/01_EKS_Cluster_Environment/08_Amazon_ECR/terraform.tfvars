aws_region         = "us-east-1"
environment_name   = "dev"
#business_division  = "retail"

github_repo  = "dercioanselmo/retail_microservices"
role_name    = "github-actions-oidc-role-ui"

tags = {
  Terraform   = "true"
  Environment = "dev"
  Project     = "karpenter-autoscaling"
  ManagedBy   = "platform-team"
}