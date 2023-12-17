resource "aws_db_instance" "prc-mysql" {
  identifier             = "prc-mysql"
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = var.rds_instance_class
  username               = var.database_usr
  password               = var.database_pwd
  vpc_security_group_ids = [aws_security_group.pythonrust_rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.prc_public.name
  skip_final_snapshot    = true
  publicly_accessible    = true
}

# resource "aws_db_instance" "prc-postgresql" {
#   identifier             = "prc-postgresql"
#   allocated_storage      = 20
#   engine                 = "postgres"
#   engine_version         = "15.4"
#   instance_class         = var.rds_instance_class
#   username               = var.database_usr
#   password               = var.database_pwd
#   vpc_security_group_ids = [aws_security_group.pythonrust_rds_sg.id]
#   db_subnet_group_name   = aws_db_subnet_group.prc_db_private.name
#   skip_final_snapshot    = true
# }
