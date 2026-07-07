terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket       = "tfstate-dev-us-east-1-1v8wcs"
    key          = "ec2_basic_multiple_accounts_regions/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}

provider "aws" {
  alias   = "account_a"
  region  = var.account_a_region
  profile = var.account_a_profile
}

provider "aws" {
  alias   = "account_b"
  region  = var.account_b_region
  profile = var.account_b_profile
}