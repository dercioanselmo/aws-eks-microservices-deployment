output "resume_bucket_name" {
  description = "Bucket Name"
  value       = module.resume_bucket.bucket_name
}

output "resume_bucket_arn" {
  description = "Bucket ARN"
  value       = module.resume_bucket.bucket_arn
}

output "report_bucket_name" {
  description = "Report Bucket Name"
  value       = module.report_bucket.bucket_name
}

output "report_bucket_arn" {
  description = "Report Bucket ARN"
  value       = module.report_bucket.bucket_arn
}