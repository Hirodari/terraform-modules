# store the terraform state file in s3
terraform {
  backend "s3" {
    bucket    = "s3-terraform-for-dynamic-web"
    key       = "jupiter-web-ecs.tfstate"
    region    = "us-east-1"
    profile   = "devops"
  }
}