terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "2tier-project/terraform.tfstate"
    region        
