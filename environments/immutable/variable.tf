variable "common" {
    default = {
        default.region     = "us-west-2"
        default.project    = "oreno-project"

        dev.region         = "us-west-2"
        stg.region         = "us-west-2"
        prd.region         = "ap-northeast-1"
  }
}

variable "elb" {
    type = "map"
    default = {
        default.name                            = "oreno-elb"

        default.instance_port                   = 80
        default.instance_protocol               = "http"
        default.lb_port_ssl                     = 443
        default.lb_protocol_ssl                 = "https"
        default.ssl_certificate_id              = "<oreno ssl arn>"

        default.healthy_threshold               = 2
        default.unhealthy_threshold             = 2
        default.timeout                         = 3
        default.target                          = "HTTP:80/"
        default.interval                        = 30

        default.cross_zone_load_balancing       = true
        default.idle_timeout                    = 400
        default.connection_draining             = true
        default.connection_draining_timeout     = 400

        # SecurityGroup
        default.protocol                        = "tcp"
        default.cidr_blocks                     = "0.0.0.0/0"
    }
}

variable "ec2" {
    type = "map"
    default = {
        default.name                            = "oreno-ec2"
        default.image_id                        = "<oreno ami>"
        default.instance_type                   = "t2.medium"
        default.key_name                        = "<oreno key>"
        default.associate_public_ip_address     = "true"

        default.volume_type                     = "gp2"
        default.volume_size                     = "30"
        default.office_ip                       = "<oreno office ip>"

        default.max_size                        = "1"
        default.min_size                        = "1"
        default.desired_capacity                = "1"
        default.health_check_grace_period       = 300
        default.health_check_type               = "EC2"
    }
}
