# The main VPC with three subnets.
# One public and two private.
resource "aws_vpc" "api" {
  cidr_block         = var.vpc_cidr_block
  instance_tenancy   = "default"
  enable_dns_support = true

  tags = {
    Name    = "api"
    BuiltBy = "terraform"
  }
}

resource "aws_internet_gateway" "api" {
  vpc_id = aws_vpc.api.id

  tags = {
    Name    = "api-main"
    BuiltBy = "Terraform"
  }
}

# The public one
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.api.id
  cidr_block              = var.public_cidr_block
  availability_zone       = var.az_1
  map_public_ip_on_launch = true

  tags = {
    Name    = "api-public"
    Type    = "public"
    BuiltBy = "Terraform"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.api.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.api.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.api.id
  }

  tags = {
    Name    = "api-public"
    BuiltBy = "Terraform"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# The private ones
resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.api.id
  cidr_block        = var.private_cidr_block_1
  availability_zone = var.az_1

  tags = {
    Name    = "api-private-1"
    Type    = "private"
    BuiltBy = "Terraform"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.api.id
  cidr_block        = var.private_cidr_block_2
  availability_zone = var.az_2

  tags = {
    Name    = "api-private-2"
    Type    = "private"
    BuiltBy = "Terraform"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.api.id

  tags = {
    Name    = "api-private"
    BuiltBy = "Terraform"
  }

}

resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private.id
}

resource "aws_security_group" "api" {
  name        = "api"
  description = "Allow TLS inbound traffic."
  vpc_id      = aws_vpc.api.id

  ingress {
    description = "For accessing api."
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "For ecs to pull image."
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "api"
    BuiltBy = "Terraform"
  }
}

resource "aws_security_group" "database" {
  name        = "database"
  description = "psql"
  vpc_id      = aws_vpc.api.id

  ingress {
    description = "For postgresql"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.public.cidr_block]
  }

  tags = {
    Name    = "database"
    BuiltBy = "Terraform"
  }
}
