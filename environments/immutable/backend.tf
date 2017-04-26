terraform {
  backend "s3" {
    bucket = "<backet name>"
    key    = "immutable/terraform.tfstate"
    region = "us-west-2"
  }
}

data "terraform_remote_state" "not_immutable" {
  backend = "s3"
  config {
    bucket = "<backet name>"
    key    = "env:/${terraform.env}/not_immutable/terraform.tfstate"
    region = "us-west-2"
  }
}
