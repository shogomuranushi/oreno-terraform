variable "common" {
    default = {
        default.region     = "us-west-2"
        default.project    = "oreno-project"

        dev.region         = "us-west-2"
        stg.region         = "us-west-2"
        prd.region         = "ap-northeast-1"
  }
}

# VPC
variable "vpc" {
    type = "map"
    default = {
        default.cidr       = "10.0.0.0/16"
        default.public-a   = "10.0.0.0/24"
        default.public-c   = "10.0.1.0/24"
        default.private-a  = "10.0.2.0/24"
        default.private-c  = "10.0.3.0/24"
    }
}

# RDS
variable "rds" {
    type = "map"
    default = {
        default.name                            = "oreno-db"
        default.storage_type                    = "gp2"
        default.allocated_storage               = 10
        default.engine                          = "postgres"
        default.port                            = 5432
        default.engine_version                  = "9.6.1"
        default.instance_class                  = "db.t2.small"
        default.multi_az                        = false
        default.backup_retention_period         = "7"
        default.backup_window                   = "19:00-19:30"
        default.apply_immediately               = "true"
        default.auto_minor_version_upgrade      = false
        default.family                          = "postgres9.6"
    }
}
