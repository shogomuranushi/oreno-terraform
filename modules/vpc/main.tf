# VPC
resource "aws_vpc" "vpc" {
    cidr_block                  = "${lookup(var.vpc, "${terraform.env}.cidr", var.vpc["default.cidr"])}"
    enable_dns_support          = "true"
    enable_dns_hostnames        = "true"
    tags {
        Name                    = "vpc-${lookup(var.common, "${terraform.env}.project", var.common["default.project"])}"
    }
}

# Internet Gateway
resource "aws_internet_gateway" "vpc-igw" {
    vpc_id                      = "${aws_vpc.vpc.id}"
    tags {
        Name                    = "vpc-igw"
    }
}

# Subnets
resource "aws_subnet" "public-a" {
    vpc_id                      = "${aws_vpc.vpc.id}"
    cidr_block                  = "${lookup(var.vpc, "${terraform.env}.public-a", var.vpc["default.public-a"])}"
    availability_zone           = "${lookup(var.common, "${terraform.env}.region", var.common["default.region"])}a"
    tags {
        Name                    = "public-a"
    }
}

resource "aws_subnet" "public-c" {
    vpc_id                      = "${aws_vpc.vpc.id}"
    cidr_block                  = "${lookup(var.vpc, "${terraform.env}.public-c", var.vpc["default.public-c"])}"
    availability_zone           = "${lookup(var.common, "${terraform.env}.region", var.common["default.region"])}c"
    tags {
        Name                    = "public-c"
    }
}

resource "aws_subnet" "private-a" {
    vpc_id                      = "${aws_vpc.vpc.id}"
    cidr_block                  = "${lookup(var.vpc, "${terraform.env}.private-a", var.vpc["default.private-a"])}"
    availability_zone           = "${lookup(var.common, "${terraform.env}.region", var.common["default.region"])}a"
    tags {
        Name                    = "private-a"
    }
}

resource "aws_subnet" "private-c" {
    vpc_id                      = "${aws_vpc.vpc.id}"
    cidr_block                  = "${lookup(var.vpc, "${terraform.env}.private-c", var.vpc["default.private-c"])}"
    availability_zone           = "${lookup(var.common, "${terraform.env}.region", var.common["default.region"])}c"
    tags {
        Name                    = "private-c"
    }
}

# Routes Table
resource "aws_route_table" "public" {
    vpc_id                      = "${aws_vpc.vpc.id}"
    route {
        cidr_block              = "0.0.0.0/0"
        gateway_id              = "${aws_internet_gateway.vpc-igw.id}"
    }
    tags {
        Name                    = "public"
    }
}

resource "aws_route_table" "private" {
    vpc_id                      = "${aws_vpc.vpc.id}"
    tags {
        Name                    = "private"
    }
}

resource "aws_route_table_association" "public-a" {
    subnet_id                   = "${aws_subnet.public-a.id}"
    route_table_id              = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "public-c" {
    subnet_id                   = "${aws_subnet.public-c.id}"
    route_table_id              = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "private-a" {
    subnet_id                   = "${aws_subnet.private-a.id}"
    route_table_id              = "${aws_route_table.private.id}"
}

resource "aws_route_table_association" "private-c" {
    subnet_id                   = "${aws_subnet.private-c.id}"
    route_table_id              = "${aws_route_table.private.id}"
}
