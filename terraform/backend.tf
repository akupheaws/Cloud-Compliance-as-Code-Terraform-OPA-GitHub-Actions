terraform {
  backend "s3" {
    bucket         = "my-unique-terraform-backend"
    key            = "cloud-compliance-as-code/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "policy-as-code"
    encrypt        = true
  }
}
