# ELB
resource "aws_elb" "elb" {
  name                          = "${lookup(var.elb, "${terraform.env}.name", var.elb["default.name"])}"
  subnets = [
                                "${var.vpc["subnet-public-a"]}",
                                "${var.vpc["subnet-public-c"]}",
  ]
  security_groups = [
                                "${aws_security_group.elb-sg.id}",
  ]

  listener {
    instance_port              = "${lookup(var.elb, "${terraform.env}.instance_port", var.elb["default.instance_port"])}"
    instance_protocol          = "${lookup(var.elb, "${terraform.env}.instance_protocol", var.elb["default.instance_protocol"])}"
    lb_port                    = "${lookup(var.elb, "${terraform.env}.lb_port", var.elb["default.lb_port_ssl"])}"
    lb_protocol                = "${lookup(var.elb, "${terraform.env}.lb_protocol", var.elb["default.lb_protocol_ssl"])}"
    ssl_certificate_id         = "${lookup(var.elb, "${terraform.env}.ssl_certificate_id", var.elb["default.ssl_certificate_id"])}"
  }

  health_check {
    healthy_threshold           = "${lookup(var.elb, "${terraform.env}.healthy_threshold", var.elb["default.healthy_threshold"])}"
    unhealthy_threshold         = "${lookup(var.elb, "${terraform.env}.unhealthy_threshold", var.elb["default.unhealthy_threshold"])}"
    timeout                     = "${lookup(var.elb, "${terraform.env}.timeout", var.elb["default.timeout"])}"
    target                      = "${lookup(var.elb, "${terraform.env}.target", var.elb["default.target"])}"
    interval                    = "${lookup(var.elb, "${terraform.env}.interval", var.elb["default.interval"])}"
  }

  cross_zone_load_balancing     = "${lookup(var.elb, "${terraform.env}.cross_zone_load_balancing", var.elb["default.cross_zone_load_balancing"])}"
  idle_timeout                  = "${lookup(var.elb, "${terraform.env}.idle_timeout", var.elb["default.idle_timeout"])}"
  connection_draining           = "${lookup(var.elb, "${terraform.env}.connection_draining", var.elb["default.connection_draining"])}"
  connection_draining_timeout   = "${lookup(var.elb, "${terraform.env}.connection_draining_timeout", var.elb["default.connection_draining_timeout"])}"

  tags {
    Name                        = "${lookup(var.elb, "${terraform.env}.name", var.elb["default.name"])}"
  }
}


# SecurityGroup
resource "aws_security_group" "elb-sg" {
  name          = "${lookup(var.elb, "${terraform.env}.name", var.elb["default.name"])}-sg"
  description   = "Allow all inbound traffic"
  vpc_id        = "${var.vpc["vpc_id"]}"

  ingress {
    from_port   = "${lookup(var.elb, "${terraform.env}.lb_port_ssl", var.elb["default.lb_port_ssl"])}"
    to_port     = "${lookup(var.elb, "${terraform.env}.lb_port_ssl", var.elb["default.lb_port_ssl"])}"
    protocol    = "${lookup(var.elb, "${terraform.env}.protocol", var.elb["default.protocol"])}"
    cidr_blocks = ["${lookup(var.elb, "${terraform.env}.cidr_blocks", var.elb["default.cidr_blocks"])}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
