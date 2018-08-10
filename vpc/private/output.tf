output "priv_subnet_1_id" {
  value = "${aws_subnet.private1.id}"
}

output "priv_subnet_2_id" {
  value = "${aws_subnet.private2.id}"
}

output "priv_subnet_3_id" {
  value = "${aws_subnet.private3.id}"
}

output "private_subnets" {
  value = ["${aws_subnet.private1.id}", "${aws_subnet.private2.id}", "${aws_subnet.private3.id}"]
}