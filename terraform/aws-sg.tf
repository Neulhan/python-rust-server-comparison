resource "aws_security_group" "pythonrust_ec2_sg" {
  name        = "pythonrust-ec2-sg"
  description = "pythonrust ecs security group"
  vpc_id      = aws_vpc.prc.id

  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "pythonrust-ec2-sg"
  }
}

resource "aws_security_group" "pythonrust_rds_sg" {
  name        = "pythonrust-rds-sg"
  description = "pythonrust rds security group"
  vpc_id      = aws_vpc.prc.id

  ingress {
    description = "mysql"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.prc.cidr_block]
  }

  ingress {
    description = "postgresql"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.prc.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "pythonrust-rds-sg"
  }
}
