resource "aws_launch_configuration" "ec2" {
    name_prefix                 = "${lookup(var.ec2, "${terraform.env}.name", var.ec2["default.name"])}-"
    image_id                    = "${lookup(var.ec2, "${terraform.env}.image_id", var.ec2["default.image_id"])}"
    instance_type               = "${lookup(var.ec2, "${terraform.env}.instance_type", var.ec2["default.instance_type"])}"
    key_name                    = "${lookup(var.ec2, "${terraform.env}.key_name", var.ec2["default.key_name"])}"
    user_data                   = "${file("${path.module}/userdata.sh")}"
    associate_public_ip_address = "${lookup(var.ec2, "${terraform.env}.associate_public_ip_address", var.ec2["default.associate_public_ip_address"])}"
    root_block_device = {
        volume_type             = "${lookup(var.ec2, "${terraform.env}.volume_type", var.ec2["default.volume_type"])}"
        volume_size             = "${lookup(var.ec2, "${terraform.env}.volume_size", var.ec2["default.volume_size"])}"
    }
    security_groups = [
        "${aws_security_group.ec2-sg.id}"
    ]

    iam_instance_profile        = "${aws_iam_instance_profile.ec2.id}"

    lifecycle {
      create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "ec2" {
    vpc_zone_identifier        = ["${var.vpc["subnet-public-a"]}", "${var.vpc["subnet-public-c"]}"]
    name                       = "${lookup(var.ec2, "${terraform.env}.name", var.ec2["default.name"])}-asg"
    max_size                   = "${lookup(var.ec2, "${terraform.env}.max_size", var.ec2["default.max_size"])}"
    min_size                   = "${lookup(var.ec2, "${terraform.env}.min_size", var.ec2["default.min_size"])}"
    health_check_grace_period  = "${lookup(var.ec2, "${terraform.env}.health_check_grace_period", var.ec2["default.health_check_grace_period"])}"
    health_check_type          = "${lookup(var.ec2, "${terraform.env}.health_check_type", var.ec2["default.health_check_type"])}"
    desired_capacity           = "${lookup(var.ec2, "${terraform.env}.desired_capacity", var.ec2["default.desired_capacity"])}"
    force_delete               = true
    launch_configuration       = "${aws_launch_configuration.ec2.name}"
    load_balancers             = ["${aws_elb.elb.name}"]

    tag {
        key                   = "Name"
        value                 = "${lookup(var.ec2, "${terraform.env}.name", var.ec2["default.name"])}"
        propagate_at_launch   = true
    }
    lifecycle {
      create_before_destroy = true
    }
}


resource "aws_security_group" "ec2-sg" {
    name                        = "${lookup(var.ec2, "${terraform.env}.name", var.ec2["default.name"])}-sg"
    description                 = "Security Group to ${lookup(var.ec2, "${terraform.env}.name", var.ec2["default.name"])}"
    vpc_id                      = "${var.vpc["vpc_id"]}"

    egress {
      from_port                 = 0
      to_port                   = 0
      protocol                  = "-1"
      cidr_blocks               = ["0.0.0.0/0"]
    }
}

resource "aws_security_group_rule" "ec2-sg_ingress" {
    security_group_id           = "${aws_security_group.ec2-sg.id}"
    type                        = "ingress"
    from_port                   = "${lookup(var.elb, "${terraform.env}.instance_port", var.elb["default.instance_port"])}"
    to_port                     = "${lookup(var.elb, "${terraform.env}.instance_port", var.elb["default.instance_port"])}"
    protocol                    = "tcp"
    source_security_group_id    = "${aws_security_group.elb-sg.id}"
}

resource "aws_security_group_rule" "ec2-sg_ingress-office-ssh" {
    security_group_id           = "${aws_security_group.ec2-sg.id}"
    type                        = "ingress"
    from_port                   = "22"
    to_port                     = "22"
    protocol                    = "tcp"
    cidr_blocks                 = ["${lookup(var.ec2, "${terraform.env}.office_ip", var.ec2["default.office_ip"])}"]
}

# SecurityGroup by EC2 to RDS
resource "aws_security_group_rule" "rds-sg_ingress" {
    security_group_id           = "${var.rds["sg"]}"
    type                        = "ingress"
    from_port                   = "${var.rds["port"]}"
    to_port                     = "${var.rds["port"]}"
    protocol                    = "tcp"
    source_security_group_id    = "${aws_security_group.ec2-sg.id}"
}

# IAM Role
resource "aws_iam_instance_profile" "ec2" {
    name                        = "${lookup(var.ec2, "${terraform.env}.name", var.ec2["default.name"])}-profile"
    role                        = "${aws_iam_role.ec2.name}"
}

resource "aws_iam_role" "ec2" {
    name                        = "${lookup(var.ec2, "${terraform.env}.name", var.ec2["default.name"])}-role"
    path                        = "/"
    assume_role_policy          = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {"Service": "ec2.amazonaws.com"},
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "policy-attach-AmazonEC2RoleforSSM" {
    role                        = "${aws_iam_role.ec2.name}"
    policy_arn                  = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}
