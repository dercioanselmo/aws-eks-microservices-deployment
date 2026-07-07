module "deploy_account_b" {
  source = "./modules/ec2_multi_region"

  providers = {
    aws = aws.account_b
  }

  instance_names      = var.account_b_instance_names
  instance_type       = var.account_b_instance_type
  key_name            = var.account_b_key_name
  root_volume_size    = var.account_b_root_volume_size
  security_group_name = "dercio-ec2-ssh-${var.account_b_name}"
  ssh_cidr_blocks     = var.account_b_ssh_cidr_blocks
  tags = merge(var.common_tags, {
    Environment = var.account_b_name
    Region      = var.account_b_region
  })
}