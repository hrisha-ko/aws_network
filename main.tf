/* The list of availability zones */
data "aws_availability_zones" "available" {
  state = "available"
}

/* VPC */
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_attributes.cidr_block
  enable_dns_hostnames = true
  tags                 = merge(var.common_tags, { Name = "VPC-${var.environment}" })
}

/* Internet Gateway */
resource "aws_internet_gateway" "igw" {
  vpc_id     = aws_vpc.vpc.id
  depends_on = [aws_vpc.vpc]
  tags       = merge(var.common_tags, { Name = "IGW-${var.environment}" })
}

/* PUBLIC subnets, route tables, subnets route table associations */
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.public_subnets_cidrs)
  cidr_block              = element(var.public_subnets_cidrs, count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = var.public_subnet_map_public_ip
  depends_on              = [aws_vpc.vpc]
  tags                    = merge(var.common_tags, { Name = "Subnet-Public-${count.index + 1}" })
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  depends_on = [aws_internet_gateway.igw]
  tags       = merge(var.common_tags, { Name = "rt-public-${var.environment}" })
}

resource "aws_route_table_association" "public_table_association" {
  depends_on     = [aws_route_table.public_rt]
  count          = length(var.public_subnets_cidrs)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public_rt.id
}

/* PRIVATE subnets, route tables, subnets route table associations */
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.vpc.id
  count             = length(var.private_subnets_cidrs)
  cidr_block        = element(var.private_subnets_cidrs, count.index)
  availability_zone = element(var.azs, count.index)
  map_public_ip_on_launch = var.private_subnet_map_public_ip
  depends_on        = [aws_vpc.vpc]
  tags              = merge(var.common_tags, { Name = "Subnet-Private-${count.index + 1}" })
}

resource "aws_route_table" "private_rt" {
  count  = length(var.private_subnets_cidrs)
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge(var.common_tags, { Name = "rt-private-${count.index + 1}-${var.environment}" })
}

resource "aws_route_table_association" "private_table_association" {
  count          = length(var.private_subnets_cidrs)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private_rt[count.index].id
}
