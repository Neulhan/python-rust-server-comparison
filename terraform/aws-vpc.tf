data "aws_availability_zones" "available" {}

resource "aws_vpc" "prc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "prc project VPC"
  }
}

resource "aws_internet_gateway" "prc" {
  vpc_id = aws_vpc.prc.id
}

resource "aws_route_table" "prc" {
  vpc_id = aws_vpc.prc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.prc.id
  }
}

resource "aws_route_table_association" "rt-association-public" {
  count          = length(aws_subnet.public_subnets)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.prc.id
}

resource "aws_subnet" "public_subnets" {
  count                   = 4
  vpc_id                  = aws_vpc.prc.id
  cidr_block              = cidrsubnet(aws_vpc.prc.cidr_block, 4, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet ${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnets" {
  count                   = 4
  vpc_id                  = aws_vpc.prc.id
  cidr_block              = cidrsubnet(aws_vpc.prc.cidr_block, 4, count.index + length(aws_subnet.public_subnets))
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false


  tags = {
    Name = "Private Subnet ${count.index + 1}"
  }
}

resource "aws_db_subnet_group" "prc_public" {
  name       = "prc_public"
  subnet_ids = aws_subnet.public_subnets[*].id
  tags = {
    Name = "PRC public"
  }
}

resource "aws_db_subnet_group" "prc_private" {
  name       = "prc_private"
  subnet_ids = aws_subnet.private_subnets[*].id
  tags = {
    Name = "PRC private"
  }
}
