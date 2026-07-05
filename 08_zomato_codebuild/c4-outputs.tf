output "codebuild_project_name" {
  description = "Name of the CodeBuild project"
  value       = aws_codebuild_project.this.name
}

output "codebuild_project_arn" {
  description = "ARN of the CodeBuild project"
  value       = aws_codebuild_project.this.arn
}

output "codebuild_service_role_arn" {
  description = "ARN of the CodeBuild service role"
  value       = aws_iam_role.codebuild.arn
}

output "codebuild_region" {
  description = "AWS region where the CodeBuild project was created"
  value       = var.aws_region
}

output "artifact_bucket_name" {
  description = "S3 bucket used for CodeBuild artifacts"
  value       = local.resolved_artifact_bucket_name
}

output "vpc_id" {
  description = "VPC used by the CodeBuild environment"
  value       = local.resolved_vpc_id
}

output "private_subnet_ids" {
  description = "Private subnets used by the CodeBuild environment"
  value       = local.resolved_private_subnet_ids
}

output "efs_dns_name" {
  description = "EFS DNS name mounted into the CodeBuild environment"
  value       = local.resolved_efs_dns_name
}
