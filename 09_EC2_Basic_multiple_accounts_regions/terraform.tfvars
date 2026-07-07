account_a_name             = "dev"
account_a_region           = "us-east-1"
account_a_profile          = "default"
account_a_key_name         = "your-key-name-us-east-1"
account_a_instance_type    = "m7i-flex.large"
account_a_root_volume_size = 50
account_a_instance_names   = ["control-plane"]
account_a_ssh_cidr_blocks  = "0.0.0.0/0"

account_b_name             = "prod"
account_b_region           = "eu-west-1"
account_b_profile          = "default"
account_b_key_name         = "your-key-name-eu-west-1"
account_b_instance_type    = "m7i-flex.large"
account_b_root_volume_size = 50
account_b_instance_names   = ["worker-node"]
account_b_ssh_cidr_blocks  = "0.0.0.0/0"

common_tags = {
  Project     = "aws-eks-microservices-deployment"
  ManagedBy   = "terraform"
  Environment = "multi-account"
}