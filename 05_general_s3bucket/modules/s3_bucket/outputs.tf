output "bucket_name" {
  description = "Created bucket name"
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "Created bucket ARN"
  value       = aws_s3_bucket.this.arn
}
