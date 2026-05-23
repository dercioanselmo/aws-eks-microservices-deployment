
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
  description       = "SSH from anywhere"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

# Existing Kubernetes API Rule
resource "aws_vpc_security_group_ingress_rule" "k8s_api" {
  security_group_id = aws_security_group.ec2_sg.id
  description       = "Kubernetes API Server (6443)"
  from_port         = 6443
  to_port           = 6443
  ip_protocol       = "tcp"
  cidr_ipv4         = data.aws_vpc.default.cidr_block
}

# etcd
resource "aws_vpc_security_group_ingress_rule" "etcd" {
  security_group_id = aws_security_group.ec2_sg.id
  description       = "etcd (2379-2380)"
  from_port         = 2379
  to_port           = 2380
  ip_protocol       = "tcp"
  cidr_ipv4         = data.aws_vpc.default.cidr_block
}

# kubelet
resource "aws_vpc_security_group_ingress_rule" "kubelet" {
  security_group_id = aws_security_group.ec2_sg.id
  description       = "kubelet (10250)"
  from_port         = 10250
  to_port           = 10250
  ip_protocol       = "tcp"
  cidr_ipv4         = data.aws_vpc.default.cidr_block
}

# NodePort Services
resource "aws_vpc_security_group_ingress_rule" "nodeport" {
  security_group_id = aws_security_group.ec2_sg.id
  description       = "NodePort Services (30000-32767)"
  from_port         = 30000
  to_port           = 32767
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

# Calico BGP
resource "aws_vpc_security_group_ingress_rule" "calico_bgp" {
  security_group_id = aws_security_group.ec2_sg.id
  description       = "Calico BGP (179)"
  from_port         = 179
  to_port           = 179
  ip_protocol       = "tcp"
  cidr_ipv4         = data.aws_vpc.default.cidr_block
}

# VXLAN
resource "aws_vpc_security_group_ingress_rule" "vxlan" {
  security_group_id = aws_security_group.ec2_sg.id
  description       = "VXLAN overlay (4789)"
  from_port         = 4789
  to_port           = 4789
  ip_protocol       = "udp"
  cidr_ipv4         = data.aws_vpc.default.cidr_block
}

# Calico Typha
resource "aws_vpc_security_group_ingress_rule" "calico_typha" {
  security_group_id = aws_security_group.ec2_sg.id
  description       = "Calico Typha (5473)"
  from_port         = 5473
  to_port           = 5473
  ip_protocol       = "tcp"
  cidr_ipv4         = data.aws_vpc.default.cidr_block
}

# My Mac access
resource "aws_vpc_security_group_ingress_rule" "k8s_api_external" {
  security_group_id = aws_security_group.ec2_sg.id
  description       = "Kubernetes API Server (6443) - admin access"
  from_port         = 6443
  to_port           = 6443
  ip_protocol       = "tcp"
  cidr_ipv4         = "87.201.143.73/32"
}