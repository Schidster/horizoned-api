resource "aws_db_subnet_group" "api_db" {
  name        = "api-db-subnet"
  description = "db subnet for api"
  subnet_ids  = [aws_subnet.private_1.id, aws_subnet.private_2.id]

  tags = {
    Name    = "api-db-subnet"
    BuiltBy = "Terraform"
  }
}

# resource "aws_db_instance" "api_main" {
#   engine = "postgres"
#   engine_version = "12.2"
#   instance_class = "db.t2.micro"

#   allocated_storage = 20
#   storage_type = "gp2"
#   storage_encrypted = false
#   deletion_protection = true

#   availability_zone = var.az_1
#   db_subnet_group_name = aws_db_subnet_group.api_db.name
#   multi_az = false

#   name = "apidefault"
#   identifier = "api-default"
#   username = "psql"
#   password = "changeme"
#   port = "5432"

#   lifecycle {
#     prevent_destroy = true
#   }

#   tags = {
#     Name = "api-default"
#     BuiltBy = "Terraform"
#   }
# }
