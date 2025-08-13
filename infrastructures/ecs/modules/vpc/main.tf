resource "aws_vpc" "vpc" {
  count = var.create_vpc ? 1 : 0

  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project}-vpc"
  }
}

resource "aws_subnet" "public_subnets" {
  count = var.create_vpc ? var.vpc_number_public_subnets : 0

  vpc_id                  = aws_vpc.vpc[0].id
  cidr_block              = cidrsubnet(aws_vpc.vpc[0].cidr_block, 8, count.index * 2 + 1)
  availability_zone       = element(var.vpc_az, (count.index % length(var.vpc_az)))
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project}-public-subnet-${count.index + 1}"
  }

  depends_on = [
    aws_vpc.vpc
  ]
}

resource "aws_subnet" "private_subnets" {
  count = var.create_vpc ? var.vpc_number_private_subnets : 0

  vpc_id                  = aws_vpc.vpc[0].id
  cidr_block              = cidrsubnet(aws_vpc.vpc[0].cidr_block, 8, count.index * 2)
  availability_zone       = element(var.vpc_az, (count.index % length(var.vpc_az)))
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project}-private-subnet-${count.index + 1}"
  }

  depends_on = [
    aws_vpc.vpc
  ]
}

resource "aws_internet_gateway" "igw" {
  count = var.create_vpc ? 1 : 0

  vpc_id = aws_vpc.vpc[0].id

  tags = {
    Name = "${var.project}-igw"
  }

  depends_on = [
    aws_vpc.vpc
  ]
}

resource "aws_route_table" "public" {
  count = var.create_vpc ? 1 : 0

  vpc_id = aws_vpc.vpc[0].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw[0].id
  }

  depends_on = [
    aws_internet_gateway.igw
  ]
}

resource "aws_route_table_association" "public" {
  count = var.create_vpc ? var.vpc_number_public_subnets : 0

  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.public[0].id

  depends_on = [
    aws_route_table.public,
    aws_subnet.public_subnets
  ]
}

resource "aws_eip" "nat_eip" {
  count = var.create_nat && var.vpc_nat_gateway_eip == "" ? 1 : 0

  domain = "vpc"

  tags = {
    Name = "${var.project}-nat-eip"
  }
}

resource "aws_nat_gateway" "nat" {
  count = var.create_nat ? 1 : 0

  allocation_id = var.vpc_nat_gateway_eip != "" ? var.vpc_nat_gateway_eip : aws_eip.nat_eip[0].id
  subnet_id     = element(aws_subnet.public_subnets[*].id, 0)

  tags = {
    Name = "${var.project}-nat"
  }

  depends_on = [
    aws_route_table.public,
    aws_internet_gateway.igw,
    aws_eip.nat_eip
  ]
}

resource "aws_route_table" "private" {
  count = var.create_vpc ? 1 : 0

  vpc_id = aws_vpc.vpc[0].id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[0].id
  }

  depends_on = [
    aws_nat_gateway.nat
  ]
}

resource "aws_route_table_association" "private" {
  count = var.create_vpc ? var.vpc_number_private_subnets : 0

  subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)
  route_table_id = aws_route_table.private[0].id

  depends_on = [
    aws_route_table.private,
    aws_subnet.private_subnets
  ]
}