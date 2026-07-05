resource "aws_efs_file_system" "zomato" {
  creation_token = var.efs_name

  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  encrypted        = true

  tags = {
    Name        = var.efs_name
    Environment = var.environment_name
  }
}

resource "aws_security_group" "efs" {
  name        = "${var.efs_name}-efs-sg"
  description = "Allow NFS traffic to EFS"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.efs_name}-efs-sg"
    Environment = var.environment_name
  }
}

resource "aws_efs_mount_target" "zomato" {
  count = length(var.subnet_ids)

  file_system_id  = aws_efs_file_system.zomato.id
  subnet_id       = var.subnet_ids[count.index]
  security_groups = [aws_security_group.efs.id]
}
