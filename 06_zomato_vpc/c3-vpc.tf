data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "zomato" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "zomato-vpc"
    Environment = var.environment_name
  }
}

resource "aws_internet_gateway" "zomato" {
  vpc_id = aws_vpc.zomato.id

  tags = {
    Name        = "zomato-igw"
    Environment = var.environment_name
  }
}

resource "aws_subnet" "public" {
  count = 2

  vpc_id                  = aws_vpc.zomato.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name        = "zomato-public-${count.index + 1}"
    Type        = "public"
    Environment = var.environment_name
  }
}

resource "aws_subnet" "private" {
  count = 2

  vpc_id            = aws_vpc.zomato.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name        = "zomato-private-${count.index + 1}"
    Type        = "private"
    Environment = var.environment_name
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.zomato.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.zomato.id
  }

  tags = {
    Name        = "zomato-public-rt"
    Environment = var.environment_name
  }
}

resource "aws_route_table_association" "public" {
  count = 2

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.zomato.id

  tags = {
    Name        = "zomato-private-rt"
    Environment = var.environment_name
  }
}

resource "aws_route_table_association" "private" {
  count = 2

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
