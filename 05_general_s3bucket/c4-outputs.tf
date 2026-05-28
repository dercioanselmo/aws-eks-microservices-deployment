output "resume_bucket_name" {
    description = "Bucket Name"
  value = aws_s3_bucket.resume_bucket.id
}

output "resume_bucket_arn" {
    description = "Bucket ARN"
  value = aws_s3_bucket.resume_bucket.arn
}