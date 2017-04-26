provider "aws" {
    region = "${lookup(var.common, "${terraform.env}.region", var.common["default.region"])}"
}
