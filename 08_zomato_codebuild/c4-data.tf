locals {
  resolved_vpc_id            = var.vpc_id != "" ? var.vpc_id : try(data.terraform_remote_state.vpc.outputs.vpc_id, "")
  resolved_private_subnet_ids = length(var.private_subnet_ids) > 0 ? var.private_subnet_ids : try(data.terraform_remote_state.vpc.outputs.private_subnet_ids, [])
  resolved_artifact_bucket_name = var.artifact_bucket_name != "" ? var.artifact_bucket_name : try(data.terraform_remote_state.s3.outputs.report_bucket_name, "")
  resolved_efs_dns_name      = var.efs_dns_name != "" ? var.efs_dns_name : try(data.terraform_remote_state.efs.outputs.efs_dns_name, "")
  resolved_security_group_id = var.security_group_id != "" ? var.security_group_id : try(data.aws_security_group.default[0].id, "")
}

data "aws_security_group" "default" {
  count = var.security_group_id == "" && local.resolved_vpc_id != "" ? 1 : 0

  filter {
    name   = "group-name"
    values = ["default"]
  }

  filter {
    name   = "vpc-id"
    values = [local.resolved_vpc_id]
  }
}
