data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn-ami-*-x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "prc-python-django-ninja" {
  subnet_id              = aws_subnet.public_subnets[0].id
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.ec2_instance_type
  vpc_security_group_ids = [aws_security_group.pythonrust_ec2_sg.id]

  tags = {
    Name = "prc-python-django-ninja"
  }
}

resource "aws_instance" "prc-python-fastapi" {
  subnet_id              = aws_subnet.public_subnets[0].id
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.ec2_instance_type
  vpc_security_group_ids = [aws_security_group.pythonrust_ec2_sg.id]

  tags = {
    Name = "prc-python-fastapi"
  }
}

resource "aws_instance" "prc-rust-axum" {
  subnet_id              = aws_subnet.public_subnets[0].id
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.ec2_instance_type
  vpc_security_group_ids = [aws_security_group.pythonrust_ec2_sg.id]

  tags = {
    Name = "prc-rust-axum"
  }
}
