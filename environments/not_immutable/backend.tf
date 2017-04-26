terraform {
  backend "s3" {
    bucket = "<backet name>"
    key    = "not_immutable/terraform.tfstate"
    region = "us-west-2"
  }
}
