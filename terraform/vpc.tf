resource "aws_vpc" "prc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "prc project VPC"
  }
}

resource "aws_subnet" "public_subnets" {
  count      = length(var.public_subnet_cidrs)
  vpc_id     = aws_vpc.prc.id
  cidr_block = element(var.public_subnet_cidrs, count.index)

  tags = {
    Name = "Public Subnet ${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnets" {
  count      = length(var.private_subnet_cidrs)
  vpc_id     = aws_vpc.prc.id
  cidr_block = element(var.private_subnet_cidrs, count.index)

  tags = {
    Name = "Private Subnet ${count.index + 1}"
  }
}

resource "aws_db_subnet_group" "prc_db_private" {
  name       = "prc_db_private"
  subnet_ids = [aws_subnet.private_subnets[0].id, aws_subnet.private_subnets[1].id]
  tags = {
    Name = "PRC db private"
  }
}
