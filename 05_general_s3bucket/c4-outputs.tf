output "resume_bucket_name" {
  description = "Bucket Name"
  value       = module.resume_bucket.bucket_name
}

output "resume_bucket_arn" {
  description = "Bucket ARN"
  value       = module.resume_bucket.bucket_arn
}