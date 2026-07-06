module "generic_bucket" {
  source = "./modules/s3_bucket"

  bucket_name_prefix = var.bucket_name_prefix
  environment_name   = var.environment_name
}