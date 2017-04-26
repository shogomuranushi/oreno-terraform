module "compute" {
    source         = "../../modules/compute"
    common         = "${var.common}"
    ec2            = "${var.ec2}"
    elb            = "${var.elb}"
    vpc            = "${data.terraform_remote_state.not_immutable.vpc}"
    rds            = "${data.terraform_remote_state.not_immutable.rds}"
}
