resource "aws_iam_role" "codebuild" {
  name = var.service_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "codebuild" {
  role = aws_iam_role.codebuild.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "codebuild:CreateReportGroup",
          "codebuild:CreateReport",
          "codebuild:UpdateReport",
          "codebuild:BatchPutTestCases",
          "codebuild:BatchPutCodeCoverages",
          "s3:PutObject",
          "s3:GetBucketLocation",
          "ec2:CreateNetworkInterface",
          "ec2:DescribeDhcpOptions",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeVpcs"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_codebuild_project" "this" {
  name          = var.project_name
  description   = "Zomato CI build project"
  build_timeout = 60
  service_role  = aws_iam_role.codebuild.arn

  artifacts {
    type = "S3"
    location = local.resolved_artifact_bucket_name
    name = var.project_name
    namespace_type = "BUILD_ID"
    packaging = "ZIP"
    encryption_disabled = false
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:7.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "EFS_MOUNT_POINT"
      value = var.efs_mount_point
    }
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/${var.github_owner}/${var.github_repo}.git"
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = false
    }

    buildspec = var.buildspec_path
  }

  source_version = "main"

  vpc_config {
    vpc_id             = local.resolved_vpc_id
    subnets            = local.resolved_private_subnet_ids
    security_group_ids = [local.resolved_security_group_id]
  }

  file_system_locations {
    identifier  = var.efs_identifier
    location    = "${local.resolved_efs_dns_name}:/"
    type        = "EFS"
    mount_point = var.efs_mount_point
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "/aws/codebuild/${var.project_name}"
      stream_name = "build"
    }
  }

  tags = {
    Name        = var.project_name
    Environment = "dev"
  }
}
