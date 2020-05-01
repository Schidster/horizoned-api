variable "aws_profile" {
  description = "Profile to use for aws authentication."
  default     = "default"
}

variable "aws_region" {
  description = "Aws region to create resources on."
  default     = "ap-south-1"
}

variable "state_bucket_name" {
  description = "Name of s3 bucket to store state."
  default     = "terraform-api-state"
}

variable "state_lock_table_name" {
  description = "DynamoDb table name to store locked state."
  default     = "terraform-api-state-lock"
}

variable "vpc_cidr_block" {
  description = "Cidr block of the main Vpc."
  default     = "10.0.0.0/16"
}

variable "public_cidr_block" {
  description = "Cidr block of public subnet."
  default     = "10.0.0.0/24"
}

variable "private_cidr_block_1" {
  description = "Cidr block of private subnet 1."
  default     = "10.0.1.0/24"
}

variable "private_cidr_block_2" {
  description = "Cidr block of private subnet 2."
  default     = "10.0.2.0/24"
}

variable "az_1" {
  description = "Availabiliy Zone 1"
  default     = "ap-south-1a"
}

variable "az_2" {
  description = "Availabiliy Zone 2"
  default     = "ap-south-1b"
}

variable "az_3" {
  description = "Availabiliy Zone 3"
  default     = "ap-south-1c"
}

variable "task_count" {
  description = "Desired count of running tasks."
  default     = 0
}
