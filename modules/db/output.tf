output "rds" {
  value = "${
    map(
      "address",  "${aws_db_instance.rds.address}",
      "port",     "${aws_db_instance.rds.port}",
      "name",     "${aws_db_instance.rds.name}",
      "username", "${aws_db_instance.rds.username}",
      "sg",       "${aws_security_group.rds-sg.id}"
    )
  }"
}
