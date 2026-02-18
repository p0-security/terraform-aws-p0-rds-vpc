variable "vpc_id" {
  description = "The ID of the AWS VPC"
  type        = string
}

variable "aws_account_id" {
  description = "The AWS account ID"
  type        = string
}

variable "aws_region" {
  description = "The AWS region"
  type        = string
}

variable "aws_role_name" {
  description = "The name of the AWS IAM role that P0 assumes to connect to your infrastructure"
  type        = string
}
