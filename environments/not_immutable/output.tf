output "common" {
    value = "${module.vpc.common}"
}

output "vpc" {
    value = "${module.vpc.vpc}"
}

output "rds" {
    value = "${module.rds.rds}"
}
