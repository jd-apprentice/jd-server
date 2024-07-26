variable "aws_queue_name" {
  description = "The name of the SQS queue"
  type        = string
  default     = "ServerQueue"
}

variable "aws_queue_url" {
  description = "The URL of the SQS queue"
  type        = string
  sensitive   = true
}
