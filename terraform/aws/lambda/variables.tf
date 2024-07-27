variable "aws_lambda_function_name" {
  description = "The name of the Lambda function"
  type        = string
}

variable "aws_lambda_function_arn" {
  description = "The ARN of the Lambda function"
  type        = string
  sensitive   = true
}
