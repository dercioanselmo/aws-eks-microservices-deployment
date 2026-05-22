# Existing Security Group
resource "aws_security_group" "ec2_sg" {
  name        = "dercio-ec2-ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dercio-ec2-sg"
  }
}

# Existing SSH Rule
resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.ec2_sg.id

  description = "SSH from anywhere"

  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"
  cidr_ipv4   = "0.0.0.0/0"
}

# New Kubernetes API Rule
resource "aws_vpc_security_group_ingress_rule" "k8s_api" {
  security_group_id = aws_security_group.ec2_sg.id

  description = "Kubernetes API Server (6443)"

  from_port   = 6443
  to_port     = 6443
  ip_protocol = "tcp"
  cidr_ipv4   = data.aws_vpc.default.cidr_block
}