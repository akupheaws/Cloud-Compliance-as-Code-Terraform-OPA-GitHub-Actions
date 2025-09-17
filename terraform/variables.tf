variable "region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable "default_tags" {
  type = map(string)
  default = {
    Environment              = "dev"
    Owner                    = "platform-team@example.com"
    CostCenter               = "CC-1234"
    ComplianceClassification = "Internal"
  }
}
