terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  aws_account_id = coalesce(var.aws_account_id, data.aws_caller_identity.current.account_id)
  aws_region     = coalesce(var.aws_region, data.aws_region.current.id)
}

# IAM Policy with permissions to describe VPC, list subnets, and describe RDS resources
resource "aws_iam_policy" "p0_rds_connector_read" {
  name        = "P0RdsConnectorRead-${var.vpc_id}"
  description = "Policy allowing read access to VPC, subnets, and RDS resources for VPC ${var.vpc_id}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DescribeVPC"
        Effect = "Allow"
        Action = [
          "ec2:DescribeVpcs"
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "ec2:vpc" = "arn:aws:ec2:${local.aws_region}:${local.aws_account_id}:vpc/${var.vpc_id}"
          }
        }
      },
      {
        Sid    = "ListSubnets"
        Effect = "Allow"
        Action = [
          "ec2:DescribeSubnets"
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "ec2:vpc" = "arn:aws:ec2:${local.aws_region}:${local.aws_account_id}:vpc/${var.vpc_id}"
          }
        }
      },
      {
        Sid    = "DescribeRDSResources"
        Effect = "Allow"
        Action = [
          "rds:DescribeDBInstances",
          "rds:DescribeDBClusters"
        ]
        Resource = "*"
      }
    ]
  })

  tags = {
    VpcId      = var.vpc_id
    ManagedBy  = "Terraform"
    ManagedFor = "P0"
  }
}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "p0_rds_connector_read" {
  role       = var.aws_role_name
  policy_arn = aws_iam_policy.p0_rds_connector_read.arn
}
