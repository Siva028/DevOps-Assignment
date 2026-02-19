terraform {
  backend "s3" {
    bucket         = "pgagi-terraform-state-siva123"
    key            = "aws/staging/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "pgagi-terraform-lock"
    encrypt        = true
  }
}
