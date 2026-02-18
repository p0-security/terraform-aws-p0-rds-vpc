# terraform-aws-p0-rds-vpc

Terraform for provisioning AWS infrastructure necessary to install P0 for AWS RDS on a VPC.

Usage:

```
module "aws-p0-connector" {
  aws_account_id         = "123456789012"
  # Retrieve from p0_aws_iam_write_staged.service_account_id
  gcp_service_account_id = "p0-prod-customer-sa@p0-prod.gserviceaccount.com"
}

module "aws-p0-rds-vpc" {
  vpc_id         = "vpc-0123456789"
  aws_account_id = "123456789012"
  aws_region     = "us-east-2"
  aws_role_name  = module.aws-p0-connector.aws_role.name
}
```
