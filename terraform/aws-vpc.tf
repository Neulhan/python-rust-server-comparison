data "aws_availability_zones" "available" {}

resource "aws_vpc" "prc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "prc project VPC"
  }
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

resource "aws_db_subnet_group" "prc_db_private" {
  name       = "prc_db_private"
  subnet_ids = aws_subnet.private_subnets[*].id
  tags = {
    Name = "PRC db private"
  }
}
