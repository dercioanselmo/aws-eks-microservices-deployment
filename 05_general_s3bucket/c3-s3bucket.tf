module "generic_bucket" {
  source             = "./modules/s3_bucket"
  bucket_name_prefix = var.bucket_name_prefix
  environment_name   = var.environment_name
}

module "CICD-Security-Scan-report_bucket" {
  source             = "./modules/s3_bucket"
  bucket_name_prefix = "cicd-security-scan-report"
  environment_name   = var.environment_name
}

# ====================== GitHub Actions S3 Upload Policy ======================

resource "aws_iam_policy" "github_snyk_report_upload" {
  name        = "github-actions-snyk-report-upload"
  description = "Allow GitHub OIDC role to upload Snyk reports"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:PutObjectAcl"
        ]
        Resource = [
          "${module.CICD-Security-Scan-report_bucket.bucket_arn}",
          "${module.CICD-Security-Scan-report_bucket.bucket_arn}/*"
        ]
      },
      {
        Effect   = "Allow"
        Action   = "s3:ListBucket"
        Resource = module.CICD-Security-Scan-report_bucket.bucket_arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_snyk_report_policy" {
  role       = "github-actions-oidc-role-gleamgoods"
  policy_arn = aws_iam_policy.github_snyk_report_upload.arn
}