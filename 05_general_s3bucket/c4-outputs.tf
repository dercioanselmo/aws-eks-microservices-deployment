output "generic_bucket_name" {
  description = "Bucket Name"
  value       = module.generic_bucket.bucket_name
}

output "generic_bucket_arn" {
  description = "Bucket ARN"
  value       = module.generic_bucket.bucket_arn
}