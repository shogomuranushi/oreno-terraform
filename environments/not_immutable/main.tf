module "vpc" {
    source       = "../../modules/vpc"
    common       = "${var.common}"
    vpc          = "${var.vpc}"
}

module "rds" {
    source       = "../../modules/db"
    common       = "${var.common}"
    rds          = "${var.rds}"
    vpc          = "${module.vpc.vpc}"
}
