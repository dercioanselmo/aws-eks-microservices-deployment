module "generic_bucket" {
  source = "./modules/s3_bucket"

  bucket_name_prefix = var.bucket_name_prefix
  environment_name   = var.environment_name
}

module "CICD-Security-Scan-report_bucket" {
  source = "./modules/s3_bucket"

  bucket_name_prefix = "cicd-security-scan-report"
  environment_name   = var.environment_name
}