data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "tfstate-dev-us-east-1-1v8wcs"
    key    = "zomato/vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "efs" {
  backend = "s3"

  config = {
    bucket = "tfstate-dev-us-east-1-1v8wcs"
    key    = "zomato/efs/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "s3" {
  backend = "s3"

  config = {
    bucket = "tfstate-dev-us-east-1-1v8wcs"
    key    = "zomato/s3/terraform.tfstate"
    region = "us-east-1"
  }
}
