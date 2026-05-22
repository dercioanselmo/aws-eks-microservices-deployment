# Get Default VPC
data "aws_vpc" "default" {
  default = true
}

# Get Default Security Group
data "aws_security_group" "default" {
  vpc_id = data.aws_vpc.default.id

  filter {
    name   = "group-name"
    values = ["default"]
  }
}

# Get latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

# Get ALL default subnets and pick the first one (most reliable method)
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "default-for-az"
    values = ["true"]
  }

  filter {
    name   = "map-public-ip-on-launch"
    values = ["true"]
  }
}

# Create EC2 Instances
resource "aws_instance" "ec2" {
  count = var.instance_count

  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  key_name      = var.key_name

  subnet_id                   = data.aws_subnets.default.ids[0]   # Pick first available subnet
  vpc_security_group_ids      = [data.aws_security_group.default.id]
  associate_public_ip_address = true

  tags = {
    Name = "${var.instance_name_prefix}-${count.index + 1}"
  }
}