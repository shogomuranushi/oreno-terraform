# Output
output "ec2" {
  value = "${
    map(
      "name",           "${aws_autoscaling_group.ec2.name}"
    )
  }"
}
