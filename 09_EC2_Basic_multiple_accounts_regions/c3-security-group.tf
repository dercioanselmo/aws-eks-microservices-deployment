module "deploy_account_a" {
  source = "./modules/ec2_multi_region"

  providers = {
    aws = aws.account_a
  }

  instance_names      = var.account_a_instance_names
  instance_type       = var.account_a_instance_type
  key_name            = var.account_a_key_name
  root_volume_size    = var.account_a_root_volume_size
  security_group_name = "dercio-ec2-ssh-${var.account_a_name}"
  ssh_cidr_blocks     = var.account_a_ssh_cidr_blocks
  tags = merge(var.common_tags, {
    Environment = var.account_a_name
    Region      = var.account_a_region
  })
}