# Security Group for Kubernetes Cluster
resource "aws_security_group" "ec2_sg" {
  name        = "dercio-k8s-cluster-sg"
  description = "Security Group for Kubernetes Cluster"
  vpc_id      = data.aws_vpc.default.id

  # SSH Access (from anywhere - you can restrict later)
  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Kubernetes API Server (6443) - Only from within the VPC
  ingress {
    description = "Kubernetes API Server (Control Plane)"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.default.cidr_block]   # Only VPC internal
  }

  # Allow all internal communication within the VPC (recommended for K8s)
  ingress {
    description = "Allow all traffic from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [data.aws_vpc.default.cidr_block]
  }

  # Egress - Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dercio-k8s-sg"
  }
}