variable "aws_topic_name" {
  description = "The name of the SNS topic"
  type        = string
  default     = "ServerTopic"
}

variable "aws_topic_arn" {
  description = "The ID of the SNS topic"
  type        = string
  sensitive   = true
}
