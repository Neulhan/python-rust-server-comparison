resource "aws_ecr_repository" "prc-server-fastapi" {
  name = "prc-server-fastapi"
}

resource "aws_ecr_repository" "prc-server-axum" {
  name = "prc-server-axum"
}

resource "aws_ecr_repository" "prc-server-django-ninja" {
  name = "prc-server-django-ninja"
}
