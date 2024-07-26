variable "aws_region" {
  description = "The AWS region to deploy to"
  type        = string
  default     = "us-east-1"
}

variable "aws_config_files" {
  description = "The AWS config files to use"
  type        = list(string)
  default     = ["~/.aws/credentials"]
}
