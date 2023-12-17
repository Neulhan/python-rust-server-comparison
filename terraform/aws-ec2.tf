resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "prc-keypare" {
  key_name   = "prcKey"
  public_key = tls_private_key.pk.public_key_openssh
}

resource "local_file" "ssh_key" {
  filename        = "${aws_key_pair.prc-keypare.key_name}.pem"
  content         = tls_private_key.pk.private_key_pem
  file_permission = "0400"
}

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
  key_name               = aws_key_pair.prc-keypare.key_name

  tags = {
    Name = "prc-python-django-ninja"
  }
}

resource "aws_instance" "prc-python-fastapi" {
  subnet_id              = aws_subnet.public_subnets[0].id
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.ec2_instance_type
  vpc_security_group_ids = [aws_security_group.pythonrust_ec2_sg.id]
  key_name               = aws_key_pair.prc-keypare.key_name

  tags = {
    Name = "prc-python-fastapi"
  }
}

resource "aws_instance" "prc-rust-axum" {
  subnet_id              = aws_subnet.public_subnets[0].id
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.ec2_instance_type
  vpc_security_group_ids = [aws_security_group.pythonrust_ec2_sg.id]
  key_name               = aws_key_pair.prc-keypare.key_name

  tags = {
    Name = "prc-rust-axum"
  }
}
