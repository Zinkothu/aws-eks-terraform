
# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.cluster_name}-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.cluster_name}-igw"
  }
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "${var.cluster_name}-nat-eip"
  }
}

# NAT Gateway (placed in public subnet ap-southeast-1b)
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_ap_southeast_1b.id

  tags = {
    Name = "${var.cluster_name}-nat"
  }
  #to check if the internet gateway is created before the NAT gateway, we can add a depends_on to ensure the correct order of resource creation
  depends_on = [aws_internet_gateway.main]
}

# Public Subnets
resource "aws_subnet" "public_ap_southeast_1a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_ap_southeast_1a_cidr
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = true

  tags = {
    Name                     = "${var.cluster_name}-subnet-public-ap-southeast-1a"
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "public_ap_southeast_1b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_ap_southeast_1b_cidr
  availability_zone       = "ap-southeast-1b"
  map_public_ip_on_launch = true

  tags = {
    Name                     = "${var.cluster_name}-subnet-public-ap-southeast-1b"
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "public_ap_southeast_1c" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_ap_southeast_1c_cidr
  availability_zone       = "ap-southeast-1c"
  map_public_ip_on_launch = true

  tags = {
    Name                     = "${var.cluster_name}-subnet-public-ap-southeast-1c"
    "kubernetes.io/role/elb" = "1"
  }
}

# Private Subnets
resource "aws_subnet" "private_ap_southeast_1a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_ap_southeast_1a_cidr
  availability_zone = "ap-southeast-1a"

  tags = {
    Name                              = "${var.cluster_name}-subnet-private-ap-southeast-1a"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_subnet" "private_ap_southeast_1b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_ap_southeast_1b_cidr
  availability_zone = "ap-southeast-1b"

  tags = {
    Name                              = "${var.cluster_name}-subnet-private-ap-southeast-1b"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_subnet" "private_ap_southeast_1c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_ap_southeast_1c_cidr
  availability_zone = "ap-southeast-1c"

  tags = {
    Name                              = "${var.cluster_name}-subnet-private-ap-southeast-1c"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

# Route Tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.cluster_name}-public-route-table"
  }
}

resource "aws_route_table" "private_ap_southeast_1a" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.cluster_name}-private-route-table-ap-southeast-1a"
  }
}

resource "aws_route_table" "private_ap_southeast_1b" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.cluster_name}-private-route-table-ap-southeast-1b"
  }
}

resource "aws_route_table" "private_ap_southeast_1c" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.cluster_name}-private-route-table-ap-southeast-1c"
  }
}

# Routes
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = var.default_route_cidr
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route" "private_nat_gateway_1a" {
  route_table_id         = aws_route_table.private_ap_southeast_1a.id
  destination_cidr_block = var.default_route_cidr
  nat_gateway_id         = aws_nat_gateway.main.id
}

resource "aws_route" "private_nat_gateway_1b" {
  route_table_id         = aws_route_table.private_ap_southeast_1b.id
  destination_cidr_block = var.default_route_cidr
  nat_gateway_id         = aws_nat_gateway.main.id
}

resource "aws_route" "private_nat_gateway_1c" {
  route_table_id         = aws_route_table.private_ap_southeast_1c.id
  destination_cidr_block = var.default_route_cidr
  nat_gateway_id         = aws_nat_gateway.main.id
}

# Route Table Associations
resource "aws_route_table_association" "public_ap_southeast_1a" {
  subnet_id      = aws_subnet.public_ap_southeast_1a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_ap_southeast_1b" {
  subnet_id      = aws_subnet.public_ap_southeast_1b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_ap_southeast_1c" {
  subnet_id      = aws_subnet.public_ap_southeast_1c.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_ap_southeast_1a" {
  subnet_id      = aws_subnet.private_ap_southeast_1a.id
  route_table_id = aws_route_table.private_ap_southeast_1a.id
}

resource "aws_route_table_association" "private_ap_southeast_1b" {
  subnet_id      = aws_subnet.private_ap_southeast_1b.id
  route_table_id = aws_route_table.private_ap_southeast_1b.id
}

resource "aws_route_table_association" "private_ap_southeast_1c" {
  subnet_id      = aws_subnet.private_ap_southeast_1c.id
  route_table_id = aws_route_table.private_ap_southeast_1c.id
}