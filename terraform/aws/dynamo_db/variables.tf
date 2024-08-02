variable "aws_dynamodb_table_name" {
  description = "The name of the DynamoDB table"
  type        = string
}

variable "aws_dynamodb_table_arn" {
  description = "The ARN of the DynamoDB table"
  type        = string
  sensitive   = true
}
