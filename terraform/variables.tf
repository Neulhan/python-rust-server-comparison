variable "region" {
  type        = string
  description = "aws region"
}

variable "profile" {
  type        = string
  description = "aws profile"
}

variable "ec2_instance_type" {
  type        = string
  description = "AWS EC2 instance type"
}

variable "rds_instance_class" {
  type        = string
  description = "AWS RDS instance class"
}

variable "database_usr" {
  type = string
}

variable "database_pwd" {
  type = string
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR values"
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR values"
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}
