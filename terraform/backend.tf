terraform {
  backend "s3" {
    bucket         = "your-tfstate-bucket"
    key            = "cloud-compliance-as-code/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "your-tflock-table"
    encrypt        = true
  }
}
