data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "tfstate-dev-eu-central-1-a65beq"
    key    = "zomato/vpc/terraform.tfstate"
    region = "eu-central-1"
  }
}

data "terraform_remote_state" "efs" {
  backend = "s3"

  config = {
    bucket = "tfstate-dev-eu-central-1-a65beq"
    key    = "zomato/efs/terraform.tfstate"
    region = "eu-central-1"
  }
}

data "terraform_remote_state" "s3" {
  backend = "s3"

  config = {
    bucket = "tfstate-dev-eu-central-1-a65beq"
    key    = "zomato/s3/terraform.tfstate"
    region = "eu-central-1"
  }
}
