terraform {
  backend "s3" {
    bucket         = "seetharam-terraform-108108"  # Replace with your bucket
    key            = "2tier-project/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"  # Optional for state locking
  }
}
