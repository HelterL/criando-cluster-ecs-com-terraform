resource "aws_vpc" "main" {
  cidr_block = var.cidr
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name: "${var.name}-vpc-${var.environment}"
    Environment: var.environment
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name: "${var.name}-igw-${var.environment}"
    Environment: var.environment
  } 
}

resource "aws_eip" "main" {
  domain = "vpc"
  tags = {
    Name: "${var.name}-eip-ngw-${var.environment}"
    Environment: var.environment
  }
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.main.id
  subnet_id = aws_subnet.private_subnet.id
  depends_on = [aws_internet_gateway.main]
  tags = {
    Name: "${var.name}-ngw-${var.environment}"
    Environment: var.environment
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.private_subnet
  availability_zone = var.availabilty_zone
  tags = {
    Name: "${var.name}-sub-private-${var.environment}"
    Environment: var.environment
  } 
}

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.public_subnet
  availability_zone = var.availabilty_zone
  map_public_ip_on_launch = true
  tags = {
    Name: "${var.name}-sub-public-${var.environment}"
    Environment: var.environment
  } 
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
   tags = {
    Name: "${var.name}-rt-private-${var.environment}"
    Environment: var.environment
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name: "${var.name}-rt-public-${var.environment}"
    Environment: var.environment
  }
}

resource "aws_route" "public" {
  route_table_id = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main.id
}

resource "aws_route" "private" {
  route_table_id = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.main.id
}

resource "aws_route_table_association" "private" {
  subnet_id = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "public" {
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public.id
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "cidr" {
  value = aws_vpc.main.cidr_block
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}
















