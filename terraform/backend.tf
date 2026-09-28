terraform {
  backend "s3" {
    bucket = "afsar-aws-cost-terraform-state-941904985119"
    key    = "aws-cost/terraform.tfstate"
    region = "eu-north-1"
  }
}