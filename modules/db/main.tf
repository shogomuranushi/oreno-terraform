############################################################
# Description:
#   Create RDS
#   Create SubnetGroup & ParameterGroup & RDS Instance
############################################################
# RDS
resource "aws_db_subnet_group" "db-subnet" {
    name                        = "${lookup(var.rds, "${terraform.env}.name", var.rds["default.name"])}-subnet"
    description                 = "${lookup(var.rds, "${terraform.env}.name", var.rds["default.name"])}-subnet"
    subnet_ids                  = ["${lookup(var.vpc, "subnet-private-a")}", "${lookup(var.vpc, "subnet-private-c")}"]
}

resource "aws_db_parameter_group" "db-pg" {
    name                        = "${lookup(var.rds, "${terraform.env}.name", var.rds["default.name"])}-pg"
    family                      = "${lookup(var.rds, "${terraform.env}.family", var.rds["default.family"])}"
    description                 = "${lookup(var.rds, "${terraform.env}.name", var.rds["default.name"])}-pg"
}

resource "aws_db_instance" "rds" {
    identifier                  = "${lookup(var.rds, "${terraform.env}.name", var.rds["default.name"])}"
    storage_type                = "${lookup(var.rds, "${terraform.env}.storage_type", var.rds["default.storage_type"])}"
    allocated_storage           = "${lookup(var.rds, "${terraform.env}.allocated_storage", var.rds["default.allocated_storage"])}"
    engine                      = "${lookup(var.rds, "${terraform.env}.engine", var.rds["default.engine"])}"
    engine_version              = "${lookup(var.rds, "${terraform.env}.engine_version", var.rds["default.engine_version"])}"
    instance_class              = "${lookup(var.rds, "${terraform.env}.instance_class", var.rds["default.instance_class"])}"
    name                        = "${lookup(var.rds, "${terraform.env}.engine", var.rds["default.engine"])}"
    username                    = "${lookup(var.rds, "${terraform.env}.engine", var.rds["default.engine"])}"
    password                    = "${lookup(var.rds, "${terraform.env}.engine", var.rds["default.engine"])}"
    db_subnet_group_name        = "${aws_db_subnet_group.db-subnet.name}"
    vpc_security_group_ids      = ["${aws_security_group.rds-sg.id}"]
    parameter_group_name        = "${aws_db_parameter_group.db-pg.name}"
    multi_az                    = "${lookup(var.rds, "${terraform.env}.multi_az", var.rds["default.multi_az"])}"
    backup_retention_period     = "${lookup(var.rds, "${terraform.env}.backup_retention_period", var.rds["default.backup_retention_period"])}"
    backup_window               = "${lookup(var.rds, "${terraform.env}.backup_window", var.rds["default.backup_window"])}"
    apply_immediately           = "${lookup(var.rds, "${terraform.env}.apply_immediately", var.rds["default.apply_immediately"])}"
    auto_minor_version_upgrade  = "${lookup(var.rds, "${terraform.env}.auto_minor_version_upgrade", var.rds["default.auto_minor_version_upgrade"])}"
}

# SecurityGroup
resource "aws_security_group" "rds-sg" {
    name                        = "${lookup(var.rds, "${terraform.env}.name", var.rds["default.name"])}-sg"
    description                 = "Security Group to ${lookup(var.rds, "${terraform.env}.name", var.rds["default.name"])}"
    vpc_id                      = "${lookup(var.vpc, "vpc_id")}"

    egress {
      from_port                 = 0
      to_port                   = 0
      protocol                  = "-1"
      cidr_blocks               = ["0.0.0.0/0"]
    }
}
