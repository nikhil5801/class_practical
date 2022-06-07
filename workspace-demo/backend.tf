terraform {
  backend "s3" {
    bucket         = "terraform-code-test-bucket"
    key            = "codva-demo"
    region         = "ap-south-1"
    dynamodb_table = "backend_terraform_tstate"

  }
}
