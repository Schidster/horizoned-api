# Create policy to trust ecs task agent.
data "aws_iam_policy_document" "assume_ecs_task" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# Create a task exection role for ecs task agent.
resource "aws_iam_role" "api_task_execution" {
  name        = "api-task-execution-role"
  description = "Role for ecs agent to access ecr and log."
  path        = "/api/"

  assume_role_policy = data.aws_iam_policy_document.assume_ecs_task.json

  force_detach_policies = true
  tags = {
    Name    = "api-task-execution-role"
    BuiltBy = "Terraform"
  }
}

# Attach policy to above role to do ecs task agent stuffs.
resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.api_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "api_parameters" {
  # To access parameters
  statement {
    effect  = "Allow"
    actions = ["ssm:GetParameters"]
    resources = [
      "arn:aws:ssm:ap-south-1:149711720779:parameter/api/*"
    ]
  }
}

resource "aws_iam_policy" "api_task" {
  name        = "api-task"
  path        = "/api/"
  description = "Grants permission for the task to get parameters from store."

  policy = data.aws_iam_policy_document.api_parameters.json
}

# Attach policy to above role to allow tasks to access parameters.
resource "aws_iam_role_policy_attachment" "ecs_task" {
  role       = aws_iam_role.api_task_execution.name
  policy_arn = aws_iam_policy.api_task.arn
}