output "generic_bucket_name" {
  description = "Bucket Name"
  value       = module.generic_bucket.bucket_name
}

output "generic_bucket_arn" {
  description = "Bucket ARN"
  value       = module.generic_bucket.bucket_arn
}

output "CICD-Security-Scan-report_bucket_name" {
  description = "Report Bucket Name"
  value       = module.CICD-Security-Scan-report_bucket.bucket_name
}

output "CICD-Security-Scan-report_bucket_arn" {
  description = "Report Bucket ARN"
  value       = module.CICD-Security-Scan-report_bucket.bucket_arn
}