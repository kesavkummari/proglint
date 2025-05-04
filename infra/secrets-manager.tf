resource "aws_secretsmanager_secret" "db_password" {
  name        = "db-password"
  description = "RDS DB password"
}

resource "aws_secretsmanager_secret_version" "db_password_value" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = var.db_password
}
