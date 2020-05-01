terraform {
  required_version = ">=0.12.24"

  backend "s3" {
    bucket         = "terraform-api-state"
    key            = "terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-api-state-lock"
    encrypt        = true
  }
}

provider "aws" {
  version                 = "~> 2.58.0"
  shared_credentials_file = "$HOME/.aws/credentials"
  profile                 = var.aws_profile
  region                  = var.aws_region
}

module "bootstrap" {
  source               = "./bootstrap"
  name_of_s3_bucket    = var.state_bucket_name
  dynamo_db_table_name = var.state_lock_table_name
}

resource "aws_ecr_repository" "api" {
  name                 = "horizoned-api"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    BuiltBy = "Terraform"
  }
}

resource "aws_ecr_repository" "api_server" {
  name                 = "horizoned-server"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    BuiltBy = "Terraform"
  }
}

resource "aws_ecs_cluster" "aeolian" {
  name               = "aeolian"
  capacity_providers = ["FARGATE"]

  tags = {
    BuiltBy = "Terraform"
  }
}

resource "aws_ecs_task_definition" "api" {
  family                   = "api"
  container_definitions    = file("task-definition.json")
  task_role_arn            = aws_iam_role.api_task_execution.arn
  execution_role_arn       = aws_iam_role.api_task_execution.arn
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"
  requires_compatibilities = ["FARGATE"]

  volume {
    name = "static"

    docker_volume_configuration {
      scope  = "task"
      driver = "local"
    }
  }
}

resource "aws_ecs_service" "api_service" {
  name                = "api-service"
  cluster             = aws_ecs_cluster.aeolian.id
  task_definition     = aws_ecs_task_definition.api.arn
  desired_count       = var.task_count
  launch_type         = "FARGATE"
  scheduling_strategy = "REPLICA"
  platform_version    = "LATEST"

  network_configuration {
    subnets          = [aws_subnet.public.id]
    security_groups  = [aws_security_group.api.id]
    assign_public_ip = true
  }
}

resource "aws_cloudwatch_log_group" "api" {
  name              = "horizoned-api"
  retention_in_days = 3

  tags = {
    BuiltBy = "Terraform"
  }
}

resource "aws_cloudwatch_log_group" "server" {
  name              = "horizoned-server"
  retention_in_days = 3

  tags = {
    BuiltBy = "Terraform"
  }
}