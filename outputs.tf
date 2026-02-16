output "p0_connector_policy" {
  description = "Details of the IAM policy attached to the P0 RDS connection role"
  value       = aws_iam_policy.p0_rds_connector_read
}
