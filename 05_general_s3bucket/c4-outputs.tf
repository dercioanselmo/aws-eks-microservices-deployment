
output "bucket_arn" {
  description = "ARN of the bucket"
  value       = aws_s3_bucket.s3_bucket.arn
}

output "tfstate_bucket_id" {
  description = "Bucket ID (same as name)"
  value       = aws_s3_bucket.s3_bucket.id
}

