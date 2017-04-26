# Output
output "vpc" {
  value = "${
    map(
      "vpc_id",           "${aws_vpc.vpc.id}",
      "subnet-public-a",  "${aws_subnet.public-a.id}",
      "subnet-public-c",  "${aws_subnet.public-c.id}",
      "subnet-private-a", "${aws_subnet.private-a.id}",
      "subnet-private-c", "${aws_subnet.private-c.id}"
    )
  }"
}

output "common" {
  value = "${var.common}"
}
