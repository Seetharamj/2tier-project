data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.env_prefix}-vpc"
    Environment = var.env_prefix
  }
}

# Public Subnets
resource "aws_subnet" "public" {
  count                   = length(data.aws_availability_zones.available.names)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.cidr_block, 8, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.env_prefix}-public-subnet-${count.index + 1}"
    Environment = var.env_prefix
    Tier        = "public"
  }
}

# Private Subnets
resource "aws_subnet" "private" {
  count             = length(data.aws_availability_zones.available.names)
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.cidr_block, 8, count.index + length(data.aws_availability_zones.available.names))
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name        = "${var.env_prefix}-private-subnet-${count.index + 1}"
    Environment = var.env_prefix
    Tier        = "private"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.env_prefix}-igw"
    Environment = var.env_prefix
  }
}

# NAT Gateway with Elastic IP
resource "aws_eip" "nat" {
  count = length(data.aws_availability_zones.available.names)
  vpc   = true

  tags = {
    Name        = "${var.env_prefix}-nat-eip-${count.index + 1}"
    Environment = var.env_prefix
  }
}

resource "aws_nat_gateway" "nat" {
  count         = length(data.aws_availability_zones.available.names)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name        = "${var.env_prefix}-nat-gw-${count.index + 1}"
    Environment = var.env_prefix
  }

  depends_on = [aws_internet_gateway.gw]
}

# Route Tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name        = "${var.env_prefix}-public-rt"
    Environment = var.env_prefix
  }
}

resource "aws_route_table" "private" {
  count  = length(data.aws_availability_zones.available.names)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[count.index].id
  }

  tags = {
    Name        = "${var.env_prefix}-private-rt-${count.index + 1}"
    Environment = var.env_prefix
  }
}

# Route Table Associations
resource "aws_route_table_association" "public" {
  count          = length(data.aws_availability_zones.available.names)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = length(data.aws_availability_zones.available.names)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
